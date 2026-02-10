/// Handles local notifications for motivation, milestones, and check-ins.
/// Stub implementation — wire up flutter_local_notifications when ready.
class NotificationService {
  NotificationService();

  /// Initialize the notification service.
  Future<void> init() async {
    // TODO: Initialize flutter_local_notifications
  }

  /// Schedule a daily motivation notification at the given time.
  Future<void> scheduleDailyMotivation(String time) async {
    // TODO: Parse time (HH:mm), schedule repeating notification
  }

  /// Cancel the daily motivation notification.
  Future<void> cancelDailyMotivation() async {
    // TODO: Cancel scheduled notification
  }

  /// Show a milestone achievement notification.
  Future<void> showMilestoneNotification({
    required String title,
    required String body,
  }) async {
    // TODO: Show immediate notification
  }

  /// Show a craving check-in reminder.
  Future<void> showCravingCheckIn() async {
    // TODO: Show notification asking "How are you doing?"
  }
}
