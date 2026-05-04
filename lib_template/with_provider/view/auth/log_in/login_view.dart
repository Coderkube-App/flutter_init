import 'package:flutter/material.dart';
import 'package:provider_project/app_widget/common_offline_builder.dart';
import 'package:provider_project/config/app_colors.dart';
import 'package:provider_project/config/constant.dart';
import 'package:provider_project/view/home/home_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
              onTap: () {
                pushNavigation(context, HomeScreen());
              },
              child: Text("login", style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700))),
        ),
      ),
    );
  }
}
