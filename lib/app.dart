import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/themes/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'routes/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Busy Items Page',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              final ctx = rootNavigatorKey.currentContext;
              if (ctx == null) return;

              if (Navigator.of(ctx).canPop()) {
                Navigator.of(ctx).pop();
              } else {
                final currentPath = appRouter
                    .routerDelegate.currentConfiguration.uri
                    .toString();
                if (currentPath == '/') {
                  _showExitDialog(ctx);
                } else {
                  appRouter.go('/');
                }
              }
            },
          },
          child: Focus(
            autofocus: true,
            descendantsAreFocusable: true,
            child: child ?? const SizedBox(),
          ),
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit the system?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C5364),
              foregroundColor: Colors.white,
            ),
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
