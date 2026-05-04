import 'package:flutter_with_reactive_getx/domain/entities/user_entity.dart';
import 'package:flutter_with_reactive_getx/domain/repositories/auth_repository.dart';
import 'package:flutter_with_reactive_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  AuthViewModel(this._repository);

  final AuthRepository _repository;
  final RxBool isLoading = false.obs;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final UserEntity? user = await _repository.login(email: email, password: password);
    isLoading.value = false;

    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
