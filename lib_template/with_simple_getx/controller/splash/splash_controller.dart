import 'package:flutter_standard/view/auth/log_in/login_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  String name = "Splash Screen";

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(LoginView());
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}