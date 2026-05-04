import 'package:bloc_project/app_widget/common_offline_builder.dart';
import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/module/auth/auth_bloc/auth_bloc.dart';
import 'package:bloc_project/module/auth/auth_bloc/auth_event.dart';
import 'package:bloc_project/module/auth/auth_bloc/auth_state.dart';
import 'package:bloc_project/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen:
            (previous, current) => previous.isLogout != current.isLogout,
        listener:
            (context, state) =>
                Navigator.pushReplacementNamed(context, AppRoutes.login),

        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  /// Event Call for logout
                  context.read<AuthBloc>().add(Logout());
                },
                icon: Icon(Icons.logout, color: AppColor.redColor),
              ),
            ],
          ),
          body: Center(
            child: Text(
              'Hello Welcome',
              style: TextStyle(
                fontSize: 22,
                color: AppColor.blackColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
