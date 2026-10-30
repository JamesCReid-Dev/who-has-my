/// Value object for risk level calculation based on days overdue.
/// 
/// Aligns with PRD FR-17 risk thresholds:
/// - None: < 2 days overdue (including future due dates)
/// - Low: 2-4 days overdue
/// - Medium: exactly 5 days overdue
/// - High: >5 days overdue

enum RiskLevel { none, low, medium, high }

class RiskCalculator {
  const RiskCalculator._();

  /// Calculate risk level based on days overdue.
  static RiskLevel calculate(int daysOverdue) {
    if (daysOverdue < 2) return RiskLevel.none;       // Not overdue
    if (daysOverdue <= 4) return RiskLevel.low;        // 2-4 days overdue
    if (daysOverdue == 5) return RiskLevel.medium;     // Exactly 5 days overdue
    return RiskLevel.high;                              // >5 days overdue
  }

  /// Calculate risk level from DateTime.
  static RiskLevel calculateFromDates(DateTime dueDate, DateTime now) {
    final daysOverdue = now.difference(dueDate).inDays;
    return calculate(daysOverdue);
  }
}
