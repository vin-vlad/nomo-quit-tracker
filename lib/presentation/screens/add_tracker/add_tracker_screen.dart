import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/addiction_types.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/addiction_type.dart';
import '../../../domain/entities/tracker.dart' as domain;
import '../../providers/database_provider.dart';
import '../../providers/purchase_providers.dart';
import '../../widgets/bauhaus_app_bar.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';

class AddTrackerScreen extends ConsumerStatefulWidget {
  const AddTrackerScreen({super.key});

  @override
  ConsumerState<AddTrackerScreen> createState() => _AddTrackerScreenState();
}

class _AddTrackerScreenState extends ConsumerState<AddTrackerScreen> {
  AddictionType? _selectedType;
  String _customName = '';
  DateTime _quitDate = DateTime.now();
  final _costController = TextEditingController();
  final _frequencyController = TextEditingController();

  @override
  void dispose() {
    _costController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedType == null) return;
    if (_selectedType!.id == 'custom' && _customName.trim().isEmpty) return;

    // Check for duplicates (skip for custom types)
    if (_selectedType!.id != 'custom') {
      final repo = ref.read(trackerRepositoryProvider);
      final exists =
          await repo.hasActiveTrackerOfType(_selectedType!.id);
      if (exists && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You already have an active "${_selectedType!.name}" tracker.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    final settings = await ref.read(settingsRepositoryProvider).getSettings();
    final currency = settings.currencyCode;

    // Determine sort order: place at the end
    final count = await ref.read(trackerRepositoryProvider).countActive();

    final now = DateTime.now();
    final tracker = domain.Tracker(
      id: const Uuid().v4(),
      name: _selectedType!.id == 'custom' ? _customName : _selectedType!.name,
      type: _selectedType!,
      customTypeName: _selectedType!.id == 'custom' ? _customName : null,
      quitDate: _quitDate,
      dailyCost: double.tryParse(_costController.text),
      dailyFrequency: int.tryParse(_frequencyController.text),
      currencyCode: currency,
      isActive: true,
      sortOrder: count,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(trackerRepositoryProvider).insert(tracker);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = ref.watch(isPremiumSyncProvider);

    return Scaffold(
      appBar: const BauhausAppBar(title: 'Add Tracker'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(NomoDimensions.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are you quitting?',
              style: NomoTypography.title.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing16),

            // Addiction type grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: NomoDimensions.spacing12,
                mainAxisSpacing: NomoDimensions.spacing12,
                childAspectRatio: 1.1,
              ),
              itemCount: AddictionTypePresets.all.length,
              itemBuilder: (context, index) {
                final type = AddictionTypePresets.all[index];
                final isLocked = type.isPremium && !isPremium;
                final isSelected = _selectedType == type;

                return GestureDetector(
                  onTap: () {
                    if (isLocked) {
                      context.push('/paywall');
                      return;
                    }
                    setState(() => _selectedType = type);
                  },
                  child: BauhausCard(
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _iconFor(type.id),
                                color: isSelected
                                    ? Colors.white
                                    : (isLocked
                                        ? theme.colorScheme.onSurface
                                            .withValues(alpha: 0.3)
                                        : theme.colorScheme.onSurface),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type.name,
                                style: NomoTypography.caption.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : (isLocked
                                          ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.3)
                                          : theme.colorScheme.onSurface),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (isLocked)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              Icons.lock,
                              size: 14,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (_selectedType?.id == 'custom') ...[
              const SizedBox(height: NomoDimensions.spacing24),
              Text(
                'Custom name',
                style: NomoTypography.caption.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: NomoDimensions.spacing8),
              TextField(
                onChanged: (v) => _customName = v,
                style: NomoTypography.body.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter habit name...',
                ),
              ),
            ],

            const SizedBox(height: NomoDimensions.spacing32),

            // Quit date
            Text(
              'Quit date',
              style: NomoTypography.caption.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _quitDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _quitDate = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      _quitDate.hour,
                      _quitDate.minute,
                    );
                  });
                }
              },
              child: BauhausCard(
                padding: const EdgeInsets.all(NomoDimensions.spacing12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_quitDate.day}/${_quitDate.month}/${_quitDate.year}',
                        style: NomoTypography.body.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_today,
                        size: 18, color: theme.colorScheme.onSurface),
                  ],
                ),
              ),
            ),

            const SizedBox(height: NomoDimensions.spacing24),

            // Daily cost
            Text(
              'Daily cost (optional)',
              style: NomoTypography.caption.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            TextField(
              controller: _costController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: const InputDecoration(hintText: 'e.g. 10.00'),
            ),

            const SizedBox(height: NomoDimensions.spacing24),

            // Frequency
            Text(
              'Times per day (optional)',
              style: NomoTypography.caption.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            TextField(
              controller: _frequencyController,
              keyboardType: TextInputType.number,
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: const InputDecoration(hintText: 'e.g. 20'),
            ),

            const SizedBox(height: NomoDimensions.spacing48),

            BauhausButton(
              label: 'Start Tracking',
              onPressed: _selectedType != null ? _save : null,
              expand: true,
            ),

            const SizedBox(height: NomoDimensions.spacing32),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String typeId) {
    switch (typeId) {
      case 'smoking':
        return Icons.smoking_rooms;
      case 'vaping':
        return Icons.cloud;
      case 'alcohol':
        return Icons.local_bar;
      case 'caffeine':
        return Icons.coffee;
      case 'custom':
        return Icons.edit;
      case 'sugar':
        return Icons.cake;
      case 'social_media':
        return Icons.phone_android;
      case 'gambling':
        return Icons.casino;
      case 'shopping':
        return Icons.shopping_bag;
      case 'nail_biting':
        return Icons.front_hand;
      case 'junk_food':
        return Icons.fastfood;
      case 'porn':
        return Icons.visibility_off;
      case 'gaming':
        return Icons.sports_esports;
      case 'drugs':
        return Icons.medication;
      default:
        return Icons.block;
    }
  }
}
