import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';

/// A card with a bold border and a solid offset shadow — the signature
/// Bauhaus/Brutalist elevation technique.
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
    final border = borderColor ?? theme.colorScheme.onSurface;
    final shadow = shadowColor ?? border;
    final bg = backgroundColor ?? theme.colorScheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Shadow block (offset behind the card)
          Positioned(
            left: NomoDimensions.shadowOffsetX,
            top: NomoDimensions.shadowOffsetY,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: shadow,
                borderRadius:
                    BorderRadius.circular(NomoDimensions.borderRadius),
              ),
            ),
          ),
          // Foreground card
          Container(
            margin: const EdgeInsets.only(
              right: NomoDimensions.shadowOffsetX,
              bottom: NomoDimensions.shadowOffsetY,
            ),
            padding: padding ??
                const EdgeInsets.all(NomoDimensions.cardPadding),
            decoration: BoxDecoration(
              color: bg,
              borderRadius:
                  BorderRadius.circular(NomoDimensions.borderRadius),
              border: Border.all(
                color: border,
                width: NomoDimensions.cardBorderWidth,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
