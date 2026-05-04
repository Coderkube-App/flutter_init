import 'dart:io';

import 'package:bloc_project/config/app_colors.dart';
import 'package:bloc_project/module/auth/auth_bloc/auth_bloc.dart';
import 'package:bloc_project/module/auth/repository/auth_repo.dart';
import 'package:bloc_project/module/home/home_bloc/home_bloc.dart';
import 'package:bloc_project/module/splash/splash_bloc/splash_bloc.dart';
import 'package:bloc_project/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'module/auth/view/log_in/login_view.dart';
import 'module/home/view/home_view.dart';
import 'module/splash/view/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  runApp(const MyApp());
}

String languageCode = getStorage.read('languageCode') ?? 'en';
String countryCode = getStorage.read('countryCode') ?? 'US';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => AuthRepo())],
      child: MultiBlocProvider(

        /// Define bloc global
        providers: [
          BlocProvider(
            create: (context) => SplashBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(authRepo: context.read<AuthRepo>()),
          ),
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Project Using Bloc',
          debugShowCheckedModeBanner: false,
          locale: Locale(languageCode, countryCode),
          theme: ThemeData(fontFamily: 'inter', useMaterial3: false),
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashView(),
            AppRoutes.login: (_) => const LoginView(),
            AppRoutes.home: (_) => const HomeView(),
          },
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: ScrollConfiguration(
                behavior: AppBehavior(),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
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
