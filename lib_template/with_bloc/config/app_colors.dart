import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppColor {
  static const Color redColor = Colors.red;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color blueColor = Colors.blue;
}

final getStorage = GetStorage();

kDebugPrint(String text) {
  if (kDebugMode) {
    print(text);
  }
}
