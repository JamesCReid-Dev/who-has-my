import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whohasmy/application/providers/settings_provider.dart';

void main() {
  group('SettingsProvider', () {
    test('should return default settings', () {
      final container = ProviderContainer();
      final settings = container.read(settingsProvider);
      expect(settings.ownerEmail, isEmpty);
      expect(settings.smtpConfig.host, isEmpty);
      expect(settings.smtpConfig.port, equals(587));
      expect(settings.notificationInterval, equals(NotificationInterval.daily));
      expect(settings.isOwnerEmailSet, isFalse);
      expect(settings.hasSmtpConfigured, isFalse);
      container.dispose();
    });

    test('ownerEmailProvider should return settings owner email', () {
      const customSettings = SettingsData(ownerEmail: 'test@example.com');
      final container = ProviderContainer(overrides: [settingsProvider.overrideWith((ref) => customSettings)]);
      expect(container.read(ownerEmailProvider), equals('test@example.com'));
      container.dispose();
    });

    test('smtpConfigProvider should return settings smtp config', () {
      const customSmtp = SmtpConfig(host: 'smtp.example.com', port: 465, username: 'user', password: 'pass');
      final container = ProviderContainer(overrides: [settingsProvider.overrideWith((ref) => SettingsData(smtpConfig: customSmtp))]);
      expect(container.read(smtpConfigProvider).host, equals('smtp.example.com'));
      expect(container.read(smtpConfigProvider).port, equals(465));
      container.dispose();
    });

    test('notificationIntervalProvider should return settings interval', () {
      final container = ProviderContainer(overrides: [settingsProvider.overrideWith((ref) => const SettingsData(notificationInterval: NotificationInterval.hourly))]);
      expect(container.read(notificationIntervalProvider), equals(NotificationInterval.hourly));
      container.dispose();
    });

    test('SmtpConfig isConfigured should return true when host and username are set', () {
      const configured = SmtpConfig(host: 'smtp.example.com', username: 'user');
      expect(configured.isConfigured, isTrue);

      const unconfigured = SmtpConfig();
      expect(unconfigured.isConfigured, isFalse);
    });

    test('SettingsData copyWith should create new instance with updated fields', () {
      const original = SettingsData(ownerEmail: 'old@example.com');
      final updated = original.copyWith(ownerEmail: 'new@example.com');
      expect(updated.ownerEmail, equals('new@example.com'));
      expect(original.ownerEmail, equals('old@example.com')); // Original unchanged
    });

    test('SettingsData isOwnerEmailSet should return true when email is set', () {
      const withEmail = SettingsData(ownerEmail: 'test@example.com');
      expect(withEmail.isOwnerEmailSet, isTrue);

      const withoutEmail = SettingsData();
      expect(withoutEmail.isOwnerEmailSet, isFalse);
    });
  });
}