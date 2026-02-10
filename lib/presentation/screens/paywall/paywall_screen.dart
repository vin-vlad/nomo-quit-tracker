import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../providers/purchase_providers.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(NomoDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(NomoDimensions.borderRadius / 2),
                      border: Border.all(
                        color: theme.colorScheme.onSurface,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // Headline
              Text(
                'Unlock\nEverything.',
                style: NomoTypography.display.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 40,
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing24),

              // Features list
              _FeatureItem(
                icon: Icons.all_inclusive,
                text: 'Unlimited trackers',
                theme: theme,
              ),
              _FeatureItem(
                icon: Icons.bar_chart,
                text: 'Insights & analytics',
                theme: theme,
              ),
              _FeatureItem(
                icon: Icons.edit_note,
                text: 'Detailed craving journal',
                theme: theme,
              ),
              _FeatureItem(
                icon: Icons.palette,
                text: 'All color themes',
                theme: theme,
              ),
              _FeatureItem(
                icon: Icons.emoji_events,
                text: 'Advanced milestones',
                theme: theme,
              ),
              _FeatureItem(
                icon: Icons.history,
                text: 'Slip tracking',
                theme: theme,
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // Plan options
              GestureDetector(
                onTap: () => setState(() => _selectedPlan = 'yearly'),
                child: BauhausCard(
                  borderColor: _selectedPlan == 'yearly'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'YEARLY',
                                style: NomoTypography.label.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: NomoDimensions.spacing8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'SAVE 50%',
                                  style: NomoTypography.caption.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '7-day free trial',
                            style: NomoTypography.caption.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$29.99/yr',
                        style: NomoTypography.title.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing12),

              GestureDetector(
                onTap: () => setState(() => _selectedPlan = 'monthly'),
                child: BauhausCard(
                  borderColor: _selectedPlan == 'monthly'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTHLY',
                            style: NomoTypography.label.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '7-day free trial',
                            style: NomoTypography.caption.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$4.99/mo',
                        style: NomoTypography.title.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // CTA
              BauhausButton(
                label: 'Start Free Trial',
                onPressed: () {
                  // TODO: Wire up RevenueCat purchase
                  // For now, activate premium for dev
                  ref
                      .read(purchaseServiceProvider)
                      .debugSetPremium(true);
                  Navigator.of(context).pop();
                },
                expand: true,
              ),

              const SizedBox(height: NomoDimensions.spacing16),

              // Restore
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Wire up RevenueCat restore
                    ref
                        .read(purchaseServiceProvider)
                        .restorePurchases();
                  },
                  child: Text(
                    'Restore Purchases',
                    style: NomoTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: NomoDimensions.spacing12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: NomoDimensions.spacing12),
          Text(
            text,
            style: NomoTypography.body.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
