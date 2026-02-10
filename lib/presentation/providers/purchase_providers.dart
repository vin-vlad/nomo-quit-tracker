import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/purchase_service.dart';

/// The purchase service singleton.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Whether the user has premium access.
final isPremiumProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(purchaseServiceProvider);
  return service.isPremiumStream;
});

/// Synchronous check — defaults to false.
final isPremiumSyncProvider = Provider<bool>((ref) {
  final async = ref.watch(isPremiumProvider);
  return async.valueOrNull ?? false;
});
