/// Settings provider using Riverpod singleton pattern.
/// 
/// Provides app-wide settings including owner email, SMTP configuration,
/// and notification interval. This is a synchronous [Provider] (not Notifier)
/// because it holds immutable configuration data.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SMTP server configuration for email notifications.
class SmtpConfig {
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useSsl;

  const SmtpConfig({
    this.host = '',
    this.port = 587,
    this.username = '',
    this.password = '',
    this.useSsl = false,
  });

  SmtpConfig copyWith({
    String? host,
    int? port,
    String? username,
    String? password,
    bool? useSsl,
  }) {
    return SmtpConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      useSsl: useSsl ?? this.useSsl,
    );
  }

  bool get isConfigured => host.isNotEmpty && username.isNotEmpty;
}

/// Notification interval settings.
enum NotificationInterval { hourly, daily, weekly }

/// Application settings data class (immutable).
class SettingsData {
  final String ownerEmail;
  final SmtpConfig smtpConfig;
  final NotificationInterval notificationInterval;

  const SettingsData({
    this.ownerEmail = '',
    this.smtpConfig = const SmtpConfig(),
    this.notificationInterval = NotificationInterval.daily,
  });

  SettingsData copyWith({
    String? ownerEmail,
    SmtpConfig? smtpConfig,
    NotificationInterval? notificationInterval,
  }) {
    return SettingsData(
      ownerEmail: ownerEmail ?? this.ownerEmail,
      smtpConfig: smtpConfig ?? this.smtpConfig,
      notificationInterval: notificationInterval ?? this.notificationInterval,
    );
  }

  bool get isOwnerEmailSet => ownerEmail.isNotEmpty;
  bool get hasSmtpConfigured => smtpConfig.isConfigured;
}

/// Singleton provider for application settings.
/// 
/// This is a synchronous [Provider] (not AsyncNotifier) because it holds
/// immutable configuration data that doesn't change during runtime.
final settingsProvider = Provider<SettingsData>((ref) {
  return const SettingsData();
});

/// Provider for updating owner email setting.
final ownerEmailProvider = Provider<String>((ref) {
  return ref.read(settingsProvider).ownerEmail;
});

/// Provider for SMTP configuration.
final smtpConfigProvider = Provider<SmtpConfig>((ref) {
  return ref.read(settingsProvider).smtpConfig;
});

/// Provider for notification interval setting.
final notificationIntervalProvider = Provider<NotificationInterval>((ref) {
  return ref.read(settingsProvider).notificationInterval;
});