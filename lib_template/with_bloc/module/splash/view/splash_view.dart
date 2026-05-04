import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/module/splash/splash_bloc/splash_bloc.dart';
import 'package:bloc_project/module/splash/splash_bloc/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();

    /// Call Event for after 3 second go to Login view
    context.read<SplashBloc>().add(NavigateToNext(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
          style: TextStyle(
            fontSize: 22,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
