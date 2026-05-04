import 'package:flutter_with_reactive_getx/modules/auth/bindings/auth_binding.dart';
import 'package:flutter_with_reactive_getx/modules/auth/presentation/views/login_view.dart';
import 'package:flutter_with_reactive_getx/modules/auth/presentation/views/sign_up_view.dart';
import 'package:flutter_with_reactive_getx/modules/home/bindings/home_binding.dart';
import 'package:flutter_with_reactive_getx/modules/home/presentation/views/home_view.dart';
import 'package:flutter_with_reactive_getx/modules/profile/presentation/views/profile_view.dart';
import 'package:flutter_with_reactive_getx/modules/splash/bindings/splash_binding.dart';
import 'package:flutter_with_reactive_getx/modules/splash/presentation/views/splash_view.dart';
import 'package:flutter_with_reactive_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
    ),
  ];
}
