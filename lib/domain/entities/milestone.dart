/// Categories of milestones.
enum MilestoneCategory {
  time,
  savings,
  cravings,
  custom,
}

/// A time-based milestone.
class Milestone {
  final String id;
  final String title;
  final String description;
  final Duration requiredDuration;
  final MilestoneCategory category;
  final String icon;

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredDuration,
    required this.category,
    required this.icon,
  });

  /// Check if this milestone has been achieved given an elapsed duration.
  bool isAchieved(Duration elapsed) => elapsed >= requiredDuration;

  /// Progress 0.0–1.0 toward this milestone.
  double progress(Duration elapsed) {
    if (requiredDuration.inSeconds == 0) return 1.0;
    return (elapsed.inSeconds / requiredDuration.inSeconds).clamp(0.0, 1.0);
  }
}

/// A savings-based milestone (premium).
class SavingsMilestone {
  final String id;
  final String title;
  final String description;
  final double requiredAmount;
  final String icon;

  const SavingsMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredAmount,
    required this.icon,
  });

  bool isAchieved(double saved) => saved >= requiredAmount;

  double progress(double saved) {
    if (requiredAmount == 0) return 1.0;
    return (saved / requiredAmount).clamp(0.0, 1.0);
  }
}

/// A craving-resistance milestone (premium).
class CravingMilestone {
  final String id;
  final String title;
  final String description;
  final int requiredCount;
  final String icon;

  const CravingMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredCount,
    required this.icon,
  });

  bool isAchieved(int count) => count >= requiredCount;

  double progress(int count) {
    if (requiredCount == 0) return 1.0;
    return (count / requiredCount).clamp(0.0, 1.0);
  }
}
