import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class TapSaveData extends HomeEvent {
  final String name;

  const TapSaveData({required this.name});

  @override
  List<Object?> get props => [];
}
