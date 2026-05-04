import 'dart:async';
import 'package:bloc_project/module/auth/auth_bloc/auth_event.dart';
import 'package:bloc_project/module/auth/auth_bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc({required this.authRepo}) : super(AuthState()) {
    on<TapLogin>(onTapLogin);
    on<Logout>(onLogout);
  }

  Future<void> onTapLogin(TapLogin event, Emitter<AuthState> emit) async {
    /// update value
    emit(state.copyWith(isLoading: true));
    await authRepo.login(body: {}).then((value) {});
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> onLogout(Logout event, Emitter<AuthState> emit) {
    /// Logout logic is here
    emit(state.copyWith(isLogout: !state.isLogout));
  }
}
