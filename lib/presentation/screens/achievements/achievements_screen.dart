import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/milestones.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/milestone.dart';
import '../../../domain/usecases/evaluate_milestones.dart';
import '../../providers/tracker_providers.dart';
import '../../widgets/bauhaus_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackersAsync = ref.watch(activeTrackersProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.onSurface,
                width: NomoDimensions.borderWidth,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NomoDimensions.spacing16,
              ),
              child: Row(
                children: [
                  Text(
                    'AWARDS',
                    style: NomoTypography.headline.copyWith(
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: trackersAsync.when(
        data: (trackers) {
          if (trackers.isEmpty) {
            return Center(
              child: Text(
                'Add a tracker to earn achievements.',
                style: NomoTypography.body.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }

          // Aggregate milestones across all trackers
          final evaluator = EvaluateMilestones();
          Duration maxElapsed = Duration.zero;
          for (final t in trackers) {
            if (t.elapsed > maxElapsed) maxElapsed = t.elapsed;
          }

          final allMilestones = MilestoneDefinitions.timeMilestones;
          final achieved = evaluator.achievedTimeMilestones(maxElapsed);
          final achievedIds = achieved.map((m) => m.id).toSet();

          return Padding(
            padding: const EdgeInsets.all(NomoDimensions.spacing16),
            child: GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: NomoDimensions.spacing12,
                mainAxisSpacing: NomoDimensions.spacing12,
                childAspectRatio: 0.85,
              ),
              itemCount: allMilestones.length,
              itemBuilder: (context, index) {
                final milestone = allMilestones[index];
                final isAchieved = achievedIds.contains(milestone.id);

                return GestureDetector(
                  onTap: isAchieved
                      ? () => _showDetail(context, theme, milestone)
                      : null,
                  child: _MilestoneBadge(
                    milestone: milestone,
                    isAchieved: isAchieved,
                    progress: milestone.progress(maxElapsed),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showDetail(
      BuildContext context, ThemeData theme, Milestone milestone) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          milestone.title,
          style: NomoTypography.headline.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          milestone.description,
          style: NomoTypography.body.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('NICE'),
          ),
        ],
      ),
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  final Milestone milestone;
  final bool isAchieved;
  final double progress;

  const _MilestoneBadge({
    required this.milestone,
    required this.isAchieved,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BauhausCard(
      backgroundColor: isAchieved
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Geometric badge shape (circle for time)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAchieved
                  ? theme.colorScheme.tertiary
                  : Colors.transparent,
              border: Border.all(
                color: isAchieved
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: isAchieved
                ? const Icon(Icons.check, color: Colors.black, size: 20)
                : Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: NomoTypography.caption.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: NomoDimensions.spacing8),
          Text(
            milestone.title,
            style: NomoTypography.caption.copyWith(
              color: isAchieved
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: isAchieved ? FontWeight.w700 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
