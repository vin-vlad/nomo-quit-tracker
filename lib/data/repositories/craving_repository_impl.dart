import 'package:drift/drift.dart';
import '../../domain/entities/craving.dart' as domain;
import '../../domain/repositories/craving_repository.dart';
import '../database/app_database.dart';
import '../database/daos/craving_dao.dart';

class CravingRepositoryImpl implements CravingRepository {
  final CravingDao _cravingDao;

  CravingRepositoryImpl(this._cravingDao);

  @override
  Stream<List<domain.Craving>> watchByTracker(String trackerId) {
    return _cravingDao.watchByTracker(trackerId).map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  @override
  Future<int> countByTracker(String trackerId) {
    return _cravingDao.countByTracker(trackerId);
  }

  @override
  Future<List<domain.Craving>> getByDateRange(
    String trackerId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await _cravingDao.getByDateRange(trackerId, start, end);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> insert(domain.Craving craving) {
    return _cravingDao.insertCraving(
      CravingsCompanion.insert(
        id: craving.id,
        trackerId: craving.trackerId,
        timestamp: craving.timestamp,
        intensity: Value(craving.intensity),
        trigger: Value(craving.trigger?.name),
        note: Value(craving.note),
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return _cravingDao.deleteCraving(id);
  }

  @override
  Future<List<domain.Craving>> getAllByTracker(String trackerId) async {
    final rows = await _cravingDao.getAllByTracker(trackerId);
    return rows.map(_toDomain).toList();
  }

  domain.Craving _toDomain(Craving row) {
    return domain.Craving(
      id: row.id,
      trackerId: row.trackerId,
      timestamp: row.timestamp,
      intensity: row.intensity,
      trigger: row.trigger != null
          ? domain.CravingTrigger.values.firstWhere(
              (t) => t.name == row.trigger,
              orElse: () => domain.CravingTrigger.other,
            )
          : null,
      note: row.note,
    );
  }
}
