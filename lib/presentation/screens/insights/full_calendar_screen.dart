import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/craving.dart';
import '../../providers/craving_providers.dart';
import '../../widgets/bauhaus_card.dart';
import 'widgets/day_detail_sheet.dart';

/// Full-screen month-by-month calendar with heatmap coloring.
/// Opens from the compact calendar heatmap in the Insights screen.
class FullCalendarScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const FullCalendarScreen({super.key, required this.trackerId});

  @override
  ConsumerState<FullCalendarScreen> createState() =>
      _FullCalendarScreenState();
}

class _FullCalendarScreenState extends ConsumerState<FullCalendarScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _currentMonth.year == now.year &&
        _currentMonth.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cravingsAsync =
        ref.watch(cravingsByTrackerProvider(widget.trackerId));

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
                horizontal: NomoDimensions.spacing8,
              ),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: NomoDimensions.spacing4),
                  Text(
                    'CALENDAR',
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
      body: cravingsAsync.when(
        data: (cravings) => _CalendarBody(
          cravings: cravings,
          currentMonth: _currentMonth,
          isCurrentMonth: _isCurrentMonth,
          onPreviousMonth: _goToPreviousMonth,
          onNextMonth: _isCurrentMonth ? null : _goToNextMonth,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar body with month navigation and grid
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarBody extends StatelessWidget {
  final List<Craving> cravings;
  final DateTime currentMonth;
  final bool isCurrentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback? onNextMonth;

  const _CalendarBody({
    required this.cravings,
    required this.currentMonth,
    required this.isCurrentMonth,
    required this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build a count map from all cravings
    final countMap = <String, int>{};
    for (final c in cravings) {
      final key = _dayKey(c.timestamp);
      countMap[key] = (countMap[key] ?? 0) + 1;
    }

    // Global max count for consistent heatmap intensity
    final maxCount = countMap.values.isEmpty
        ? 0
        : countMap.values.reduce((a, b) => a > b ? a : b);

    // Month summary
    final monthCravings = cravings.where((c) {
      return c.timestamp.year == currentMonth.year &&
          c.timestamp.month == currentMonth.month;
    }).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NomoDimensions.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigation row
          _MonthNavigator(
            currentMonth: currentMonth,
            onPrevious: onPreviousMonth,
            onNext: onNextMonth,
          ),

          const SizedBox(height: NomoDimensions.spacing8),

          // Month summary
          Text(
            '$monthCravings craving${monthCravings != 1 ? 's' : ''} this month',
            style: NomoTypography.caption.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: NomoDimensions.spacing24),

          // Calendar grid
          BauhausCard(
            padding: const EdgeInsets.all(NomoDimensions.spacing16),
            child: _MonthGrid(
              month: currentMonth,
              countMap: countMap,
              maxCount: maxCount,
              allCravings: cravings,
              primaryColor: theme.colorScheme.primary,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),

          const SizedBox(height: NomoDimensions.spacing16),

          // Legend
          _HeatmapLegend(
            primaryColor: theme.colorScheme.primary,
            backgroundColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ],
      ),
    );
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Month navigator — chevron arrows and month/year label
// ─────────────────────────────────────────────────────────────────────────────

class _MonthNavigator extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  const _MonthNavigator({
    required this.currentMonth,
    required this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthLabel =
        DateFormat('MMMM yyyy').format(currentMonth).toUpperCase();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.chevron_left,
          onTap: onPrevious,
        ),
        Text(
          monthLabel,
          style: NomoTypography.label.copyWith(
            color: theme.colorScheme.onSurface,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right,
          onTap: onNext,
          enabled: onNext != null,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _NavButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(NomoDimensions.borderRadius / 2),
          border: Border.all(
            color: enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.15),
            width: NomoDimensions.borderWidth,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Month grid — standard 7-column calendar layout with heatmap cells
// ─────────────────────────────────────────────────────────────────────────────

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final Map<String, int> countMap;
  final int maxCount;
  final List<Craving> allCravings;
  final Color primaryColor;
  final Color backgroundColor;

  const _MonthGrid({
    required this.month,
    required this.countMap,
    required this.maxCount,
    required this.allCravings,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // First day of the month
    final firstDay = DateTime(month.year, month.month, 1);
    // Number of days in the month
    final daysInMonth =
        DateTime(month.year, month.month + 1, 0).day;
    // Weekday offset (Monday = 0, Sunday = 6)
    final startWeekday = firstDay.weekday - 1; // 0-indexed from Monday

    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const cellGap = 4.0;

    return Column(
      children: [
        // Weekday header row
        Row(
          children: weekdays.map((d) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    d,
                    style: NomoTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Calendar day rows
        ...List.generate(_numRows(startWeekday, daysInMonth), (row) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: row < _numRows(startWeekday, daysInMonth) - 1
                    ? cellGap
                    : 0),
            child: Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final dayNum = cellIndex - startWeekday + 1;

                // Empty cells before the 1st or after last day
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 44));
                }

                final day =
                    DateTime(month.year, month.month, dayNum);
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
                      right: col < 6 ? cellGap : 0,
                    ),
                    child: GestureDetector(
                      onTap: isFuture
                          ? null
                          : () => showDayDetailSheet(
                                context: context,
                                day: day,
                                allCravings: allCravings,
                              ),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: isFuture
                              ? Colors.transparent
                              : count > 0
                                  ? primaryColor.withValues(
                                      alpha: 0.15 + intensity * 0.85)
                                  : backgroundColor,
                          border: isToday
                              ? Border.all(
                                  color: theme.colorScheme.onSurface,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayNum',
                              style: NomoTypography.caption.copyWith(
                                fontSize: 12,
                                fontWeight: isToday
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isFuture
                                    ? theme.colorScheme.onSurface
                                        .withValues(alpha: 0.15)
                                    : count > 0 && intensity > 0.5
                                        ? Colors.white
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                              ),
                            ),
                            if (count > 0 && !isFuture) ...[
                              const SizedBox(height: 1),
                              Text(
                                '$count',
                                style: NomoTypography.caption.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: intensity > 0.5
                                      ? Colors.white
                                          .withValues(alpha: 0.8)
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  int _numRows(int startWeekday, int daysInMonth) {
    return ((startWeekday + daysInMonth + 6) ~/ 7);
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Heatmap legend
// ─────────────────────────────────────────────────────────────────────────────

class _HeatmapLegend extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundColor;

  const _HeatmapLegend({
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
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
    );
  }
}
