import '../entities/tracker.dart';

/// Computes how long the user has been quit.
/// For slips, timer keeps running. For resets, uses the new quit date.
class CalculateTimeQuit {
  /// Returns the effective quit duration.
  Duration call(Tracker tracker) {
    return DateTime.now().difference(tracker.quitDate);
  }
}
