import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/presentation/navigation/app_router.dart';
import 'package:whohasmy/presentation/theme/app_theme.dart';

/// Root application widget.
/// 
/// Wraps the app in Riverpod ProviderContainer for state management.
class WhoHasMyApp extends StatelessWidget {
  const WhoHasMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhoHasMy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppRouter(),
    );
  }
}
