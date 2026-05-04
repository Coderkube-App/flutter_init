import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/core/widgets/common_offline_builder.dart';
import 'package:flutter_with_reactive_getx/modules/home/presentation/viewmodels/home_view_model.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text(
            controller.welcomeText.value.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
