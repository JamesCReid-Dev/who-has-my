/// Application layer - MIDDLE LAYER (orchestration)
/// 
/// Contains business logic orchestration, Riverpod providers, use cases,
/// and state management classes. Imports domain only.

library;

// State classes (Freezed-generated immutability)
export 'state/dashboard_state.dart';
export 'state/items_catalog_state.dart';
export 'state/contacts_state.dart';
export 'state/registration_form_state.dart';

// Riverpod providers
export 'providers/dashboard_provider.dart';
export 'providers/items_catalog_provider.dart';
export 'providers/contacts_provider.dart';
export 'providers/registration_form_provider.dart';
export 'providers/settings_provider.dart';
