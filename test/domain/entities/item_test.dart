import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/domain/entities/item.dart';

void main() {
  group('Item Entity', () {
    test('should create Item with required fields only', () {
      final item = Item(
        id: 'item-1',
        name: 'Test Item',
        category: 'Tools',
        createdAt: DateTime.now(),
      );

      expect(item.id, equals('item-1'));
      expect(item.name, equals('Test Item'));
      expect(item.category, equals('Tools'));
      expect(item.description, isNull);
      expect(item.status, equals(ItemStatus.available));
      expect(item.updatedAt, isNull);
    });

    test('should create Item with all fields', () {
      final now = DateTime.now();
      final item = Item(
        id: 'item-2',
        name: 'Drill',
        description: 'Power drill for borrowing',
        category: 'Tools',
        status: ItemStatus.loaned,
        createdAt: now,
        updatedAt: now,
      );

      expect(item.id, equals('item-2'));
      expect(item.name, equals('Drill'));
      expect(item.description, equals('Power drill for borrowing'));
      expect(item.category, equals('Tools'));
      expect(item.status, equals(ItemStatus.loaned));
    });

    test('copyWith should create new instance with updated values', () {
      final item = Item(
        id: 'item-3',
        name: 'Original Name',
        category: 'Books',
        createdAt: DateTime.now(),
      );

      final updatedItem = item.copyWith(
        name: 'Updated Name',
        status: ItemStatus.inMaintenance,
      );

      expect(updatedItem.id, equals(item.id)); // ID unchanged
      expect(updatedItem.name, equals('Updated Name'));
      expect(updatedItem.category, equals(item.category)); // Category unchanged
      expect(updatedItem.status, equals(ItemStatus.inMaintenance));
    });

    test('copyWith with no arguments should return equivalent item', () {
      final item = Item(
        id: 'item-4',
        name: 'Test',
        category: 'Other',
        createdAt: DateTime.now(),
      );

      final copiedItem = item.copyWith();

      expect(copiedItem, equals(item));
    });

    test('equality should compare by ID', () {
      final item1 = Item(
        id: 'item-5',
        name: 'Same ID',
        category: 'Test',
        createdAt: DateTime.now(),
      );
      final item2 = Item(
        id: 'item-5',
        name: 'Different Name',
        category: 'Different',
        createdAt: DateTime.now(),
      );

      expect(item1, equals(item2));
    });

    test('inequality should return false for different IDs', () {
      final item1 = Item(
        id: 'item-6a',
        name: 'Item A',
        category: 'Test',
        createdAt: DateTime.now(),
      );
      final item2 = Item(
        id: 'item-6b',
        name: 'Item A',
        category: 'Test',
        createdAt: DateTime.now(),
      );

      expect(item1, isNot(equals(item2)));
    });

    test('hashCode should be consistent with equality', () {
      final item1 = Item(
        id: 'item-7',
        name: 'Test',
        category: 'Test',
        createdAt: DateTime.now(),
      );
      final item2 = Item(
        id: 'item-7',
        name: 'Different',
        category: 'Different',
        createdAt: DateTime.now(),
      );

      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('ItemStatus enum should have all expected values', () {
      expect(ItemStatus.values.length, equals(3));
      expect(ItemStatus.values, containsAll([
        ItemStatus.available,
        ItemStatus.loaned,
        ItemStatus.inMaintenance,
      ]));
    });

    test('default status should be available', () {
      final item = Item(
        id: 'item-8',
        name: 'Test',
        category: 'Test',
        createdAt: DateTime.now(),
      );

      expect(item.status, equals(ItemStatus.available));
    });
  });
}
