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
}

