# tvOS Phase 20 — Settings and tvOS-Specific Preferences

- Date: 2026-03-25
- Scope: Promote `/settings` into the active tvOS shell as a television-safe preferences route.

## Shipped

- Added a real native tvOS `Settings` route to the sidebar and route shell.
- Added persisted startup behavior preferences for:
  - open Profiles first
  - resume last household route
  - start on Home
  - start on Qur'an
  - start on Prayer
  - start on Learn
- Added persisted Qur'an listening defaults for:
  - default reciter
  - show translation by default
  - show transliteration by default
- Kept deeper account, backup, restore, and sync controls off tvOS and explicitly positioned them as companion-device work.
- Promoted `settings` into the shared tvOS rollout and content-registry layer with stable section keys:
  - `settings.startup`
  - `settings.listeningDefaults`
  - `settings.tvPreferences`

## Product Boundaries

- This is not a mobile Settings port.
- tvOS settings remains limited to room-level preferences that work with a remote and a family-room context.
- Dense management continues to belong on iPhone and iPad.

## Verification Target

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase20_modulecache`
