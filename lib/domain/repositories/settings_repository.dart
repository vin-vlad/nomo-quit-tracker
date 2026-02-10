/// User settings entity.
class UserSettings {
  final String selectedPaletteId;
  final int? customPrimary;
  final int? customSecondary;
  final int? customAccent;
  final String brightnessMode; // "system", "light", "dark"
  final String currencyCode;
  final bool notificationsEnabled;
  final String? dailyMotivationTime; // "HH:mm"
  final bool hasCompletedOnboarding;

  const UserSettings({
    this.selectedPaletteId = 'classic_bauhaus',
    this.customPrimary,
    this.customSecondary,
    this.customAccent,
    this.brightnessMode = 'system',
    this.currencyCode = 'USD',
    this.notificationsEnabled = true,
    this.dailyMotivationTime,
    this.hasCompletedOnboarding = false,
  });

  UserSettings copyWith({
    String? selectedPaletteId,
    int? customPrimary,
    int? customSecondary,
    int? customAccent,
    String? brightnessMode,
    String? currencyCode,
    bool? notificationsEnabled,
    String? dailyMotivationTime,
    bool? hasCompletedOnboarding,
  }) {
    return UserSettings(
      selectedPaletteId: selectedPaletteId ?? this.selectedPaletteId,
      customPrimary: customPrimary ?? this.customPrimary,
      customSecondary: customSecondary ?? this.customSecondary,
      customAccent: customAccent ?? this.customAccent,
      brightnessMode: brightnessMode ?? this.brightnessMode,
      currencyCode: currencyCode ?? this.currencyCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyMotivationTime: dailyMotivationTime ?? this.dailyMotivationTime,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

/// Abstract interface for settings persistence.
abstract class SettingsRepository {
  /// Watch the user settings as a reactive stream.
  Stream<UserSettings> watchSettings();

  /// Get current settings (one-shot).
  Future<UserSettings> getSettings();

  /// Update the settings.
  Future<void> updateSettings(UserSettings settings);
}
