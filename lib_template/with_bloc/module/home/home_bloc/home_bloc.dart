import 'dart:async';

import 'package:bloc_project/module/home/home_bloc/home_event.dart';
import 'package:bloc_project/module/home/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<TapSaveData>(onTapSaveData);
  }

  FutureOr<void> onTapSaveData(TapSaveData event, Emitter<HomeState> emit) {
    emit(state.copyWith(name: event.name));
  }
}
