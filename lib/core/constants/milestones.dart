import '../../domain/entities/milestone.dart';

/// All milestone definitions.
class MilestoneDefinitions {
  MilestoneDefinitions._();

  // ── Time-based milestones (available to all) ──────────────────────
  static final List<Milestone> timeMilestones = [
    const Milestone(
      id: 'time_1h',
      title: '1 Hour',
      description: 'You made it through your first hour!',
      requiredDuration: Duration(hours: 1),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_12h',
      title: '12 Hours',
      description: 'Half a day strong. Keep going!',
      requiredDuration: Duration(hours: 12),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_1d',
      title: '1 Day',
      description: 'A full day without it. You\'re doing amazing!',
      requiredDuration: Duration(days: 1),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_3d',
      title: '3 Days',
      description: 'Three days in. The hardest part is behind you.',
      requiredDuration: Duration(days: 3),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_1w',
      title: '1 Week',
      description: 'One whole week! You should be proud.',
      requiredDuration: Duration(days: 7),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_2w',
      title: '2 Weeks',
      description: 'Two weeks strong. A real habit shift.',
      requiredDuration: Duration(days: 14),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_1m',
      title: '1 Month',
      description: 'A full month! Your commitment is inspiring.',
      requiredDuration: Duration(days: 30),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_2m',
      title: '2 Months',
      description: 'Two months of freedom.',
      requiredDuration: Duration(days: 60),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_3m',
      title: '3 Months',
      description: 'A quarter year. This is who you are now.',
      requiredDuration: Duration(days: 90),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_6m',
      title: '6 Months',
      description: 'Half a year! Incredible dedication.',
      requiredDuration: Duration(days: 180),
      category: MilestoneCategory.time,
      icon: 'timer',
    ),
    const Milestone(
      id: 'time_1y',
      title: '1 Year',
      description: 'One full year. You did it!',
      requiredDuration: Duration(days: 365),
      category: MilestoneCategory.time,
      icon: 'star',
    ),
    const Milestone(
      id: 'time_2y',
      title: '2 Years',
      description: 'Two years of strength and resolve.',
      requiredDuration: Duration(days: 730),
      category: MilestoneCategory.time,
      icon: 'star',
    ),
    const Milestone(
      id: 'time_5y',
      title: '5 Years',
      description: 'Five years. A legend.',
      requiredDuration: Duration(days: 1825),
      category: MilestoneCategory.time,
      icon: 'star',
    ),
  ];

  // ── Savings-based milestones (premium) ────────────────────────────
  static final List<SavingsMilestone> savingsMilestones = [
    const SavingsMilestone(id: 'save_10', title: 'First 10', description: 'Saved your first 10!', requiredAmount: 10, icon: 'savings'),
    const SavingsMilestone(id: 'save_50', title: '50 Saved', description: 'That\'s 50 in your pocket.', requiredAmount: 50, icon: 'savings'),
    const SavingsMilestone(id: 'save_100', title: '100 Saved', description: 'Triple digits!', requiredAmount: 100, icon: 'savings'),
    const SavingsMilestone(id: 'save_250', title: '250 Saved', description: 'A nice treat-yourself fund.', requiredAmount: 250, icon: 'savings'),
    const SavingsMilestone(id: 'save_500', title: '500 Saved', description: 'Half a thousand. Wow.', requiredAmount: 500, icon: 'savings'),
    const SavingsMilestone(id: 'save_1000', title: '1,000 Saved', description: 'A thousand! What will you do with it?', requiredAmount: 1000, icon: 'savings'),
    const SavingsMilestone(id: 'save_5000', title: '5,000 Saved', description: 'Life-changing savings.', requiredAmount: 5000, icon: 'savings'),
  ];

  // ── Craving-resistance milestones (premium) ───────────────────────
  static final List<CravingMilestone> cravingMilestones = [
    const CravingMilestone(id: 'craving_10', title: '10 Resisted', description: 'Ten cravings faced and conquered.', requiredCount: 10, icon: 'shield'),
    const CravingMilestone(id: 'craving_25', title: '25 Resisted', description: 'A quarter hundred. Strong!', requiredCount: 25, icon: 'shield'),
    const CravingMilestone(id: 'craving_50', title: '50 Resisted', description: 'Fifty times you said no.', requiredCount: 50, icon: 'shield'),
    const CravingMilestone(id: 'craving_100', title: '100 Resisted', description: 'Triple-digit willpower.', requiredCount: 100, icon: 'shield'),
    const CravingMilestone(id: 'craving_250', title: '250 Resisted', description: 'You\'re unstoppable.', requiredCount: 250, icon: 'shield'),
    const CravingMilestone(id: 'craving_500', title: '500 Resisted', description: 'Five hundred. A true warrior.', requiredCount: 500, icon: 'shield'),
    const CravingMilestone(id: 'craving_1000', title: '1,000 Resisted', description: 'A thousand cravings defeated.', requiredCount: 1000, icon: 'shield'),
  ];
}
