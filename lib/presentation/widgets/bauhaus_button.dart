import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

enum BauhausButtonVariant { filled, outlined }

/// A Bauhaus-styled button: sharp corners, bold border, uppercase label.
/// On press the colors invert for instant tactile feedback.
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
    final borderColor = theme.colorScheme.onSurface;

    final isFilled = widget.variant == BauhausButtonVariant.filled;

    // Invert on press
    final bg = _pressed
        ? (isFilled ? Colors.white : baseColor)
        : (isFilled ? baseColor : Colors.transparent);
    final fg = _pressed
        ? (isFilled ? baseColor : Colors.white)
        : (isFilled ? Colors.white : baseColor);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: NomoDimensions.spacing24,
          vertical: NomoDimensions.spacing16,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: isFilled ? borderColor : baseColor,
            width: NomoDimensions.borderWidth,
          ),
          borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
        ),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
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
              widget.label.toUpperCase(),
              style: NomoTypography.label.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}
