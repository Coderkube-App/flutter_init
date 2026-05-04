import 'package:flutter/material.dart';
import 'package:my_real_app/config/app_colors.dart';

class ExpansionTileWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ExpansionTileWidget(
      {required this.title, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsetsDirectional.only(start: 0, end: 5),
        iconColor: AppColor.blackColor,
        initiallyExpanded: false,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: AppColor.redColor,
              fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: children,
      ),
    );
  }
}