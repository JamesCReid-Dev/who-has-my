/// Dashboard state provider using Riverpod.
/// 
/// Provides risk-ranked active loans for the dashboard view.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/domain/entities/item.dart';
import 'package:whohasmy/domain/repositories/repositories.dart';

class DashboardState {
  final List<Item> items;
  final bool loading;
  final String? error;

  const DashboardState({
    this.items = const [],
    this.loading = false,
    this.error,
  });

  DashboardState copyWith({
    List<Item>? items,
    bool? loading,
    String? error,
  }) {
    return DashboardState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

final dashboardStateProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  () => DashboardNotifier(),
);

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() {
    return Future.value(const DashboardState());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Inject ItemRepository and fetch data
      final items = <Item>[];
      state = AsyncData(DashboardState(items: items));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
