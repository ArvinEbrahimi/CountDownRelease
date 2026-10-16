import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark, premium "launch control" visual language shared by the full app,
/// the desktop corner widget, and the Android overlay.
class AppPalette {
  AppPalette._();

  static const Color background = Color(0xFF05070D);
  static const Color backgroundAlt = Color(0xFF0B0F1A);
  static const Color surface = Color(0x78111624);
  static const Color accentCyan = Color(0xFF34E7E4);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentMagenta = Color(0xFFFF4FA3);
  static const Color textPrimary = Color(0xFFF5F7FB);
  static const Color textMuted = Color(0xFF8A93A6);

  static const LinearGradient backdrop = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF05070D), Color(0xFF0C1022), Color(0xFF14102A)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, accentViolet],
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final displayFont = GoogleFonts.orbitron();
  final bodyFont = GoogleFonts.manrope();

  return base.copyWith(
    scaffoldBackgroundColor: AppPalette.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppPalette.accentCyan,
      secondary: AppPalette.accentViolet,
      surface: AppPalette.backgroundAlt,
    ),
    textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
      displayLarge: displayFont.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        color: AppPalette.textPrimary,
        letterSpacing: 2,
      ),
      titleLarge: bodyFont.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppPalette.textPrimary,
        letterSpacing: 4,
      ),
      bodyMedium: bodyFont.copyWith(
        color: AppPalette.textMuted,
        fontSize: 14,
      ),
    ),
  );
}
