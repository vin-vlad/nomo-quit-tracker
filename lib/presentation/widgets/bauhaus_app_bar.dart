import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

/// Custom Bauhaus-styled app bar with geometric back indicator
/// and bold bottom border.
class BauhausAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const BauhausAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface,
            width: NomoDimensions.borderWidth,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NomoDimensions.spacing16,
          ),
          child: Row(
            children: [
              if (showBack && Navigator.of(context).canPop())
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: NomoDimensions.spacing12),
                    child: CustomPaint(
                      size: const Size(20, 20),
                      painter: _TriangleBackPainter(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: NomoTypography.headline.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints a left-pointing triangle as the back indicator.
class _TriangleBackPainter extends CustomPainter {
  final Color color;

  _TriangleBackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
