import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/app_widget/common_offline_builder.dart';
import 'package:flutter_with_reactive_getx/config/app_colors.dart';
import 'package:flutter_with_reactive_getx/module/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text("Login", style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700))
        ),
      ),
    );
  }
}
