/// Dashboard state provider using Riverpod.
/// 
/// Provides risk-ranked active loans for the dashboard view.
/// Uses [AsyncNotifierProvider] with autoDispose for automatic lifecycle management.
/// 
/// State update flow: User Action → Widget → Notifier → UseCase → Repository → Hive → UI

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/application/state/dashboard_state.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// Provider for dashboard state with autoDispose.
final dashboardStateProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  () => DashboardNotifier(),
);

/// Dashboard notifier that fetches and manages dashboard data.
class DashboardNotifier extends AsyncNotifier<DashboardState> {
  DashboardNotifier();

  /// Resolves the ItemRepository from the ref.
  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  @override
  Future<DashboardState> build() {
    // Initial state: loading
    return Future.value(const DashboardState(items: [], loading: true));
  }

  /// Refreshes dashboard data from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getAll();
      final now = DateTime.now();
      
      // Convert items to ItemCardData for display
      final cardData = items.map((item) => ItemCardData.fromItem(item, now: now)).toList();
      
      state = AsyncData(DashboardState(
        items: cardData,
        loading: false,
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Refreshes dashboard data synchronously from the current state.
  Future<void> refreshFromState() async {
    final items = state.value?.items ?? [];
    // Re-process existing items (e.g., after a loan status change)
    state = AsyncData(DashboardState(
      items: items,
      loading: false,
    ));
  }
}

/// Provider for the ItemRepository dependency injection.
/// 
/// This provider allows injecting mock repositories in tests.
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  throw UnimplementedError('ItemRepository not initialized. Call HiveStorage.initialize() first.');
});
