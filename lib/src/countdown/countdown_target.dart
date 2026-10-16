import 'package:timezone/timezone.dart' as tz;

import '../core/app_config.dart';

/// Resolves the configured launch moment to an absolute UTC [DateTime],
/// independent of the device's local timezone.
class CountdownTarget {
  const CountdownTarget(this.utcTarget);

  final DateTime utcTarget;

  static CountdownTarget defaultTarget() {
    final tehran = tz.getLocation(AppConfig.defaultTargetTimeZone);
    final local = tz.TZDateTime(
      tehran,
      AppConfig.defaultTargetYear,
      AppConfig.defaultTargetMonth,
      AppConfig.defaultTargetDay,
      AppConfig.defaultTargetHour,
      AppConfig.defaultTargetMinute,
      AppConfig.defaultTargetSecond,
    );
    return CountdownTarget(local.toUtc());
  }

  static CountdownTarget fromEpochMs(int epochMs) {
    return CountdownTarget(DateTime.fromMillisecondsSinceEpoch(epochMs, isUtc: true));
  }

  int get epochMs => utcTarget.millisecondsSinceEpoch;
}
