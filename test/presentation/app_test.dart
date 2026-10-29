import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/presentation/app.dart';
import 'package:whohasmy/presentation/navigation/app_router.dart';

void main() {
  group('WhoHasMyApp Widget Tests', () {
    testWidgets('should render WhoHasMyApp without errors', (tester) async {
      await tester.pumpWidget(const WhoHasMyApp());
      
      // Verify the app renders
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display scaffold with content', (tester) async {
      await tester.pumpWidget(const WhoHasMyApp());
      
      // Verify scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppRouter should render placeholder text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AppRouter()));
      
      // The current implementation shows a Center widget with text
      expect(find.text('WhoHasMy - Foundation Scaffold'), findsOneWidget);
    });
  });
}
