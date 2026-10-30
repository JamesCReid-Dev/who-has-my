import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

/// Item entity representing a physical object registered in the app.
@freezed
class Item with _$Item {
  const factory.Item({
    required String id,
    required String name,
    String? description,
    required String category,
    required ItemStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

/// Item status enum
enum ItemStatus { available, loaned, inMaintenance }

