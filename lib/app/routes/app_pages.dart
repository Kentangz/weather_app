import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/views/login_view.dart';
import 'package:weather_app/app/modules/auth/views/register_view.dart';
import 'package:weather_app/app/modules/home/bindings/home_binding.dart';
import 'package:weather_app/app/modules/home/views/home_view.dart';
import 'package:weather_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:weather_app/app/modules/splash/views/splash_view.dart';
import 'package:weather_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:weather_app/app/modules/profile/views/profile_view.dart';
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
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
