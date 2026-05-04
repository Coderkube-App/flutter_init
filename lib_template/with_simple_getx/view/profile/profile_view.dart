import 'package:flutter/material.dart';
import 'package:flutter_standard/controller/profile/profile_controller.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Text(
            controller.title.value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
