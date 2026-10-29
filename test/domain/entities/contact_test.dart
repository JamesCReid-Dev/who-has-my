import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/domain/entities/contact.dart';

void main() {
  group('Contact Entity', () {
    test('should create Contact with required fields only', () {
      final contact = Contact(
        id: 'contact-1',
        name: 'John Doe',
        createdAt: DateTime.now(),
      );

      expect(contact.id, equals('contact-1'));
      expect(contact.name, equals('John Doe'));
      expect(contact.email, isNull);
      expect(contact.phone, isNull);
    });

    test('should create Contact with email and phone', () {
      final contact = Contact(
        id: 'contact-2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1234567890',
        createdAt: DateTime.now(),
      );

      expect(contact.email, equals('jane@example.com'));
      expect(contact.phone, equals('+1234567890'));
    });

    test('copyWith should create new instance with updated values', () {
      final contact = Contact(
        id: 'contact-3',
        name: 'Original Name',
        createdAt: DateTime.now(),
      );

      final updatedContact = contact.copyWith(
        name: 'Updated Name',
        email: 'updated@example.com',
      );

      expect(updatedContact.id, equals(contact.id)); // ID unchanged
      expect(updatedContact.name, equals('Updated Name'));
      expect(updatedContact.email, equals('updated@example.com'));
    });

    test('equality should compare by ID', () {
      final contact1 = Contact(
        id: 'contact-4',
        name: 'Same ID',
        createdAt: DateTime.now(),
      );
      final contact2 = Contact(
        id: 'contact-4',
        name: 'Different Name',
        createdAt: DateTime.now(),
      );

      expect(contact1, equals(contact2));
    });

    test('inequality should return false for different IDs', () {
      final contact1 = Contact(
        id: 'contact-5a',
        name: 'Contact A',
        createdAt: DateTime.now(),
      );
      final contact2 = Contact(
        id: 'contact-5b',
        name: 'Contact A',
        createdAt: DateTime.now(),
      );

      expect(contact1, isNot(equals(contact2)));
    });

    test('hashCode should be consistent with equality', () {
      final contact1 = Contact(
        id: 'contact-6',
        name: 'Test',
        createdAt: DateTime.now(),
      );
      final contact2 = Contact(
        id: 'contact-6',
        name: 'Different',
        createdAt: DateTime.now(),
      );

      expect(contact1.hashCode, equals(contact2.hashCode));
    });
  });
}
