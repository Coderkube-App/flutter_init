import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_reactive_getx/core/localization/app_translations.dart';
import 'package:flutter_with_reactive_getx/core/theme/app_theme.dart';
import 'package:flutter_with_reactive_getx/core/utils/http_overrides.dart';
import 'package:flutter_with_reactive_getx/routes/app_pages.dart';
import 'package:flutter_with_reactive_getx/routes/app_routes.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = DevHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  runApp(const MyApp());
}

final GetStorage _storage = GetStorage();
String languageCode = _storage.read('languageCode') ?? 'en';
String countryCode = _storage.read('countryCode') ?? 'US';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Reactive MVVM',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(languageCode, countryCode),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
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