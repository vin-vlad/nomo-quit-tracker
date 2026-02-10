import 'package:flutter/material.dart';

/// Holds a complete color palette for the Nomo Bauhaus design system.
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
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      onBackground: const Color(0xFFFAFAF8),
      onSurface: const Color(0xFFE0E0E0),
      error: error,
      border: const Color(0xFFFAFAF8),
      shadow: const Color(0xFF000000),
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
      background: const Color(0xFFFAFAF8),
      surface: const Color(0xFFFFFFFF),
      onBackground: const Color(0xFF1A1A1A),
      onSurface: const Color(0xFF2D2D2D),
      error: const Color(0xFFD32F2F),
      border: const Color(0xFF1A1A1A),
      shadow: const Color(0xFF1A1A1A),
    );
  }
}

/// All preset color palettes.
class NomoPalettes {
  NomoPalettes._();

  static const classicBauhaus = NomoColorPalette(
    id: 'classic_bauhaus',
    name: 'Classic Bauhaus',
    primary: Color(0xFFBE1E2D),
    secondary: Color(0xFF21409A),
    accent: Color(0xFFF5D327),
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF2D2D2D),
    error: Color(0xFFD32F2F),
    border: Color(0xFF1A1A1A),
    shadow: Color(0xFF1A1A1A),
  );

  static const mondrian = NomoColorPalette(
    id: 'mondrian',
    name: 'Mondrian',
    primary: Color(0xFFD40920),
    secondary: Color(0xFF1356A2),
    accent: Color(0xFFF7D842),
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF2D2D2D),
    error: Color(0xFFD32F2F),
    border: Color(0xFF1A1A1A),
    shadow: Color(0xFF1A1A1A),
  );

  static const kandinsky = NomoColorPalette(
    id: 'kandinsky',
    name: 'Kandinsky',
    primary: Color(0xFF6B3FA0),
    secondary: Color(0xFF2A9D8F),
    accent: Color(0xFFE76F51),
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF2D2D2D),
    error: Color(0xFFD32F2F),
    border: Color(0xFF1A1A1A),
    shadow: Color(0xFF1A1A1A),
  );

  static const klee = NomoColorPalette(
    id: 'klee',
    name: 'Klee',
    primary: Color(0xFFC4745A),
    secondary: Color(0xFF606C38),
    accent: Color(0xFFDDA15E),
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF2D2D2D),
    error: Color(0xFFD32F2F),
    border: Color(0xFF1A1A1A),
    shadow: Color(0xFF1A1A1A),
  );

  static const monochrome = NomoColorPalette(
    id: 'monochrome',
    name: 'Monochrome',
    primary: Color(0xFF1A1A1A),
    secondary: Color(0xFF6B6B6B),
    accent: Color(0xFFFAFAF8),
    background: Color(0xFFFAFAF8),
    surface: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF2D2D2D),
    error: Color(0xFFD32F2F),
    border: Color(0xFF1A1A1A),
    shadow: Color(0xFF1A1A1A),
  );

  static const List<NomoColorPalette> all = [
    classicBauhaus,
    mondrian,
    kandinsky,
    klee,
    monochrome,
  ];

  /// Look up a palette by its id. Falls back to Classic Bauhaus.
  static NomoColorPalette byId(String id) {
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => classicBauhaus,
    );
  }
}
