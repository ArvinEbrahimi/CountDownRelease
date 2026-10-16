/// Static app-wide configuration for the Sprint launch countdown.
library;

class AppConfig {
  AppConfig._();

  /// Default countdown target: Gregorian New Year 2027, Asia/Tehran time.
  static const String defaultTargetTimeZone = 'Asia/Tehran';
  static const int defaultTargetYear = 2027;
  static const int defaultTargetMonth = 1;
  static const int defaultTargetDay = 1;
  static const int defaultTargetHour = 0;
  static const int defaultTargetMinute = 0;
  static const int defaultTargetSecond = 0;

  static const String appName = 'Sprint Countdown';
  static const String eventTitle = 'SPRINT';
  static const String eventSubtitle = 'LAUNCHING AT NEW YEAR';

  /// Shared-preferences keys.
  static const String prefTargetEpochMs = 'target_epoch_ms';
  static const String prefCornerMode = 'corner_mode_enabled';
  static const String prefWidgetEnabled = 'widget_enabled';
  static const String prefOverlayEnabled = 'overlay_enabled';

  /// Shared app-group id used to bridge data to the Android/iOS widgets.
  static const String widgetAppGroupId = 'group.com.sprint.countdown';
  static const String androidWidgetProviderName = 'CountdownWidgetProvider';
  static const String iosWidgetKind = 'SprintCountdownWidget';
}
