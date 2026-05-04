import 'package:flutter_with_reactive_getx/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login({required String email, required String password});
}
