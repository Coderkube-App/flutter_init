import 'package:bloc_project/module/profile/profile_bloc/profile_bloc.dart';
import 'package:bloc_project/module/profile/profile_bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Text(
              state.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            );
          },
        ),
      ),
    );
  }
}
