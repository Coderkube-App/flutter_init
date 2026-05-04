import 'package:flutter/material.dart';
import 'package:flutter_with_reactive_getx/modules/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:get/get.dart';

class SignUpView extends GetView<AuthViewModel> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sign Up'),
      ),
    );
  }
}
