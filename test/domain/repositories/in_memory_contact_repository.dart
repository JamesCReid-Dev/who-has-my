import 'dart:async';

import 'package:whohasmy/domain/entities/contact.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// In-memory implementation of ContactRepository for unit testing.
class InMemoryContactRepository implements ContactRepository {
  final Map<String, Contact> _contacts = {};
  final StreamController<List<Contact>> _controller = StreamController.broadcast();

  @override
  Future<Contact> getById(String id) async {
    final contact = _contacts[id];
    if (contact == null) throw Exception('Contact not found: $id');
    return contact;
  }

  @override
  Future<List<Contact>> getAll() async {
    return _contacts.values.toList();
  }

  @override
  Stream<List<Contact>> watchAll() {
    return _controller.stream.map((_) => _contacts.values.toList());
  }

  @override
  Future<String> insert(Contact contact) async {
    _contacts[contact.id] = contact;
    _controller.add(_contacts.values.toList());
    return contact.id;
  }

  @override
  Future<void> update(Contact contact) async {
    if (!_contacts.containsKey(contact.id)) {
      throw Exception('Contact not found: ${contact.id}');
    }
    _contacts[contact.id] = contact;
    _controller.add(_contacts.values.toList());
  }

  @override
  Future<void> delete(String id) async {
    if (!_contacts.containsKey(id)) {
      throw Exception('Contact not found: $id');
    }
    _contacts.remove(id);
    _controller.add(_contacts.values.toList());
  }

  void clear() {
    _contacts.clear();
    _controller.add(_contacts.values.toList());
  }
}
