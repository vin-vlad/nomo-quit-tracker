import 'package:flutter/material.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/theme/nomo_typography.dart';

/// A tab item definition with standard Material icons.
class BauhausTabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const BauhausTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

/// Predefined tab items for the main navigation.
class BauhausTabs {
  BauhausTabs._();

  static const home = BauhausTabItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  );
  static const achievements = BauhausTabItem(
    label: 'Awards',
    icon: Icons.emoji_events_outlined,
    activeIcon: Icons.emoji_events_rounded,
  );
  static const settings = BauhausTabItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
  );

  static const List<BauhausTabItem> all = [
    achievements,
    home,
    settings,
  ];
}

/// Bottom tab bar with clean Apple-style icons and labels.
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
            color: theme.dividerColor,
            width: NomoDimensions.dividerWidth,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
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
                      Icon(
                        isActive ? tab.activeIcon : tab.icon,
                        size: 24,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: NomoTypography.caption.copyWith(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 10,
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
