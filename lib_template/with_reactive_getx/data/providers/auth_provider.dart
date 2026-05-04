import 'package:flutter_with_reactive_getx/core/network/api_client.dart';
import 'package:flutter_with_reactive_getx/core/network/api_endpoints.dart';

class AuthProvider {
  AuthProvider(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post(ApiEndpoints.login, {
      'email': email,
      'password': password,
    });
  }
}
