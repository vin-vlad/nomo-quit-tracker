import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/nomo_colors.dart';
import '../../core/theme/nomo_theme.dart';
import 'settings_providers.dart';

/// The currently selected color palette.
final currentPaletteProvider = Provider<NomoColorPalette>((ref) {
  final settingsAsync = ref.watch(userSettingsProvider);
  return settingsAsync.when(
    data: (settings) {
      if (settings.selectedPaletteId == 'custom' &&
          settings.customPrimary != null &&
          settings.customSecondary != null &&
          settings.customAccent != null) {
        return NomoColorPalette.custom(
          primary: Color(settings.customPrimary!),
          secondary: Color(settings.customSecondary!),
          accent: Color(settings.customAccent!),
        );
      }
      return NomoPalettes.byId(settings.selectedPaletteId);
    },
    loading: () => NomoPalettes.serenity,
    error: (_, __) => NomoPalettes.serenity,
  );
});

/// The brightness mode from settings.
final brightnessModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(userSettingsProvider);
  return settingsAsync.when(
    data: (settings) {
      switch (settings.brightnessMode) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});

/// Light theme.
final lightThemeProvider = Provider<ThemeData>((ref) {
  final palette = ref.watch(currentPaletteProvider);
  return NomoTheme.build(palette, Brightness.light);
});

/// Dark theme.
final darkThemeProvider = Provider<ThemeData>((ref) {
  final palette = ref.watch(currentPaletteProvider);
  return NomoTheme.build(palette, Brightness.dark);
});
