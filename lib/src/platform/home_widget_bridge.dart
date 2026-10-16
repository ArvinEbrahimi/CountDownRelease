import 'package:home_widget/home_widget.dart';

import '../core/app_config.dart';
import '../countdown/countdown_target.dart';

/// Pushes the current countdown target to the native Android App Widget /
/// iOS WidgetKit storage so the home-screen widgets can render without the
/// Flutter engine running.
///
/// The native widget providers (Android `CountdownWidgetProvider` and the
/// iOS `SprintCountdownWidget` WidgetKit extension) read the same
/// `target_epoch_ms` key and compute their own remaining time locally.
class HomeWidgetBridge {
  HomeWidgetBridge._();

  static Future<void> configure() async {
    await HomeWidget.setAppGroupId(AppConfig.widgetAppGroupId);
  }

  static Future<void> pushTarget(CountdownTarget target) async {
    await HomeWidget.saveWidgetData<int>(AppConfig.prefTargetEpochMs, target.epochMs);
    await HomeWidget.updateWidget(
      androidName: AppConfig.androidWidgetProviderName,
      iOSName: AppConfig.iosWidgetKind,
    );
  }
}
