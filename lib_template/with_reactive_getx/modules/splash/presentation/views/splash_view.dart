import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/core/theme/app_colors.dart';
import 'package:flutter_with_reactive_getx/modules/splash/presentation/viewmodels/splash_view_model.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Text(
            controller.title.value,
            style: const TextStyle(
              fontSize: 22,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
