import 'package:uuid/uuid.dart';
import '../entities/slip_record.dart';

/// Records a slip without resetting the timer (premium feature).
class RecordSlip {
  /// Records a slip event. The quit date is NOT changed.
  SlipRecord call({
    required String trackerId,
    String? note,
  }) {
    return SlipRecord(
      id: const Uuid().v4(),
      trackerId: trackerId,
      timestamp: DateTime.now(),
      note: note,
    );
  }
}
