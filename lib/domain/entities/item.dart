/// Item entity representing a physical object registered in the app.
/// 
/// Has a name, description, optional image, category, and condition.
/// Can be in one of three statuses: Available, Loaned, or In-Maintenance.
class Item {
  final String id;              // Hive key: "item:{uuid}"
  final String name;            // Required, non-empty, max 200 chars
  final String? description;    // Optional, max 1000 chars
  final String category;        // Required (default or custom)
  final ItemStatus status;      // Available, Loaned, In-Maintenance
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Item({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    this.status = ItemStatus.available,
    required this.createdAt,
    this.updatedAt,
  });

  /// Copy with new values
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
