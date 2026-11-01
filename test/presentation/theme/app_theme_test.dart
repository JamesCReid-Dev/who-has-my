import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/presentation/theme/app_theme.dart';

void main() {
  group('AppTheme — STORY-004 Acceptance Criteria', () {
    
    // ─── AC1: Material 3 theme configured with WhoHasMy custom color tokens ──
    
    test('AC1: should have correct primary blue color (#1565C0)', () {
      expect(AppTheme.primaryBlue, equals(const Color(0xFF1565C0)));
    });

    test('AC1: should have correct secondary amber color (#FFA726)', () {
      expect(AppTheme.secondaryAmber, equals(const Color(0xFFFFA726)));
    });

    test('AC1: light theme should use Material 3 with primary seed', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.light));
      // Seed color generates the full palette - verify key colors derived from it
      expect(theme.colorScheme.primary, equals(AppTheme.primaryBlue));
    });

    test('AC1: dark theme should use Material 3 with primary seed', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.dark));
      // Seed color generates the full palette - verify key colors derived from it
      expect(theme.colorScheme.primary, equals(AppTheme.primaryLight));
    });

    test('AC1: light theme should have custom color scheme extensions', () {
      final theme = AppTheme.lightTheme;
      expect(theme.colorScheme.primary, equals(AppTheme.primaryBlue));
      expect(theme.colorScheme.secondary, equals(AppTheme.secondaryAmber));
      expect(theme.colorScheme.surface, equals(AppTheme.surfaceLight));
    });

    test('AC1: dark theme should have custom color scheme extensions', () {
      final theme = AppTheme.darkTheme;
      expect(theme.colorScheme.primary, equals(AppTheme.primaryLight));
      expect(theme.colorScheme.secondary, equals(AppTheme.secondaryAmber));
      expect(theme.colorScheme.surface, equals(AppTheme.surfaceDark));
    });

    // ─── AC2: Risk semantic colors mapped correctly ──────────────────────

    test('AC2: should have correct risk green color (#43A047)', () {
      expect(AppTheme.riskNone, equals(const Color(0xFF43A047)));
    });

    test('AC2: should have correct risk amber color (#FB8C00)', () {
      expect(AppTheme.riskLow, equals(const Color(0xFFFB8C00)));
    });

    test('AC2: should have correct risk orange-red color (#FF7043)', () {
      expect(AppTheme.riskMedium, equals(const Color(0xFFFF7043)));
    });

    test('AC2: should have correct risk red color (#E53935)', () {
      expect(AppTheme.riskHigh, equals(const Color(0xFFE53935)));
    });

    test('AC2: getRiskColor returns green for on-time items', () {
      expect(AppTheme.getRiskColor(0), equals(AppTheme.riskNone));
      expect(AppTheme.getRiskColor(-1), equals(AppTheme.riskNone));
    });

    test('AC2: getRiskColor returns amber for 1-4 days overdue', () {
      expect(AppTheme.getRiskColor(1), equals(AppTheme.riskLow));
      expect(AppTheme.getRiskColor(2), equals(AppTheme.riskLow));
      expect(AppTheme.getRiskColor(3), equals(AppTheme.riskLow));
      expect(AppTheme.getRiskColor(4), equals(AppTheme.riskLow));
    });

    test('AC2: getRiskColor returns orange-red for 5 days overdue', () {
      expect(AppTheme.getRiskColor(5), equals(AppTheme.riskMedium));
    });

    test('AC2: getRiskColor returns red for >5 days overdue', () {
      expect(AppTheme.getRiskColor(6), equals(AppTheme.riskHigh));
      expect(AppTheme.getRiskColor(10), equals(AppTheme.riskHigh));
    });

    // ─── AC3: Typography scale implemented (Inter font, 7 sizes) ──────────

    test('AC3: displayLarge should be 57px Inter', () {
      final style = AppTheme.displayLarge;
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(57));
      expect(style.fontWeight, equals(FontWeight.w400));
    });

    test('AC3: headlineMedium should be 24px Inter semi-bold', () {
      final style = AppTheme.headlineMedium;
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(24));
      expect(style.fontWeight, equals(FontWeight.w600));
    });

    test('AC3: bodyLarge should be 16px Inter', () {
      final style = AppTheme.bodyLarge;
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(16));
    });

    test('AC3: labelLarge should be 14px Inter medium', () {
      final style = AppTheme.labelLarge;
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(14));
      expect(style.fontWeight, equals(FontWeight.w500));
    });

    test('AC3: light theme text should use Inter font family', () {
      final textTheme = AppTheme.lightTheme.textTheme;
      expect(textTheme.displayLarge!.fontFamily, equals('Inter'));
      expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
      expect(textTheme.labelLarge!.fontFamily, equals('Inter'));
    });

    // ─── AC4: Spacing tokens applied (xs=4px through xl=32px) ─────────────

    test('AC4: spacingXs should be 4.0', () {
      expect(AppTheme.spacingXs, equals(4.0));
    });

    test('AC4: spacingSm should be 8.0', () {
      expect(AppTheme.spacingSm, equals(8.0));
    });

    test('AC4: spacingMd should be 12.0', () {
      expect(AppTheme.spacingMd, equals(12.0));
    });

    test('AC4: spacingLg should be 16.0', () {
      expect(AppTheme.spacingLg, equals(16.0));
    });

    test('AC4: spacingXl should be 24.0', () {
      expect(AppTheme.spacingXl, equals(24.0));
    });

    test('AC4: spacingXXl should be 32.0', () {
      expect(AppTheme.spacingXXl, equals(32.0));
    });

    test('AC4: getSpacing returns correct values for all tokens', () {
      expect(AppTheme.getSpacing('xs'), equals(4.0));
      expect(AppTheme.getSpacing('sm'), equals(8.0));
      expect(AppTheme.getSpacing('md'), equals(12.0));
      expect(AppTheme.getSpacing('lg'), equals(16.0));
      expect(AppTheme.getSpacing('xl'), equals(24.0));
      expect(AppTheme.getSpacing('xxl'), equals(32.0));
    });

    // ─── AC5: Dark mode support via Material 3 dynamic color scheme ──────

    test('AC5: dark theme should have light text colors', () {
      final theme = AppTheme.darkTheme;
      expect(theme.textTheme.bodyLarge!.color, equals(AppTheme.onSurfaceDark));
      expect(theme.textTheme.labelLarge!.color, equals(AppTheme.onSurfaceDark));
    });

    test('AC5: dark theme should have dark surface color', () {
      final theme = AppTheme.darkTheme;
      expect(theme.colorScheme.surface, equals(AppTheme.surfaceDark));
    });

    test('AC5: light theme should have light text colors', () {
      final theme = AppTheme.lightTheme;
      expect(theme.textTheme.bodyLarge!.color, equals(AppTheme.onSurfaceLight));
    });

    // ─── AC6/7/8: Theme renders correctly in MaterialApp ──────────────────

    testWidgets('AC6-8: MaterialApp should render with WhoHasMy theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SizedBox(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('AC6-8: light theme renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              expect(theme.useMaterial3, isTrue);
              expect(theme.colorScheme.primary, equals(AppTheme.primaryBlue));
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('AC6-8: dark theme renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              expect(theme.useMaterial3, isTrue);
              expect(theme.brightness, equals(Brightness.dark));
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    // ─── Additional Component Theme Tests ────────────────────────────────

    test('AC1: FAB should use secondary amber color', () {
      final theme = AppTheme.lightTheme;
      expect(theme.floatingActionButtonTheme.backgroundColor, equals(AppTheme.secondaryAmber));
    });

    test('AC1: elevated buttons should use primary blue', () {
      final theme = AppTheme.lightTheme;
      expect(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}), equals(AppTheme.primaryBlue));
    });

    test('AC4: input decoration should have proper styling', () {
      final theme = AppTheme.lightTheme;
      final inputTheme = theme.inputDecorationTheme;
      expect(inputTheme.filled, isTrue);
      expect(inputTheme.border, isNotNull);
    });
  });
}
