import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  const ProfileState({this.title = 'Profile'});

  final String title;

  ProfileState copyWith({String? title}) {
    return ProfileState(title: title ?? this.title);
  }

  @override
  List<Object?> get props => [title];
}
