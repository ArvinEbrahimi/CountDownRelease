import 'dart:io';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../countdown/countdown_controller.dart';
import '../platform/home_widget_bridge.dart';
import '../platform/overlay_control.dart';
import 'settings_store.dart';

/// Lets the user turn on the Android home-screen widget and the floating
/// overlay bubble. Desktop corner mode is toggled directly from the pin
/// icon on the main screen, so it isn't duplicated here.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.controller,
  });

  final SettingsStore settings;
  final CountdownController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _busy = false;

  Future<void> _toggleWidget(bool enabled) async {
    setState(() => _busy = true);
    await widget.settings.setWidgetEnabled(enabled);
    if (enabled) {
      await HomeWidgetBridge.configure();
      await HomeWidgetBridge.pushTarget(widget.controller.target);
    }
    setState(() => _busy = false);
  }

  Future<void> _toggleOverlay(bool enabled) async {
    if (!Platform.isAndroid) return;
    setState(() => _busy = true);
    if (enabled) {
      final granted = await OverlayControl.hasPermission();
      if (!granted) {
        await OverlayControl.requestPermission();
      }
      if (await OverlayControl.hasPermission()) {
        await OverlayControl.show(widget.controller.target);
        await widget.settings.setOverlayEnabled(true);
      }
    } else {
      await OverlayControl.hide();
      await widget.settings.setOverlayEnabled(false);
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (Platform.isAndroid || Platform.isIOS)
            SwitchListTile(
              title: const Text('Home-screen widget'),
              subtitle: const Text('Shows the countdown on your home screen'),
              value: widget.settings.widgetEnabled,
              onChanged: _busy ? null : _toggleWidget,
            ),
          if (Platform.isAndroid)
            SwitchListTile(
              title: const Text('Floating bubble (always on top)'),
              subtitle: const Text('Keeps the countdown visible over other apps'),
              value: widget.settings.overlayEnabled,
              onChanged: _busy ? null : _toggleOverlay,
            ),
        ],
      ),
    );
  }
}
