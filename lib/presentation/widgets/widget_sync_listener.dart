import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/tracker.dart' as domain;
import '../providers/tracker_providers.dart';
import '../providers/widget_providers.dart';

/// Listens to tracker changes and syncs data to home_widget.
/// Syncs on app resume and every 60s when in foreground to keep widget fresh.
class WidgetSyncListener extends ConsumerStatefulWidget {
  const WidgetSyncListener({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<WidgetSyncListener> createState() => _WidgetSyncListenerState();
}

class _WidgetSyncListenerState extends ConsumerState<WidgetSyncListener>
    with WidgetsBindingObserver {
  Timer? _periodicSyncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    _periodicSyncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync();
      _startPeriodicSync();
    } else {
      _periodicSyncTimer?.cancel();
      _periodicSyncTimer = null;
    }
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) _sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeTrackersProvider, (prev, next) {
      next.whenData((list) => _syncWithTrackers(list));
    });
    return widget.child;
  }

  void _sync() {
    final trackers = ref.read(activeTrackersProvider).valueOrNull;
    if (trackers != null && trackers.isNotEmpty) {
      _syncWithTrackers(trackers);
    }
  }

  Future<void> _syncWithTrackers(List<domain.Tracker> trackers) async {
    final service = ref.read(widgetSyncServiceProvider);
    await service.syncTrackersList(trackers);
  }
}
