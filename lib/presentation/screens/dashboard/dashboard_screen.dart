import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/nomo_dimensions.dart';
import '../../../core/theme/nomo_typography.dart';
import '../../providers/database_provider.dart';
import '../../providers/tracker_providers.dart';
import '../../providers/purchase_providers.dart';
import '../add_tracker/add_tracker_screen.dart';
import '../craving/log_craving_sheet.dart';
import '../tracker_detail/tracker_detail_screen.dart';
import 'widgets/tracker_card_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackersAsync = ref.watch(activeTrackersProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
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
                  Text(
                    AppConstants.appName,
                    style: NomoTypography.title.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: trackersAsync.when(
        data: (trackers) {
          if (trackers.isEmpty) {
            return _buildEmptyState(context, theme);
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(NomoDimensions.spacing16),
            itemCount: trackers.length,
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (ctx, c) => Material(
                  color: Colors.transparent,
                  elevation: 4.0 * animation.value,
                  child: c,
                ),
                child: child,
              );
            },
            onReorder: (oldIndex, newIndex) {
              _handleReorder(ref, trackers, oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final tracker = trackers[index];
              return Padding(
                key: ValueKey(tracker.id),
                padding: EdgeInsets.only(
                  bottom: index < trackers.length - 1
                      ? NomoDimensions.spacing16
                      : 0,
                ),
                child: OpenContainer(
                  closedElevation: 0,
                  openElevation: 0,
                  closedColor: Colors.transparent,
                  openColor: theme.scaffoldBackgroundColor,
                  transitionDuration: const Duration(milliseconds: 500),
                  closedShape: const RoundedRectangleBorder(),
                  tappable: false,
                  closedBuilder: (closedCtx, openContainer) {
                    return TrackerCardWidget(
                      tracker: tracker,
                      onTap: openContainer,
                      onLogCraving: () =>
                          _showCravingSheet(context, ref, tracker.id),
                    );
                  },
                  openBuilder: (openCtx, _) {
                    return TrackerDetailScreen(trackerId: tracker.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error loading trackers: $e'),
        ),
      ),
      floatingActionButton: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedColor: Colors.transparent,
        openColor: theme.scaffoldBackgroundColor,
        transitionDuration: const Duration(milliseconds: 500),
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        tappable: false,
        closedBuilder: (closedCtx, openContainer) {
          return GestureDetector(
            onTap: () => _addTracker(closedCtx, ref, openContainer),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
        openBuilder: (openCtx, _) {
          return const AddTrackerScreen();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NomoDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(NomoDimensions.borderRadius),
                border: Border.all(
                  color: theme.dividerColor,
                  width: NomoDimensions.borderWidth,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 40,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing24),
            Text(
              'No trackers yet',
              style: NomoTypography.title.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: NomoDimensions.spacing8),
            Text(
              'Tap + to start tracking your first quit.',
              style: NomoTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTracker(
    BuildContext context,
    WidgetRef ref,
    VoidCallback openContainer,
  ) async {
    final isPremium = ref.read(isPremiumSyncProvider);
    final count = await ref.read(trackerRepositoryProvider).countActive();

    if (!isPremium && count >= AppConstants.freeTrackerLimit) {
      if (context.mounted) context.push('/paywall');
      return;
    }

    openContainer();
  }

  void _showCravingSheet(
      BuildContext context, WidgetRef ref, String trackerId) {
    final isPremium = ref.read(isPremiumSyncProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => LogCravingSheet(
        trackerId: trackerId,
        isPremium: isPremium,
      ),
    );
  }

  void _handleReorder(
    WidgetRef ref,
    List<dynamic> trackers,
    int oldIndex,
    int newIndex,
  ) {
    if (oldIndex < newIndex) newIndex -= 1;

    // Build new order map
    final items = List.from(trackers);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    final orders = <String, int>{};
    for (var i = 0; i < items.length; i++) {
      orders[items[i].id] = i;
    }

    ref.read(trackerRepositoryProvider).updateSortOrders(orders);
  }
}
