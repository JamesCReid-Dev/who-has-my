/// Registration form provider using Riverpod.
/// 
/// Provides synchronous form state management for item registration.
/// Uses [NotifierProvider] (NOT AsyncNotifierProvider) because this manages
/// local form state, not async data fetching.
/// 
/// State update flow: User Action → Widget → Notifier → Validation → Form State

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whohasmy/application/state/registration_form_state.dart';

/// Provider for registration form state (synchronous, non-async).
final registrationFormProvider = NotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
  () => RegistrationFormNotifier(),
);

/// Registration form notifier that manages local form state.
/// 
/// This is a synchronous [Notifier] because it only handles:
/// - User input changes (name, description, category)
/// - Form validation
/// - Step navigation
/// It does NOT fetch or save data to repositories.
class RegistrationFormNotifier extends Notifier<RegistrationFormState> {
  RegistrationFormNotifier();

  @override
  RegistrationFormState build() {
    return const RegistrationFormState(
      currentStep: 1,
    );
  }

  /// Updates the item name field.
  void updateItemName(String name) {
    state = state.copyWith(itemName: name);
  }

  /// Updates the description field.
  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  /// Updates the category selection.
  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  /// Validates the current form state and updates errors.
  bool validate() {
    final validatedState = state.validate();
    state = validatedState;
    return validatedState.isValid;
  }

  /// Advances to the next step (1 → 2 → 3).
  void nextStep() {
    final currentStep = state.currentStep ?? 1;
    if (currentStep < 3) {
      state = state.copyWith(currentStep: currentStep + 1);
    }
  }

  /// Goes back to the previous step.
  void previousStep() {
    final currentStep = state.currentStep ?? 1;
    if (currentStep > 1) {
      state = state.copyWith(currentStep: currentStep - 1);
    }
  }

  /// Resets the form to initial state.
  void reset() {
    state = const RegistrationFormState(currentStep: 1);
  }

  /// Sets the submitting flag (used during async save operation).
  void setSubmitting(bool submitting) {
    state = state.copyWith(isSubmitting: submitting);
  }
}