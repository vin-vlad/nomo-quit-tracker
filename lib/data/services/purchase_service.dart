import 'dart:async';

/// Wraps RevenueCat for subscription management.
/// For now this is a stub that defaults to non-premium.
/// Replace with actual RevenueCat integration when ready.
class PurchaseService {
  final _isPremiumController = StreamController<bool>.broadcast();
  bool _isPremium = false;

  PurchaseService();

  /// Initialize the purchase service. Call once at app startup.
  Future<void> init() async {
    // TODO: Initialize RevenueCat with API keys
    // await Purchases.configure(PurchasesConfiguration('<api_key>'));
    _isPremiumController.add(false);
  }

  /// Whether the user has a premium subscription.
  bool get isPremium => _isPremium;

  /// Stream of premium status changes.
  Stream<bool> get isPremiumStream => _isPremiumController.stream;

  /// Restore previous purchases.
  Future<bool> restorePurchases() async {
    // TODO: Implement with RevenueCat
    return false;
  }

  /// Purchase a subscription package.
  Future<bool> purchase(String packageId) async {
    // TODO: Implement with RevenueCat
    return false;
  }

  /// For development: toggle premium status.
  void debugSetPremium(bool value) {
    _isPremium = value;
    _isPremiumController.add(value);
  }

  void dispose() {
    _isPremiumController.close();
  }
}
