import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:weather_app/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  void _checkAuth() {
    try {
      final AuthController authController = Get.find<AuthController>();

      final user = authController.user.value;

      Future.delayed(const Duration(seconds: 1), () {
        if (user != null) {
          Get.offAllNamed(AppRoutes.HOME);
        } else {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      });
    } catch (e) {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
