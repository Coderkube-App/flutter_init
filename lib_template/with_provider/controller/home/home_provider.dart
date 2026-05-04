import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  String _message = "Welcome to Home!";

  String get message => _message;

  void updateMessage(String msg) {
    _message = msg;
    notifyListeners();
  }
}
