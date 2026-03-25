# tvOS Phase 24 — analytics, crash safety, and quality guardrails

Date: 2026-03-25

## Goal

Add production-safe tvOS analytics and diagnostics foundations without turning Apple TV into a cloud-managed or backend-dependent telemetry surface.

## Plan

1. Add shared Flutter-side tvOS quality and guardrail models so release posture and diagnostics expectations are explicit.
2. Add native tvOS local diagnostics logging for route opens, profile switching, settings changes, listening events, and playback failures.
3. Surface diagnostics posture inside tvOS Settings and verify the target still builds cleanly for unsigned Release.

## Implemented

### Shared Flutter-side guardrails

- Added shared quality-guardrail models in `lib/features/tvos/domain/tvos_quality_guardrail_models.dart`.
- Added canonical guardrail definitions in `lib/features/tvos/data/tvos_quality_guardrails.dart`.
- Added application access helpers in `lib/features/tvos/application/tvos_quality_guardrails.dart`.
- Added test coverage in `test/features/tvos/tvos_quality_guardrails_test.dart`.

### Native tvOS local diagnostics

- Added `TVTelemetry.swift` as a local-first diagnostics buffer backed by `UserDefaults`.
- Logged route opens, profile switches, startup-preference changes, listening-default changes, reciter selection, listening-mode entry and exit, and playback errors.
- Bootstrapped telemetry from app launch in `PathOfNurTVApp.swift`.
- Added `TVDiagnosticsSummary` in `TVModels.swift` to keep diagnostics UI structured and reusable.

### Settings diagnostics visibility

- Added `TVDiagnosticsSummaryCard.swift`.
- Extended `TVSettingsScreen.swift` and `TVSettingsViewModel` so diagnostics state is visible from the tvOS Settings route.
- Kept the posture local-first and companion-managed: this phase does not claim server analytics, cloud crash reporting, or remote dashboard ownership.

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase24_modulecache`

Result:

- `** BUILD SUCCEEDED **`

## Outcome

- tvOS now has a real local diagnostics and quality-guardrail foundation.
- Diagnostics are visible from Settings instead of being hidden implementation detail.
- Route and playback behavior can now leave a local QA trail without changing iOS behavior or introducing a backend dependency.

## Search and indexing impact

- None in this phase.
- This was an observability and quality pass, not a discovery-surface change.

## Follow-up enhancement options

1. Add a lightweight diagnostics export or companion-device handoff only after Phase 25 regression coverage proves the payload is trustworthy.
2. Add route-level focus and playback recovery quality notes once Phase 25 focus-navigation QA begins.
3. Decide whether later release analytics should remain fully local-first on tvOS or selectively mirror only privacy-safe aggregate counters from companion devices.
4. Add a small native crash-context snapshot for active route and profile only if it stays local-first and does not complicate launch stability.
