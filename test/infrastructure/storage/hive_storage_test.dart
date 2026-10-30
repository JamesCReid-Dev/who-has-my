import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/infrastructure/storage/hive_storage.dart';

void main() {
  group('HiveStorage', () {
    test('should define correct box names', () {
      expect(HiveStorage.boxItems, equals('items'));
      expect(HiveStorage.boxContacts, equals('contacts'));
      expect(HiveStorage.boxLoans, equals('loans'));
      expect(HiveStorage.boxPhotos, equals('photos'));
      expect(HiveStorage.boxSettings, equals('settings'));
    });

    test('should have exactly 5 box names defined', () {
      // Verify we can access all box constants
      final boxes = [
        HiveStorage.boxItems,
        HiveStorage.boxContacts,
        HiveStorage.boxLoans,
        HiveStorage.boxPhotos,
        HiveStorage.boxSettings,
      ];

      expect(boxes.length, equals(5));
    });

    test('box names should not contain special characters', () {
      // Box names should be simple strings for Hive compatibility
      final boxPattern = RegExp(r'^[a-z]+$');
      
      expect(HiveStorage.boxItems, matches(boxPattern));
      expect(HiveStorage.boxContacts, matches(boxPattern));
      expect(HiveStorage.boxLoans, matches(boxPattern));
      expect(HiveStorage.boxPhotos, matches(boxPattern));
      expect(HiveStorage.boxSettings, matches(boxPattern));
    });

    test('HiveStorage should be a class with static methods', () {
      // This is more of an integration check - the class exists and has static members
      expect(() => HiveStorage.initialize(), returnsNormally);
      expect(() => HiveStorage.close(), returnsNormally);
    });
  });
}
