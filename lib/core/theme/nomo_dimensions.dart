/// Spacing, sizing, and visual constants for a calm, spacious design.
/// Based on an 8 px grid with additional intermediate sizes for flexibility.
class NomoDimensions {
  NomoDimensions._();

  // ── Spacing (8px grid) ──────────────────────────────────────────────
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing28 = 28;
  static const double spacing32 = 32;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // ── Borders ─────────────────────────────────────────────────────────
  /// Subtle border for cards.
  static const double cardBorderWidth = 0.5;

  /// Standard border for buttons & inputs.
  static const double borderWidth = 1.0;

  /// Thin border for dividers.
  static const double dividerWidth = 0.5;

  // ── Shadow ──────────────────────────────────────────────────────────
  /// Soft blur shadow (not block-style).
  static const double shadowBlur = 10;
  static const double shadowOffsetX = 0;
  static const double shadowOffsetY = 2;

  // ── Border radius ───────────────────────────────────────────────────
  /// Rounded corners — soft and friendly.
  static const double borderRadius = 16;

  /// Smaller radius for chips, badges, pills.
  static const double borderRadiusSmall = 10;

  // ── Progress ring ───────────────────────────────────────────────────
  static const double progressRingStroke = 5;

  // ── Icon sizes ──────────────────────────────────────────────────────
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;

  // ── Card ────────────────────────────────────────────────────────────
  static const double cardPadding = 16;
}
