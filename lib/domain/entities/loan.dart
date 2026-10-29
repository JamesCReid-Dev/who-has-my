/// Loan entity representing a record linking an Item to a Contact with a due date.
/// 
/// A loan is active from creation until the owner confirms return.
class Loan {
  final String id;              // Hive key: "loan:{uuid}"
  final String itemId;          // Reference to Item.id (Hive key string)
  final String contactId;       // Reference to Contact.id (Hive key string)
  final DateTime dueDate;       // Required, >= today
  final DateTime createdAt;
  final bool isReturned;        // False = active, True = returned
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

  /// Copy with new values
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
