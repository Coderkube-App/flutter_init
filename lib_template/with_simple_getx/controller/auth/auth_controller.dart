import 'package:flutter_standard/config/constant.dart';
import 'package:flutter_standard/repositories/auth/auth_repo.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  bool isLoading = false;


  /// Login API
  Future<void> login() async {
    try {
      isLoading = true;
      update();

      await AuthRepo.login(body: {}).then((value) async {
        appPrint("login Response -> $value");
        if (value?.statusState == "success") {

        }
      });
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      appPrint("error -> $e");
    }
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}