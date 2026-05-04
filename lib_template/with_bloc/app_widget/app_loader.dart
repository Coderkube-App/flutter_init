import 'package:flutter/material.dart';

import '../config/app_colors.dart';

Widget appLoader() {
  return Container(
    color: AppColor.blackColor.withValues(alpha: 0.5),
    child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.blueColor,
          strokeWidth: 5,
        )
    ),
  );
}