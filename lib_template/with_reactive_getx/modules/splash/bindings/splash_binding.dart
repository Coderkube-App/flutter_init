import 'package:flutter_with_reactive_getx/modules/splash/presentation/viewmodels/splash_view_model.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashViewModel());
  }
}
