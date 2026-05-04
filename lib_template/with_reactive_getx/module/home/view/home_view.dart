import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/app_widget/common_offline_builder.dart';
import 'package:flutter_with_reactive_getx/config/app_text_style.dart';
import 'package:flutter_with_reactive_getx/module/home/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
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
