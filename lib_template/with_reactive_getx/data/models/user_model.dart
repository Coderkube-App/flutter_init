import 'package:flutter_with_reactive_getx/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }
}
