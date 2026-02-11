import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/craving.dart';
import '../../../domain/entities/slip_record.dart';
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

enum CravingRange { week, month, threeMonths, sixMonths, all }

extension CravingRangeLabel on CravingRange {
  String get label {
    switch (this) {
      case CravingRange.week:
        return '7d';
      case CravingRange.month:
        return '1m';
      case CravingRange.threeMonths:
        return '3m';
      case CravingRange.sixMonths:
        return '6m';
      case CravingRange.all:
        return 'All';
    }
  }
}

final _cravingRangeProvider = StateProvider<CravingRange>(
  (ref) => CravingRange.threeMonths,
);

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
                color: theme.dividerColor,
                width: NomoDimensions.dividerWidth,
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
                    'Insights',
                    style: NomoTypography.title.copyWith(
                      color: theme.colorScheme.onSurface,
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
                      child: InsightsContent(trackerId: selectedTracker.id),
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
            color: theme.dividerColor,
            width: NomoDimensions.dividerWidth,
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
                      NomoDimensions.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                      width: NomoDimensions.borderWidth,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tracker.name,
                        style: NomoTypography.caption.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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

class InsightsContent extends ConsumerWidget {
  final String trackerId;

  const InsightsContent({super.key, required this.trackerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cravingsAsync = ref.watch(cravingsByTrackerProvider(trackerId));
    final slipsAsync = ref.watch(slipsByTrackerProvider(trackerId));

    final slips = slipsAsync.valueOrNull ?? <SlipRecord>[];

    return cravingsAsync.when(
      data: (cravings) {
        final analyzer = AnalyzeCravings();
        final daily = analyzer.dailyTrend(cravings, slips: slips);
        final peak = analyzer.peakHours(cravings, slips: slips);

        final range = ref.watch(_cravingRangeProvider);
        final filteredDaily = _filterDailyByRange(daily, range);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(NomoDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Craving trend chart ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _SectionHeader(
                      title: 'Craving Trend',
                      subtitle: daily.isEmpty
                          ? null
                          : '${cravings.length} total · ${(cravings.length / (daily.length.clamp(1, 999))).toStringAsFixed(1)}/day avg',
                    ),
                  ),
                  if (daily.isNotEmpty)
                    _CravingRangeFilter(
                      selected: range,
                      onSelected: (newRange) {
                        ref.read(_cravingRangeProvider.notifier).state =
                            newRange;
                      },
                    ),
                ],
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              _CravingTrendChart(
                daily: filteredDaily,
                theme: theme,
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Peak hours chart ──
              _SectionHeader(
                title: 'Peak Hours',
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
                      title: 'Calendar',
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
                              'View All',
                              style: NomoTypography.caption.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                allSlips: slips,
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

  List<DayCount> _filterDailyByRange(List<DayCount> daily, CravingRange range) {
    if (daily.isEmpty) return daily;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime? cutoff;
    switch (range) {
      case CravingRange.week:
        cutoff = today.subtract(const Duration(days: 6));
        break;
      case CravingRange.month:
        cutoff = today.subtract(const Duration(days: 30));
        break;
      case CravingRange.threeMonths:
        cutoff = today.subtract(const Duration(days: 90));
        break;
      case CravingRange.sixMonths:
        cutoff = today.subtract(const Duration(days: 180));
        break;
      case CravingRange.all:
        cutoff = null;
        break;
    }

    if (cutoff == null) return daily;
    return daily.where((d) => !d.date.isBefore(cutoff!)).toList();
  }
}

class _CravingRangeFilter extends StatelessWidget {
  final CravingRange selected;
  final ValueChanged<CravingRange> onSelected;

  const _CravingRangeFilter({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: CravingRange.values.map((range) {
        final isSelected = range == selected;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: GestureDetector(
            onTap: () => onSelected(range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  NomoDimensions.borderRadiusSmall,
                ),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                  width: NomoDimensions.borderWidth,
                ),
              ),
              child: Text(
                range.label,
                style: NomoTypography.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
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
    final maxY = _maxY;
    final yInterval = _yInterval;
    final xInterval = _xInterval;
    final showDots = daily.length <= 45;

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
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: yInterval,
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
                          interval: xInterval,
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
                          interval: yInterval,
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
                        tooltipRoundedRadius: NomoDimensions.borderRadiusSmall,
                        tooltipBorder: BorderSide(
                          color: theme.dividerColor,
                          width: NomoDimensions.cardBorderWidth,
                        ),
                        getTooltipColor: (_) => theme.colorScheme.surface,
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            final idx = spot.x.toInt();
                            if (idx < 0 || idx >= daily.length) {
                              return null;
                            }
                            final d = daily[idx];
                            final isSlipLine = spot.barIndex == 1;
                            if (isSlipLine) {
                              return LineTooltipItem(
                                '${d.slipCount} slip${d.slipCount != 1 ? 's' : ''}',
                                NomoTypography.label.copyWith(
                                  color: theme.colorScheme.error,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              );
                            }
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
                      // Cravings line
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
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: theme.colorScheme.primary,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: showDots,
                          getDotPainter: (spot, _, __, ___) =>
                              FlDotCirclePainter(
                                radius: 1,
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
                      // Slips line
                      if (_hasSlips)
                        LineChartBarData(
                          spots: daily
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.slipCount.toDouble(),
                                ),
                              )
                              .toList(),
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: theme.colorScheme.error,
                          barWidth: 2,
                          dashArray: [6, 3],
                          dotData: FlDotData(
                            show: showDots,
                            getDotPainter: (spot, _, __, ___) =>
                                FlDotCirclePainter(
                                  radius: 1.5,
                                  color: theme.colorScheme.error,
                                  strokeWidth: 0,
                                ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.06,
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

  bool get _hasSlips => daily.any((d) => d.slipCount > 0);

  double get _maxY {
    if (daily.isEmpty) return 1;
    final maxCraving =
        daily.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    final maxSlip =
        daily.map((d) => d.slipCount).reduce((a, b) => a > b ? a : b);
    final maxCount = maxCraving > maxSlip ? maxCraving : maxSlip;
    return maxCount.toDouble();
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
    final hasData = peak.any((h) => h.count > 0 || h.slipCount > 0);
    final hasSlips = peak.any((h) => h.slipCount > 0);
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
                              final period = hour >= 12 ? 'pm' : 'am';
                              final display = hour == 0
                                  ? '12am'
                                  : hour == 12
                                  ? '12pm'
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
                        tooltipRoundedRadius: NomoDimensions.borderRadiusSmall,
                        tooltipBorder: BorderSide(
                          color: theme.dividerColor,
                          width: NomoDimensions.cardBorderWidth,
                        ),
                        getTooltipColor: (_) => theme.colorScheme.surface,
                        getTooltipItem: (group, groupIdx, rod, rodIdx) {
                          final hour = group.x;
                          final h = peak.firstWhere((p) => p.hour == hour);
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
                                text:
                                    '${h.count} craving${h.count != 1 ? 's' : ''}',
                                style: NomoTypography.label.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (h.slipCount > 0)
                                TextSpan(
                                  text:
                                      '\n${h.slipCount} slip${h.slipCount != 1 ? 's' : ''}',
                                  style: NomoTypography.label.copyWith(
                                    color: theme.colorScheme.error,
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
                                width: hasSlips ? 5 : 8,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              if (hasSlips)
                                BarChartRodData(
                                  toY: h.slipCount.toDouble(),
                                  color: theme.colorScheme.error,
                                  width: 5,
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
  final List<SlipRecord> allSlips;
  final Color primaryColor;
  final Color backgroundColor;

  const _CalendarHeatmap({
    required this.trackerId,
    required this.dailyCounts,
    required this.allCravings,
    required this.allSlips,
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
    final slipMap = <String, int>{};
    for (final d in dailyCounts) {
      countMap[_dayKey(d.date)] = d.count;
      if (d.slipCount > 0) {
        slipMap[_dayKey(d.date)] = d.slipCount;
      }
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

    const cellGap = 3.0;

    return BauhausCard(
      padding: const EdgeInsets.all(NomoDimensions.spacing16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final cellSize =
              ((totalWidth - (7 - 1) * cellGap) / 7).clamp(16.0, 44.0);

          // Detect which week-rows start a new month
          final monthLabels = <int, String>{};
          int? lastMonth;
          for (int week = 0; week < numWeeks; week++) {
            final dayIdx = week * 7;
            if (dayIdx < days.length) {
              final day = days[dayIdx];
              if (day.month != lastMonth) {
                monthLabels[week] = DateFormat('MMM').format(day);
                lastMonth = day.month;
              }
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weekday header row (M T W T F S S)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(7, (col) {
                  return Container(
                    width: cellSize,
                    margin: EdgeInsets.only(right: col < 6 ? cellGap : 0),
                    alignment: Alignment.center,
                    child: Text(
                      weekdays[col],
                      style: NomoTypography.caption.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),

              // Week rows
              ...List.generate(numWeeks, (week) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Month label above week row when month changes
                    if (monthLabels.containsKey(week)) ...[
                      if (week > 0) const SizedBox(height: 6),
                      Text(
                        monthLabels[week]!,
                        style: NomoTypography.caption.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    SizedBox(
                      height: cellSize,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(7, (col) {
                          final dayIdx = week * 7 + col;
                          if (dayIdx >= days.length) {
                            return SizedBox(
                              width: cellSize,
                              height: cellSize,
                            );
                          }
                          final day = days[dayIdx];
                          final key = _dayKey(day);
                          final count = countMap[key] ?? 0;
                          final slipCount = slipMap[key] ?? 0;
                          final intensity = maxCount > 0
                              ? (count / maxCount).clamp(0.0, 1.0)
                              : 0.0;
                          final isToday = day.isAtSameMomentAs(today);
                          final isFuture = day.isAfter(today);
                          final hasSlip = slipCount > 0;

                          // Use error color for slip days, primary for craving-only
                          final cellColor = isFuture
                              ? Colors.transparent
                              : hasSlip
                                  ? theme.colorScheme.error.withValues(
                                      alpha: 0.25 + intensity * 0.75,
                                    )
                                  : count > 0
                                      ? primaryColor.withValues(
                                          alpha: 0.15 + intensity * 0.85,
                                        )
                                      : backgroundColor;

                          return Container(
                            width: cellSize,
                            height: cellSize,
                            margin: EdgeInsets.only(
                              right: col < 6 ? cellGap : 0,
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: cellColor,
                                  border: isToday
                                      ? Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: NomoTypography.caption.copyWith(
                                      fontSize: 9,
                                      fontWeight: isToday
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isFuture
                                          ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.15)
                                          : (count > 0 && intensity > 0.5) ||
                                                  hasSlip
                                              ? Colors.white
                                              : theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    if (week < numWeeks - 1) const SizedBox(height: 3),
                  ],
                );
              }),

              const SizedBox(height: NomoDimensions.spacing12),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Less',
                    style: NomoTypography.caption.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDayDetail(BuildContext context, DateTime day, ThemeData theme) {
    showDayDetailSheet(
      context: context,
      day: day,
      allCravings: allCravings,
      allSlips: allSlips,
    );
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}
