import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/craving.dart';
import '../../../domain/usecases/analyze_cravings.dart';
import '../../providers/craving_providers.dart';
import '../../providers/purchase_providers.dart';
import '../../providers/tracker_providers.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';
import 'full_calendar_screen.dart';
import 'widgets/day_detail_sheet.dart';

/// Tracks which tracker is currently selected on the Insights screen.
final _selectedTrackerIndexProvider = StateProvider<int>((ref) => 0);

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPremium = ref.watch(isPremiumSyncProvider);
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
                    'INSIGHTS',
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
      body: !isPremium
          ? _buildPremiumGate(context, theme)
          : trackersAsync.when(
              data: (trackers) {
                if (trackers.isEmpty) {
                  return Center(
                    child: Text(
                      'Add a tracker to see insights.',
                      style: NomoTypography.body.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }

                // Clamp index if trackers were deleted
                final selectedIndex = ref.watch(_selectedTrackerIndexProvider);
                final safeIndex = selectedIndex.clamp(0, trackers.length - 1);
                if (safeIndex != selectedIndex) {
                  // Schedule the correction for after the build
                  Future.microtask(() {
                    ref.read(_selectedTrackerIndexProvider.notifier).state =
                        safeIndex;
                  });
                }

                final selectedTracker = trackers[safeIndex];

                return Column(
                  children: [
                    // Tracker selector (only if more than one)
                    if (trackers.length > 1)
                      _TrackerSelector(
                        trackers: trackers,
                        selectedIndex: safeIndex,
                        onSelected: (index) {
                          ref
                                  .read(_selectedTrackerIndexProvider.notifier)
                                  .state =
                              index;
                        },
                      ),

                    // Insights content for selected tracker
                    Expanded(
                      child: _InsightsContent(trackerId: selectedTracker.id),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
    );
  }

  Widget _buildPremiumGate(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NomoDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Blurred preview placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(
                  NomoDimensions.borderRadius,
                ),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  width: NomoDimensions.borderWidth,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing24),
            Text(
              'Unlock Insights',
              style: NomoTypography.headline.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            Text(
              'See craving trends, peak hours, and patterns with Premium.',
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: NomoDimensions.spacing24),
            BauhausButton(
              label: 'Go Premium',
              onPressed: () => context.push('/paywall'),
              expand: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal tracker selector chips
// ─────────────────────────────────────────────────────────────────────────────

class _TrackerSelector extends StatelessWidget {
  final List<dynamic> trackers; // List<domain.Tracker>
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TrackerSelector({
    required this.trackers,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: NomoDimensions.spacing16,
          vertical: NomoDimensions.spacing12,
        ),
        child: Row(
          children: List.generate(trackers.length, (index) {
            final tracker = trackers[index];
            final isSelected = index == selectedIndex;
            final daysQuit = DateTime.now().difference(tracker.quitDate).inDays;

            return Padding(
              padding: EdgeInsets.only(
                right: index < trackers.length - 1
                    ? NomoDimensions.spacing8
                    : 0,
              ),
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: NomoDimensions.spacing12,
                    vertical: NomoDimensions.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      NomoDimensions.borderRadius / 2,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      width: NomoDimensions.borderWidth,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tracker.name.toUpperCase(),
                        style: NomoTypography.caption.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.08,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${daysQuit}d',
                          style: NomoTypography.caption.copyWith(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _InsightsContent extends ConsumerWidget {
  final String trackerId;

  const _InsightsContent({required this.trackerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cravingsAsync = ref.watch(cravingsByTrackerProvider(trackerId));

    return cravingsAsync.when(
      data: (cravings) {
        final analyzer = AnalyzeCravings();
        final daily = analyzer.dailyTrend(cravings);
        final peak = analyzer.peakHours(cravings);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(NomoDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Craving trend chart ──
              _SectionHeader(
                title: 'CRAVING TREND',
                subtitle: daily.isEmpty
                    ? null
                    : '${cravings.length} total · ${(cravings.length / (daily.length.clamp(1, 999))).toStringAsFixed(1)}/day avg',
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              _CravingTrendChart(daily: daily, theme: theme),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Peak hours chart ──
              _SectionHeader(
                title: 'PEAK HOURS',
                subtitle: _peakHourSummary(peak),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              _PeakHoursChart(peak: peak, theme: theme),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Calendar heatmap ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: _SectionHeader(
                      title: 'CALENDAR',
                      subtitle: 'Tap a day to view logged cravings',
                    ),
                  ),
                  OpenContainer(
                    closedElevation: 0,
                    openElevation: 0,
                    closedColor: Colors.transparent,
                    openColor: theme.scaffoldBackgroundColor,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedShape: const RoundedRectangleBorder(),
                    closedBuilder: (closedCtx, openContainer) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'VIEW ALL',
                              style: NomoTypography.caption.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      );
                    },
                    openBuilder: (openCtx, _) {
                      return FullCalendarScreen(trackerId: trackerId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              _CalendarHeatmap(
                trackerId: trackerId,
                dailyCounts: daily,
                allCravings: cravings,
                primaryColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.05,
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  String? _peakHourSummary(List<HourCount> peak) {
    if (peak.every((h) => h.count == 0)) return null;
    final maxHour = peak.reduce((a, b) => a.count >= b.count ? a : b);
    final hour = maxHour.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    return 'Peak at $displayHour:00 $period · ${maxHour.count} cravings';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header with title + subtitle
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: NomoTypography.label.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: NomoTypography.caption.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Craving trend line chart with axis labels and tooltips
// ─────────────────────────────────────────────────────────────────────────────

class _CravingTrendChart extends StatelessWidget {
  final List<DayCount> daily;
  final ThemeData theme;

  const _CravingTrendChart({required this.daily, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BauhausCard(
      child: SizedBox(
        height: 220,
        child: daily.isEmpty
            ? Center(
                child: Text(
                  'Your cravings will show up here!',
                  style: NomoTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 16, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _yInterval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: _xInterval,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= daily.length) {
                              return const SizedBox.shrink();
                            }
                            final date = daily[idx].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                DateFormat('d MMM').format(date),
                                style: NomoTypography.caption.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: _yInterval,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max || value < 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                value.toInt().toString(),
                                style: NomoTypography.caption.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.45,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: NomoDimensions.borderRadius,
                        tooltipBorder: BorderSide(
                          color: theme.colorScheme.onSurface,
                          width: NomoDimensions.borderWidth,
                        ),
                        getTooltipColor: (_) => theme.colorScheme.surface,
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            final idx = spot.x.toInt();
                            if (idx < 0 || idx >= daily.length) {
                              return null;
                            }
                            final d = daily[idx];
                            return LineTooltipItem(
                              '${DateFormat('EEE, d MMM').format(d.date)}\n',
                              NomoTypography.caption.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${d.count} craving${d.count != 1 ? 's' : ''}',
                                  style: NomoTypography.label.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: daily
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.count.toDouble(),
                              ),
                            )
                            .toList(),
                        isCurved: false,
                        color: theme.colorScheme.primary,
                        barWidth: 2.5,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) =>
                              FlDotSquarePainter(
                                size: 6,
                                color: theme.colorScheme.primary,
                                strokeWidth: 0,
                              ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  double get _yInterval {
    if (daily.isEmpty) return 1;
    final maxCount = daily.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    if (maxCount <= 5) return 1;
    if (maxCount <= 15) return 2;
    return (maxCount / 5).ceilToDouble();
  }

  double get _xInterval {
    if (daily.length <= 7) return 1;
    if (daily.length <= 14) return 2;
    return (daily.length / 6).ceilToDouble();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Peak hours bar chart with tooltips and peak highlight
// ─────────────────────────────────────────────────────────────────────────────

class _PeakHoursChart extends StatelessWidget {
  final List<HourCount> peak;
  final ThemeData theme;

  const _PeakHoursChart({required this.peak, required this.theme});

  @override
  Widget build(BuildContext context) {
    final hasData = peak.any((h) => h.count > 0);
    final peakHour = hasData
        ? peak.reduce((a, b) => a.count >= b.count ? a : b).hour
        : -1;

    return BauhausCard(
      child: SizedBox(
        height: 220,
        child: !hasData
            ? Center(
                child: Text(
                  'No data yet.',
                  style: NomoTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _yInterval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final hour = value.toInt();
                            // Show every 3 hours
                            if (hour % 3 == 0) {
                              final period = hour >= 12 ? 'p' : 'a';
                              final display = hour == 0
                                  ? '12a'
                                  : hour == 12
                                  ? '12p'
                                  : hour > 12
                                  ? '${hour - 12}$period'
                                  : '$hour$period';
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  display,
                                  style: NomoTypography.caption.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 10,
                                    fontWeight: hour == peakHour
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: _yInterval,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max || value < 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                value.toInt().toString(),
                                style: NomoTypography.caption.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.45,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: NomoDimensions.borderRadius,
                        tooltipBorder: BorderSide(
                          color: theme.colorScheme.onSurface,
                          width: NomoDimensions.borderWidth,
                        ),
                        getTooltipColor: (_) => theme.colorScheme.surface,
                        getTooltipItem: (group, groupIdx, rod, rodIdx) {
                          final hour = group.x;
                          final count = rod.toY.toInt();
                          final period = hour >= 12 ? 'PM' : 'AM';
                          final display = hour == 0
                              ? 12
                              : hour > 12
                              ? hour - 12
                              : hour;
                          return BarTooltipItem(
                            '$display:00 $period\n',
                            NomoTypography.caption.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: '$count craving${count != 1 ? 's' : ''}',
                                style: NomoTypography.label.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    barGroups: peak
                        .map(
                          (h) => BarChartGroupData(
                            x: h.hour,
                            barRods: [
                              BarChartRodData(
                                toY: h.count.toDouble(),
                                color: h.hour == peakHour
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary,
                                width: 8,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }

  double get _yInterval {
    final maxCount = peak.map((h) => h.count).reduce((a, b) => a > b ? a : b);
    if (maxCount <= 5) return 1;
    if (maxCount <= 15) return 2;
    return (maxCount / 5).ceilToDouble();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar heatmap — proper week grid with labels and tap support
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarHeatmap extends StatelessWidget {
  final String trackerId;
  final List<DayCount> dailyCounts;
  final List<Craving> allCravings;
  final Color primaryColor;
  final Color backgroundColor;

  const _CalendarHeatmap({
    required this.trackerId,
    required this.dailyCounts,
    required this.allCravings,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dailyCounts.isEmpty) {
      return BauhausCard(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No data yet.',
              style: NomoTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Show last 35 days to fill complete weeks
    final startDate = today.subtract(const Duration(days: 34));
    // Adjust start to Monday
    final daysToMonday = startDate.weekday - 1;
    final gridStart = startDate.subtract(Duration(days: daysToMonday));

    final maxCount = dailyCounts.isEmpty
        ? 0
        : dailyCounts.map((d) => d.count).reduce((a, b) => a > b ? a : b);

    // Build map of counts
    final countMap = <String, int>{};
    for (final d in dailyCounts) {
      countMap[_dayKey(d.date)] = d.count;
    }

    // Build weeks grid
    final days = <DateTime>[];
    var cursor = gridStart;
    while (cursor.isBefore(today) || cursor.isAtSameMomentAs(today)) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    // Pad to complete the last week
    while (days.length % 7 != 0) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    final numWeeks = days.length ~/ 7;

    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return BauhausCard(
      padding: const EdgeInsets.all(NomoDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month label row
          _CalendarMonthLabels(days: days, numWeeks: numWeeks, theme: theme),
          const SizedBox(height: NomoDimensions.spacing8),

          // Grid with weekday labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weekday labels column
              Column(
                children: weekdays
                    .map(
                      (d) => SizedBox(
                        height: 28,
                        width: 20,
                        child: Center(
                          child: Text(
                            d,
                            style: NomoTypography.caption.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 4),

              // Calendar grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cellSize =
                        ((constraints.maxWidth - (numWeeks - 1) * 3) / numWeeks)
                            .clamp(16.0, 32.0);
                    return Column(
                      children: List.generate(7, (row) {
                        return SizedBox(
                          height: 28,
                          child: Row(
                            children: List.generate(numWeeks, (col) {
                              final dayIdx = col * 7 + row;
                              if (dayIdx >= days.length) {
                                return SizedBox(
                                  width: cellSize,
                                  height: cellSize,
                                );
                              }
                              final day = days[dayIdx];
                              final key = _dayKey(day);
                              final count = countMap[key] ?? 0;
                              final intensity = maxCount > 0
                                  ? (count / maxCount).clamp(0.0, 1.0)
                                  : 0.0;
                              final isToday = day.isAtSameMomentAs(today);
                              final isFuture = day.isAfter(today);

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: col < numWeeks - 1 ? 3 : 0,
                                  ),
                                  child: GestureDetector(
                                    onTap: isFuture
                                        ? null
                                        : () => _showDayDetail(
                                            context,
                                            day,
                                            theme,
                                          ),
                                    child: Container(
                                      height: cellSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: isFuture
                                            ? Colors.transparent
                                            : count > 0
                                            ? primaryColor.withValues(
                                                alpha: 0.15 + intensity * 0.85,
                                              )
                                            : backgroundColor,
                                        border: isToday
                                            ? Border.all(
                                                color:
                                                    theme.colorScheme.onSurface,
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: NomoTypography.caption
                                              .copyWith(
                                                fontSize: 9,
                                                fontWeight: isToday
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                                color: isFuture
                                                    ? theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.15,
                                                          )
                                                    : count > 0 &&
                                                          intensity > 0.5
                                                    ? Colors.white
                                                    : theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: NomoDimensions.spacing12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: NomoTypography.caption.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (i) {
                final alpha = i == 0 ? 0.0 : 0.15 + (i / 4) * 0.85;
                return Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i == 0
                        ? backgroundColor
                        : primaryColor.withValues(alpha: alpha),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(
                'More',
                style: NomoTypography.caption.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDayDetail(BuildContext context, DateTime day, ThemeData theme) {
    showDayDetailSheet(context: context, day: day, allCravings: allCravings);
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar month labels row
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarMonthLabels extends StatelessWidget {
  final List<DateTime> days;
  final int numWeeks;
  final ThemeData theme;

  const _CalendarMonthLabels({
    required this.days,
    required this.numWeeks,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Find first day of each week and detect month boundaries
    final labels = <_MonthLabel>[];
    int? lastMonth;
    for (int col = 0; col < numWeeks; col++) {
      final dayIdx = col * 7; // First day (Monday) of each week
      if (dayIdx < days.length) {
        final day = days[dayIdx];
        if (day.month != lastMonth) {
          labels.add(_MonthLabel(col, DateFormat('MMM').format(day)));
          lastMonth = day.month;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 24), // Offset for weekday labels
      child: LayoutBuilder(
        builder: (context, constraints) {
          final weekWidth = constraints.maxWidth / numWeeks;
          return SizedBox(
            height: 16,
            child: Stack(
              children: labels.map((label) {
                return Positioned(
                  left: label.weekIndex * weekWidth,
                  child: Text(
                    label.name,
                    style: NomoTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _MonthLabel {
  final int weekIndex;
  final String name;
  const _MonthLabel(this.weekIndex, this.name);
}
