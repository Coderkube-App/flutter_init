import 'package:flutter/cupertino.dart';
import 'package:provider_project/config/app_colors.dart';
import 'package:provider_project/config/constant.dart';

class AppTextStyle {
  static TextStyle largeSemiBoldText =
      TextStyle(fontWeight: FontWeight.w600, fontSize: size.height(18));

  static TextStyle regularText = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.height(18),
      color: AppColor.blackColor);
}
