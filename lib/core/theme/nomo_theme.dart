import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'nomo_colors.dart';
import 'nomo_dimensions.dart';
import 'nomo_typography.dart';

/// Builds a Material [ThemeData] from a [NomoColorPalette] and brightness.
///
/// Apple Health-inspired: soft surfaces, subtle borders, gentle shadows,
/// rounded corners, and generous whitespace.
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
      shadowColor: colors.shadow,
      dividerColor: colors.border,

      // ── Text ──────────────────────────────────────────────────────
      textTheme: textTheme,

      // ── AppBar ────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: NomoTypography.title.copyWith(
          color: colors.onBackground,
        ),
        shape: Border(
          bottom: BorderSide(
            color: colors.border,
            width: NomoDimensions.dividerWidth,
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
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
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
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
          ),
          side: BorderSide(
            color: colors.primary.withValues(alpha: 0.4),
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
        filled: true,
        fillColor: isDark
            ? colors.surface
            : colors.onSurface.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(NomoDimensions.borderRadiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(NomoDimensions.borderRadiusSmall),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(NomoDimensions.borderRadiusSmall),
          borderSide: BorderSide(
            color: colors.primary,
            width: NomoDimensions.borderWidth,
          ),
        ),
        labelStyle:
            NomoTypography.footnote.copyWith(color: colors.onSurface),
        hintStyle: NomoTypography.body.copyWith(
          color: colors.onSurface.withValues(alpha: isDark ? 0.5 : 0.35),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NomoDimensions.spacing16,
          vertical: NomoDimensions.spacing12,
        ),
      ),

      // ── Bottom Nav ────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor:
            colors.onSurface.withValues(alpha: isDark ? 0.6 : 0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: NomoTypography.caption.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
        unselectedLabelStyle: NomoTypography.caption.copyWith(
          fontSize: 10,
        ),
      ),

      // ── Misc ──────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.border,
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

      // Enable subtle Material ripple for gentle feedback.
      splashFactory: InkSparkle.splashFactory,
      highlightColor: colors.primary.withValues(alpha: 0.08),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
        ),
        elevation: 4,
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 8,
      ),
    );
  }
}
