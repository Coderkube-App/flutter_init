import 'package:bloc_project/app_widget/common_offline_builder.dart';
import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/route/app_route.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text(
            "Register",
            style: TextStyle(
              fontSize: 22,
              color: AppColor.blackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.blackColor,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

  }
}
