import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_config.dart';
import '../countdown/countdown_target.dart';

/// Thin wrapper around [SharedPreferences] for the few user-configurable
/// toggles: target date override, desktop corner mode, widget/overlay state.
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<SettingsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsStore(prefs);
  }

  CountdownTarget get target {
    final epochMs = _prefs.getInt(AppConfig.prefTargetEpochMs);
    if (epochMs == null) return CountdownTarget.defaultTarget();
    return CountdownTarget.fromEpochMs(epochMs);
  }

  Future<void> setTarget(CountdownTarget target) {
    return _prefs.setInt(AppConfig.prefTargetEpochMs, target.epochMs);
  }

  bool get cornerModeEnabled => _prefs.getBool(AppConfig.prefCornerMode) ?? false;

  Future<void> setCornerModeEnabled(bool value) {
    return _prefs.setBool(AppConfig.prefCornerMode, value);
  }

  bool get widgetEnabled => _prefs.getBool(AppConfig.prefWidgetEnabled) ?? false;

  Future<void> setWidgetEnabled(bool value) {
    return _prefs.setBool(AppConfig.prefWidgetEnabled, value);
  }

  bool get overlayEnabled => _prefs.getBool(AppConfig.prefOverlayEnabled) ?? false;

  Future<void> setOverlayEnabled(bool value) {
    return _prefs.setBool(AppConfig.prefOverlayEnabled, value);
  }
}
