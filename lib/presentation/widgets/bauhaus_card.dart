import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';

/// A clean card with a soft blur shadow and rounded corners.
/// No offset block shadow — just gentle elevation.
class BauhausCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? shadowColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const BauhausCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.shadowColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final border = borderColor ?? theme.dividerColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.all(NomoDimensions.cardPadding),
        decoration: BoxDecoration(
          color: bg,
          borderRadius:
              BorderRadius.circular(NomoDimensions.borderRadius),
          border: Border.all(
            color: border,
            width: NomoDimensions.cardBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor ??
                  theme.shadowColor.withValues(alpha: 0.06),
              blurRadius: NomoDimensions.shadowBlur,
              offset: const Offset(
                NomoDimensions.shadowOffsetX,
                NomoDimensions.shadowOffsetY,
              ),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
