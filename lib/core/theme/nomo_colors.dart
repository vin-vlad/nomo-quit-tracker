import 'package:flutter/material.dart';

/// Holds a complete color palette for the Nomo design system.
/// Apple Health-inspired with soft, calming tones.
class NomoColorPalette {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onSurface;
  final Color error;
  final Color border;
  final Color shadow;

  const NomoColorPalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurface,
    required this.error,
    required this.border,
    required this.shadow,
  });

  /// Returns a dark-mode variant of this palette.
  NomoColorPalette toDark() {
    return NomoColorPalette(
      id: id,
      name: name,
      primary: primary,
      secondary: secondary,
      accent: accent,
      // Deep charcoal backgrounds — comfortable reading at night.
      background: const Color(0xFF1C1C1E),
      surface: const Color(0xFF2C2C2E),
      onBackground: const Color(0xFFF2F2F7),
      onSurface: const Color(0xFFAEAEB2),
      error: error,
      border: const Color(0xFF38383A),
      shadow: const Color(0x29000000),
    );
  }

  /// Creates a custom palette from user-selected colors.
  static NomoColorPalette custom({
    required Color primary,
    required Color secondary,
    required Color accent,
  }) {
    return NomoColorPalette(
      id: 'custom',
      name: 'Custom',
      primary: primary,
      secondary: secondary,
      accent: accent,
      background: const Color(0xFFF2F2F7),
      surface: const Color(0xFFFFFFFF),
      onBackground: const Color(0xFF1C1C1E),
      onSurface: const Color(0xFF3A3A3C),
      error: const Color(0xFFFF3B30),
      border: const Color(0xFFE5E5EA),
      shadow: const Color(0x1A8E8E93),
    );
  }
}

/// All preset color palettes — Apple Health-inspired.
class NomoPalettes {
  NomoPalettes._();

  /// Default: Soft green health theme.
  static const serenity = NomoColorPalette(
    id: 'serenity',
    name: 'Serenity',
    primary: Color(0xFF34C759),
    secondary: Color(0xFF5856D6),
    accent: Color(0xFFFF9F0A),
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1C1E),
    onSurface: Color(0xFF3A3A3C),
    error: Color(0xFFFF3B30),
    border: Color(0xFFE5E5EA),
    shadow: Color(0x1A8E8E93),
  );

  /// Calming blue tones.
  static const ocean = NomoColorPalette(
    id: 'ocean',
    name: 'Ocean',
    primary: Color(0xFF0A84FF),
    secondary: Color(0xFF5AC8FA),
    accent: Color(0xFF30D158),
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1C1E),
    onSurface: Color(0xFF3A3A3C),
    error: Color(0xFFFF3B30),
    border: Color(0xFFE5E5EA),
    shadow: Color(0x1A8E8E93),
  );

  /// Warm coral tones.
  static const sunset = NomoColorPalette(
    id: 'sunset',
    name: 'Sunset',
    primary: Color(0xFFFF6B6B),
    secondary: Color(0xFFFF9F0A),
    accent: Color(0xFFFFD60A),
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1C1E),
    onSurface: Color(0xFF3A3A3C),
    error: Color(0xFFFF3B30),
    border: Color(0xFFE5E5EA),
    shadow: Color(0x1A8E8E93),
  );

  /// Calming purple tones.
  static const lavender = NomoColorPalette(
    id: 'lavender',
    name: 'Lavender',
    primary: Color(0xFFBF5AF2),
    secondary: Color(0xFFAF52DE),
    accent: Color(0xFFFF2D55),
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1C1E),
    onSurface: Color(0xFF3A3A3C),
    error: Color(0xFFFF3B30),
    border: Color(0xFFE5E5EA),
    shadow: Color(0x1A8E8E93),
  );

  /// Clean grayscale.
  static const monochrome = NomoColorPalette(
    id: 'monochrome',
    name: 'Monochrome',
    primary: Color(0xFF48484A),
    secondary: Color(0xFF8E8E93),
    accent: Color(0xFFC7C7CC),
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1C1E),
    onSurface: Color(0xFF3A3A3C),
    error: Color(0xFFFF3B30),
    border: Color(0xFFE5E5EA),
    shadow: Color(0x1A8E8E93),
  );

  static const List<NomoColorPalette> all = [
    serenity,
    ocean,
    sunset,
    lavender,
    monochrome,
  ];

  /// Look up a palette by its id. Falls back to Serenity.
  /// Maps legacy Bauhaus IDs to new equivalents for backward compatibility.
  static NomoColorPalette byId(String id) {
    switch (id) {
      case 'classic_bauhaus':
        return serenity;
      case 'mondrian':
        return ocean;
      case 'kandinsky':
        return lavender;
      case 'klee':
        return sunset;
    }
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => serenity,
    );
  }
}
