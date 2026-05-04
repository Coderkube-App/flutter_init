import 'package:flutter/material.dart';
import 'package:flutter_standard/config/app_colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash", style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
