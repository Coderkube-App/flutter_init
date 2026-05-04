import 'package:flutter/material.dart';

import '../config/app_colors.dart';

Widget appLoader() {
  return Container(
    color: AppColor.blackColor,
    child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.blueColor,
          // color: AppColor.redColor,
          strokeWidth: 5,
        )
    ),
  );
}