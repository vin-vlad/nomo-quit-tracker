import 'package:flutter/material.dart';

/// Bauhaus-inspired typography scale using Jost and Space Mono.
class NomoTypography {
  NomoTypography._();

  static const String _fontFamily = 'Jost';
  static const String _monoFamily = 'SpaceMono';

  /// Timer display — Jost Bold 48pt
  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.1,
    letterSpacing: -0.5,
  );

  /// Smaller display — Jost Bold 32pt
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// Section headline — Jost SemiBold 24pt
  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.25,
  );

  /// Card/screen title — Jost Medium 20pt
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.3,
  );

  /// Smaller title — Jost Medium 16pt
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.35,
  );

  /// Body text — Jost Regular 16pt
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

  /// Small body text — Jost Regular 14pt
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
  );

  /// Button label — Jost SemiBold 14pt UPPERCASE
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.2,
    letterSpacing: 1.5,
  );

  /// Caption / small labels — Jost Regular 12pt
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
  );

  /// Monospaced counter digits — Space Mono Regular 32pt
  static const TextStyle mono = TextStyle(
    fontFamily: _monoFamily,
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 1.1,
    letterSpacing: 2,
  );

  /// Monospaced small — Space Mono Regular 20pt
  static const TextStyle monoSmall = TextStyle(
    fontFamily: _monoFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.2,
    letterSpacing: 1.5,
  );

  /// Build a Material [TextTheme] from our type scale.
  static TextTheme textTheme(Color color) {
    return TextTheme(
      displayLarge: display.copyWith(color: color),
      displayMedium: displaySmall.copyWith(color: color),
      headlineLarge: headline.copyWith(color: color),
      titleLarge: title.copyWith(color: color),
      titleMedium: titleSmall.copyWith(color: color),
      bodyLarge: body.copyWith(color: color),
      bodyMedium: bodySmall.copyWith(color: color),
      labelLarge: label.copyWith(color: color),
      bodySmall: caption.copyWith(color: color),
    );
  }
}
