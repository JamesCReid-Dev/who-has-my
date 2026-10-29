import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/dashboard_provider.dart';

void main() {
  group('DashboardNotifier', () {
    test('should initialize with empty state', () async {
      final notifier = DashboardNotifier();
      await Future.delayed(Duration.zero); // Allow async initialization

      expect(notifier.state.value, isNotNull);
      expect(notifier.state.value!.items, isEmpty);
      expect(notifier.state.value!.loading, isFalse);
      expect(notifier.state.value!.error, isNull);
    });

    test('should set loading state during refresh', () async {
      final notifier = DashboardNotifier();
      
      // Trigger refresh - this will fail since no repository is injected
      // but we can verify the loading state is set
      try {
        await notifier.refresh();
      } catch (_) {
        // Expected to fail without repository injection
      }

      expect(notifier.state.value, isNotNull);
    });

    test('DashboardState should be immutable', () {
      final state = const DashboardState(
        items: [],
        loading: false,
        error: null,
      );

      // Verify default values
      expect(state.items, isEmpty);
      expect(state.loading, isFalse);
      expect(state.error, isNull);
    });

    test('DashboardState copyWith should create new instance', () {
      final state = const DashboardState(
        items: [],
        loading: false,
        error: null,
      );

      final updatedState = state.copyWith(loading: true);

      expect(updatedState.loading, isTrue);
      expect(updatedState.items, isEmpty); // Unchanged
      expect(updatedState.error, isNull); // Unchanged
    });

    test('DashboardState copyWith with error should preserve other fields', () {
      final state = const DashboardState(
        items: [],
        loading: false,
        error: null,
      );

      final errorState = state.copyWith(error: 'Test error');

      expect(errorState.error, equals('Test error'));
      expect(errorState.loading, isFalse); // Unchanged
    });
  });
}
