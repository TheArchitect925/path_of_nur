# tvOS Phase 25 — test suite, focus navigation QA, and regression harness

Date: 2026-03-25

## Goal

Add a shared regression harness for tvOS shell and focus behavior so enabled routes, ordered focus sections, sidebar return expectations, and guardrail-backed QA coverage cannot drift silently.

## Plan

1. Add a shared focus QA matrix for the current enabled tvOS route set.
2. Add regression helpers that compare the QA matrix with enabled sidebar routes and existing quality guardrails.
3. Add tests for route coverage, focus ordering, high-risk routes, and telemetry-backed QA expectations.
4. Verify with Flutter analyze, Flutter tests, and an unsigned native tvOS Release build.

## Implemented

### Shared focus QA contract

- Added `lib/features/tvos/domain/tvos_focus_regression_models.dart`.
- Added `lib/features/tvos/data/tvos_focus_regression_matrix.dart`.
- Added `lib/features/tvos/application/tvos_focus_regression.dart`.

The shared matrix now records, for each enabled tvOS route:

- canonical route path
- default section ID
- ordered section IDs
- left-edge sidebar escape expectation
- content-focus restore expectation
- navigation restore expectation
- modal-return coverage requirement
- route-level focus regression risk

### Regression tests

- Added `test/features/tvos/tvos_focus_regression_test.dart`.

The new tests now assert:

- every enabled sidebar route has focus QA coverage
- each route keeps stable default-first section ordering
- quality-guardrail surfaces that require focus QA are covered by the matrix
- Qur'an remains the highest-risk focus route because it combines browse, reader, playback, and listening-mode return
- Settings keeps explicit regression coverage for startup, listening, and support sections
- active focus-QA routes all expect both navigation restore and content restore
- focus-QA telemetry surfaces include route-open, settings-change, and playback-error coverage

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase25_modulecache`

Result:

- `** BUILD SUCCEEDED **`

## Outcome

- tvOS now has an explicit shared regression harness for shell and focus behavior.
- The enabled route set, focus order, and focus-QA-required surfaces now fail together if they drift.
- Future tvOS route additions can extend the same matrix instead of inventing ad hoc QA notes or route-local assumptions.

## Search and indexing impact

- None in this phase.
- This was a test and regression-hardening pass, not a content-discovery change.

## Follow-up enhancement options

1. Add native XCTest or UI-test coverage for the highest-risk Qur'an focus paths once the tvOS target gains a dedicated test target.
2. Add a small generated report that turns the shared focus QA matrix into a release checklist artifact for TestFlight QA.
3. Add a parity alert test that fails when native tvOS route sections change without a matching update to the shared focus matrix.
4. Add real-device Apple TV QA evidence capture for sidebar return, listening-mode exit, and profile-switch resume once Phase 27 release readiness begins.
