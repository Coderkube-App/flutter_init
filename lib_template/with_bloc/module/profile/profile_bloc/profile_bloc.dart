import 'dart:async';

import 'package:bloc_project/module/profile/profile_bloc/profile_event.dart';
import 'package:bloc_project/module/profile/profile_bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<UpdateProfileTitle>(_onUpdateProfileTitle);
  }

  FutureOr<void> _onUpdateProfileTitle(
    UpdateProfileTitle event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }
}
