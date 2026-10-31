/// Registration form state definitions using Freezed for immutability.
/// 
/// Contains [RegistrationFormState] and [FormValidationError] for managing
/// the item registration form state (non-async, local form data).

import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_form_state.freezed.dart';

/// Validation error for a single form field.
@freezed
class FormValidationError with _$FormValidationError {
  const factory FormValidationError({
    required String field,
    required String message,
  }) = _FormValidationError;
}

/// Registration form state holding local form data and validation errors.
/// 
/// This is a synchronous Notifier (not AsyncNotifier) because it manages
/// local form state, not async data fetching.
@freezed
class RegistrationFormState with _$RegistrationFormState {
  const factory RegistrationFormState({
    @Default('') String itemName,
    @Default('') String description,
    @Default('other') String category,
    List<FormValidationError>? errors,
    @Default(false) bool isSubmitting,
    int? currentStep,
  }) = _RegistrationFormState;

  const RegistrationFormState._();

  /// Returns true if the form has any validation errors.
  bool get hasErrors => (errors ?? []).isNotEmpty;

  /// Returns validation errors for a specific field.
  List<FormValidationError> getErrorsForField(String field) {
    return (errors ?? []).where((e) => e.field == field).toList();
  }

  /// Returns true if all required fields are valid.
  bool get isValid {
    final nameValid = itemName.trim().isNotEmpty && itemName.trim().length <= 200;
    final descValid = description.isEmpty || description.length <= 500;
    return nameValid && descValid;
  }

  /// Validates the current form state and returns updated state with errors.
  RegistrationFormState validate() {
    final errors = <FormValidationError>[];

    // Validate item name
    if (itemName.trim().isEmpty) {
      errors.add(const FormValidationError(
        field: 'itemName',
        message: 'Item name is required',
      ));
    } else if (itemName.trim().length > 200) {
      errors.add(const FormValidationError(
        field: 'itemName',
        message: 'Item name must be 200 characters or less',
      ));
    }

    // Validate description length
    if (description.length > 500) {
      errors.add(const FormValidationError(
        field: 'description',
        message: 'Description must be 500 characters or less',
      ));
    }

    return RegistrationFormState(
      itemName: itemName,
      description: description,
      category: category,
      errors: errors.isNotEmpty ? errors : null,
      isSubmitting: isSubmitting,
      currentStep: currentStep,
    );
  }
}