import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/nomo_dimensions.dart';
import '../../../../core/theme/nomo_typography.dart';
import '../../../../domain/entities/craving.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Day detail bottom sheet — shows craving logs for a tapped day
// ─────────────────────────────────────────────────────────────────────────────

class DayDetailSheet extends StatelessWidget {
  final DateTime day;
  final List<Craving> cravings;

  const DayDetailSheet({
    super.key,
    required this.day,
    required this.cravings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(day);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NomoDimensions.spacing24,
                vertical: NomoDimensions.spacing8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: NomoTypography.titleSmall.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cravings.length} craving${cravings.length != 1 ? 's' : ''} logged',
                          style: NomoTypography.caption.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            NomoDimensions.borderRadius / 2),
                        border: Border.all(
                          color: theme.colorScheme.onSurface,
                          width: NomoDimensions.borderWidth,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: NomoDimensions.dividerWidth,
              color: theme.colorScheme.onSurface,
              margin: const EdgeInsets.symmetric(
                  horizontal: NomoDimensions.spacing24),
            ),

            // Content
            Expanded(
              child: cravings.isEmpty
                  ? Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(NomoDimensions.spacing32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.2),
                            ),
                            const SizedBox(
                                height: NomoDimensions.spacing12),
                            Text(
                              'No cravings logged this day',
                              style: NomoTypography.body.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(
                                height: NomoDimensions.spacing4),
                            Text(
                              'That\'s a win!',
                              style: NomoTypography.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding:
                          const EdgeInsets.all(NomoDimensions.spacing24),
                      itemCount: cravings.length,
                      separatorBuilder: (_, __) => const SizedBox(
                          height: NomoDimensions.spacing16),
                      itemBuilder: (context, index) {
                        return CravingLogItem(
                            craving: cravings[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual craving log item in the detail sheet
// ─────────────────────────────────────────────────────────────────────────────

class CravingLogItem extends StatelessWidget {
  final Craving craving;

  const CravingLogItem({super.key, required this.craving});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr = DateFormat('h:mm a').format(craving.timestamp);
    final hasDetails = craving.intensity != null ||
        craving.trigger != null ||
        (craving.note != null && craving.note!.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(NomoDimensions.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          width: NomoDimensions.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: NomoDimensions.spacing8),
              Text(
                timeStr,
                style: NomoTypography.label.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          if (hasDetails) ...[
            const SizedBox(height: NomoDimensions.spacing12),

            // Intensity bar
            if (craving.intensity != null) ...[
              Row(
                children: [
                  Text(
                    'INTENSITY',
                    style: NomoTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                      fontSize: 10,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: NomoDimensions.spacing8),
                  Expanded(
                    child: IntensityBar(
                      value: craving.intensity!,
                      primaryColor: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.onSurface
                          .withValues(alpha: 0.08),
                    ),
                  ),
                  const SizedBox(width: NomoDimensions.spacing8),
                  Text(
                    '${craving.intensity}/10',
                    style: NomoTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: NomoDimensions.spacing8),
            ],

            // Trigger chip
            if (craving.trigger != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: NomoDimensions.spacing8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                      NomoDimensions.borderRadius / 2),
                  border: Border.all(
                    color: theme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  craving.trigger!.label.toUpperCase(),
                  style: NomoTypography.caption.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing8),
            ],

            // Note
            if (craving.note != null && craving.note!.isNotEmpty) ...[
              Text(
                craving.note!,
                style: NomoTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ] else ...[
            const SizedBox(height: NomoDimensions.spacing4),
            Text(
              'Quick log — no details recorded',
              style: NomoTypography.caption.copyWith(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.35),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small intensity bar widget
// ─────────────────────────────────────────────────────────────────────────────

class IntensityBar extends StatelessWidget {
  final int value; // 1–10
  final Color primaryColor;
  final Color backgroundColor;

  const IntensityBar({
    super.key,
    required this.value,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Row(
        children: List.generate(10, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 9 ? 2 : 0),
              color: i < value ? primaryColor : backgroundColor,
            ),
          );
        }),
      ),
    );
  }
}

/// Helper to show the day detail bottom sheet from any screen.
void showDayDetailSheet({
  required BuildContext context,
  required DateTime day,
  required List<Craving> allCravings,
}) {
  final theme = Theme.of(context);
  final dayCravings = allCravings.where((c) {
    return c.timestamp.year == day.year &&
        c.timestamp.month == day.month &&
        c.timestamp.day == day.day;
  }).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(NomoDimensions.borderRadius),
      ),
    ),
    builder: (ctx) => DayDetailSheet(
      day: day,
      cravings: dayCravings,
    ),
  );
}
