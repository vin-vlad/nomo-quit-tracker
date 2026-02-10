import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'nomo_colors.dart';
import 'nomo_dimensions.dart';
import 'nomo_typography.dart';

/// Builds a Material [ThemeData] from a [NomoColorPalette] and brightness.
///
/// All Material defaults are overridden to match the Bauhaus aesthetic:
/// sharp corners, bold borders, no ripple, flat colors.
class NomoTheme {
  NomoTheme._();

  static ThemeData build(NomoColorPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark ? palette.toDark() : palette;
    final textTheme = NomoTypography.textTheme(colors.onBackground);

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      fontFamily: 'NotoSans',

      // ── Colors ────────────────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: Colors.white,
        secondary: colors.secondary,
        onSecondary: Colors.white,
        tertiary: colors.accent,
        onTertiary: Colors.black,
        error: colors.error,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.onSurface,
      ),
      scaffoldBackgroundColor: colors.background,

      // ── Text ──────────────────────────────────────────────────────
      textTheme: textTheme,

      // ── AppBar ────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: NomoTypography.headline.copyWith(
          color: colors.onBackground,
        ),
        shape: Border(
          bottom: BorderSide(
            color: colors.border,
            width: NomoDimensions.borderWidth,
          ),
        ),
      ),

      // ── Cards ─────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
          side: BorderSide(
            color: colors.border,
            width: NomoDimensions.cardBorderWidth,
          ),
        ),
      ),

      // ── Buttons ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: NomoTypography.label,
          padding: const EdgeInsets.symmetric(
            horizontal: NomoDimensions.spacing24,
            vertical: NomoDimensions.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
            side: BorderSide(
              color: colors.border,
              width: NomoDimensions.borderWidth,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          elevation: 0,
          textStyle: NomoTypography.label,
          padding: const EdgeInsets.symmetric(
            horizontal: NomoDimensions.spacing24,
            vertical: NomoDimensions.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
          ),
          side: BorderSide(
            color: colors.border,
            width: NomoDimensions.borderWidth,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: NomoTypography.label,
          padding: const EdgeInsets.symmetric(
            horizontal: NomoDimensions.spacing16,
            vertical: NomoDimensions.spacing8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
          ),
        ),
      ),

      // ── Input ─────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.border,
            width: NomoDimensions.borderWidth,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            // Make borders a bit more visible in dark mode while
            // staying subtle in light mode.
            color: colors.border.withValues(alpha: isDark ? 0.6 : 0.4),
            width: NomoDimensions.borderWidth,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary,
            width: NomoDimensions.borderWidth,
          ),
        ),
        labelStyle: NomoTypography.caption.copyWith(color: colors.onSurface),
        hintStyle: NomoTypography.body.copyWith(
          // Slightly stronger hint contrast in dark mode for legibility.
          color: colors.onSurface.withValues(alpha: isDark ? 0.7 : 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: NomoDimensions.spacing12,
        ),
      ),

      // ── Bottom Nav ────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        // Unselected items stay readable in dark mode.
        unselectedItemColor:
            colors.onSurface.withValues(alpha: isDark ? 0.7 : 0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: NomoTypography.caption.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: NomoTypography.caption,
      ),

      // ── Misc ──────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        // Soften dividers in dark mode to avoid high-contrast lines.
        color: isDark ? colors.border.withValues(alpha: 0.7) : colors.border,
        thickness: NomoDimensions.dividerWidth,
        space: 0,
      ),

      // ── Page transitions (shared axis vertical for push/pop) ──
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.vertical,
          ),
          TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.vertical,
          ),
          TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.vertical,
          ),
        },
      ),

      // Disable Material splash/ripple for a Bauhaus feel.
      splashFactory: NoSplash.splashFactory,
      highlightColor: colors.primary.withValues(alpha: 0.1),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
          side: BorderSide(
            color: colors.border,
            width: NomoDimensions.cardBorderWidth,
          ),
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(NomoDimensions.borderRadius),
            topRight: Radius.circular(NomoDimensions.borderRadius),
          ),
          side: BorderSide(
            color: colors.border,
            width: NomoDimensions.cardBorderWidth,
          ),
        ),
      ),
    );
  }
}
