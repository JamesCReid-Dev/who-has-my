import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/domain/entities/loan.dart';

void main() {
  group('Loan Entity', () {
    test('should create Loan with required fields only', () {
      final loan = Loan(
        id: 'loan-1',
        itemId: 'item-1',
        contactId: 'contact-1',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );

      expect(loan.id, equals('loan-1'));
      expect(loan.itemId, equals('item-1'));
      expect(loan.contactId, equals('contact-1'));
      expect(loan.isReturned, isFalse); // Default is false
      expect(loan.returnedAt, isNull);
      expect(loan.returnConditionNotes, isNull);
    });

    test('should create returned Loan with all fields', () {
      final now = DateTime.now();
      final loan = Loan(
        id: 'loan-2',
        itemId: 'item-2',
        contactId: 'contact-2',
        dueDate: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 10)),
        isReturned: true,
        returnedAt: now,
        returnConditionNotes: 'Good condition',
      );

      expect(loan.isReturned, isTrue);
      expect(loan.returnedAt, equals(now));
      expect(loan.returnConditionNotes, equals('Good condition'));
    });

    test('copyWith should create new instance with updated values', () {
      final loan = Loan(
        id: 'loan-3',
        itemId: 'item-3',
        contactId: 'contact-3',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );

      final updatedLoan = loan.copyWith(
        dueDate: DateTime.now().add(const Duration(days: 21)),
        isReturned: true,
        returnedAt: DateTime.now(),
      );

      expect(updatedLoan.id, equals(loan.id)); // ID unchanged
      expect(updatedLoan.itemId, equals(loan.itemId)); // Unchanged fields preserved
      expect(updatedLoan.contactId, equals(loan.contactId));
      expect(updatedLoan.dueDate.isAfter(loan.dueDate), isTrue);
      expect(updatedLoan.isReturned, isTrue);
    });

    test('copyWith with no arguments should return equivalent loan', () {
      final loan = Loan(
        id: 'loan-4',
        itemId: 'item-4',
        contactId: 'contact-4',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );

      final copiedLoan = loan.copyWith();

      expect(copiedLoan, equals(loan));
    });

    test('equality should compare by ID', () {
      final loan1 = Loan(
        id: 'loan-5',
        itemId: 'item-a',
        contactId: 'contact-a',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );
      final loan2 = Loan(
        id: 'loan-5',
        itemId: 'item-b', // Different item
        contactId: 'contact-b', // Different contact
        dueDate: DateTime.now().add(const Duration(days: 7)), // Different date
        createdAt: DateTime.now(),
      );

      expect(loan1, equals(loan2));
    });

    test('inequality should return false for different IDs', () {
      final loan1 = Loan(
        id: 'loan-6a',
        itemId: 'item-6',
        contactId: 'contact-6',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );
      final loan2 = Loan(
        id: 'loan-6b',
        itemId: 'item-6',
        contactId: 'contact-6',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );

      expect(loan1, isNot(equals(loan2)));
    });

    test('hashCode should be consistent with equality', () {
      final loan1 = Loan(
        id: 'loan-7',
        itemId: 'item-7',
        contactId: 'contact-7',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );
      final loan2 = Loan(
        id: 'loan-7',
        itemId: 'different-item',
        contactId: 'different-contact',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      expect(loan1.hashCode, equals(loan2.hashCode));
    });

    test('active loan should have isReturned as false by default', () {
      final activeLoan = Loan(
        id: 'loan-8',
        itemId: 'item-8',
        contactId: 'contact-8',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      );

      expect(activeLoan.isReturned, isFalse);
    });

    test('returned loan should have returnedAt set', () {
      final now = DateTime.now();
      final returnedLoan = Loan(
        id: 'loan-9',
        itemId: 'item-9',
        contactId: 'contact-9',
        dueDate: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 5)),
        isReturned: true,
        returnedAt: now,
      );

      expect(returnedLoan.isReturned, isTrue);
      expect(returnedLoan.returnedAt, isNotNull);
    });
  });
}
