import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/presentation/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('should have correct primary blue color', () {
      expect(AppTheme.primaryBlue, equals(const Color(0xFF1565C0)));
    });

    test('should have correct secondary amber color', () {
      expect(AppTheme.secondaryAmber, equals(const Color(0xFFFFA726)));
    });

    test('should have correct risk semantic colors', () {
      // Risk green - success/low risk
      expect(AppTheme.riskGreen, equals(const Color(0xFF43A047)));
      
      // Risk amber - approaching due
      expect(AppTheme.riskAmber, equals(const Color(0xFFFB8C00)));
      
      // Risk orange-red - medium/high risk
      expect(AppTheme.riskOrangeRed, equals(const Color(0xFFFF7043)));
      
      // Risk red - high/urgent risk
      expect(AppTheme.riskRed, equals(const Color(0xFFE53935)));
    });

    test('should have correct spacing tokens', () {
      expect(AppTheme.spacingXs, equals(4.0));
      expect(AppTheme.spacingSm, equals(8.0));
      expect(AppTheme.spacingMd, equals(12.0));
      expect(AppTheme.spacingLg, equals(16.0));
      expect(AppTheme.spacingXl, equals(24.0));
      expect(AppTheme.spacingXXl, equals(32.0));
    });

    test('light theme should use Material 3', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.light));
    });

    test('dark theme should use Material 3', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.dark));
    });

    test('light theme text colors should be dark on light background', () {
      final theme = AppTheme.lightTheme;
      final textTheme = theme.textTheme;
      
      // Body large should have default (dark) color in light theme
      expect(textTheme.bodyLarge!.color, isNull); // Uses theme default
    });

    test('dark theme body text should be white', () {
      final theme = AppTheme.darkTheme;
      final textTheme = theme.textTheme;
      
      expect(textTheme.bodyLarge!.color, equals(Colors.white));
      expect(textTheme.bodyMedium!.color, equals(Colors.white70));
    });

    test('theme should have Inter font family configured', () {
      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;
      
      // Check that typography is configured (font family should be 'Inter')
      expect(lightTheme.textTheme.displayLarge!.fontFamily, equals('Inter'));
      expect(darkTheme.textTheme.displayLarge!.fontFamily, equals('Inter'));
    });

    test('theme should have correct typography sizes', () {
      final textTheme = AppTheme.lightTheme.textTheme;
      
      // Display large - 57px
      expect(textTheme.displayLarge!.fontSize, equals(57));
      
      // Headline medium - 24px with semi-bold
      expect(textTheme.headlineMedium!.fontSize, equals(24));
      expect(textTheme.headlineMedium!.fontWeight, equals(FontWeight.w600));
      
      // Body large - 16px
      expect(textTheme.bodyLarge!.fontSize, equals(16));
      
      // Label large - 14px with medium weight
      expect(textTheme.labelLarge!.fontSize, equals(14));
      expect(textTheme.labelLarge!.fontWeight, equals(FontWeight.w500));
    });

    test('MaterialApp should render with WhoHasMy theme', () {
      final rendered = <Widget>[];
      
      runApp(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              rendered.add(context.findAncestorWidgetOfExactType<MaterialApp>()!);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(rendered.isNotEmpty, isTrue);
    });
  });
}
