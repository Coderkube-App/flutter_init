import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class CommonOfflineBuilder extends StatelessWidget {
  const CommonOfflineBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      builder: (context) => child,
      connectivityBuilder: (context, result, childWidget) {
        if (result.first == ConnectivityResult.none) {
          return Stack(
            children: [
              childWidget,
              const _OfflineBanner(),
            ],
          );
        }
        return childWidget;
      },
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'no_internet_connection'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
