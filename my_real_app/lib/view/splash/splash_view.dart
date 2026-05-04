import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_real_app/config/app_colors.dart';
import 'package:my_real_app/controller/splash/splash_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<SplashProvider>(context, listen: false);
      provider.initializeApp(context); // or loadData(), fetch(), etc.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash", style: TextStyle(fontSize: 22, color: AppColor.blackColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
