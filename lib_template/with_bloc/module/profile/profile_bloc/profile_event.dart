import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileTitle extends ProfileEvent {
  const UpdateProfileTitle(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}
