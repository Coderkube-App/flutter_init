import 'package:flutter_with_reactive_getx/core/constants/app_constants.dart';
import 'package:flutter_with_reactive_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  final title = 'Splash'.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(AppConstants.splashDelay, () {
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
