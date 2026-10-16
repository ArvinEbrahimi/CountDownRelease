import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../core/theme.dart';
import '../countdown/countdown_controller.dart';
import '../countdown/countdown_target.dart';
import '../countdown/widgets/time_unit_card.dart';

/// Root widget for the floating overlay window shown over other Android
/// apps. Receives the target epoch once from the main app via
/// [FlutterOverlayWindow.overlayListener] and then ticks independently.
class OverlayCountdownApp extends StatefulWidget {
  const OverlayCountdownApp({super.key});

  @override
  State<OverlayCountdownApp> createState() => _OverlayCountdownAppState();
}

class _OverlayCountdownAppState extends State<OverlayCountdownApp> {
  CountdownController? _controller;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is int) {
        setState(() {
          _controller?.dispose();
          _controller = CountdownController(CountdownTarget.fromEpochMs(event))
            ..addListener(() => setState(() {}));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakdown = _controller?.breakdown;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FlutterOverlayWindow.resizeOverlay(260, 92, false),
          child: Container(
            decoration: BoxDecoration(
              color: AppPalette.backgroundAlt.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: breakdown == null
                ? const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TimeUnitCard(value: breakdown.days, label: 'D', compact: true),
                      TimeUnitCard(value: breakdown.hours, label: 'H', compact: true),
                      TimeUnitCard(value: breakdown.minutes, label: 'M', compact: true),
                      TimeUnitCard(value: breakdown.seconds, label: 'S', compact: true),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
