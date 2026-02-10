/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Nomo';
  static const String appTagline = 'No More.';
  static const String appDescription = 'Track your progress. Quit for good.';

  /// Maximum number of trackers in the free tier.
  static const int freeTrackerLimit = 1;

  /// RevenueCat entitlement identifier.
  static const String premiumEntitlement = 'premium';

  /// Platform channel name reserved for future watch connectivity.
  static const String watchChannel = 'com.nomo/watch';

  /// Default currency code.
  static const String defaultCurrency = 'USD';
}
