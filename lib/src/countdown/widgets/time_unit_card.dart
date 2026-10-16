import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// A single "DD / HH / MM / SS" unit with a smooth digit-roll transition
/// and a soft glass-morphism card. Scales cleanly from the tiny desktop
/// corner window up to a full-screen hero layout.
class TimeUnitCard extends StatelessWidget {
  const TimeUnitCard({
    super.key,
    required this.value,
    required this.label,
    this.compact = false,
  });

  final int value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final digits = value.toString().padLeft(2, '0');
    final valueStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: compact ? 22 : 56,
          shadows: [
            Shadow(
              color: AppPalette.accentCyan.withValues(alpha: 0.45),
              blurRadius: compact ? 8 : 18,
            ),
          ],
        );
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: compact ? 9 : 13,
          letterSpacing: 3,
          fontWeight: FontWeight.w600,
        );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 22,
        vertical: compact ? 8 : 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 14 : 24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              digits,
              key: ValueKey(digits),
              style: valueStyle,
            ),
          ),
          SizedBox(height: compact ? 2 : 8),
          Text(label.toUpperCase(), style: labelStyle),
        ],
      ),
    );
  }
}
