/// Items catalog provider using Riverpod.
/// 
/// Provides the full list of registered items with filtering and search support.
/// Uses [AsyncNotifierProvider] with autoDispose for automatic lifecycle management.
/// 
/// State update flow: User Action → Widget → Notifier → UseCase → Repository → Hive → UI

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/application/state/items_catalog_state.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// Provider for items catalog state with autoDispose.
final itemsCatalogStateProvider = AsyncNotifierProvider<ItemsCatalogNotifier, ItemsCatalogState>(
  () => ItemsCatalogNotifier(),
);

/// Items catalog notifier that manages the full item list.
class ItemsCatalogNotifier extends AsyncNotifier<ItemsCatalogState> {
  const ItemsCatalogNotifier();

  /// Resolves the ItemRepository from the ref.
  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  @override
  Future<ItemsCatalogState> build() {
    return Future.value(const ItemsCatalogState(items: [], loading: true));
  }

  /// Refreshes items catalog data from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getAll();
      state = AsyncData(ItemsCatalogState(
        items: items,
        loading: false,
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Updates the search query and returns updated state.
  ItemsCatalogState updateSearch(String query) {
    final currentState = state.value ?? const ItemsCatalogState(items: []);
    return currentState.copyWith(searchQuery: query);
  }

  /// Updates the status filter and returns updated state.
  ItemsCatalogState updateFilter(ItemStatus? status) {
    final currentState = state.value ?? const ItemsCatalogState(items: []);
    return currentState.copyWith(filterByStatus: status);
  }
}

/// Provider for the ItemRepository dependency injection (shared with dashboard).
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  throw UnimplementedError('ItemRepository not initialized. Call HiveStorage.initialize() first.');
});