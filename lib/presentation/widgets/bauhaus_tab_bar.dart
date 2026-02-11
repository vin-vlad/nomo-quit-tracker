import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

/// A tab item definition.
class BauhausTabItem {
  final String label;
  final _TabShape shape;

  const BauhausTabItem({required this.label, required this.shape});
}

enum _TabShape { circle, square, triangle, gear }

/// Predefined tab items for the main navigation.
class BauhausTabs {
  BauhausTabs._();

  static const home = BauhausTabItem(label: 'Home', shape: _TabShape.circle);
  static const achievements =
      BauhausTabItem(label: 'Awards', shape: _TabShape.triangle);
  static const settings =
      BauhausTabItem(label: 'Settings', shape: _TabShape.gear);

  static const List<BauhausTabItem> all = [
    achievements,
    home,
    settings,
  ];
}

/// Bottom tab bar with geometric icon shapes.
class BauhausTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BauhausTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface,
            width: NomoDimensions.borderWidth,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(BauhausTabs.all.length, (i) {
              final tab = BauhausTabs.all[i];
              final isActive = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ShapeIcon(
                        shape: tab.shape,
                        isActive: isActive,
                        activeColor: theme.colorScheme.primary,
                        inactiveColor:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: NomoTypography.caption.copyWith(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      if (isActive)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 2,
                          width: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ShapeIcon extends StatelessWidget {
  final _TabShape shape;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const _ShapeIcon({
    required this.shape,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(
        painter: _ShapePainter(
          shape: shape,
          color: isActive ? activeColor : inactiveColor,
          filled: isActive,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final _TabShape shape;
  final Color color;
  final bool filled;

  _ShapePainter({
    required this.shape,
    required this.color,
    required this.filled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (shape) {
      case _TabShape.circle:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2 - 1,
          paint,
        );
      case _TabShape.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
            const Radius.circular(4),
          ),
          paint,
        );
      case _TabShape.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 1)
          ..lineTo(size.width - 1, size.height - 1)
          ..lineTo(1, size.height - 1)
          ..close();
        canvas.drawPath(path, paint);
      case _TabShape.gear:
        // Simplified gear: circle with 4 ticks
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 3,
          paint,
        );
        final tickPaint = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        final c = Offset(size.width / 2, size.height / 2);
        final r1 = size.width / 3;
        final r2 = size.width / 2 - 1;
        // Top, bottom, left, right ticks
        canvas.drawLine(Offset(c.dx, c.dy - r1), Offset(c.dx, c.dy - r2), tickPaint);
        canvas.drawLine(Offset(c.dx, c.dy + r1), Offset(c.dx, c.dy + r2), tickPaint);
        canvas.drawLine(Offset(c.dx - r1, c.dy), Offset(c.dx - r2, c.dy), tickPaint);
        canvas.drawLine(Offset(c.dx + r1, c.dy), Offset(c.dx + r2, c.dy), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) =>
      old.shape != shape || old.color != color || old.filled != filled;
}
