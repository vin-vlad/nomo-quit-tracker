import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/nomo_colors.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../providers/database_provider.dart';
import '../../providers/purchase_providers.dart';
import '../../providers/settings_providers.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(userSettingsProvider);
    final isPremium = ref.watch(isPremiumSyncProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: NomoDimensions.dividerWidth,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NomoDimensions.spacing16,
              ),
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: NomoTypography.title.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => SingleChildScrollView(
          padding: const EdgeInsets.all(NomoDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Theme ───────────────────────────────────────────
              Text(
                'Theme',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              Wrap(
                spacing: NomoDimensions.spacing12,
                runSpacing: NomoDimensions.spacing12,
                children: NomoPalettes.all.map((palette) {
                  // Resolve legacy palette IDs for correct selection highlight
                  final resolvedId =
                      NomoPalettes.byId(settings.selectedPaletteId).id;
                  final isSelected = palette.id == resolvedId;
                  final isLocked = palette.id != 'serenity' &&
                      palette.id != 'monochrome' &&
                      !isPremium;

                  return GestureDetector(
                    onTap: () {
                      if (isLocked) {
                        context.push('/paywall');
                        return;
                      }
                      _updatePalette(ref, settings, palette.id);
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(NomoDimensions.borderRadiusSmall),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                          width: isSelected ? 3 : 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    color: palette.primary)),
                              Expanded(
                                child: Container(
                                    color: palette.secondary)),
                              Expanded(
                                child: Container(
                                    color: palette.accent)),
                            ],
                          ),
                          if (isLocked)
                            Center(
                              child: Icon(
                                Icons.lock,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Brightness ──────────────────────────────────────
              Text(
                'Appearance',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              Row(
                children: [
                  _BrightnessOption(
                    label: 'System',
                    isSelected: settings.brightnessMode == 'system',
                    onTap: () =>
                        _updateBrightness(ref, settings, 'system'),
                  ),
                  const SizedBox(width: NomoDimensions.spacing8),
                  _BrightnessOption(
                    label: 'Light',
                    isSelected: settings.brightnessMode == 'light',
                    onTap: () =>
                        _updateBrightness(ref, settings, 'light'),
                  ),
                  const SizedBox(width: NomoDimensions.spacing8),
                  _BrightnessOption(
                    label: 'Dark',
                    isSelected: settings.brightnessMode == 'dark',
                    onTap: () =>
                        _updateBrightness(ref, settings, 'dark'),
                  ),
                ],
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Currency ────────────────────────────────────────
              Text(
                'Currency',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              DropdownButtonFormField<String>(
                key: ValueKey(settings.currencyCode),
                initialValue: settings.currencyCode,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                items: CurrencyUtils.currencies
                    .map((c) => DropdownMenuItem(
                          value: c.code,
                          child: Text('${c.symbol} ${c.code} — ${c.name}'),
                        ))
                    .toList(),
                onChanged: (v) async {
                  if (v != null) await _updateCurrency(ref, settings, v);
                },
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Notifications ───────────────────────────────────
              Text(
                'Notifications',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              BauhausCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Motivation',
                      style: NomoTypography.body.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Switch.adaptive(
                      value: settings.notificationsEnabled,
                      activeTrackColor: theme.colorScheme.primary,
                      onChanged: (v) {
                        _updateNotifications(ref, settings, v);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── Subscription ────────────────────────────────────
              Text(
                'Subscription',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              BauhausCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium ? 'Premium Active' : 'Free Plan',
                          style: NomoTypography.titleSmall.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          isPremium
                              ? 'You have full access.'
                              : 'Upgrade to unlock all features.',
                          style: NomoTypography.caption.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    if (!isPremium)
                      BauhausButton(
                        label: 'Upgrade',
                        onPressed: () => context.push('/paywall'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing32),

              // ── About ──────────────────────────────────────────
              Text(
                'About',
                style: NomoTypography.label.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing12),
              BauhausCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomo v1.0.0',
                      style: NomoTypography.titleSmall.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track your progress. Quit for good.',
                      style: NomoTypography.caption.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NomoDimensions.spacing48),

              // Dev toggle
              BauhausButton(
                label: isPremium ? 'Debug: Disable Premium' : 'Debug: Enable Premium',
                variant: BauhausButtonVariant.outlined,
                onPressed: () {
                  ref.read(purchaseServiceProvider).debugSetPremium(!isPremium);
                },
                expand: true,
                color: theme.colorScheme.secondary,
              ),

              const SizedBox(height: NomoDimensions.spacing32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _updatePalette(WidgetRef ref, dynamic settings, String paletteId) {
    ref.read(settingsRepositoryProvider).updateSettings(
          settings.copyWith(selectedPaletteId: paletteId),
        );
  }

  void _updateBrightness(WidgetRef ref, dynamic settings, String mode) {
    ref.read(settingsRepositoryProvider).updateSettings(
          settings.copyWith(brightnessMode: mode),
        );
  }

  Future<void> _updateCurrency(
      WidgetRef ref, dynamic settings, String code) async {
    await ref.read(settingsRepositoryProvider).updateSettings(
          settings.copyWith(currencyCode: code),
        );
    await ref.read(trackerRepositoryProvider).updateAllCurrencyCodes(code);
  }

  void _updateNotifications(WidgetRef ref, dynamic settings, bool enabled) {
    ref.read(settingsRepositoryProvider).updateSettings(
          settings.copyWith(notificationsEnabled: enabled),
        );
  }
}

class _BrightnessOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BrightnessOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: NomoDimensions.spacing12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: NomoDimensions.borderWidth,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: NomoTypography.caption.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
