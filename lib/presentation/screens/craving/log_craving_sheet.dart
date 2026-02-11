import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../../domain/entities/craving.dart' as domain;
import '../../providers/database_provider.dart';
import '../../widgets/bauhaus_button.dart';

class LogCravingSheet extends ConsumerStatefulWidget {
  final String trackerId;
  final bool isPremium;

  const LogCravingSheet({
    super.key,
    required this.trackerId,
    this.isPremium = false,
  });

  @override
  ConsumerState<LogCravingSheet> createState() => _LogCravingSheetState();
}

class _LogCravingSheetState extends ConsumerState<LogCravingSheet> {
  int _intensity = 5;
  domain.CravingTrigger? _trigger;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final craving = domain.Craving(
      id: const Uuid().v4(),
      trackerId: widget.trackerId,
      timestamp: DateTime.now(),
      intensity: widget.isPremium ? _intensity : null,
      trigger: widget.isPremium ? _trigger : null,
      note: widget.isPremium && _noteController.text.isNotEmpty
          ? _noteController.text
          : null,
    );

    await ref.read(cravingRepositoryProvider).insert(craving);
    HapticFeedback.mediumImpact();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Free tier: simple tap-to-log
    if (!widget.isPremium) {
      return Container(
        padding: const EdgeInsets.all(NomoDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Having a craving?',
              style: NomoTypography.headline.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing16),
            Text(
              'You\'re stronger than this. Log it and move on.',
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: NomoDimensions.spacing32),
            GestureDetector(
              onTap: _save,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.dividerColor,
                    width: NomoDimensions.borderWidth,
                  ),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing12),
            Text(
              'Tap to log',
              style: NomoTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing32),
          ],
        ),
      );
    }

    // Premium: detailed craving journal
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: NomoDimensions.spacing24,
        right: NomoDimensions.spacing24,
        top: NomoDimensions.spacing24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Craving',
              style: NomoTypography.headline.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing24),

            // Intensity slider
            Text(
              'Intensity',
              style: NomoTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            Row(
              children: [
                Text(
                  '1',
                  style: NomoTypography.caption.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: theme.colorScheme.primary,
                      inactiveTrackColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      thumbColor: theme.colorScheme.primary,
                      thumbShape: const _SquareThumb(),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _intensity.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (v) =>
                          setState(() => _intensity = v.round()),
                    ),
                  ),
                ),
                Text(
                  '10',
                  style: NomoTypography.caption.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: NomoDimensions.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NomoDimensions.spacing8,
                    vertical: NomoDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(NomoDimensions.borderRadiusSmall),
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '$_intensity',
                    style: NomoTypography.titleSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: NomoDimensions.spacing24),

            // Trigger picker
            Text(
              'Trigger',
              style: NomoTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            Wrap(
              spacing: NomoDimensions.spacing8,
              runSpacing: NomoDimensions.spacing8,
              children: domain.CravingTrigger.values.map((t) {
                final isSelected = _trigger == t;
                return GestureDetector(
                  onTap: () => setState(() => _trigger = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NomoDimensions.spacing12,
                      vertical: NomoDimensions.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(NomoDimensions.borderRadiusSmall),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      t.label,
                      style: NomoTypography.caption.copyWith(
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: NomoDimensions.spacing24),

            // Note
            Text(
              'Note (optional)',
              style: NomoTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: NomoTypography.body.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: 'What triggered this?',
              ),
            ),

            const SizedBox(height: NomoDimensions.spacing32),

            BauhausButton(
              label: 'Save Craving',
              onPressed: _save,
              expand: true,
            ),

            const SizedBox(height: NomoDimensions.spacing24),
          ],
        ),
      ),
    );
  }
}

/// Rounded slider thumb.
class _SquareThumb extends SliderComponentShape {
  const _SquareThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    const radius = 9.0;
    final rect = Rect.fromCenter(center: center, width: 18, height: 18);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    final paint = Paint()..color = sliderTheme.thumbColor!;
    canvas.drawRRect(rrect, paint);
    // Border
    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor!.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, borderPaint);
  }
}
