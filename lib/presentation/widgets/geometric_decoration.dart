import 'package:flutter/material.dart';

/// Decorative geometric shapes used as background accents.
/// Positioned asymmetrically for Bauhaus flair.
class GeometricDecoration extends StatelessWidget {
  final List<_GeoShape> shapes;

  const GeometricDecoration({super.key, required this.shapes});

  /// A preset decoration for the onboarding screen.
  factory GeometricDecoration.onboarding(BuildContext context) {
    final theme = Theme.of(context);
    return GeometricDecoration(
      shapes: [
        _GeoShape(
          type: _ShapeType.circle,
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          size: 200,
          position: const Alignment(-1.2, -0.5),
        ),
        _GeoShape(
          type: _ShapeType.rectangle,
          color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
          size: 100,
          position: const Alignment(1.1, -0.8),
        ),
        _GeoShape(
          type: _ShapeType.triangle,
          color: theme.colorScheme.secondary.withValues(alpha: 0.12),
          size: 150,
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
      child: SizedBox(
        width: shape.size,
        height: shape.size,
        child: CustomPaint(
          painter: _GeoPainter(
            type: shape.type,
            color: shape.color,
          ),
        ),
      ),
    );
  }
}

enum _ShapeType { circle, rectangle, triangle }

class _GeoShape {
  final _ShapeType type;
  final Color color;
  final double size;
  final Alignment position;

  const _GeoShape({
    required this.type,
    required this.color,
    required this.size,
    required this.position,
  });
}

class _GeoPainter extends CustomPainter {
  final _ShapeType type;
  final Color color;

  _GeoPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case _ShapeType.circle:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
      case _ShapeType.rectangle:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
      case _ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
