import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../countdown/countdown_target.dart';

/// Main-app side controls for the Android floating overlay: permission
/// request, show/hide, and pushing the current target to the running
/// overlay engine.
class OverlayControl {
  OverlayControl._();

  static Future<bool> hasPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  static Future<bool?> requestPermission() {
    return FlutterOverlayWindow.requestPermission();
  }

  static Future<void> show(CountdownTarget target) async {
    await FlutterOverlayWindow.showOverlay(
      height: 92,
      width: 260,
      alignment: OverlayAlignment.topRight,
      flag: OverlayFlag.defaultFlag,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
    );
    await FlutterOverlayWindow.shareData(target.epochMs);
  }

  static Future<void> hide() {
    return FlutterOverlayWindow.closeOverlay();
  }

  static Future<void> updateTarget(CountdownTarget target) {
    return FlutterOverlayWindow.shareData(target.epochMs);
  }
}
