import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Geometric confetti celebration overlay for milestones.
/// Shows circles, squares, and triangles falling in palette colors.
class CelebrationOverlay extends StatefulWidget {
  final VoidCallback? onComplete;

  const CelebrationOverlay({super.key, this.onComplete});

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Confetti> _confettiPieces;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    _confettiPieces = List.generate(40, (_) => _generateConfetti());
    HapticFeedback.heavyImpact();
    _controller.forward();
  }

  _Confetti _generateConfetti() {
    return _Confetti(
      x: _random.nextDouble(),
      startY: -0.1 - _random.nextDouble() * 0.3,
      endY: 1.1 + _random.nextDouble() * 0.2,
      size: 6 + _random.nextDouble() * 12,
      shape: _ConfettiShape.values[_random.nextInt(3)],
      colorIndex: _random.nextInt(3),
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 4,
      horizontalDrift: (_random.nextDouble() - 0.5) * 0.15,
      delay: _random.nextDouble() * 0.3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ConfettiPainter(
            confetti: _confettiPieces,
            colors: colors,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

enum _ConfettiShape { circle, square, triangle }

class _Confetti {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final _ConfettiShape shape;
  final int colorIndex;
  final double rotation;
  final double rotationSpeed;
  final double horizontalDrift;
  final double delay;

  _Confetti({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.shape,
    required this.colorIndex,
    required this.rotation,
    required this.rotationSpeed,
    required this.horizontalDrift,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetti> confetti;
  final List<Color> colors;
  final double progress;

  _ConfettiPainter({
    required this.confetti,
    required this.colors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in confetti) {
      final adjustedProgress = ((progress - c.delay) / (1 - c.delay)).clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      final opacity = adjustedProgress < 0.8 ? 1.0 : (1.0 - adjustedProgress) / 0.2;
      final paint = Paint()
        ..color = colors[c.colorIndex % colors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final x = (c.x + c.horizontalDrift * adjustedProgress) * size.width;
      final y = (c.startY + (c.endY - c.startY) * adjustedProgress) * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(c.rotation + c.rotationSpeed * adjustedProgress * pi);

      switch (c.shape) {
        case _ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, c.size / 2, paint);
        case _ConfettiShape.square:
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size),
            paint,
          );
        case _ConfettiShape.triangle:
          final path = Path()
            ..moveTo(0, -c.size / 2)
            ..lineTo(c.size / 2, c.size / 2)
            ..lineTo(-c.size / 2, c.size / 2)
            ..close();
          canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
