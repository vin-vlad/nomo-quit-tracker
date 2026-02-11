import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

/// Clean app bar with subtle bottom separator and a standard back arrow.
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
            color: theme.dividerColor,
            width: NomoDimensions.dividerWidth,
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
                    padding: const EdgeInsets.only(
                        right: NomoDimensions.spacing12),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: NomoTypography.title.copyWith(
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
