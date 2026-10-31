import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/registration_form_provider.dart';

void main() {
  group('RegistrationFormNotifier', () {
    test('should initialize with default state', () {
      final container = ProviderContainer();
      final state = container.read(registrationFormProvider);
      expect(state.itemName, isEmpty);
      expect(state.description, isEmpty);
      expect(state.category, equals('other'));
      expect(state.currentStep, equals(1));
      expect(state.errors, isNull);
      expect(state.isSubmitting, isFalse);
      container.dispose();
    });

    test('should update item name', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateItemName('Drill');
      final state = container.read(registrationFormProvider);
      expect(state.itemName, equals('Drill'));
      container.dispose();
    });

    test('should update description', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateDescription('Power tool');
      final state = container.read(registrationFormProvider);
      expect(state.description, equals('Power tool'));
      container.dispose();
    });

    test('should update category', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateCategory('tools');
      final state = container.read(registrationFormProvider);
      expect(state.category, equals('tools'));
      container.dispose();
    });

    test('validate should return true for valid form', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateItemName('Drill');
      container.read(registrationFormProvider.notifier).updateDescription('Power tool');
      final isValid = container.read(registrationFormProvider.notifier).validate();
      expect(isValid, isTrue);
      container.dispose();
    });

    test('validate should return false for empty item name', () {
      final container = ProviderContainer();
      final isValid = container.read(registrationFormProvider.notifier).validate();
      expect(isValid, isFalse);
      final state = container.read(registrationFormProvider);
      expect(state.hasErrors, isTrue);
      container.dispose();
    });

    test('validate should return false for name over 200 chars', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateItemName('A' * 201);
      final isValid = container.read(registrationFormProvider.notifier).validate();
      expect(isValid, isFalse);
      container.dispose();
    });

    test('should advance to next step', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).nextStep();
      expect(container.read(registrationFormProvider).currentStep, equals(2));
      container.read(registrationFormProvider.notifier).nextStep();
      expect(container.read(registrationFormProvider).currentStep, equals(3));
      container.dispose();
    });

    test('should not advance beyond step 3', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).nextStep();
      container.read(registrationFormProvider.notifier).nextStep();
      container.read(registrationFormProvider.notifier).nextStep();
      expect(container.read(registrationFormProvider).currentStep, equals(3));
      container.dispose();
    });

    test('should go back to previous step', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).nextStep();
      container.read(registrationFormProvider.notifier).nextStep();
      container.read(registrationFormProvider.notifier).previousStep();
      expect(container.read(registrationFormProvider).currentStep, equals(1));
      container.dispose();
    });

    test('should reset form to initial state', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).updateItemName('Drill');
      container.read(registrationFormProvider.notifier).nextStep();
      container.read(registrationFormProvider.notifier).reset();
      final state = container.read(registrationFormProvider);
      expect(state.itemName, isEmpty);
      expect(state.currentStep, equals(1));
      container.dispose();
    });

    test('should set submitting flag', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).setSubmitting(true);
      expect(container.read(registrationFormProvider).isSubmitting, isTrue);
      container.read(registrationFormProvider.notifier).setSubmitting(false);
      expect(container.read(registrationFormProvider).isSubmitting, isFalse);
      container.dispose();
    });

    test('should get errors for specific field', () {
      final container = ProviderContainer();
      container.read(registrationFormProvider.notifier).validate();
      final state = container.read(registrationFormProvider);
      final nameErrors = state.getErrorsForField('itemName');
      expect(nameErrors, hasLength(1));
      expect(nameErrors[0].field, equals('itemName'));
      container.dispose();
    });

    test('RegistrationFormState isValid should check all fields', () {
      final validState = RegistrationFormState(itemName: 'Drill', description: 'Power tool');
      expect(validState.isValid, isTrue);

      final invalidState = RegistrationFormState(itemName: '');
      expect(invalidState.isValid, isFalse);

      final longDescState = RegistrationFormState(itemName: 'Drill', description: 'A' * 501);
      expect(longDescState.isValid, isFalse);
    });
  });
}