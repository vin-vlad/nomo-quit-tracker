extension DurationExtensions on Duration {
  /// Total number of complete days.
  int get totalDays => inDays;

  /// Hours component (0-23).
  int get hoursComponent => inHours.remainder(24);

  /// Minutes component (0-59).
  int get minutesComponent => inMinutes.remainder(60);

  /// Seconds component (0-59).
  int get secondsComponent => inSeconds.remainder(60);

  /// Formats as "DDd HHh MMm SSs".
  String get formatted {
    final d = totalDays;
    final h = hoursComponent;
    final m = minutesComponent;
    final s = secondsComponent;
    if (d > 0) return '${d}d ${h}h ${m}m ${s}s';
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  /// Pad a number to 2 digits.
  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// Returns components as a record for display.
  ({String days, String hours, String minutes, String seconds})
      get counterParts => (
            days: totalDays.toString().padLeft(2, '0'),
            hours: _pad(hoursComponent),
            minutes: _pad(minutesComponent),
            seconds: _pad(secondsComponent),
          );
}
