/// Trigger that caused a craving.
enum CravingTrigger {
  stress,
  boredom,
  social,
  habit,
  anxiety,
  celebration,
  other;

  String get label {
    switch (this) {
      case CravingTrigger.stress:
        return 'Stress';
      case CravingTrigger.boredom:
        return 'Boredom';
      case CravingTrigger.social:
        return 'Social';
      case CravingTrigger.habit:
        return 'Habit';
      case CravingTrigger.anxiety:
        return 'Anxiety';
      case CravingTrigger.celebration:
        return 'Celebration';
      case CravingTrigger.other:
        return 'Other';
    }
  }
}

/// A logged craving event.
class Craving {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final int? intensity; // 1–10, premium only
  final CravingTrigger? trigger; // premium only
  final String? note; // premium only

  const Craving({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    this.intensity,
    this.trigger,
    this.note,
  });
}
