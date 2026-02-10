import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [UserSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// Watch the settings row as a reactive stream.
  Stream<UserSettingsTableData> watchSettings() {
    return (select(userSettingsTable)..limit(1)).watchSingle();
  }

  /// Get current settings (one-shot).
  Future<UserSettingsTableData> getSettings() {
    return (select(userSettingsTable)..limit(1)).getSingle();
  }

  /// Update settings.
  Future<void> updateSettings(UserSettingsTableCompanion settings) {
    return (update(userSettingsTable)
          ..where((s) => s.id.equals(1)))
        .write(settings);
  }
}
