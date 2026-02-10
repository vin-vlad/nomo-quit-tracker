import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/database/connection/connection.dart';
import '../../data/repositories/tracker_repository_impl.dart';
import '../../data/repositories/craving_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/craving_repository.dart';
import '../../domain/repositories/settings_repository.dart';

/// The single app-wide database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = constructDb();
  ref.onDispose(() => db.close());
  return db;
});

/// Tracker repository.
final trackerRepositoryProvider = Provider<TrackerRepositoryImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return TrackerRepositoryImpl(db.trackerDao);
});

/// Craving repository.
final cravingRepositoryProvider = Provider<CravingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CravingRepositoryImpl(db.cravingDao);
});

/// Settings repository.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(db.settingsDao);
});
