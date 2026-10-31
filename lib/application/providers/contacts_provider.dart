/// Contacts provider using Riverpod.
/// 
/// Provides the list of contacts/borrowers with search support.
/// Uses [AsyncNotifierProvider] with autoDispose for automatic lifecycle management.
/// 
/// State update flow: User Action → Widget → Notifier → UseCase → Repository → Hive → UI

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/application/state/contacts_state.dart';
import 'package:whohasmy/domain/entities/contact.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// Provider for contacts state with autoDispose.
final contactsStateProvider = AsyncNotifierProvider<ContactsNotifier, ContactsState>(
  () => ContactsNotifier(),
);

/// Contacts notifier that manages the contact list.
class ContactsNotifier extends AsyncNotifier<ContactsState> {
  ContactsNotifier();

  /// Resolves the ContactRepository from the ref.
  ContactRepository get _repository => ref.read(contactRepositoryProvider);

  @override
  Future<ContactsState> build() {
    return Future.value(const ContactsState(contacts: [], loading: true));
  }

  /// Refreshes contacts data from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final contacts = await _repository.getAll();
      state = AsyncData(ContactsState(
        contacts: contacts,
        loading: false,
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Updates the search query and returns updated state.
  ContactsState updateSearch(String query) {
    final currentState = state.value ?? const ContactsState(contacts: []);
    return currentState.copyWith(searchQuery: query);
  }
}

/// Provider for the ContactRepository dependency injection.
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  throw UnimplementedError('ContactRepository not initialized. Call HiveStorage.initialize() first.');
});