import 'package:drift/drift.dart';
import '../../core/constants/addiction_types.dart';
import '../../domain/entities/tracker.dart' as domain;
import '../../domain/entities/slip_record.dart' as domain;
import '../../domain/repositories/tracker_repository.dart';
import '../database/app_database.dart';
import '../database/daos/tracker_dao.dart';

/// Maps between Drift data classes and domain entities.
class TrackerRepositoryImpl implements TrackerRepository {
  final TrackerDao _trackerDao;

  TrackerRepositoryImpl(this._trackerDao);

  @override
  Stream<List<domain.Tracker>> watchAllActive() {
    return _trackerDao.watchAllActive().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  @override
  Stream<domain.Tracker?> watchById(String id) {
    return _trackerDao.watchById(id).map(
          (row) => row == null ? null : _toDomain(row),
        );
  }

  @override
  Future<domain.Tracker?> getById(String id) async {
    final row = await _trackerDao.getById(id);
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> insert(domain.Tracker tracker) {
    return _trackerDao.insertTracker(_toCompanion(tracker));
  }

  @override
  Future<void> update(domain.Tracker tracker) {
    return _trackerDao.updateTracker(_toCompanion(tracker));
  }

  @override
  Future<void> delete(String id) {
    return _trackerDao.deleteTracker(id);
  }

  @override
  Future<int> countActive() {
    return _trackerDao.countActive();
  }

  @override
  Future<void> updateSortOrders(Map<String, int> orders) async {
    for (final entry in orders.entries) {
      await _trackerDao.updateSortOrder(entry.key, entry.value);
    }
  }

  @override
  Future<bool> hasActiveTrackerOfType(String addictionTypeId) {
    return _trackerDao.hasActiveTrackerOfType(addictionTypeId);
  }

  @override
  Future<void> updateAllCurrencyCodes(String currencyCode) {
    return _trackerDao.updateAllCurrencyCodes(currencyCode);
  }

  /// Insert a slip record for a tracker.
  Future<void> insertSlip(domain.SlipRecord slip) {
    return _trackerDao.insertSlip(
      SlipsCompanion.insert(
        id: slip.id,
        trackerId: slip.trackerId,
        timestamp: slip.timestamp,
        note: Value(slip.note),
      ),
    );
  }

  /// Watch slips for a tracker.
  Stream<List<domain.SlipRecord>> watchSlips(String trackerId) {
    return _trackerDao.watchSlips(trackerId).map(
          (rows) => rows
              .map((s) => domain.SlipRecord(
                    id: s.id,
                    trackerId: s.trackerId,
                    timestamp: s.timestamp,
                    note: s.note,
                  ))
              .toList(),
        );
  }

  /// Count slips for a tracker.
  Future<int> countSlips(String trackerId) {
    return _trackerDao.countSlips(trackerId);
  }

  // ── Mapping ─────────────────────────────────────────────────────

  domain.Tracker _toDomain(Tracker row) {
    return domain.Tracker(
      id: row.id,
      name: row.name,
      type: AddictionTypePresets.byId(row.addictionTypeId),
      customTypeName: row.customTypeName,
      quitDate: row.quitDate,
      dailyCost: row.dailyCost,
      dailyFrequency: row.dailyFrequency,
      currencyCode: row.currencyCode,
      isActive: row.isActive,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TrackersCompanion _toCompanion(domain.Tracker t) {
    return TrackersCompanion(
      id: Value(t.id),
      name: Value(t.name),
      addictionTypeId: Value(t.type.id),
      customTypeName: Value(t.customTypeName),
      quitDate: Value(t.quitDate),
      dailyCost: Value(t.dailyCost),
      dailyFrequency: Value(t.dailyFrequency),
      currencyCode: Value(t.currencyCode),
      isActive: Value(t.isActive),
      sortOrder: Value(t.sortOrder),
      createdAt: Value(t.createdAt),
      updatedAt: Value(t.updatedAt),
    );
  }
}
