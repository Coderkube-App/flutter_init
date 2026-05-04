import 'package:flutter/cupertino.dart';
import 'package:flutter_with_reactive_getx/config/app_colors.dart';
import 'package:flutter_with_reactive_getx/config/constant.dart';

class AppTextStyle {
  static TextStyle largeSemiBoldText =
      TextStyle(fontWeight: FontWeight.w600, fontSize: size.height(18));

  static TextStyle regularText = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.height(12),
      color: AppColor.whiteColor);
}
