import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late final CloudinaryPublic _cloudinary;
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'NOT_FOUND';
  final String _uploadPreset =
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'NOT_FOUND';

  @override
  void onInit() {
    super.onInit();
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset);
  }

  Future<String> uploadImage(File imageFile) async {

    try {
      final CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } on CloudinaryException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
