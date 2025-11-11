import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  User? get user => authController.user.value;
}
