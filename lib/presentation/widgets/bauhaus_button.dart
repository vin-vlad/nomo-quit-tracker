import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

enum BauhausButtonVariant { filled, outlined }

/// A clean, soft button with rounded corners and subtle interactions.
/// Labels are displayed as-is (no forced uppercase).
class BauhausButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final BauhausButtonVariant variant;
  final Color? color;
  final bool expand;
  final Widget? icon;

  const BauhausButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = BauhausButtonVariant.filled,
    this.color,
    this.expand = false,
    this.icon,
  });

  @override
  State<BauhausButton> createState() => _BauhausButtonState();
}

class _BauhausButtonState extends State<BauhausButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.color ?? theme.colorScheme.primary;
    final isFilled = widget.variant == BauhausButtonVariant.filled;
    final isDisabled = widget.onPressed == null;

    final bg = isFilled
        ? (isDisabled ? baseColor.withValues(alpha: 0.4) : baseColor)
        : Colors.transparent;
    final fg = isFilled
        ? Colors.white
        : (isDisabled ? baseColor.withValues(alpha: 0.4) : baseColor);

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            },
      onTapCancel:
          isDisabled ? null : () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.7 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: NomoDimensions.spacing24,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                BorderRadius.circular(NomoDimensions.borderRadius),
            border: isFilled
                ? null
                : Border.all(
                    color: isDisabled
                        ? baseColor.withValues(alpha: 0.3)
                        : baseColor.withValues(alpha: 0.4),
                    width: NomoDimensions.borderWidth,
                  ),
          ),
          child: Row(
            mainAxisSize:
                widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: fg, size: 18),
                  child: widget.icon!,
                ),
                const SizedBox(width: NomoDimensions.spacing8),
              ],
              Text(
                widget.label,
                style: NomoTypography.label.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
