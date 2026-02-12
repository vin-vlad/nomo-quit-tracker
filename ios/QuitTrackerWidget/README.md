# Quit Tracker Widget Extension

This folder contains the iOS WidgetKit extension for the Quit Tracker app.

## Setup in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode.
2. File → New → Target.
3. Select **Widget Extension**, click Next.
4. Product Name: `QuitTrackerWidget`, uncheck "Include Configuration App Intent".
5. Click Finish. When prompted to activate the scheme, click Activate.
6. Delete the auto-generated Swift file(s) in the new target.
7. Add the existing `QuitTrackerWidget.swift` to the target: Right-click the QuitTrackerWidget group → Add Files → select `QuitTrackerWidget.swift`.
8. **Enable App Groups** for both targets:
   - Select **Runner** target → Signing & Capabilities → + Capability → App Groups → add `group.com.nomo.nomo`
   - Select **QuitTrackerWidgetExtension** target → Signing & Capabilities → + Capability → App Groups → add `group.com.nomo.nomo`
9. Ensure the widget's **kind** in the Swift file matches `QuitTrackerWidget` (used in Flutter's `updateWidget`).
10. Build and run.

## App Group

The App Group ID `group.com.nomo.nomo` must match:
- `WidgetConstants.appGroupId` in Flutter
- The capability added in Xcode for both Runner and the widget extension.

## Data flow

Flutter writes tracker data via `HomeWidget.saveWidgetData`. The widget reads from `UserDefaults(suiteName: "group.com.nomo.nomo")` using keys: `widget_tracker_id`, `widget_tracker_name`, `widget_elapsed`, `widget_include_slip`.
