import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/addiction_types.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../domain/entities/addiction_type.dart';
import '../../../domain/entities/tracker.dart' as domain;
import '../../providers/database_provider.dart';
import '../../widgets/bauhaus_button.dart';
import '../../widgets/bauhaus_card.dart';
import '../../widgets/geometric_decoration.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // State for addiction selection
  AddictionType? _selectedType;
  String _customName = '';

  // State for details
  DateTime _quitDate = DateTime.now();
  final _costController = TextEditingController();
  final _frequencyController = TextEditingController();
  String _currency = AppConstants.defaultCurrency;

  @override
  void initState() {
    super.initState();
    // Check if onboarding is already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnboarding();
    });
  }

  Future<void> _checkOnboarding() async {
    final settings = await ref.read(settingsRepositoryProvider).getSettings();
    if (settings.hasCompletedOnboarding && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _costController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    if (_selectedType == null) return;

    final now = DateTime.now();
    final tracker = domain.Tracker(
      id: const Uuid().v4(),
      name: _selectedType!.id == 'custom' ? _customName : _selectedType!.name,
      type: _selectedType!,
      customTypeName: _selectedType!.id == 'custom' ? _customName : null,
      quitDate: _quitDate,
      dailyCost: double.tryParse(_costController.text),
      dailyFrequency: int.tryParse(_frequencyController.text),
      currencyCode: _currency,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final trackerRepo = ref.read(trackerRepositoryProvider);
    await trackerRepo.insert(tracker);

    final settingsRepo = ref.read(settingsRepositoryProvider);
    final settings = await settingsRepo.getSettings();
    await settingsRepo.updateSettings(
      settings.copyWith(hasCompletedOnboarding: true, currencyCode: _currency),
    );

    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          GeometricDecoration.onboarding(context),
          SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                _buildWelcomePage(theme),
                _buildPickTypePage(theme),
                _buildDetailsPage(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Page 1: Welcome ───────────────────────────────────────────────
  Widget _buildWelcomePage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(NomoDimensions.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Text(
            AppConstants.appTagline,
            style: NomoTypography.display.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: NomoDimensions.spacing16),
          Text(
            AppConstants.appDescription,
            style: NomoTypography.title.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Spacer(flex: 3),
          BauhausButton(
            label: 'Get Started',
            onPressed: _nextPage,
            expand: true,
          ),
          const SizedBox(height: NomoDimensions.spacing48),
        ],
      ),
    );
  }

  // ── Page 2: Pick addiction type ───────────────────────────────────
  Widget _buildPickTypePage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(NomoDimensions.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: NomoDimensions.spacing32),
          Text(
            'What are you quitting?',
            style: NomoTypography.headline.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: NomoDimensions.spacing8),
          Text(
            'Choose one to start. You can add more later.',
            style: NomoTypography.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: NomoDimensions.spacing24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: NomoDimensions.spacing16,
                mainAxisSpacing: NomoDimensions.spacing16,
                childAspectRatio: 1.6,
              ),
              itemCount: AddictionTypePresets.freeTypes.length,
              itemBuilder: (context, index) {
                final type = AddictionTypePresets.freeTypes[index];
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: BauhausCard(
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AddictionIcon(
                            type: type,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(height: NomoDimensions.spacing8),
                          Text(
                            type.name,
                            style: NomoTypography.titleSmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedType?.id == 'custom') ...[
            const SizedBox(height: NomoDimensions.spacing16),
            TextField(
              onChanged: (v) => _customName = v,
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Enter habit name...',
                hintStyle: NomoTypography.body.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
          const SizedBox(height: NomoDimensions.spacing16),
          BauhausButton(
            label: 'Next',
            onPressed: _selectedType != null ? _nextPage : null,
            expand: true,
          ),
          const SizedBox(height: NomoDimensions.spacing24),
        ],
      ),
    );
  }

  // ── Page 3: Details ───────────────────────────────────────────────
  Widget _buildDetailsPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(NomoDimensions.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: NomoDimensions.spacing32),
          Text(
            'Set your details',
            style: NomoTypography.headline.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
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
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_quitDate),
                );
                setState(() {
                  _quitDate = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    time?.hour ?? DateTime.now().hour,
                    time?.minute ?? DateTime.now().minute,
                  );
                });
              }
            },
            child: BauhausCard(
              padding: const EdgeInsets.all(NomoDimensions.spacing16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_quitDate.day}/${_quitDate.month}/${_quitDate.year} at ${_quitDate.hour.toString().padLeft(2, '0')}:${_quitDate.minute.toString().padLeft(2, '0')}',
                      style: NomoTypography.body.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: NomoDimensions.spacing32),

          // Currency
          Text(
            'Currency',
            style: NomoTypography.caption.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: NomoDimensions.spacing8),
          DropdownButtonFormField<String>(
            initialValue: _currency,
            decoration: const InputDecoration(border: UnderlineInputBorder()),
            items: CurrencyUtils.currencies
                .map(
                  (c) => DropdownMenuItem(
                    value: c.code,
                    child: Text('${c.symbol} ${c.code}'),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _currency = v);
            },
          ),

          const SizedBox(height: NomoDimensions.spacing32),

          // Daily cost (optional)
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: NomoTypography.body.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 10.00',
              prefixText: '${CurrencyUtils.symbolFor(_currency)} ',
            ),
          ),

          const SizedBox(height: NomoDimensions.spacing32),

          // Daily frequency (optional)
          Text(
            'Daily frequency (optional)',
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
            decoration: const InputDecoration(
              hintText: 'e.g. 20 cigarettes per day',
            ),
          ),

          const SizedBox(height: NomoDimensions.spacing48),

          BauhausButton(
            label: 'Start Tracking',
            onPressed: _finish,
            expand: true,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(height: NomoDimensions.spacing32),
        ],
      ),
    );
  }
}

class _AddictionIcon extends StatelessWidget {
  final AddictionType type;
  final Color color;

  const _AddictionIcon({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    // Map addiction types to simple geometric icons
    IconData icon;
    switch (type.id) {
      case 'smoking':
        icon = Icons.smoking_rooms;
      case 'vaping':
        icon = Icons.cloud;
      case 'alcohol':
        icon = Icons.local_bar;
      case 'caffeine':
        icon = Icons.coffee;
      case 'custom':
        icon = Icons.edit;
      case 'sugar':
        icon = Icons.cake;
      case 'social_media':
        icon = Icons.phone_android;
      case 'gambling':
        icon = Icons.casino;
      case 'shopping':
        icon = Icons.shopping_bag;
      case 'nail_biting':
        icon = Icons.front_hand;
      case 'junk_food':
        icon = Icons.fastfood;
      case 'gaming':
        icon = Icons.sports_esports;
      case 'drugs':
        icon = Icons.medication;
      default:
        icon = Icons.block;
    }
    return Icon(icon, color: color, size: 28);
  }
}
