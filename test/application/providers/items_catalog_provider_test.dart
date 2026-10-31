import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/items_catalog_provider.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

class MockItemRepository implements ItemRepository {
  final List<Item> _items = [];
  bool throwError = false;

  @override
  Future<Item> getById(String id) async {
    if (throwError) throw Exception('Mock error');
    return _items.firstWhere((item) => item.id == id);
  }

  @override
  Future<List<Item>> getAll() async {
    if (throwError) throw Exception('Mock error');
    return List.from(_items);
  }

  @override
  Stream<List<Item>> watchAll() => throw UnimplementedError();

  @override
  Future<String> insert(Item item) async { _items.add(item); return item.id; }

  @override
  Future<void> update(Item item) async {}

  @override
  Future<void> delete(String id) async {}

  void addItem(Item item) => _items.add(item);
}

void main() {
  late MockItemRepository mockRepo;

  setUp(() => mockRepo = MockItemRepository());

  group('ItemsCatalogNotifier', () {
    test('should initialize with loading state', () async {
      final container = ProviderContainer(overrides: [itemRepositoryProvider.overrideWithValue(mockRepo)]);
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(itemsCatalogStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isTrue);
      container.dispose();
    });

    test('should load items from repository on refresh', () async {
      mockRepo.addItem(Item(id: '1', name: 'Drill', category: 'Tools', status: ItemStatus.available, createdAt: DateTime.now()));
      final container = ProviderContainer(overrides: [itemRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(itemsCatalogStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(itemsCatalogStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isFalse);
      expect(state.items, hasLength(1));
      container.dispose();
    });

    test('should filter items by status', () async {
      mockRepo.addItem(Item(id: '1', name: 'Drill', category: 'Tools', status: ItemStatus.available, createdAt: DateTime.now()));
      mockRepo.addItem(Item(id: '2', name: 'Laptop', category: 'Electronics', status: ItemStatus.loaned, createdAt: DateTime.now()));
      final container = ProviderContainer(overrides: [itemRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(itemsCatalogStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final filteredState = container.read(itemsCatalogStateProvider.notifier).updateFilter(ItemStatus.loaned);
      expect(filteredState.displayedItems, hasLength(1));
      expect(filteredState.displayedItems[0].status, equals(ItemStatus.loaned));
      container.dispose();
    });

    test('should filter items by search query', () async {
      mockRepo.addItem(Item(id: '1', name: 'Power Drill', category: 'Tools', status: ItemStatus.available, createdAt: DateTime.now()));
      final container = ProviderContainer(overrides: [itemRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(itemsCatalogStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final searchedState = container.read(itemsCatalogStateProvider.notifier).updateSearch('Power');
      expect(searchedState.displayedItems, hasLength(1));
      expect(searchedState.displayedItems[0].name, equals('Power Drill'));
      container.dispose();
    });

    test('should handle error during refresh', () async {
      mockRepo.throwError = true;
      final container = ProviderContainer(overrides: [itemRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(itemsCatalogStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final asyncValue = container.read(itemsCatalogStateProvider);
      expect(asyncValue, isA<AsyncError>());
      container.dispose();
    });
  });
}