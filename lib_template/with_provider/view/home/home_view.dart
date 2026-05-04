import 'package:flutter/material.dart';
import 'package:provider_project/app_widget/common_offline_builder.dart';
import 'package:provider_project/config/app_text_style.dart';
import 'package:provider_project/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonOfflineBuilder(
      child: Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.title),
        ),
      ),
    );
  }
}
