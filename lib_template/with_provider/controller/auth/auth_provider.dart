
import 'package:provider_project/config/constant.dart';
import 'package:provider_project/repositories/auth/auth_repo.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Login API
  Future<void> login() async {
    try {
      _isLoading = true;
      notifyListeners();

      final value = await AuthRepo.login(body: {});
      appPrint("login Response -> $value");

      if (value?.statusState == "success") {}

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      appPrint("error -> $e");
    }
  }

  /// Optional: Lifecycle equivalents
  void onInit() {
    // Optional init logic
  }

  void onDispose() {
    // Optional cleanup
  }
}
