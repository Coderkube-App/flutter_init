import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_reactive_getx/config/app_colors.dart';
import 'package:flutter_with_reactive_getx/config/localization.dart';
import 'package:flutter_with_reactive_getx/route/app_route.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  runApp(const MyApp());
}

String languageCode = getStorage.read('languageCode') ?? 'en';
String countryCode = getStorage.read('countryCode') ?? 'US';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Project Name',
      debugShowCheckedModeBanner: false,
      translations: Localization(),
      locale: Locale(languageCode, countryCode),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(fontFamily: 'inter', useMaterial3: false),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
            data: mediaQueryData.copyWith(
                textScaler: const TextScaler.linear(1.0)),
            child: ScrollConfiguration(behavior: AppBehavior(), child: child!));
      },
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}