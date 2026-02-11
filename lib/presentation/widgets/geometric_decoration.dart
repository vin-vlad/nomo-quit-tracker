import 'package:flutter/material.dart';

/// Decorative soft gradient circles used as background accents.
/// Replaces sharp Bauhaus shapes with calm, blurred orbs.
class GeometricDecoration extends StatelessWidget {
  final List<_GeoShape> shapes;

  const GeometricDecoration({super.key, required this.shapes});

  /// A preset decoration for the onboarding screen.
  factory GeometricDecoration.onboarding(BuildContext context) {
    final theme = Theme.of(context);
    return GeometricDecoration(
      shapes: [
        _GeoShape(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          size: 250,
          position: const Alignment(-1.3, -0.4),
        ),
        _GeoShape(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.06),
          size: 180,
          position: const Alignment(1.2, -0.7),
        ),
        _GeoShape(
          color: theme.colorScheme.secondary.withValues(alpha: 0.06),
          size: 200,
          position: const Alignment(0.8, 0.7),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: shapes.map((s) => _buildShape(s)).toList(),
      ),
    );
  }

  Widget _buildShape(_GeoShape shape) {
    return Align(
      alignment: shape.position,
      child: Container(
        width: shape.size,
        height: shape.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              shape.color,
              shape.color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeoShape {
  final Color color;
  final double size;
  final Alignment position;

  const _GeoShape({
    required this.color,
    required this.size,
    required this.position,
  });
}
