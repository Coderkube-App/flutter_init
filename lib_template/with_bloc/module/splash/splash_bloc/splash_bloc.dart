import 'dart:async';

import 'package:bloc_project/module/splash/splash_bloc/splash_event.dart';
import 'package:bloc_project/module/splash/splash_bloc/splash_state.dart';
import 'package:bloc_project/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<NavigateToNext>(onNavigateToNext);
  }

  FutureOr<void> onNavigateToNext(
    NavigateToNext event,
    Emitter<SplashState> emit,
  ) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(event.context, AppRoutes.login);
    });
  }
}
