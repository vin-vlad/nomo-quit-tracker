import '../entities/tracker.dart';

/// Computes total money saved since quitting.
class CalculateSavings {
  /// Returns the total amount saved.
  double call(Tracker tracker) {
    if (tracker.dailyCost == null || tracker.dailyCost == 0) return 0;
    final elapsedDays =
        DateTime.now().difference(tracker.quitDate).inSeconds / 86400.0;
    return elapsedDays * tracker.dailyCost!;
  }

  /// Project savings for a given number of months.
  double projected(double dailyCost, int months) {
    return dailyCost * months * 30.44; // average days per month
  }
}
