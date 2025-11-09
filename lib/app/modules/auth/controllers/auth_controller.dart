import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/routes/app_routes.dart';
import 'package:weather_app/app/utils/notification_helper.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> user = Rx<User?>(null);

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    user.bindStream(_auth.authStateChanges());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      NotificationHelper.showError(
        'Login Failed',
        'Email and password must be filled.',
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(AppRoutes.HOME);
      NotificationHelper.showSuccess(
        'Login Successful',
        'Welcome back!',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthError(e);
      NotificationHelper.showError('Login Failed', errorMessage);
    }
  }

  Future<void> register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      NotificationHelper.showError(
        'Registration Failed',
        'Email and password must be filled.',
      );
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(AppRoutes.HOME);
      NotificationHelper.showSuccess(
        'Registration Successful',
        'Your account has been created!',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthError(e);
      NotificationHelper.showError('Registration Failed', errorMessage);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
    NotificationHelper.showInfo(
      'Logout',
      'You have logged out.',
    );
  }

  Future<void> sendPasswordReset() async {
    if (emailController.text.trim().isEmpty) {
      NotificationHelper.showError(
        'Reset Gagal',
        'Silakan masukkan email Anda di kolom email terlebih dahulu.',
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      NotificationHelper.showSuccess(
        'Email Terkirim',
        'Link reset password telah dikirim ke email Anda. Silakan cek inbox.',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthError(e);
      NotificationHelper.showError('Reset Gagal', errorMessage);
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'invalid-credential':
        message = 'The email or password you entered is incorrect.';
        break;
      case 'user-not-found':
        message = 'No account found with this email.';
        break;
      case 'wrong-password':
        message = 'The password you entered is incorrect.';
        break;
      case 'invalid-email':
        message = 'Invalid email format. Please check again.';
        break;
      case 'email-already-in-use':
        message = 'This email is already registered. Please log in.';
        break;
      case 'weak-password':
        message = 'Password is too weak (minimum 6 characters).';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Your account is temporarily locked for 15 minutes.';
        break;
      default:
        message = 'An error occurred. Please try again later.';
    }
    return message;
  }
}
