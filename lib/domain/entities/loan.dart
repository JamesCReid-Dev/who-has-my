import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan.freezed.dart';
part 'loan.g.dart';

/// Loan entity representing a record linking an Item to a Contact with a due date.
@freezed
class Loan with _$Loan {
  const factory.Loan({
    required String id,
    required String itemId,
    required String contactId,
    required DateTime dueDate,
    required DateTime createdAt,
    bool isReturned,
    DateTime? returnedAt,
    String? returnConditionNotes,
  }) = _Loan;

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
}

