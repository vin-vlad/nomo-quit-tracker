import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../domain/entities/slip_record.dart' as domain;
import '../../../domain/usecases/evaluate_milestones.dart';
import '../../providers/craving_providers.dart';
import '../../providers/database_provider.dart';
import '../../providers/purchase_providers.dart';
import '../../providers/tracker_providers.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/bauhaus_app_bar.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';
import '../../widgets/bauhaus_progress_ring.dart';
import '../craving/log_craving_sheet.dart';

class TrackerDetailScreen extends ConsumerWidget {
  final String trackerId;

  const TrackerDetailScreen({super.key, required this.trackerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackerAsync = ref.watch(trackerByIdProvider(trackerId));
    final cravingsAsync = ref.watch(cravingsByTrackerProvider(trackerId));
    final slipsAsync = ref.watch(slipsByTrackerProvider(trackerId));
    final isPremium = ref.watch(isPremiumSyncProvider);

    return trackerAsync.when(
      data: (tracker) {
        if (tracker == null) {
          return Scaffold(
            appBar: const BauhausAppBar(title: 'Tracker'),
            body: Center(
              child: Text(
                'Tracker not found',
                style: NomoTypography.body
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
            ),
          );
        }

        final elapsed = tracker.elapsed;
        final evaluator = EvaluateMilestones();
        final achieved = evaluator.achievedTimeMilestones(elapsed);
        final nextMilestone = evaluator.nextTimeMilestone(elapsed);
        final cravingCount = cravingsAsync.valueOrNull?.length ?? 0;
        final slipCount = slipsAsync.valueOrNull?.length ?? 0;

        return Scaffold(
          appBar: BauhausAppBar(title: tracker.name),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(NomoDimensions.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large animated counter
                Center(
                  child: AnimatedCounter(quitDate: tracker.quitDate),
                ),

                const SizedBox(height: NomoDimensions.spacing32),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatBlock(
                        label: 'SAVED',
                        value: tracker.dailyCost != null
                            ? CurrencyUtils.format(
                                tracker.totalSaved, tracker.currencyCode)
                            : '—',
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: NomoDimensions.spacing12),
                    Expanded(
                      child: _StatBlock(
                        label: 'RESISTED',
                        value: cravingCount.toString(),
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: NomoDimensions.spacing12),
                    Expanded(
                      child: _StatBlock(
                        label: 'SLIPS',
                        value: slipCount.toString(),
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: NomoDimensions.spacing32),

                // Next milestone progress
                if (nextMilestone != null) ...[
                  Text(
                    'NEXT MILESTONE',
                    style: NomoTypography.label.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: NomoDimensions.spacing16),
                  BauhausCard(
                    child: Row(
                      children: [
                        BauhausProgressRing(
                          progress: nextMilestone.progress(elapsed),
                          size: 64,
                          child: Text(
                            '${(nextMilestone.progress(elapsed) * 100).toInt()}%',
                            style: NomoTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: NomoDimensions.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nextMilestone.title,
                                style: NomoTypography.titleSmall.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                nextMilestone.description,
                                style: NomoTypography.caption.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: NomoDimensions.spacing24),

                // Achieved milestones
                if (achieved.isNotEmpty) ...[
                  Text(
                    'ACHIEVED (${achieved.length})',
                    style: NomoTypography.label.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: NomoDimensions.spacing12),
                  Wrap(
                    spacing: NomoDimensions.spacing8,
                    runSpacing: NomoDimensions.spacing8,
                    children: achieved.map((m) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NomoDimensions.spacing12,
                          vertical: NomoDimensions.spacing8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(NomoDimensions.borderRadius / 2),
                          border: Border.all(
                            color: theme.colorScheme.onSurface,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          m.title,
                          style: NomoTypography.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: NomoDimensions.spacing48),

                // Action buttons
                BauhausButton(
                  label: 'Log Craving',
                  onPressed: () => _logCraving(context, ref),
                  expand: true,
                ),
                const SizedBox(height: NomoDimensions.spacing12),
                if (isPremium)
                  BauhausButton(
                    label: 'Log Slip',
                    variant: BauhausButtonVariant.outlined,
                    onPressed: () => _logSlip(context, ref),
                    expand: true,
                    color: theme.colorScheme.secondary,
                  ),
                if (isPremium)
                  const SizedBox(height: NomoDimensions.spacing12),
                BauhausButton(
                  label: 'Reset Timer',
                  variant: BauhausButtonVariant.outlined,
                  onPressed: () => _resetTimer(context, ref, tracker),
                  expand: true,
                  color: theme.colorScheme.error,
                ),

                const SizedBox(height: NomoDimensions.spacing32),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: const BauhausAppBar(title: 'Error'),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  void _logCraving(BuildContext context, WidgetRef ref) {
    final isPremium = ref.read(isPremiumSyncProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => LogCravingSheet(
        trackerId: trackerId,
        isPremium: isPremium,
      ),
    );
  }

  void _logSlip(BuildContext context, WidgetRef ref) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: NomoDimensions.spacing24,
            right: NomoDimensions.spacing24,
            top: NomoDimensions.spacing24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log a Slip',
                style: NomoTypography.headline.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing8),
              Text(
                'Slips happen. Your timer keeps running — this is just a note for you.',
                style: NomoTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing16),
              TextField(
                controller: noteController,
                maxLines: 3,
                style: NomoTypography.body.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: 'What happened? (optional)',
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing24),
              BauhausButton(
                label: 'Log Slip',
                expand: true,
                color: theme.colorScheme.secondary,
                onPressed: () async {
                  final slip = domain.SlipRecord(
                    id: const Uuid().v4(),
                    trackerId: trackerId,
                    timestamp: DateTime.now(),
                    note: noteController.text.isEmpty
                        ? null
                        : noteController.text,
                  );
                  await ref.read(trackerRepositoryProvider).insertSlip(slip);
                  HapticFeedback.mediumImpact();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: NomoDimensions.spacing24),
            ],
          ),
        );
      },
    );
  }

  void _resetTimer(
      BuildContext context, WidgetRef ref, dynamic tracker) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Reset Timer?',
          style: NomoTypography.headline.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This will set your quit date to now. Your craving history and previous slips are preserved.\n\nSlips happen. Starting fresh is still progress.',
          style: NomoTypography.body.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            onPressed: () async {
              final repo = ref.read(trackerRepositoryProvider);
              final current = await repo.getById(trackerId);
              if (current != null) {
                final updated = current.copyWith(
                  quitDate: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await repo.update(updated);
              }
              HapticFeedback.heavyImpact();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BauhausCard(
      padding: const EdgeInsets.all(NomoDimensions.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: NomoDimensions.spacing8),
          Text(
            value,
            style: NomoTypography.titleSmall.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: NomoTypography.caption.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
