import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:window_manager/window_manager.dart';

import 'src/app.dart';
import 'src/countdown/countdown_controller.dart';
import 'src/platform/home_widget_bridge.dart';
import 'src/platform/overlay_view.dart';
import 'src/settings/settings_store.dart';

/// Entry point used by `flutter_overlay_window` to launch the floating
/// countdown bubble in its own Flutter engine, separate from the main app.
@pragma('vm:entry-point')
void overlayMain() {
  runApp(const OverlayCountdownApp());
}

bool get _isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final settings = await SettingsStore.load();

  if (_isDesktop) {
    await windowManager.ensureInitialized();
    const defaultOptions = WindowOptions(
      size: Size(420, 520),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(defaultOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else {
    await HomeWidgetBridge.configure();
    await HomeWidgetBridge.pushTarget(settings.target);
  }

  final controller = CountdownController(settings.target);

  runApp(SprintCountdownApp(controller: controller, settings: settings));
}
