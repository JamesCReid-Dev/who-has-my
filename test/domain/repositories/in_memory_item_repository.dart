import 'dart:async';

import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// In-memory implementation of ItemRepository for unit testing.
class InMemoryItemRepository implements ItemRepository {
  final Map<String, Item> _items = {};
  final StreamController<List<Item>> _controller = StreamController.broadcast();

  @override
  Future<Item> getById(String id) async {
    final item = _items[id];
    if (item == null) throw Exception('Item not found: $id');
    return item;
  }

  @override
  Future<List<Item>> getAll() async {
    return _items.values.toList();
  }

  @override
  Stream<List<Item>> watchAll() {
    return _controller.stream.map((_) => _items.values.toList());
  }

  @override
  Future<String> insert(Item item) async {
    _items[item.id] = item;
    _controller.add(_items.values.toList());
    return item.id;
  }

  @override
  Future<void> update(Item item) async {
    if (!_items.containsKey(item.id)) {
      throw Exception('Item not found: ${item.id}');
    }
    _items[item.id] = item;
    _controller.add(_items.values.toList());
  }

  @override
  Future<void> delete(String id) async {
    if (!_items.containsKey(id)) {
      throw Exception('Item not found: $id');
    }
    _items.remove(id);
    _controller.add(_items.values.toList());
  }

  void clear() {
    _items.clear();
    _controller.add(_items.values.toList());
  }
}
