import 'package:flutter_with_reactive_getx/modules/home/presentation/viewmodels/home_view_model.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewModel());
  }
}
