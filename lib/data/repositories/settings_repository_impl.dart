import 'package:drift/drift.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';
import '../database/daos/settings_dao.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDao _settingsDao;

  SettingsRepositoryImpl(this._settingsDao);

  @override
  Stream<UserSettings> watchSettings() {
    return _settingsDao.watchSettings().map(_toDomain);
  }

  @override
  Future<UserSettings> getSettings() async {
    final row = await _settingsDao.getSettings();
    return _toDomain(row);
  }

  @override
  Future<void> updateSettings(UserSettings settings) {
    return _settingsDao.updateSettings(
      UserSettingsTableCompanion(
        selectedPaletteId: Value(settings.selectedPaletteId),
        customPrimary: Value(settings.customPrimary),
        customSecondary: Value(settings.customSecondary),
        customAccent: Value(settings.customAccent),
        brightnessMode: Value(settings.brightnessMode),
        currencyCode: Value(settings.currencyCode),
        notificationsEnabled: Value(settings.notificationsEnabled),
        dailyMotivationTime: Value(settings.dailyMotivationTime),
        hasCompletedOnboarding: Value(settings.hasCompletedOnboarding),
      ),
    );
  }

  UserSettings _toDomain(UserSettingsTableData row) {
    return UserSettings(
      selectedPaletteId: row.selectedPaletteId,
      customPrimary: row.customPrimary,
      customSecondary: row.customSecondary,
      customAccent: row.customAccent,
      brightnessMode: row.brightnessMode,
      currencyCode: row.currencyCode,
      notificationsEnabled: row.notificationsEnabled,
      dailyMotivationTime: row.dailyMotivationTime,
      hasCompletedOnboarding: row.hasCompletedOnboarding,
    );
  }
}
