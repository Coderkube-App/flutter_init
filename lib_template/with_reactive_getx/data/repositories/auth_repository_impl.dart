import 'dart:convert';

import 'package:flutter_with_reactive_getx/data/models/user_model.dart';
import 'package:flutter_with_reactive_getx/data/providers/auth_provider.dart';
import 'package:flutter_with_reactive_getx/domain/entities/user_entity.dart';
import 'package:flutter_with_reactive_getx/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._provider);

  final AuthProvider _provider;

  @override
  Future<UserEntity?> login({required String email, required String password}) async {
    final response = await _provider.login(email: email, password: password);
    final body = response['body'];
    if (body == null || (body as String).isEmpty) return null;
    final decoded = jsonDecode(body as String);
    if (decoded is! Map<String, dynamic>) return null;
    return UserModel.fromJson(decoded);
  }
}
