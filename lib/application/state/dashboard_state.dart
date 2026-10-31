/// Dashboard state definitions using Freezed for immutability.
/// 
/// Contains [DashboardState] for risk-ranked active loans display
/// and [ItemCardData] for compact item card information.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/value_objects/risk_level.dart';

part 'dashboard_state.freezed.dart';

/// Compact data class for displaying an item in card form on the dashboard.
@freezed
class ItemCardData with _$ItemCardData {
  const factory ItemCardData({
    required String id,
    required String name,
    required String category,
    required RiskLevel riskLevel,
    required int daysOverdue,
    @Default(false) bool isReturned,
  }) = _ItemCardData;

  factory ItemCardData.fromItem(Item item, {required DateTime now}) {
    final riskLevel = RiskCalculator.calculateFromDates(
      DateTime.now().add(const Duration(days: 14)), // approximate due date
      now,
    );
    
    return ItemCardData(
      id: item.id,
      name: item.name,
      category: item.category,
      riskLevel: riskLevel,
      daysOverdue: 0,
      isReturned: false,
    );
  }
}

/// Dashboard state holding risk-ranked active loans.
@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    required List<ItemCardData> items,
    @Default(false) bool loading,
    String? error,
  }) = _DashboardState;

  const DashboardState._();

  /// Returns the number of active (non-returned) loans.
  int get activeLoanCount => items.where((item) => !item.isReturned).length;

  /// Returns items grouped by risk level.
  Map<RiskLevel, List<ItemCardData>> get itemsByRiskLevel {
    final result = <RiskLevel, List<ItemCardData>>{
      RiskLevel.none: [],
      RiskLevel.low: [],
      RiskLevel.medium: [],
      RiskLevel.high: [],
    };
    for (final item in items) {
      result[item.riskLevel]!.add(item);
    }
    return result;
  }

  /// Returns true if the dashboard is in an error state.
  bool get hasError => error != null;
}