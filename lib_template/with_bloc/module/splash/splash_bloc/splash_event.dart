import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToNext extends SplashEvent {
  final BuildContext context;

  const NavigateToNext({required this.context});

  @override
  List<Object?> get props => [context];
}
