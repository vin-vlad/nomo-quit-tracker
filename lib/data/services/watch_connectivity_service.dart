/// Abstract interface for watch connectivity.
/// Reserved platform channel: com.nomo/watch
abstract class WatchConnectivityService {
  /// Whether a watch is paired and connected.
  Future<bool> isWatchConnected();

  /// Send tracker data to the watch.
  Future<void> sendTrackerUpdate(Map<String, dynamic> data);

  /// Receive a craving log from the watch.
  Stream<Map<String, dynamic>> receiveCravingLog();
}

/// No-op implementation for when watch apps are not available.
class NoOpWatchConnectivityService implements WatchConnectivityService {
  @override
  Future<bool> isWatchConnected() async => false;

  @override
  Future<void> sendTrackerUpdate(Map<String, dynamic> data) async {}

  @override
  Stream<Map<String, dynamic>> receiveCravingLog() => const Stream.empty();
}
