import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/settings_repository.dart';
import 'database_provider.dart';

/// Stream of user settings.
final userSettingsProvider = StreamProvider<UserSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
});

/// One-shot settings.
final settingsFutureProvider = FutureProvider<UserSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.getSettings();
});
