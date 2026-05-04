import 'package:flutter/material.dart';
import 'package:provider_project/config/app_colors.dart';
import 'package:provider_project/config/app_text_style.dart';

class DropDownButtonCommon extends StatelessWidget {
  final String value;
  final String? hintText;
  final List<String> dropDownItems;
  final ValueChanged<String?> onChanged;
  final bool? isExpanded;
  final EdgeInsetsGeometry? padding;

  const DropDownButtonCommon({required this.value,
    required this.dropDownItems,
    required this.onChanged,
    this.isExpanded,
    this.padding,
    super.key,
    this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.blackColor,
          // color: AppColor.redColor,
          border: Border.all(width: 1, color: AppColor.whiteColor),
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                hint: Text(hintText ?? ""),
                // padding: padding ?? const EdgeInsets.only(left: 3, right: 3),
                isExpanded: isExpanded ?? true,
                style:
                AppTextStyle.regularText.copyWith(color: AppColor.redColor),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.whiteColor,
                ),
                value: value,
                // items: dropDownItems.map<DropdownMenuItem<String>>((value) {
                //   return DropdownMenuItem(
                //       value: value, child: Text(value.toString()));
                // }).toList(),
                items:
                dropDownItems
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged),
          )),
    );
  }
}