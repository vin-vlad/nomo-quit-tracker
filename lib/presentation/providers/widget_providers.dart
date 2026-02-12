import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/widget_sync_service.dart';

/// Provides the widget sync service.
final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  return WidgetSyncService();
});

/// Exposes [WidgetSyncService] for manual sync calls.
/// Use [WidgetSyncListener] to auto-sync when trackers change.
