import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to WhoHasMy'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
