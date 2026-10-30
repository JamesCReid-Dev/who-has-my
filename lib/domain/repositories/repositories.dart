/// Repository interfaces (ports) for domain layer.
/// 
/// Abstract classes defining contracts for data access.
/// Implementations live in infrastructure layer.

import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/entities/contact.dart';
import 'package:whohasmy/domain/entities/loan.dart';

/// Repository interface for Item operations.
abstract class ItemRepository {
  Future<Item> getById(String id);
  Future<List<Item>> getAll();
  Stream<List<Item>> watchAll();
  Future<String> insert(Item item);
  Future<void> update(Item item);
  Future<void> delete(String id);
}

/// Repository interface for Contact operations.
abstract class ContactRepository {
  Future<Contact> getById(String id);
  Future<List<Contact>> getAll();
  Stream<List<Contact>> watchAll();
  Future<String> insert(Contact contact);
  Future<void> update(Contact contact);
  Future<void> delete(String id);
}

/// Repository interface for Loan operations.
abstract class LoanRepository {
  Future<Loan> getById(String id);
  Future<List<Loan>> getAll();
  Stream<List<Loan>> watchAll();
  Future<String> insert(Loan loan);
  Future<void> update(Loan loan);
  Future<void> delete(String id);
}

