import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/nomo_dimensions.dart';
import '../../../../core/theme/nomo_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../domain/entities/tracker.dart' as domain;
import '../../../providers/craving_providers.dart';
import '../../../widgets/animated_counter.dart';
import '../../../widgets/bauhaus_button.dart';
import '../../../widgets/bauhaus_card.dart';

class TrackerCardWidget extends ConsumerWidget {
  final domain.Tracker tracker;
  final VoidCallback onTap;
  final VoidCallback onLogCraving;

  const TrackerCardWidget({
    super.key,
    required this.tracker,
    required this.onTap,
    required this.onLogCraving,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cravingCountAsync = ref.watch(cravingsByTrackerProvider(tracker.id));

    return BauhausCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: name + days badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tracker.name,
                style: NomoTypography.label.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: NomoDimensions.spacing8,
                  vertical: NomoDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    NomoDimensions.borderRadiusSmall,
                  ),
                ),
                child: Text(
                  '${tracker.elapsed.inDays}d',
                  style: NomoTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: NomoDimensions.spacing16),

          // Animated counter
          Center(
            child: AnimatedCounter(quitDate: tracker.quitDate, compact: true),
          ),

          const SizedBox(height: NomoDimensions.spacing16),

          // Stats row
          Row(
            children: [
              if (tracker.dailyCost != null) ...[
                _StatChip(
                  shape: _ChipShape.circle,
                  label: CurrencyUtils.format(
                    tracker.totalSaved,
                    tracker.currencyCode,
                  ),
                  sublabel: 'saved',
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: NomoDimensions.spacing12),
              ],
              _StatChip(
                shape: _ChipShape.triangle,
                label: cravingCountAsync.when(
                  data: (cravings) => cravings.length.toString(),
                  loading: () => '—',
                  error: (_, __) => '0',
                ),
                sublabel: 'resisted',
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),

          const SizedBox(height: NomoDimensions.spacing16),

          // Quick actions
          BauhausButton(
            label: 'Log Craving',
            variant: BauhausButtonVariant.outlined,
            onPressed: onLogCraving,
            expand: true,
          ),
        ],
      ),
    );
  }
}

enum _ChipShape { circle, triangle }

class _StatChip extends StatelessWidget {
  final _ChipShape shape;
  final String label;
  final String sublabel;
  final Color color;

  const _StatChip({
    required this.shape,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CustomPaint(
            painter: _ChipShapePainter(shape: shape, color: color),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: NomoTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          sublabel,
          style: NomoTypography.caption.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ChipShapePainter extends CustomPainter {
  final _ChipShape shape;
  final Color color;

  _ChipShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (shape) {
      case _ChipShape.circle:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
      case _ChipShape.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
