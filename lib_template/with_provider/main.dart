import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider_project/controller/auth/auth_provider.dart';
import 'package:provider_project/controller/home/home_provider.dart';
import 'package:provider_project/controller/profile/profile_provider.dart';
import 'package:provider_project/controller/splash/splash_provider.dart';
import 'package:provider_project/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider_project/view/splash/splash_view.dart';

import 'config/app_colors.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashProvider>(
          create: (_) => SplashProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Project Name',
        debugShowCheckedModeBanner: false,
        locale: Locale(languageCode, countryCode),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('hi'), // Hindi
        ],
        theme: ThemeData(fontFamily: 'inter', useMaterial3: false),
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          return MediaQuery(
              data: mediaQueryData.copyWith(
                  textScaler: const TextScaler.linear(1.0)),
              child: ScrollConfiguration(behavior: AppBehavior(), child: child!));
        },
        home: const SplashView(),
      ),
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