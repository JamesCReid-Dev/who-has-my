// import 'package:freezed_annotation/freezed_annotation.dart';
// 
// part 'item.freezed.dart';
// part 'item.g.dart';

/// Item entity representing a physical object registered in the app.
class Item {
  final String id;
  final String name;
  final String? description;
  final String category;
  final ItemStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Item({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        category: json['category'] as String,
        status: ItemStatus.values[json['status'] as int],
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'status': status.index,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  Item copyWith({
    String? name,
    String? description,
    String? category,
    ItemStatus? status,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Item status enum
enum ItemStatus { available, loaned, inMaintenance }

