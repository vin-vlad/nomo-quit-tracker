import '../entities/tracker.dart';

/// Abstract interface for tracker persistence.
abstract class TrackerRepository {
  /// Watch all active trackers as a reactive stream.
  Stream<List<Tracker>> watchAllActive();

  /// Watch a single tracker by id.
  Stream<Tracker?> watchById(String id);

  /// Get a single tracker by id (one-shot).
  Future<Tracker?> getById(String id);

  /// Insert a new tracker.
  Future<void> insert(Tracker tracker);

  /// Update an existing tracker.
  Future<void> update(Tracker tracker);

  /// Delete a tracker by id.
  Future<void> delete(String id);

  /// Count all active trackers.
  Future<int> countActive();

  /// Update sort orders for a list of trackers (id -> sortOrder).
  Future<void> updateSortOrders(Map<String, int> orders);

  /// Check if an active tracker with a given addiction type ID exists.
  Future<bool> hasActiveTrackerOfType(String addictionTypeId);
}
