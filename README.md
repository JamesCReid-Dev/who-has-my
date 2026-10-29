# WhoHasMy

A cross-platform lending tracker built with Flutter using Clean Architecture.

## Project Structure

This project follows **Clean Architecture** (Ports & Adapters) with four concentric layers:

```
lib/
├── core/                    # Shared utilities, constants, extensions
│   ├── constants/           # App-wide constants (risk thresholds, dates)
│   ├── errors/              # Error types and failure classes
│   ├── extensions/          # String, DateTime, int extensions
│   └── utils/               # Formatting helpers, validators
├── domain/                  # INNER LAYER — pure Dart, no dependencies
│   ├── entities/            # Item, Contact, Loan (data classes)
│   ├── repositories/        # Repository interfaces (ports)
│   ├── usecases/            # Business operations (TODO)
│   └── value_objects/       # RiskLevel, Status, DueDate calculations
├── application/             # MIDDLE LAYER — orchestration
│   ├── providers/           # Riverpod providers (state containers)
│   ├── services/            # Service interfaces (email, date provider)
│   └── validators/          # Form validation logic
├── infrastructure/          # OUTER LAYER — platform concerns
│   ├── storage/             # Hive adapters, box names, serialization
│   ├── email/               # SMTP implementation, email templates
│   └── plugins/             # Platform-specific plugin wrappers
└── presentation/            # Flutter UI (depends on application)
    ├── widgets/             # Reusable UI components
    ├── screens/             # Full-screen views
    ├── navigation/          # Route definitions, bottom nav
    └── theme/               # App theme and design tokens
```

## Dependencies

### Core
- **flutter_riverpod** - State management
- **freezed** - Immutable data classes with copyWith
- **hive / hive_flutter** - Local storage
- **image_picker** - Photo capture/pick
- **flutter_email_sender** - Email notifications
- **workmanager** - Background tasks (Android)
- **flutter_local_notifications** - Notifications (iOS/macOS)

### Development
- **build_runner** - Code generation
- **freezed** + **json_serializable** - Serialization
- **hive_generator** - Hive adapter generation
- **riverpod_generator** - Provider code generation

## Getting Started

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Run `flutter pub get` to install dependencies
3. Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Run on target platform: `flutter run -d <device-id>`

### Target Platforms
- **Android**: minSdk 21
- **iOS**: deployment target 13.0
- **macOS**: 10.14+
- **Chrome Webapp**: PWA-ready

## Architecture Decisions

See `ARCHITECTURE.md` for detailed architectural decisions including:
- Clean Architecture with dependency rule (inner layers never import outer)
- Riverpod + Freezed for state management
- Hive for local storage with five boxes
- Email-only notifications via SMTP in v1

## Sprint Status

Tracking file: `_bmad-output/implementation-artifacts/sprint-status.yaml`

Current epic: **EPIC-01** - Cross-Platform Foundation
