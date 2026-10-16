import 'dart:ui';

import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// Toggles the desktop window between a normal resizable window and a
/// small, frameless, always-on-top widget pinned to the screen's
/// bottom-right corner — the "always in the corner of your eye" mode.
class DesktopCornerMode {
  DesktopCornerMode._();

  static const Size normalSize = Size(420, 520);
  static const Size cornerSize = Size(260, 110);
  static const double cornerMargin = 24;

  static Future<void> enterCornerMode() async {
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setResizable(false);
    await windowManager.setHasShadow(true);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: false);
    await windowManager.setSize(cornerSize);

    final screenBounds = await _primaryDisplaySize();
    final x = screenBounds.width - cornerSize.width - cornerMargin;
    final y = screenBounds.height - cornerSize.height - cornerMargin;
    await windowManager.setPosition(Offset(x, y));
  }

  static Future<void> exitCornerMode() async {
    await windowManager.setTitleBarStyle(TitleBarStyle.normal, windowButtonVisibility: true);
    await windowManager.setResizable(true);
    await windowManager.setSize(normalSize);
    await windowManager.center();
    await windowManager.setAlwaysOnTop(false);
  }

  /// Falls back to a common 1920x1080 canvas if the OS can't report bounds,
  /// so corner placement never throws.
  static Future<Size> _primaryDisplaySize() async {
    try {
      final display = await screenRetriever.getPrimaryDisplay();
      return display.size;
    } catch (_) {
      return const Size(1920, 1080);
    }
  }
}
