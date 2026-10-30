// import 'package:freezed_annotation/freezed_annotation.dart';
// 
// part 'contact.freezed.dart';
// part 'contact.g.dart';

/// Contact entity representing a person who can receive items.
class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
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

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

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

