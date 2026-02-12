import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/router/app_router.dart';
import '../../core/utils/deep_link_utils.dart';

/// Listens to widget deep links and navigates the app accordingly.
class DeepLinkHandler extends ConsumerStatefulWidget {
  const DeepLinkHandler({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends ConsumerState<DeepLinkHandler> {
  StreamSubscription<Uri?>? _widgetSubscription;
  StreamSubscription<Uri?>? _appLinksSubscription;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleInitialLink();
    _widgetSubscription = HomeWidget.widgetClicked.listen(_handleUri);
    _appLinksSubscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  @override
  void dispose() {
    _widgetSubscription?.cancel();
    _appLinksSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialLink() async {
    // Check home_widget first (when launched from widget's HomeWidgetBackgroundIntent)
    var uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (uri == null) {
      // Fallback: app_links for VIEW intents (e.g. when widget uses PendingIntent with Uri)
      uri = await _appLinks.getInitialLink();
    }
    final link = uri;
    if (link != null && mounted) {
      // Defer navigation so GoRouter and shell routes are ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _navigateFromUri(link);
          });
        }
      });
    }
  }

  void _handleUri(Uri? uri) {
    final link = uri;
    if (link != null && mounted) {
      // Brief delay so router is ready when app comes from background
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) _navigateFromUri(link);
      });
    }
  }

  void _navigateFromUri(Uri uri) {
    final result = DeepLinkResult.fromUri(uri);
    if (result == null) return;

    final router = ref.read(appRouterProvider);
    // Use location with query param (extra can be lost with StatefulShellRoute)
    router.go(result.location);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
