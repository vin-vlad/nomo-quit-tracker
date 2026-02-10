import '../entities/craving.dart';

/// Abstract interface for craving persistence.
abstract class CravingRepository {
  /// Watch all cravings for a tracker.
  Stream<List<Craving>> watchByTracker(String trackerId);

  /// Count cravings for a tracker (one-shot).
  Future<int> countByTracker(String trackerId);

  /// Get cravings within a date range.
  Future<List<Craving>> getByDateRange(
      String trackerId, DateTime start, DateTime end);

  /// Insert a new craving.
  Future<void> insert(Craving craving);

  /// Delete a craving.
  Future<void> delete(String id);

  /// Get all cravings for a tracker (one-shot).
  Future<List<Craving>> getAllByTracker(String trackerId);
}
