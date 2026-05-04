import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/module/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("signUp"),
      ),
    );
  }
}
