import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/tracker.dart' as domain;
import '../../domain/entities/slip_record.dart' as domain;
import 'database_provider.dart';

/// Stream of all active trackers.
final activeTrackersProvider =
    StreamProvider<List<domain.Tracker>>((ref) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchAllActive();
});

/// Stream of a single tracker by id.
final trackerByIdProvider =
    StreamProvider.family<domain.Tracker?, String>((ref, id) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchById(id);
});

/// Count of active trackers.
final activeTrackerCountProvider = FutureProvider<int>((ref) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.countActive();
});

/// Slips for a tracker.
final slipsByTrackerProvider =
    StreamProvider.family<List<domain.SlipRecord>, String>((ref, trackerId) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchSlips(trackerId);
});

/// Slip count for a tracker.
final slipCountProvider =
    FutureProvider.family<int, String>((ref, trackerId) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.countSlips(trackerId);
});
