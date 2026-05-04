import 'dart:io';

import 'package:dynamicutils/Size/dynamicutils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_standard/config/app_colors.dart';

DynamicSize size = DynamicSize(926, 428);

documentSelectionBottomSheet({required BuildContext context, required void Function() filesOnTap, required void Function() photoVideoOnTap}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    backgroundColor: Colors.white,
    useSafeArea: true,
    isScrollControlled: true,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
    builder: (BuildContext context) {
      return SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 23, 23, 0),
                  child: Icon(
                    Icons.close,
                    size: 25,
                    color: AppColor.redColor,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text("Choose Documents",
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
                onTap: filesOnTap,
                title: const Text("Choose from files"),
                trailing: const Icon(Icons.file_copy)),
            if(Platform.isIOS) ListTile(
                onTap: photoVideoOnTap,
                title: const Text("Choose photo or video"),
                trailing: const Icon(Icons.photo))
          ],
        ),
      );
    },
  );
}


appPrint(String data) {
  if (kDebugMode) {
    print(data);
  }
}