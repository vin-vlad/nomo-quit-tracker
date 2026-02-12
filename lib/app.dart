import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/theme_providers.dart';
import 'presentation/widgets/deep_link_handler.dart';
import 'presentation/widgets/widget_sync_listener.dart';

class NomoApp extends ConsumerWidget {
  const NomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeMode = ref.watch(brightnessModeProvider);
    final router = ref.watch(appRouterProvider);

    return WidgetSyncListener(
      child: DeepLinkHandler(
        child: MaterialApp.router(
        title: 'Nomo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        routerConfig: router,
        ),
      ),
    );
  }
}
