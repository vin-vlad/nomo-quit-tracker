import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'app.dart';
import 'core/constants/widget_constants.dart';
import 'data/services/purchase_service.dart';
import 'data/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _widgetBackgroundCallback(Uri? uri) async {
  // Handles widget taps / background updates. Main UX uses deep links.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize home_widget for Android + iOS
  await HomeWidget.setAppGroupId(WidgetConstants.appGroupId);
  await HomeWidget.registerInteractivityCallback(_widgetBackgroundCallback);

  // Initialize services
  final purchaseService = PurchaseService();
  await purchaseService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    const ProviderScope(
      child: NomoApp(),
    ),
  );
}
