import '../../core/constants/milestones.dart';
import '../entities/milestone.dart';

/// Evaluates which milestones have been achieved and what's next.
class EvaluateMilestones {
  /// Returns all achieved time milestones.
  List<Milestone> achievedTimeMilestones(Duration elapsed) {
    return MilestoneDefinitions.timeMilestones
        .where((m) => m.isAchieved(elapsed))
        .toList();
  }

  /// Returns the next unachieved time milestone (or null if all achieved).
  Milestone? nextTimeMilestone(Duration elapsed) {
    final remaining = MilestoneDefinitions.timeMilestones
        .where((m) => !m.isAchieved(elapsed))
        .toList();
    return remaining.isEmpty ? null : remaining.first;
  }

  /// Returns all achieved savings milestones.
  List<SavingsMilestone> achievedSavingsMilestones(double saved) {
    return MilestoneDefinitions.savingsMilestones
        .where((m) => m.isAchieved(saved))
        .toList();
  }

  /// Returns the next unachieved savings milestone.
  SavingsMilestone? nextSavingsMilestone(double saved) {
    final remaining = MilestoneDefinitions.savingsMilestones
        .where((m) => !m.isAchieved(saved))
        .toList();
    return remaining.isEmpty ? null : remaining.first;
  }

  /// Returns all achieved craving milestones.
  List<CravingMilestone> achievedCravingMilestones(int count) {
    return MilestoneDefinitions.cravingMilestones
        .where((m) => m.isAchieved(count))
        .toList();
  }

  /// Returns the next unachieved craving milestone.
  CravingMilestone? nextCravingMilestone(int count) {
    final remaining = MilestoneDefinitions.cravingMilestones
        .where((m) => !m.isAchieved(count))
        .toList();
    return remaining.isEmpty ? null : remaining.first;
  }
}
