import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/config/constant.dart';
import 'package:flutter/cupertino.dart';


class AppTextStyle {
  static TextStyle largeSemiBoldText =
      TextStyle(fontWeight: FontWeight.w600, fontSize: size.height(18));

  static TextStyle regularText = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.height(12),
      color: AppColor.whiteColor);
}
