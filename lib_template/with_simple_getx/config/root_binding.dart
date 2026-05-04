import 'package:flutter_standard/controller/auth/auth_controller.dart';
import 'package:flutter_standard/controller/home/home_controller.dart';
import 'package:flutter_standard/controller/splash/splash_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(AuthController());
    Get.put(HomeController());
  }
}
