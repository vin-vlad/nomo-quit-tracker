/// A "slip" — the user gave in but chose NOT to reset their timer.
/// This is a premium feature. Free users can only do a full reset.
class SlipRecord {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final String? note;

  const SlipRecord({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    this.note,
  });
}
