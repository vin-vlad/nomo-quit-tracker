import '../repositories/tracker_repository.dart';

/// Resets a tracker's quit date to now (hard reset).
class ResetTracker {
  final TrackerRepository _trackerRepository;

  ResetTracker(this._trackerRepository);

  /// Resets the quit date to now. Previous cravings and slips remain
  /// in history.
  Future<void> call(String trackerId) async {
    final tracker = await _trackerRepository.getById(trackerId);
    if (tracker == null) return;

    final updated = tracker.copyWith(
      quitDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _trackerRepository.update(updated);
  }
}
