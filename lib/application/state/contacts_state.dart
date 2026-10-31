/// Contacts state definitions using Freezed for immutability.
/// 
/// Contains [ContactsState] for managing the list of contacts/borrowers.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whohasmy/domain/entities/contact.dart';

part 'contacts_state.freezed.dart';

/// State for the contacts list view with filtering support.
@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState({
    required List<Contact> contacts,
    @Default(false) bool loading,
    String? error,
    @Default('') String searchQuery,
  }) = _ContactsState;

  const ContactsState._();

  /// Returns filtered and searched contacts based on current state.
  List<Contact> get displayedContacts {
    if (searchQuery.isEmpty) return contacts;

    final query = searchQuery.toLowerCase();
    return contacts.where((contact) =>
        contact.name.toLowerCase().contains(query) ||
        (contact.email?.toLowerCase().contains(query) ?? false)).toList();
  }

  /// Returns true if the contacts view is in an error state.
  bool get hasError => error != null;

  /// Returns true if there are no contacts matching current filters.
  bool get isEmpty => displayedContacts.isEmpty && !loading;
}