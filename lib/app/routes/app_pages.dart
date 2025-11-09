// ========================================
// lib/app/routes/app_pages.dart
// ========================================
import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:weather_app/app/modules/auth/views/login_view.dart';
import 'package:weather_app/app/modules/auth/views/register_view.dart';
import 'package:weather_app/app/modules/home/bindings/home_binding.dart';
import 'package:weather_app/app/modules/home/views/home_view.dart';
import 'package:weather_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:weather_app/app/modules/splash/views/splash_view.dart';
import 'package:weather_app/app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
