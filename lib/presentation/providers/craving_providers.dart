import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/craving.dart' as domain;
import 'database_provider.dart';

/// Stream of cravings for a tracker.
final cravingsByTrackerProvider =
    StreamProvider.family<List<domain.Craving>, String>((ref, trackerId) {
  final repo = ref.watch(cravingRepositoryProvider);
  return repo.watchByTracker(trackerId);
});

/// Craving count for a tracker (one-shot).
final cravingCountProvider =
    FutureProvider.family<int, String>((ref, trackerId) {
  final repo = ref.watch(cravingRepositoryProvider);
  return repo.countByTracker(trackerId);
});
