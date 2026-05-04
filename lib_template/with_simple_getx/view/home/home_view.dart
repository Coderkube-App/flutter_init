import 'package:flutter/material.dart';
import 'package:flutter_standard/app_widget/common_offline_builder.dart';
import 'package:flutter_standard/config/app_text_style.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text("hello_world".tr, style: AppTextStyle.regularText),
        ),
      ),
    );
  }
}
