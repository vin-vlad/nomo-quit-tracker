import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/insights/tracker_insights_screen.dart';
import '../../presentation/screens/achievements/achievements_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/tracker_detail/tracker_detail_screen.dart';
import '../../presentation/screens/add_tracker/add_tracker_screen.dart';
import '../../presentation/screens/paywall/paywall_screen.dart';
import '../../presentation/widgets/bauhaus_tab_bar.dart';

/// Shell with bottom tab navigation and shared-axis transition on tab switch.
class _ShellScaffold extends StatefulWidget {
  final int currentIndex;
  final Widget child;
  final StatefulNavigationShell navigationShell;

  const _ShellScaffold({
    required this.currentIndex,
    required this.child,
    required this.navigationShell,
  });

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _goingForward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..value = 1.0;
    _buildAnimations();
  }

  void _buildAnimations() {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    final slideBegin =
        _goingForward ? const Offset(0.04, 0) : const Offset(-0.04, 0);
    _slideAnimation =
        Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(curve);
  }

  @override
  void didUpdateWidget(covariant _ShellScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _goingForward = widget.currentIndex > oldWidget.currentIndex;
      _buildAnimations();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
      bottomNavigationBar: BauhausTabBar(
        currentIndex: widget.currentIndex,
        onTap: (index) => widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
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
          // Tab 0: Achievements (Awards)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/achievements',
                builder: (context, state) => const AchievementsScreen(),
              ),
            ],
          ),
          // Tab 1: Dashboard (Home)
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
                    routes: [
                      GoRoute(
                        path: 'insights',
                        builder: (context, state) => TrackerInsightsScreen(
                          trackerId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddTrackerScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Tab 2: Settings
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
