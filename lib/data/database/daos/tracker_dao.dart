import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/trackers_table.dart';
import '../tables/slips_table.dart';

part 'tracker_dao.g.dart';

@DriftAccessor(tables: [Trackers, Slips])
class TrackerDao extends DatabaseAccessor<AppDatabase>
    with _$TrackerDaoMixin {
  TrackerDao(super.db);

  /// Watch all active trackers, ordered by sortOrder then creation date.
  Stream<List<Tracker>> watchAllActive() {
    return (select(trackers)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Watch a single tracker by id.
  Stream<Tracker?> watchById(String id) {
    return (select(trackers)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Get a single tracker by id (one-shot).
  Future<Tracker?> getById(String id) {
    return (select(trackers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new tracker.
  Future<void> insertTracker(TrackersCompanion tracker) {
    return into(trackers).insert(tracker);
  }

  /// Update an existing tracker.
  Future<void> updateTracker(TrackersCompanion tracker) {
    return (update(trackers)..where((t) => t.id.equals(tracker.id.value)))
        .write(tracker);
  }

  /// Delete a tracker by id.
  Future<void> deleteTracker(String id) {
    return (delete(trackers)..where((t) => t.id.equals(id))).go();
  }

  /// Count all active trackers.
  Future<int> countActive() async {
    final count = countAll();
    final query = selectOnly(trackers)
      ..where(trackers.isActive.equals(true))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }

  /// Update sort order for a tracker.
  Future<void> updateSortOrder(String id, int order) {
    return (update(trackers)..where((t) => t.id.equals(id)))
        .write(TrackersCompanion(sortOrder: Value(order)));
  }

  /// Update currency code for all trackers.
  Future<void> updateAllCurrencyCodes(String currencyCode) {
    return (update(trackers))
        .write(TrackersCompanion(currencyCode: Value(currencyCode)));
  }

  /// Check if an active tracker with a given addiction type already exists.
  Future<bool> hasActiveTrackerOfType(String addictionTypeId) async {
    final count = countAll();
    final query = selectOnly(trackers)
      ..where(trackers.isActive.equals(true) &
          trackers.addictionTypeId.equals(addictionTypeId))
      ..addColumns([count]);
    final result = await query.getSingle();
    return (result.read(count) ?? 0) > 0;
  }

  /// Watch slips for a tracker.
  Stream<List<Slip>> watchSlips(String trackerId) {
    return (select(slips)
          ..where((s) => s.trackerId.equals(trackerId))
          ..orderBy([(s) => OrderingTerm.desc(s.timestamp)]))
        .watch();
  }

  /// Insert a slip.
  Future<void> insertSlip(SlipsCompanion slip) {
    return into(slips).insert(slip);
  }

  /// Count slips for a tracker.
  Future<int> countSlips(String trackerId) async {
    final count = countAll();
    final query = selectOnly(slips)
      ..where(slips.trackerId.equals(trackerId))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
