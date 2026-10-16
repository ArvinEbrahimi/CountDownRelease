import 'dart:io';

import 'package:flutter/material.dart';

import '../core/app_config.dart';
import '../core/theme.dart';
import '../desktop/desktop_corner_mode.dart';
import '../settings/settings_screen.dart';
import '../settings/settings_store.dart';
import 'countdown_controller.dart';
import 'widgets/time_unit_card.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({
    super.key,
    required this.controller,
    required this.settings,
  });

  final CountdownController controller;
  final SettingsStore settings;

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  bool get _isDesktop =>
      !Platform.environment.containsKey('FLUTTER_TEST') &&
      (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTick);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() => setState(() {});

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(settings: widget.settings, controller: widget.controller),
      ),
    );
  }

  Future<void> _toggleCornerMode() async {
    final enabled = !widget.settings.cornerModeEnabled;
    await widget.settings.setCornerModeEnabled(enabled);
    if (enabled) {
      await DesktopCornerMode.enterCornerMode();
    } else {
      await DesktopCornerMode.exitCornerMode();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final breakdown = widget.controller.breakdown;
    final compact = widget.settings.cornerModeEnabled;

    final content = Container(
      decoration: const BoxDecoration(gradient: AppPalette.backdrop),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(compact ? 12 : 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!compact) ...[
                  ShaderMask(
                    shaderCallback: (bounds) => AppPalette.accentGradient
                        .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      AppConfig.eventTitle,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConfig.eventSubtitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppPalette.textMuted,
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 36),
                ],
                breakdown.isComplete
                    ? _LaunchedBanner(compact: compact)
                    : Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: compact ? 6 : 16,
                        runSpacing: compact ? 6 : 16,
                        children: [
                          TimeUnitCard(value: breakdown.days, label: 'Days', compact: compact),
                          _Separator(compact: compact),
                          TimeUnitCard(value: breakdown.hours, label: 'Hours', compact: compact),
                          _Separator(compact: compact),
                          TimeUnitCard(value: breakdown.minutes, label: 'Min', compact: compact),
                          _Separator(compact: compact),
                          TimeUnitCard(value: breakdown.seconds, label: 'Sec', compact: compact),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!_isDesktop) {
      return Scaffold(
        body: Stack(
          children: [
            content,
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined, color: AppPalette.textMuted),
                  onPressed: _openSettings,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          content,
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              tooltip: compact ? 'Expand' : 'Pin to corner',
              icon: Icon(
                compact ? Icons.open_in_full : Icons.push_pin_outlined,
                color: AppPalette.textMuted,
                size: compact ? 16 : 22,
              ),
              onPressed: _toggleCornerMode,
            ),
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: compact ? 18 : 40,
            color: AppPalette.textMuted,
          ),
    );
  }
}

class _LaunchedBanner extends StatelessWidget {
  const _LaunchedBanner({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppPalette.accentGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        'WE ARE LIVE 🚀',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: compact ? 16 : 40,
              color: Colors.white,
            ),
      ),
    );
  }
}
