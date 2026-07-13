import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xFF080F1F);
  static const Color surface = Color(0xFF121B2D);
  static const Color elevatedSurface = Color(0xFF19243A);
  static const Color primary = Color(0xFF36E879);
  static const Color accent = Color(0xFFFF8A2A);
  static const Color violet = Color(0xFF8995FF);
  static const Color muted = Color(0xFF99A6B8);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: background,
      primary: primary,
      secondary: accent,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: const Color(0xFF2C3650),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF062111),
          disabledBackgroundColor: const Color(0xFF283247),
          disabledForegroundColor: muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: muted),
      ),
    );
  }
}
