import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/config/app_images.dart';
import 'package:bloc_project/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';


class CommonOfflineBuilder extends StatelessWidget {
  final Widget child;

  const CommonOfflineBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      builder: (BuildContext context) {
        return child;
      },
      connectivityBuilder:
          (BuildContext context, List<ConnectivityResult> value, Widget child) {
        if (value.first == ConnectivityResult.none) {
          return Stack(
            children: [
              child,
              OfflineBanner(),
            ],
          );
        }
        return child;
      },
    );
  }
}


/// No network banner
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // height: 50,
        color: Colors.redAccent,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "No internet connection",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontFamily: "inter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// No network screen
class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: size.height(15),
          children: [
            Center(
              child: Image.asset(
                AppImages.noNetworkPng,
                height: size.height(312),
              ),
            ),
            Text(
              'Whoops !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: size.height(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'No Internet Connection found.\nCheck your connection or try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: size.height(17),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
