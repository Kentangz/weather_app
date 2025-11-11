import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/app/data/models/user_model.dart';
import 'package:weather_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:weather_app/app/utils/notification_helper.dart';
import 'package:weather_app/app/data/services/storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final Connectivity _connectivity = Connectivity();

  var isLoading = false.obs;
  var selectedImage = Rx<File?>(null);
  var userProfile = Rx<UserModel?>(null);
  late TextEditingController nameController;
  StreamSubscription<DocumentSnapshot>? _profileListener;
  User? get user => authController.user.value;

  var isProfileModified = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    _listenToUserProfile();

    selectedImage.listen((_) => _checkIfProfileModified());
    nameController.addListener(_checkIfProfileModified);
  }

  void _listenToUserProfile() {
    if (user != null) {
      _profileListener = _firestore
          .collection('users')
          .doc(user!.uid)
          .snapshots()
          .listen((doc) {
            if (doc.exists) {
              userProfile.value = UserModel.fromFirestore(doc);
              nameController.text = userProfile.value?.displayName ?? '';
              isProfileModified(false);
            } else {
              _createInitialUserProfile();
            }
          });
    }
  }

  void _checkIfProfileModified() {
    bool imageChanged = selectedImage.value != null;
    bool nameChanged =
        nameController.text.trim() != (userProfile.value?.displayName ?? '');

    isProfileModified.value = imageChanged || nameChanged;
  }

  Future<void> _createInitialUserProfile() async {
    if (user != null) {
      UserModel newUser = UserModel(
        uid: user!.uid,
        email: user!.email ?? 'no-email',
        displayName: user!.email?.split('@').first ?? 'User',
        photoURL: null,
      );
      await _firestore.collection('users').doc(user!.uid).set(newUser.toJson());
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      if (e.toString().contains('no_available_camera')) {
        NotificationHelper.showError(
          'Failed',
          'No camera found.',
        );
      } else {
        NotificationHelper.showError('Failed to Select Image', e.toString());
      }
    }
  }

  Future<void> saveProfile() async {
    if (user == null) return;

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      NotificationHelper.showError(
        'Save Failed',
        'No internet connection.',
      );
      return;
    }

    isLoading(true);
    String? newPhotoURL = userProfile.value?.photoURL;

    try {
      if (selectedImage.value != null) {
        NotificationHelper.showInfo('Uploading Photo', 'Please wait...');
        newPhotoURL = await _storageService.uploadImage(selectedImage.value!);
      }

      Map<String, dynamic> dataToUpdate = {
        'displayName': nameController.text.trim(),
        'photoURL': newPhotoURL,
      };

      await _firestore
          .collection('users')
          .doc(user!.uid)
          .set(dataToUpdate, SetOptions(merge: true));

      selectedImage.value = null;
      NotificationHelper.showSuccess(
        'Profile Saved',
        'Your data has been updated.',
      );
    } on SocketException catch (_) {
      NotificationHelper.showError(
        'Save Failed',
        'Internet connection is unstable.',
      );
    } catch (e) {
      NotificationHelper.showError('Save Failed', e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    _profileListener?.cancel();
    super.onClose();
  }
}