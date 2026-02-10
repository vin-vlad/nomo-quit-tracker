import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/services/purchase_service.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
