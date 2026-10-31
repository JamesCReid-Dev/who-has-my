import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/dashboard_provider.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';
import 'package:whohasmy/domain/value_objects/risk_level.dart';

/// In-memory mock ItemRepository for testing.
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
  Stream<List<Item>> watchAll() {
    throw UnimplementedError();
  }

  @override
  Future<String> insert(Item item) async {
    _items.add(item);
    return item.id;
  }

  @override
  Future<void> update(Item item) async {}

  @override
  Future<void> delete(String id) async {}

  void addItem(Item item) => _items.add(item);
  void clear() => _items.clear();
}

void main() {
  late MockItemRepository mockRepo;

  setUp(() {
    mockRepo = MockItemRepository();
  });

  group('DashboardNotifier', () {
    test('should initialize with loading state', () async {
      final container = ProviderContainer(
        overrides: [
          itemRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(dashboardStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isTrue);
      expect(state.items, isEmpty);

      container.dispose();
    });

    test('should load items from repository on refresh', () async {
      mockRepo.addItem(Item(
        id: '1',
        name: 'Test Item 1',
        category: 'Tools',
        status: ItemStatus.available,
        createdAt: DateTime.now(),
      ));
      mockRepo.addItem(Item(
        id: '2',
        name: 'Test Item 2',
        category: 'Electronics',
        status: ItemStatus.loaned,
        createdAt: DateTime.now(),
      ));

      final container = ProviderContainer(
        overrides: [
          itemRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      await container.read(dashboardStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(dashboardStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isFalse);
      expect(state.items, hasLength(2));
      expect(state.items[0].name, equals('Test Item 1'));
      expect(state.items[1].name, equals('Test Item 2'));

      container.dispose();
    });

    test('should handle error during refresh', () async {
      mockRepo.throwError = true;

      final container = ProviderContainer(
        overrides: [
          itemRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      await container.read(dashboardStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(dashboardStateProvider);
      expect(state, isA<AsyncError>());

      container.dispose();
    });

    test('DashboardState should be immutable', () {
      const state = DashboardState(items: []);

      expect(state.items, isEmpty);
      expect(state.loading, isFalse);
      expect(state.error, isNull);
      expect(state.hasError, isFalse);
    });

    test('DashboardState activeLoanCount should count non-returned items', () {
      const state = DashboardState(
        items: [
          ItemCardData(id: '1', name: 'Item 1', category: 'Tools', riskLevel: RiskLevel.none, daysOverdue: 0),
          ItemCardData(id: '2', name: 'Item 2', category: 'Electronics', riskLevel: RiskLevel.low, daysOverdue: 2, isReturned: true),
          ItemCardData(id: '3', name: 'Item 3', category: 'Books', riskLevel: RiskLevel.medium, daysOverdue: 5),
        ],
      );

      expect(state.activeLoanCount, equals(2));
    });

    test('DashboardState itemsByRiskLevel should group correctly', () {
      const state = DashboardState(
        items: [
          ItemCardData(id: '1', name: 'Item 1', category: 'Tools', riskLevel: RiskLevel.none, daysOverdue: 0),
          ItemCardData(id: '2', name: 'Item 2', category: 'Electronics', riskLevel: RiskLevel.low, daysOverdue: 2),
          ItemCardData(id: '3', name: 'Item 3', category: 'Books', riskLevel: RiskLevel.high, daysOverdue: 10),
        ],
      );

      final grouped = state.itemsByRiskLevel;
      expect(grouped[RiskLevel.none]!.length, equals(1));
      expect(grouped[RiskLevel.low]!.length, equals(1));
      expect(grouped[RiskLevel.high]!.length, equals(1));
    });

    test('DashboardState hasError should return true when error is set', () {
      const state = DashboardState(items: [], error: 'Something went wrong');

      expect(state.hasError, isTrue);
    });
  });
}
