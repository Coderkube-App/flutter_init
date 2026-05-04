import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_project/controller/profile/profile_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ProfileProvider>(
          builder: (_, provider, __) => Text(
            provider.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
