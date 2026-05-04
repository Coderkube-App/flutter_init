import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  String _title = 'Profile';

  String get title => _title;

  void updateTitle(String value) {
    _title = value;
    notifyListeners();
  }
}
