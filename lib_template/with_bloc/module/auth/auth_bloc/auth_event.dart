import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event call from screen
/// Working like method call
class TapLogin extends AuthEvent {
  final bool isTapLoading;

  const TapLogin({required this.isTapLoading});

  @override
  List<Object?> get props => [isTapLoading];
}

class Logout extends AuthEvent {
  const Logout();

  @override
  List<Object?> get props => [];
}
