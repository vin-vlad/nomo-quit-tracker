import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';

/// Circular progress ring with rounded caps and smooth appearance.
class BauhausProgressRing extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final double size;
  final Color? activeColor;
  final Color? trackColor;
  final Widget? child;

  const BauhausProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.activeColor,
    this.trackColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final track =
        trackColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              activeColor: active,
              trackColor: track,
              strokeWidth: NomoDimensions.progressRingStroke,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // start from top
        2 * pi * progress,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.activeColor != activeColor ||
      old.trackColor != trackColor;
}
