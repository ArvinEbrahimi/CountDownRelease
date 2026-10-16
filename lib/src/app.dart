import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'core/theme.dart';
import 'countdown/countdown_controller.dart';
import 'countdown/countdown_screen.dart';
import 'settings/settings_store.dart';

class SprintCountdownApp extends StatelessWidget {
  const SprintCountdownApp({
    super.key,
    required this.controller,
    required this.settings,
  });

  final CountdownController controller;
  final SettingsStore settings;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: CountdownScreen(controller: controller, settings: settings),
    );
  }
}
