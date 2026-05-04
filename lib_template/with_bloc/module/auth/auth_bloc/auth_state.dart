import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isLogout;

  const AuthState({this.isLoading = false, this.isLogout = false});

  AuthState copyWith({bool? isLoading, bool? isLogout}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLogout: isLogout ?? this.isLogout,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLogout];
}
