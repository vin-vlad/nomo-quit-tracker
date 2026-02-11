import 'package:flutter/material.dart';

/// Clean, soft typography scale inspired by Apple's design guidelines.
/// Generous line heights and moderate weights for readability and calm.
class NomoTypography {
  NomoTypography._();

  static const String _fontFamily = 'NotoSans';
  static const String _condensedFamily = 'NotoSansCondensed';

  /// Large display — hero numbers, key metrics — 40pt SemiBold
  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 40,
    height: 1.15,
    letterSpacing: -0.5,
  );

  /// Medium display — 28pt SemiBold
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// Section headline — 22pt SemiBold
  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// Card / screen title — 18pt Medium
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.35,
  );

  /// Smaller title — 15pt Medium
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.4,
  );

  /// Body text — 16pt Regular
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

  /// Small body text — 14pt Regular
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
  );

  /// Button / action label — 15pt SemiBold (no forced uppercase)
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.2,
    letterSpacing: 0.0,
  );

  /// Footnote — helper text — 13pt Regular
  static const TextStyle footnote = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
  );

  /// Caption / small labels — 12pt Regular
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
  );

  /// Counter digits — Noto Sans Condensed 32pt
  static const TextStyle mono = TextStyle(
    fontFamily: _condensedFamily,
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 1.1,
    letterSpacing: 2,
  );

  /// Condensed small — 20pt
  static const TextStyle monoSmall = TextStyle(
    fontFamily: _condensedFamily,
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
