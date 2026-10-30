// import 'package:freezed_annotation/freezed_annotation.dart';
// 
// part 'loan.freezed.dart';
// part 'loan.g.dart';

/// Loan entity representing a record linking an Item to a Contact with a due date.
class Loan {
  final String id;
  final String itemId;
  final String contactId;
  final DateTime dueDate;
  final DateTime createdAt;
  final bool isReturned;
  final DateTime? returnedAt;
  final String? returnConditionNotes;

  const Loan({
    required this.id,
    required this.itemId,
    required this.contactId,
    required this.dueDate,
    required this.createdAt,
    this.isReturned = false,
    this.returnedAt,
    this.returnConditionNotes,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'] as String,
        itemId: json['itemId'] as String,
        contactId: json['contactId'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        isReturned: json['isReturned'] as bool? ?? false,
        returnedAt: json['returnedAt'] != null ? DateTime.parse(json['returnedAt'] as String) : null,
        returnConditionNotes: json['returnConditionNotes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemId': itemId,
        'contactId': contactId,
        'dueDate': dueDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'isReturned': isReturned,
        'returnedAt': returnedAt?.toIso8601String(),
        'returnConditionNotes': returnConditionNotes,
      };

  Loan copyWith({
    DateTime? dueDate,
    bool? isReturned,
    DateTime? returnedAt,
    String? returnConditionNotes,
  }) {
    return Loan(
      id: id,
      itemId: itemId,
      contactId: contactId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      isReturned: isReturned ?? this.isReturned,
      returnedAt: returnedAt ?? this.returnedAt,
      returnConditionNotes: returnConditionNotes ?? this.returnConditionNotes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Loan && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

