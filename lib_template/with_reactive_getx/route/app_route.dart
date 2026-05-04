
import 'package:flutter_with_reactive_getx/module/auth/binding/auth_binding.dart';
import 'package:flutter_with_reactive_getx/module/auth/view/log_in/login_view.dart';
import 'package:flutter_with_reactive_getx/module/auth/view/sign_up/sign_up_view.dart';
import 'package:flutter_with_reactive_getx/module/home/binding/home_binding.dart';
import 'package:flutter_with_reactive_getx/module/home/view/home_view.dart';
import 'package:flutter_with_reactive_getx/module/splash/binding/splash_binding.dart';
import 'package:get/get.dart';

import '../module/splash/view/splash_view.dart';

class AppRoutes {
  static const String initialRoute = "/";
  static const String signUpView = "/signup_view";
  static const String loginView = "/login_view";
  static const String homeView = "/home_view";

  static List<GetPage> pages = [
    GetPage(name: initialRoute, page: () => SplashView(), binding: SplashBinding()),
    GetPage(name: signUpView, page: () => SignUpView(), binding: AuthBinding()),
    GetPage(name: loginView, page: () => LoginView(), binding: AuthBinding()),
    GetPage(name: homeView, page: () => HomeScreen(), binding: HomeBinding()),
  ];
}
