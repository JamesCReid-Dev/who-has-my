/// Items catalog state definitions using Freezed for immutability.
/// 
/// Contains [ItemsCatalogState] for managing the full list of registered items.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whohasmy/domain/entities/item.dart';

part 'items_catalog_state.freezed.dart';

/// State for the items catalog view with filtering and sorting support.
@freezed
class ItemsCatalogState with _$ItemsCatalogState {
  const factory ItemsCatalogState({
    required List<Item> items,
    @Default(false) bool loading,
    String? error,
    @Default('') String searchQuery,
    @Default(ItemStatus.available) ItemStatus? filterByStatus,
  }) = _ItemsCatalogState;

  const ItemsCatalogState._();

  /// Returns filtered and searched items based on current state.
  List<Item> get displayedItems {
    var result = items;

    // Apply status filter if set
    if (filterByStatus != null) {
      result = result.where((item) => item.status == filterByStatus).toList();
    }

    // Apply search query filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((item) =>
          item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          (item.description?.toLowerCase().contains(query) ?? false)).toList();
    }

    return result;
  }

  /// Returns true if the catalog is in an error state.
  bool get hasError => error != null;

  /// Returns true if there are no items matching current filters.
  bool get isEmpty => displayedItems.isEmpty && !loading;
}