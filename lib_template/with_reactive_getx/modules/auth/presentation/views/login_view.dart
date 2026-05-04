import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/core/widgets/common_offline_builder.dart';
import 'package:flutter_with_reactive_getx/modules/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthViewModel> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text(
                    'Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}
