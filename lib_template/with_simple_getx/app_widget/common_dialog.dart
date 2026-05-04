import 'package:flutter/material.dart';
import 'package:flutter_standard/app_widget/app_button.dart';
import 'package:flutter_standard/config/app_colors.dart';
import 'package:flutter_standard/config/app_text_style.dart';
import 'package:flutter_standard/config/constant.dart';
import 'package:get/get.dart';

showCommonAlertDialog(
    {
      required String title,
      required String subTitle,
      required String confirmText,
      required String cancelText,
      Function()? confirmOnTap,
      Function()? cancelOnTap}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (context) {
      return PopScope(
        canPop: true,
        child: AlertDialog(
          backgroundColor: AppColor.blackColor,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width(10), vertical: size.height(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regularText
                          .copyWith(color: AppColor.whiteColor)
                  ),
                  size.heightSpace(10),
                  Text(subTitle, textAlign: TextAlign.center, style: AppTextStyle.regularText
                      .copyWith(color: AppColor.whiteColor)),
                  size.heightSpace(10),
                  Row(
                    children: [
                      Expanded(child: AppButton(text: cancelText, borderRadius: 35,)),
                      size.widthSpace(10),
                      Expanded(child: AppButton(text: confirmText, borderRadius: 35,))
                    ],
                  )
                ],
              )),
        ),
      );
    },
  );
}