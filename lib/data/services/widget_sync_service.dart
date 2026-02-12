import 'dart:convert';

import 'package:home_widget/home_widget.dart';

import '../../core/constants/widget_constants.dart';
import '../../core/extensions/duration_extensions.dart';
import '../../domain/entities/tracker.dart';

/// Syncs tracker data to home_widget storage for Android and iOS widgets.
///
/// Widget configuration (which tracker per widget instance, include slip button)
/// is stored on the native side. This service writes the global tracker snapshot
/// so any configured widget can display its selected tracker.
class WidgetSyncService {
  /// Saves a snapshot of the given tracker for widget display.
  /// Used when we have a single "primary" tracker selection.
  Future<void> syncTrackerSnapshot(
    Tracker tracker, {
    bool includeCravingButton = true,
  }) async {
    final elapsed = DateTime.now().difference(tracker.quitDate);
    await HomeWidget.saveWidgetData<String>(
      WidgetConstants.keyTrackerId,
      tracker.id,
    );
    await HomeWidget.saveWidgetData<String>(
      WidgetConstants.keyTrackerName,
      tracker.name,
    );
    await HomeWidget.saveWidgetData<String>(
      WidgetConstants.keyElapsed,
      elapsed.formattedWithoutSeconds,
    );
    await HomeWidget.saveWidgetData<bool>(
      WidgetConstants.keyIncludeCravingButton,
      includeCravingButton,
    );
    await HomeWidget.saveWidgetData<String>(
      '${WidgetConstants.keyTrackerId}_${tracker.id}_quit_date',
      tracker.quitDate.toIso8601String(),
    );
    await _updateWidget();
  }

  /// Updates the full tracker list for widget configuration UIs and
  /// multi-tracker widgets. Each tracker gets id, name, elapsed, quitDate.
  /// Also writes the first tracker to single keys for iOS (StaticConfiguration).
  Future<void> syncTrackersList(List<Tracker> trackers) async {
    final list = trackers.map((t) {
      final elapsed = DateTime.now().difference(t.quitDate);
      return {
        'id': t.id,
        'name': t.name,
        'elapsed': elapsed.formattedWithoutSeconds,
        'quitDate': t.quitDate.toIso8601String(),
      };
    }).toList();
    await HomeWidget.saveWidgetData<String>(
      WidgetConstants.keyTrackersList,
      jsonEncode(list),
    );
    if (trackers.isNotEmpty) {
      final first = trackers.first;
      final elapsed = DateTime.now().difference(first.quitDate);
      await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyTrackerId,
        first.id,
      );
      await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyTrackerName,
        first.name,
      );
      await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyElapsed,
        elapsed.formattedWithoutSeconds,
      );
      await HomeWidget.saveWidgetData<bool>(
        WidgetConstants.keyIncludeCravingButton,
        true,
      );
    }
    await _updateWidget();
  }

  /// Syncs both a specific tracker snapshot and the full list.
  /// Call this when trackers change (e.g. from dashboard).
  Future<void> syncAll(
    List<Tracker> trackers, {
    String? selectedTrackerId,
    bool includeCravingButton = true,
  }) async {
    await syncTrackersList(trackers);

    if (trackers.isEmpty) return;

    Tracker? selected;
    if (selectedTrackerId != null) {
      final found = trackers.where((t) => t.id == selectedTrackerId);
      selected = found.isEmpty ? null : found.first;
    } else {
      selected = trackers.isNotEmpty ? trackers.first : null;
    }
    if (selected != null) {
      await syncTrackerSnapshot(selected, includeCravingButton: includeCravingButton);
    }
  }

  Future<void> _updateWidget() async {
    await HomeWidget.updateWidget(
      iOSName: WidgetConstants.iOSWidgetKind,
      androidName: WidgetConstants.androidWidgetProvider,
    );
  }
}
