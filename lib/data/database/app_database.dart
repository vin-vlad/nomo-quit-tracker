import 'package:drift/drift.dart';
import 'tables/trackers_table.dart';
import 'tables/cravings_table.dart';
import 'tables/slips_table.dart';
import 'tables/settings_table.dart';
import 'daos/tracker_dao.dart';
import 'daos/craving_dao.dart';
import 'daos/settings_dao.dart';
import 'dev_seed.dart';

part 'app_database.g.dart';

/// Set to true to populate the database with dummy data on first launch.
/// Delete the existing nomo.db file to trigger onCreate again.
/// After launching, enable premium via the debug toggle in Settings → scroll
/// to the bottom to view Insights with the seeded data.
const bool kSeedDevData = true;

@DriftDatabase(
  tables: [Trackers, Cravings, Slips, UserSettingsTable],
  daos: [TrackerDao, CravingDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default settings row
        await into(userSettingsTable).insert(
          UserSettingsTableCompanion.insert(),
        );

        // Seed dummy data for development / testing
        if (kSeedDevData) {
          await seedDevData(this);
        }
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add sortOrder column to trackers
          await m.addColumn(trackers, trackers.sortOrder);
        }
      },
    );
  }
}
