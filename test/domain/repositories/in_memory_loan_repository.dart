import 'dart:async';

import 'package:whohasmy/domain/entities/loan.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

/// In-memory implementation of LoanRepository for unit testing.
class InMemoryLoanRepository implements LoanRepository {
  final Map<String, Loan> _loans = {};
  final StreamController<List<Loan>> _controller = StreamController.broadcast();

  @override
  Future<Loan> getById(String id) async {
    final loan = _loans[id];
    if (loan == null) throw Exception('Loan not found: $id');
    return loan;
  }

  @override
  Future<List<Loan>> getAll() async {
    return _loans.values.toList();
  }

  @override
  Stream<List<Loan>> watchAll() {
    return _controller.stream.map((_) => _loans.values.toList());
  }

  @override
  Future<String> insert(Loan loan) async {
    _loans[loan.id] = loan;
    _controller.add(_loans.values.toList());
    return loan.id;
  }

  @override
  Future<void> update(Loan loan) async {
    if (!_loans.containsKey(loan.id)) {
      throw Exception('Loan not found: ${loan.id}');
    }
    _loans[loan.id] = loan;
    _controller.add(_loans.values.toList());
  }

  @override
  Future<void> delete(String id) async {
    if (!_loans.containsKey(id)) {
      throw Exception('Loan not found: $id');
    }
    _loans.remove(id);
    _controller.add(_loans.values.toList());
  }

  void clear() {
    _loans.clear();
    _controller.add(_loans.values.toList());
  }
}
