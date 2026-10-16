import 'dart:async';

import 'package:flutter/foundation.dart';

import 'countdown_breakdown.dart';
import 'countdown_target.dart';

/// Ticks once a second and exposes the current [CountdownBreakdown] for
/// [target]. Shared by the full-screen UI, the desktop corner window, and
/// the data pushed to the Android/iOS home-screen widgets.
class CountdownController extends ChangeNotifier {
  CountdownController(CountdownTarget target) : _target = target {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  CountdownTarget _target;
  Timer? _timer;
  CountdownBreakdown _breakdown = const CountdownBreakdown(
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0,
    isComplete: false,
  );

  CountdownTarget get target => _target;
  CountdownBreakdown get breakdown => _breakdown;

  void updateTarget(CountdownTarget target) {
    _target = target;
    _tick();
  }

  void _tick() {
    final remaining = _target.utcTarget.difference(DateTime.now().toUtc());
    _breakdown = CountdownBreakdown.fromDuration(remaining);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
