import 'package:flutter/material.dart';
import 'package:flutter_standard/app_widget/common_offline_builder.dart';
import 'package:flutter_standard/config/app_colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text("login", style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
