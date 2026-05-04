
import 'package:my_real_app/config/constant.dart';
import 'package:my_real_app/repositories/auth/auth_repo.dart';
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

      if (value?.statusState == "success") {
        // TODO: Add your success logic here
      }

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
