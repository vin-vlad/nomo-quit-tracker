import 'package:drift/drift.dart';

/// Drift table definition for user settings (single-row table).
class UserSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get selectedPaletteId =>
      text().withDefault(const Constant('classic_bauhaus'))();
  IntColumn get customPrimary => integer().nullable()();
  IntColumn get customSecondary => integer().nullable()();
  IntColumn get customAccent => integer().nullable()();
  TextColumn get brightnessMode =>
      text().withDefault(const Constant('system'))();
  TextColumn get currencyCode =>
      text().withDefault(const Constant('USD'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get dailyMotivationTime => text().nullable()();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();

  @override
  String get tableName => 'user_settings';
}
