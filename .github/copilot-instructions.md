---
description: Workspace instructions for Path of Nūr — Flutter app for daily Islamic practice
---

# Path of Nūr — AI Agent Instructions

Path of Nūr is a Flutter application for worship tracking, Qur'an engagement, guided learning, and daily spiritual growth. This document helps AI agents work productively in the codebase.

## Project Essentials

**Tech Stack**: Flutter (Dart), Riverpod, GoRouter, SQLite, shared_preferences, local-first architecture

**Platforms**:
- **Active/Primary**: iOS, Android
- **In Development**: watchOS, tvOS (see `/apple_tv_app/`)
- **Secondary**: Web, macOS, Linux

**Version**: Check `pubspec.yaml` for current version and dependencies

## Architecture

The codebase follows **clean feature-based architecture**:

```
lib/
├── main.dart                    # App bootstrap
├── app/                         # Root app widget, theme, routing
├── core/                        # Cross-app infrastructure
│   ├── config/                  # App constants, configuration
│   ├── diagnostics/             # Telemetry, logging (AppTelemetry)
│   ├── localization/            # i18n/l10n setup
│   ├── navigation/              # GoRouter configuration
│   ├── prayer/                  # Prayer calculation/utilities
│   ├── reminders/               # Local notifications
│   └── theme/                   # Material/Cupertino theme
├── features/                    # Feature modules (highly independent)
│   ├── home/                    # Home screen, navigation shell
│   ├── journey/                 # Daily growth, habits, reflections
│   ├── quran/                   # Qur'an reader, search, bookmarks
│   ├── learn/                   # Learning journeys, content
│   └── [35+ other features]     # Each with own logic, UI, state
├── shared/                      # Shared utilities across features
│   ├── application/             # App-level widgets, providers
│   ├── content/                 # Content models, helpers
│   ├── persistence/             # AppDatabase, LocalStore, schemas
│   ├── profile/                 # Profile state, multi-user support
│   ├── state/                   # Shared Riverpod providers
│   ├── theme/                   # UI components, theme utilities
│   ├── utils/                   # String, date, validation helpers
│   └── widgets/                 # Reusable UI components
└── l10n/                        # ARB localization files
```

### Key Architectural Patterns

**Feature Independence**: Each feature is largely independent with its own models, providers, and UI. Features should not directly import from other features; use shared abstractions instead.

**State Management**: Riverpod is used for all reactive state — providers, families, and async providers. The pattern is heavily async-first.

**Routing**: GoRouter manages all navigation. Routes are defined in `core/navigation/`. Deep linking and named routes are supported.

**Persistence**:
- `SharedPreferences`: User settings, preferences, flags
- `SQLite` (via `sqlite3`): Main app database schemas (`shared/persistence/schemas/`)
- Local-first design — sync is planned but not the default flow

**Profiles**: Multi-profile support for shared devices. Profile state is centralized in `shared/profile/`.

## Common Development Tasks

### Running the App

```bash
# Get dependencies
flutter pub get

# Run on iOS (requires Xcode)
flutter run -d ios

# Run on Android (requires Android emulator/device)
flutter run -d android

# Run on a specific device
flutter devices                    # List available devices
flutter run -d <device_id>
```

### Code Quality

```bash
# Format code (automatic, enforced in CI)
dart format .

# Lint analysis
flutter analyze

# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

**Linting Policy**: The project uses `flutter_lints` base set with minimal custom rules. See `analysis_options.yaml`. Rule philosophy: keep linting practical, avoid style churn.

### Building for Release

**iOS**:
```bash
# Requires valid signing certificates
flutter build ios --release
# Then use Xcode for final archive/submission
```

**Android**:
```bash
flutter build apk --release
# Or AAB for Play Store
flutter build appbundle --release
```

See `/scripts/ci_*` for CI-specific build validation steps.

### Database Migrations

Database schema changes go in `shared/persistence/schemas/`. The app uses raw SQLite with Dart schemas. When modifying, ensure:
- Migrations are backward-compatible
- Old device versions can still run
- Profile/sync implications are documented

## Common Patterns

### Adding a New Feature

1. Create `lib/features/<feature_name>/` with structure:
   ```
   <feature_name>/
   ├── models/          # Data models, DTOs
   ├── providers/       # Riverpod providers, notifiers
   ├── screens/         # Full-screen UI
   ├── widgets/         # Feature-specific components
   ├── repositories/    # Data layer (if complex)
   └── <feature_name>.dart  # Public API/exports
   ```

2. Export public APIs via `<feature_name>.dart` to control surface area.

3. Define providers in `providers/` directory, following naming (`<name>Provider`, `<name>RepositoryProvider`).

4. Use Riverpod's async patterns for data fetching and caching.

### Creating Providers

```dart
// Read-only state
final exampleProvider = StateProvider<String>((ref) => 'initial');

// Async data (with caching)
final exampleDataProvider = FutureProvider<List<Item>>((ref) async {
  // ...
});

// Notifiers for complex state
class ExampleNotifier extends StateNotifier<MyState> {
  ExampleNotifier() : super(MyState.initial());
  // ...
}

