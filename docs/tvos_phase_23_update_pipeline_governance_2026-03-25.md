# tvOS Phase 23 — update pipeline and release governance

Date: 2026-03-25

## Goal

Turn the current tvOS shell and release-check work into an explicit governed update pipeline, with one shared source of truth for the active channel, gated route set, required phases, and blocking release gates.

## Plan

1. Add a shared tvOS governance model for update channel, release gates, and governed route scope.
2. Add tests so the governed route set cannot drift away from the enabled sidebar surfaces or the release-stage posture.
3. Align the TestFlight checklist with the actual shipped tvOS route scope and governed release gates.
4. Verify with Flutter analyze, shared tests, and an unsigned native tvOS Release build.

## Implemented

### Shared governance layer

- Added `lib/features/tvos/domain/tvos_release_governance_models.dart`
- Added `lib/features/tvos/data/tvos_release_governance.dart`
- Added `lib/features/tvos/application/tvos_release_governance.dart`
- Added `test/features/tvos/tvos_release_governance_test.dart`

The governance layer now defines:

- current update channel: `testflight`
- current governed release stage: `testflight`
- governed route scope as the enabled sidebar route set
- required gating phases:
  - Phase 21
  - Phase 22
  - Phase 24
  - Phase 25
  - Phase 26
  - Phase 23
- explicit release gates for:
  - unsigned tvOS Release build
  - focus regression harness
  - diagnostics and crash guardrails
  - large-surface performance profile
  - checklist maintenance
  - companion-managed sync posture
  - real-device Apple TV QA

### Governance posture

- TestFlight promotion is now explicitly allowed only at the current governed stage.
- Public-store promotion remains blocked because real-device Apple TV QA is still open.
- The shared governance snapshot now reflects the actual active route scope instead of the earlier Home-plus-Qur’an-only assumption.

### Checklist alignment

- Updated `docs/tvos_testflight_release_checklist_2026-03-25.md`
- The checklist now reflects the real governed route scope:
  - Home
  - Profiles
  - Qur'an
  - Saved
  - Settings
  - Arabic
  - Learn
  - Games
  - Prayer
  - Dhikr
  - Kids
- QA items were expanded to match the current shell, focus, diagnostics, and route-return expectations.

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart test/features/tvos/tvos_performance_profiles_test.dart test/features/tvos/tvos_release_governance_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart test/features/tvos/tvos_performance_profiles_test.dart test/features/tvos/tvos_release_governance_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase23_modulecache`

Result:

- `** BUILD SUCCEEDED **`

## Outcome

- tvOS update governance is now explicit in shared code instead of living only in scattered docs.
- The governed route set now stays tied to the real enabled sidebar route set.
- Public-release claims remain blocked by an explicit real-device QA gate instead of vague checklist wording.

## Search and indexing impact

- None in this phase.
- This was a release-governance and pipeline-hardening pass, not a discovery/indexing change.

## Follow-up enhancement options

1. Add an exportable release-governance summary that can be attached to TestFlight review notes or internal QA tickets.
2. Add environment-aware governance snapshots only if tvOS later needs separate internal and external TestFlight route scopes.
3. Add a build-time check that fails if the TestFlight checklist and shared governed route set drift apart again.
4. Add real-device QA evidence capture and checklist completion logging before Phase 27 public-readiness decisions.
