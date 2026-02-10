import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/insights/insights_screen.dart';
import '../../presentation/screens/achievements/achievements_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/tracker_detail/tracker_detail_screen.dart';
import '../../presentation/screens/add_tracker/add_tracker_screen.dart';
import '../../presentation/screens/paywall/paywall_screen.dart';
import '../../presentation/widgets/bauhaus_tab_bar.dart';

/// Shell with bottom tab navigation.
class _ShellScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final StatefulNavigationShell navigationShell;

  const _ShellScaffold({
    required this.currentIndex,
    required this.child,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BauhausTabBar(
        currentIndex: currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      // Onboarding (no tabs)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main tab shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ShellScaffold(
            currentIndex: navigationShell.currentIndex,
            navigationShell: navigationShell,
            child: navigationShell,
          );
        },
        branches: [
          // Tab 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'tracker/:id',
                    builder: (context, state) => TrackerDetailScreen(
                      trackerId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddTrackerScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Tab 1: Insights
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
          // Tab 2: Achievements
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/achievements',
                builder: (context, state) => const AchievementsScreen(),
              ),
            ],
          ),
          // Tab 3: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Paywall (modal overlay, outside of tabs)
      GoRoute(
        path: '/paywall',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const PaywallScreen(),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
    ],
  );
});
