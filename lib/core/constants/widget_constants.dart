/// Constants for home-screen widget integration.
class WidgetConstants {
  WidgetConstants._();

  /// App Group ID for iOS - must match Xcode App Group for main app and widget.
  static const String appGroupId = 'group.com.nomo.nomo';

  /// iOS WidgetKit kind - must match the widget extension's kind.
  static const String iOSWidgetKind = 'QuitTrackerWidget';

  /// Android AppWidgetProvider class name.
  static const String androidWidgetProvider = 'QuitTrackerWidgetProvider';

  /// Storage keys for home_widget (shared with native).
  static const String keyTrackerId = 'widget_tracker_id';
  static const String keyTrackerName = 'widget_tracker_name';
  static const String keyElapsed = 'widget_elapsed';
  static const String keyIncludeCravingButton = 'widget_include_craving';
  static const String keyTrackersList = 'widget_trackers_list';
  static const String keyQuitDateIso = 'widget_quit_date_iso';
}
