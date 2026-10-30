import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

/// Contact entity representing a person who can receive items.
@freezed
class Contact with _$Contact {
  const factory.Contact({
    required String id,
    required String name,
    String? email,
    String? phone,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}

