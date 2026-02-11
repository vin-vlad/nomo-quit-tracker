import '../entities/craving.dart';
import '../entities/slip_record.dart';

/// Analytics data structures.
class DayCount {
  final DateTime date;
  final int count;
  final int slipCount;
  const DayCount(this.date, this.count, {this.slipCount = 0});
}

class HourCount {
  final int hour; // 0–23
  final int count;
  final int slipCount;
  const HourCount(this.hour, this.count, {this.slipCount = 0});
}

class PeriodAverage {
  final DateTime periodStart;
  final double averageIntensity;
  const PeriodAverage(this.periodStart, this.averageIntensity);
}

/// Analyzes craving patterns for the Insights screen (premium).
class AnalyzeCravings {
  /// Cravings (and optionally slips) per day over a date range.
  List<DayCount> dailyTrend(
    List<Craving> cravings, {
    List<SlipRecord> slips = const [],
  }) {
    if (cravings.isEmpty && slips.isEmpty) return [];

    final cravingMap = <String, int>{};
    for (final c in cravings) {
      final key =
          '${c.timestamp.year}-${c.timestamp.month}-${c.timestamp.day}';
      cravingMap[key] = (cravingMap[key] ?? 0) + 1;
    }

    final slipMap = <String, int>{};
    for (final s in slips) {
      final key =
          '${s.timestamp.year}-${s.timestamp.month}-${s.timestamp.day}';
      slipMap[key] = (slipMap[key] ?? 0) + 1;
    }

    final allKeys = {...cravingMap.keys, ...slipMap.keys};
    final result = <DayCount>[];
    for (final key in allKeys) {
      final parts = key.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      result.add(DayCount(
        date,
        cravingMap[key] ?? 0,
        slipCount: slipMap[key] ?? 0,
      ));
    }
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  /// Distribution of cravings (and optionally slips) by hour of day (0–23).
  List<HourCount> peakHours(
    List<Craving> cravings, {
    List<SlipRecord> slips = const [],
  }) {
    final counts = List.filled(24, 0);
    for (final c in cravings) {
      counts[c.timestamp.hour]++;
    }
    final slipCounts = List.filled(24, 0);
    for (final s in slips) {
      slipCounts[s.timestamp.hour]++;
    }
    return List.generate(
        24, (h) => HourCount(h, counts[h], slipCount: slipCounts[h]));
  }

  /// Average intensity per week.
  List<PeriodAverage> weeklyIntensity(List<Craving> cravings) {
    final withIntensity = cravings.where((c) => c.intensity != null).toList();
    if (withIntensity.isEmpty) return [];

    withIntensity.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final result = <PeriodAverage>[];
    var weekStart = _startOfWeek(withIntensity.first.timestamp);
    var weekCravings = <Craving>[];

    for (final c in withIntensity) {
      final cWeekStart = _startOfWeek(c.timestamp);
      if (cWeekStart != weekStart) {
        if (weekCravings.isNotEmpty) {
          final avg = weekCravings
                  .map((c) => c.intensity!)
                  .reduce((a, b) => a + b) /
              weekCravings.length;
          result.add(PeriodAverage(weekStart, avg));
        }
        weekStart = cWeekStart;
        weekCravings = [];
      }
      weekCravings.add(c);
    }

    // Last week
    if (weekCravings.isNotEmpty) {
      final avg =
          weekCravings.map((c) => c.intensity!).reduce((a, b) => a + b) /
              weekCravings.length;
      result.add(PeriodAverage(weekStart, avg));
    }

    return result;
  }

  DateTime _startOfWeek(DateTime dt) {
    final diff = dt.weekday - 1; // Monday = 0
    return DateTime(dt.year, dt.month, dt.day - diff);
  }
}