final exampleNotifierProvider = StateNotifierProvider<ExampleNotifier, MyState>((ref) {
  return ExampleNotifier();
});
```

### Routing

New routes go in `core/navigation/`. Update GoRouter configuration to add routes:

```dart
GoRoute(
  path: '/example',
  name: 'example',
  builder: (context, state) => ExampleScreen(),
)
```

Deep links use the same route definitions.

### Localization

UI strings go in `lib/l10n/*.arb` (ARB format). Use the `intl` package:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In widget
AppLocalizations.of(context)!.exampleString
```

New locales are added via `l10n.yaml` configuration.

### Telemetry & Diagnostics

Use `AppTelemetry` from `core/diagnostics/` for logging and error reporting:

```dart
import 'package:path_of_nur/core/diagnostics/app_telemetry.dart';

AppTelemetry.logEvent('feature_accessed', {'feature': 'quran'});
AppTelemetry.logError('api_error', error: exception, stackTrace: stackTrace);
```

## Testing

### Unit Tests

Place in `test/` with same directory structure as `lib/`:

```dart
// test/features/home/providers/home_provider_test.dart
void main() {
  group('HomeProvider', () {
    test('initial state is correct', () {
      // ...
    });
  });
}
```

Mock Riverpod providers using `ProviderContainer`:

```dart
test('provider test', () {
  final container = ProviderContainer();
  final state = container.read(exampleProvider);
  expect(state, isNotNull);
});
```

### Integration Tests

Place in `integration_test/` for end-to-end flows.

## CI/CD Pipeline

The project uses GitHub Actions (`.github/workflows/ci.yml`):

1. **Validate** (Ubuntu):
   - `flutter pub get`
   - PNG asset policy check
   - Code formatting check (`dart format`)
   - Analysis (`flutter analyze`)
   - Tests (`flutter test`)

2. **iOS + watchOS Preflight** (macOS):
   - iOS/watchOS build validation
   - Apple bundle consistency
   - Signing doctor
   - Archive packaging

**On PRs**: All checks must pass before merge.

## Key Files & Directories

| Path | Purpose |
|------|---------|
| [pubspec.yaml](pubspec.yaml) | Dependencies, version, Flutter config |
| [analysis_options.yaml](analysis_options.yaml) | Lint rules, analyzer settings |
| [l10n.yaml](l10n.yaml) | Localization configuration |
| [lib/app/](lib/app/) | Root app widget, theme, routing setup |
| [lib/core/theme/](lib/core/theme/) | Material Design theme, brand colors |
| [shared/persistence/app_database.dart](lib/shared/persistence/app_database.dart) | SQLite setup, schema migrations |
| [scripts/](scripts/) | CI scripts, validation utilities |
| [docs/](docs/) | Feature backlogs, architectural decisions |

## Platform-Specific Notes

### iOS/watchOS

- Signing requires provisioning profiles
- XCode build cache can cause issues; use `flutter clean` if needed
- See `apple_tv_app/` for tvOS-specific work (not yet production)
- Key files: `ios/Podfile`, `ios/Runner.xcodeproj/`

### Android

- Gradle configuration in `android/build.gradle.kts`, `android/settings.gradle.kts`
- Signing via `android/key.properties`
- Firebase (if applicable) configs in `android/app/google-services.json`

### Multi-Platform

- Avoid platform-specific code; use Flutter abstractions
- Permission handling via `permission_handler` plugin
- Use `Theme.of(context)` for adaptive UI (Cupertino on iOS, Material on Android)

## Common Pitfalls

1. **Circular Imports**: Features should not import each other directly. Use shared abstractions.
2. **Provider Invalidation**: Be cautious with `.invalidate()` — can cause unnecessary rebuilds. Prefer updating state.
3. **Riverpod Rebuild Loops**: Ensure providers don't depend on watchable state in ways that create cascading rebuilds.
4. **SQLite Concurrency**: The `sqlite3` package is synchronous — avoid blocking operations on the main thread.
5. **Memory Leaks**: Dispose listeners, cancel streams, and clear caches properly in state notifiers.
6. **Localization**: New strings must be added to all `.arb` files, not just English. Use `flutter gen-l10n` to validate.
7. **Assets**: PNG assets are checked by CI (`tooling/scripts/check_runtime_png_policy.sh`). Use WebP where possible.

## Debugging Tips

**Enable verbose logging**:
```bash
flutter run -v
```

**Use DevTools**:
```bash
flutter pub global activate devtools
devtools
```

Then open `http://localhost:9100` in your browser.

**Check Riverpod state**:
Use Riverpod's DevTools inspector in the app (when enabled). See provider output in the console.

**SQLite Queries**:
Enable query logging in `shared/persistence/app_database.dart` for debugging.

## Learning Resources

- [Flutter documentation](https://flutter.dev/docs)
- [Riverpod guide](https://riverpod.dev/docs/introduction/getting_started)
- [GoRouter documentation](https://pub.dev/packages/go_router)
- [SQLite + Dart](https://pub.dev/packages/sqlite3)
- See [README.md](README.md) for high-level app overview

## Getting Help

- Check `docs/` for feature-specific backlogs and decisions
- Review existing features for patterns, especially `home/`, `journey/`, `quran/`
- Refer to CI logs (`.github/workflows/ci.yml`) for build/test failures
- Check `analysis_options.yaml` for lint rule definitions

---

*Last updated: April 2026*
