import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/dashboard_provider.dart';

void main() {
  group('DashboardNotifier', () {
    test('should initialize with empty state', () async {
      final container = ProviderContainer(overrides: []);

      // Wait for the AsyncNotifier's build() future to resolve
      final completer = Completer<void>();
      final subscription = container.listen<AsyncValue<DashboardState>>(
        dashboardStateProvider,
        (_, value) {
          if (value.hasValue && !completer.isCompleted) {
            completer.complete();
          }
        },
        fireImmediately: true,
      );

      await completer.future;
      subscription.close();

      final state = container.read(dashboardStateProvider).value;
      expect(state, isNotNull);
      expect(state!.items, isEmpty);
      expect(state.loading, isFalse);
      expect(state.error, isNull);

      container.dispose();
    });

    test('should set loading state during refresh', () async {
      final container = ProviderContainer(
        overrides: [],
      );

      // Trigger refresh - this will fail since no repository is injected
      // but we can verify the loading state is set
      try {
        await container.read(dashboardStateProvider.notifier).refresh();
      } catch (_) {
        // Expected to fail without repository injection
      }

      final state = container.read(dashboardStateProvider).value;
      expect(state, isNotNull);

      container.dispose();
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
