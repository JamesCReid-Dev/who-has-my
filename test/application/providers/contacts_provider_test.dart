import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/contacts_provider.dart';
import 'package:whohasmy/domain/entities/contact.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

class MockContactRepository implements ContactRepository {
  final List<Contact> _contacts = [];
  bool throwError = false;

  @override
  Future<Contact> getById(String id) async {
    if (throwError) throw Exception('Mock error');
    return _contacts.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<Contact>> getAll() async {
    if (throwError) throw Exception('Mock error');
    return List.from(_contacts);
  }

  @override
  Stream<List<Contact>> watchAll() => throw UnimplementedError();

  @override
  Future<String> insert(Contact contact) async { _contacts.add(contact); return contact.id; }

  @override
  Future<void> update(Contact contact) async {}

  @override
  Future<void> delete(String id) async {}

  void addContact(Contact c) => _contacts.add(c);
}

void main() {
  late MockContactRepository mockRepo;

  setUp(() => mockRepo = MockContactRepository());

  group('ContactsNotifier', () {
    test('should initialize with loading state', () async {
      final container = ProviderContainer(overrides: [contactRepositoryProvider.overrideWithValue(mockRepo)]);
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(contactsStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isTrue);
      container.dispose();
    });

    test('should load contacts from repository on refresh', () async {
      mockRepo.addContact(Contact(id: '1', name: 'Alice', email: 'alice@example.com', createdAt: DateTime.now()));
      mockRepo.addContact(Contact(id: '2', name: 'Bob', email: 'bob@example.com', createdAt: DateTime.now()));
      final container = ProviderContainer(overrides: [contactRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(contactsStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(contactsStateProvider).value;
      expect(state, isNotNull);
      expect(state!.loading, isFalse);
      expect(state.contacts, hasLength(2));
      container.dispose();
    });

    test('should filter contacts by search query', () async {
      mockRepo.addContact(Contact(id: '1', name: 'Alice Smith', email: 'alice@example.com', createdAt: DateTime.now()));
      mockRepo.addContact(Contact(id: '2', name: 'Bob Jones', email: 'bob@example.com', createdAt: DateTime.now()));
      final container = ProviderContainer(overrides: [contactRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(contactsStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final searchedState = container.read(contactsStateProvider.notifier).updateSearch('Alice');
      expect(searchedState.displayedContacts, hasLength(1));
      expect(searchedState.displayedContacts[0].name, equals('Alice Smith'));
      container.dispose();
    });

    test('should handle error during refresh', () async {
      mockRepo.throwError = true;
      final container = ProviderContainer(overrides: [contactRepositoryProvider.overrideWithValue(mockRepo)]);
      await container.read(contactsStateProvider.notifier).refresh();
      await Future.delayed(const Duration(milliseconds: 10));
      final asyncValue = container.read(contactsStateProvider);
      expect(asyncValue, isA<AsyncError>());
      container.dispose();
    });
  });
}