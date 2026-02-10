import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cravings_table.dart';

part 'craving_dao.g.dart';

@DriftAccessor(tables: [Cravings])
class CravingDao extends DatabaseAccessor<AppDatabase>
    with _$CravingDaoMixin {
  CravingDao(super.db);

  /// Watch all cravings for a tracker, newest first.
  Stream<List<Craving>> watchByTracker(String trackerId) {
    return (select(cravings)
          ..where((c) => c.trackerId.equals(trackerId))
          ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]))
        .watch();
  }

  /// Count cravings for a tracker (one-shot).
  Future<int> countByTracker(String trackerId) async {
    final count = countAll();
    final query = selectOnly(cravings)
      ..where(cravings.trackerId.equals(trackerId))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }

  /// Get cravings within a date range.
  Future<List<Craving>> getByDateRange(
    String trackerId,
    DateTime start,
    DateTime end,
  ) {
    return (select(cravings)
          ..where((c) =>
              c.trackerId.equals(trackerId) &
              c.timestamp.isBiggerOrEqualValue(start) &
              c.timestamp.isSmallerOrEqualValue(end))
          ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]))
        .get();
  }

  /// Insert a new craving.
  Future<void> insertCraving(CravingsCompanion craving) {
    return into(cravings).insert(craving);
  }

  /// Delete a craving by id.
  Future<void> deleteCraving(String id) {
    return (delete(cravings)..where((c) => c.id.equals(id))).go();
  }

  /// Get all cravings for a tracker (one-shot).
  Future<List<Craving>> getAllByTracker(String trackerId) {
    return (select(cravings)
          ..where((c) => c.trackerId.equals(trackerId))
          ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]))
        .get();
  }
}
