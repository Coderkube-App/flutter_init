import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_reactive_getx/config/app_colors.dart';
import 'package:flutter_with_reactive_getx/config/constant.dart';
import 'package:flutter_with_reactive_getx/config/app_text_style.dart';


class AppTextFormField extends StatelessWidget {
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? obscuringCharacter;
  final bool? obscureText;
  final bool? readOnly;
  final FocusNode? focusNode;
  final String? Function(dynamic value)? validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final TextStyle? style;
  final Widget? suffix;
  final bool? filled;
  final bool autoFocus;
  final bool? isDense;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmit;
  final int? maxLength;
  final Widget? prefix;
  final double borderRadius;
  final Color errorBorderColor;
  final Color borderColor;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField(
      {this.suffixIcon,
      this.prefixIcon,
      this.obscuringCharacter,
      this.obscureText,
      this.hintText,
      this.maxLines,
      this.readOnly,
      this.contentPadding,
      this.validator,
        this.keyboardType = TextInputType.text,
      required this.controller,
      super.key,
      this.textAlign,
      this.style,
      this.suffix,
      this.onTap,
      this.onFieldSubmit,
      this.maxLength,
      this.inputFormatters,
      this.onChanged, this.filled = false, this.focusNode, this.minLines, this.textInputAction = TextInputAction.next, this.autoFocus = false, this.isDense, this.prefix, this.borderRadius = 8.0, this.errorBorderColor = AppColor.redColor, this.borderColor = AppColor.blackColor, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
      textAlign: textAlign ?? TextAlign.start,
      onFieldSubmitted: onFieldSubmit,
      maxLength: maxLength,
      onChanged: onChanged,
      inputFormatters: inputFormatters ??
          [
            FilteringTextInputFormatter.deny(RegExp('"')),
          ],
      autovalidateMode: AutovalidateMode.always,
      focusNode: focusNode,
      minLines: minLines,
      textInputAction: textInputAction,
      onSaved: onSaved,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.regularText,
        prefix: prefix,
        isDense: isDense,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
                vertical: size.height(0), horizontal: size.width(20)),
        filled: filled,
        counterText: "",
        fillColor: AppColor.whiteColor,
        suffixIcon: suffixIcon,
        suffix: suffix,
        prefixIcon: prefixIcon,
        errorMaxLines: 3,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: errorBorderColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: errorBorderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: borderColor),
        ),
      ),
      obscuringCharacter: '*',
      obscureText: obscureText ?? false,
      validator: validator,
      keyboardType: keyboardType,
      cursorColor: AppColor.whiteColor,
      onTap: onTap,
    );
  }
}
