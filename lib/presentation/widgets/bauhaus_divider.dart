import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';

/// Thick Bauhaus-styled horizontal rule.
class BauhausDivider extends StatelessWidget {
  final Color? color;

  const BauhausDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: NomoDimensions.dividerWidth,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }
}
