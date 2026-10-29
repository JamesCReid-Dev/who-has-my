/// Contact entity representing a person who can receive items.
/// 
/// Created via address book import or manual entry.
/// Has a name and contact info (email, phone) for notifications.
class Contact {
  final String id;              // Hive key: "contact:{uuid}"
  final String name;            // Required, non-empty, max 200 chars
  final String? email;          // Optional but warned if missing in v1
  final String? phone;          // Stored for future SMS (v2+), no v1 notifications
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  /// Copy with new values
  Contact copyWith({
    String? name,
    String? email,
    String? phone,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
