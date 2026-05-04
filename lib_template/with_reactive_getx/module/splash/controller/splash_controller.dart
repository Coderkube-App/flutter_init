import 'package:flutter_with_reactive_getx/route/app_route.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  String name = "Splash";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.loginView);
    });
  }
   @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}