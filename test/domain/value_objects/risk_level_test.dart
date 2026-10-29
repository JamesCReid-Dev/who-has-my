import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/domain/value_objects/risk_level.dart';

void main() {
  group('RiskCalculator', () {
    test('should return None for future due dates (negative days overdue)', () {
      final risk = RiskCalculator.calculate(-1);
      expect(risk, equals(RiskLevel.none));
    });

    test('should return None for today (0 days overdue)', () {
      final risk = RiskCalculator.calculate(0);
      expect(risk, equals(RiskLevel.none));
    });

    test('should return None for 1 day overdue (< 2 days)', () {
      final risk = RiskCalculator.calculate(1);
      expect(risk, equals(RiskLevel.none));
    });

    test('should return Low for 2 days overdue', () {
      final risk = RiskCalculator.calculate(2);
      expect(risk, equals(RiskLevel.low));
    });

    test('should return Low for 3 days overdue', () {
      final risk = RiskCalculator.calculate(3);
      expect(risk, equals(RiskLevel.low));
    });

    test('should return Low for 4 days overdue', () {
      final risk = RiskCalculator.calculate(4);
      expect(risk, equals(RiskLevel.low));
    });

    test('should return Medium for exactly 5 days overdue', () {
      final risk = RiskCalculator.calculate(5);
      expect(risk, equals(RiskLevel.medium));
    });

    test('should return High for 6 days overdue (> 5 days)', () {
      final risk = RiskCalculator.calculate(6);
      expect(risk, equals(RiskLevel.high));
    });

    test('should return High for 10 days overdue', () {
      final risk = RiskCalculator.calculate(10);
      expect(risk, equals(RiskLevel.high));
    });

    test('should return High for 30 days overdue', () {
      final risk = RiskCalculator.calculate(30);
      expect(risk, equals(RiskLevel.high));
    });

    test('calculateFromDates should compute correctly for future date', () {
      final dueDate = DateTime.now().add(const Duration(days: 7));
      final risk = RiskCalculator.calculateFromDates(dueDate, DateTime.now());
      expect(risk, equals(RiskLevel.none));
    });

    test('calculateFromDates should compute correctly for overdue date', () {
      final dueDate = DateTime.now().subtract(const Duration(days: 3));
      final risk = RiskCalculator.calculateFromDates(dueDate, DateTime.now());
      expect(risk, equals(RiskLevel.low));
    });

    test('RiskLevel enum should have all expected values', () {
      expect(RiskLevel.values.length, equals(4));
      expect(RiskLevel.values, containsAll([
        RiskLevel.none,
        RiskLevel.low,
        RiskLevel.medium,
        RiskLevel.high,
      ]));
    });

    test('risk thresholds should match PRD FR-17 specification', () {
      // None: < 2 days overdue (including future due dates)
      expect(RiskCalculator.calculate(-1), equals(RiskLevel.none));
      expect(RiskCalculator.calculate(0), equals(RiskLevel.none));
      expect(RiskCalculator.calculate(1), equals(RiskLevel.none));

      // Low: 2-4 days overdue
      expect(RiskCalculator.calculate(2), equals(RiskLevel.low));
      expect(RiskCalculator.calculate(3), equals(RiskLevel.low));
      expect(RiskCalculator.calculate(4), equals(RiskLevel.low));

      // Medium: exactly 5 days overdue
      expect(RiskCalculator.calculate(5), equals(RiskLevel.medium));

      // High: >5 days overdue
      expect(RiskCalculator.calculate(6), equals(RiskLevel.high));
      expect(RiskCalculator.calculate(100), equals(RiskLevel.high));
    });
  });
}
