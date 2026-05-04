import 'package:flutter/material.dart';
import 'package:my_real_app/config/app_colors.dart';

// class AppButton extends StatelessWidget {
//   final String text;
//   final Function() onPressed;
//   final double? width;
//   final Color? color;
//
//   const AppButton({required this.text, required this.onPressed, this.width, super.key, this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: color ?? AppColor.whiteColor,
//               padding: EdgeInsets.symmetric(vertical: size.height(12)),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7))),
//           onPressed: onPressed,
//           child: Text(text,
//               style: AppTextStyle.regularText)),
//     );
//   }
// }

class AppButton extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final double horizontalMargin;
  final double verticalMargin;
  final Color? buttonColor;
  final double borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Function()? onTap;

  const AppButton({
    super.key,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 16.0,
    this.horizontalMargin = 16.0,
    this.verticalMargin = 0.0,
    this.buttonColor = AppColor.blueColor,
    this.borderRadius = 5,
    this.border,
    this.boxShadow,
    this.gradient,
    required this.text,
    this.textColor,
    this.fontWeight,
    this.fontSize, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: boxShadow,
          gradient: gradient,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
