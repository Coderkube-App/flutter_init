import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/config/app_colors.dart';
import 'package:flutter_with_reactive_getx/module/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(controller.name, style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
