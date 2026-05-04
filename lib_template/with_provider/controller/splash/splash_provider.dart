import 'package:provider_project/config/constant.dart';
import 'package:provider_project/view/auth/log_in/login_view.dart';

import 'package:flutter/material.dart';

class SplashProvider with ChangeNotifier {
  bool _initialized = false;

  bool get initialized => _initialized;

  void initializeApp(BuildContext context) {
    _initialized = true;
    Future.delayed(Duration(seconds: 3), () {
      offAllNavigation(context, LoginView());
    });
    notifyListeners();
  }


}