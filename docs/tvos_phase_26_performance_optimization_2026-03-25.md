# tvOS Phase 26 — performance optimization for large-screen media surfaces

Date: 2026-03-25

## Goal

Reduce unnecessary eager rendering and repeated large-surface data work on the heaviest tvOS routes, especially Qur'an, Home, and Learn, while preserving the current remote-first behavior.

## Plan

1. Optimize the native tvOS large-surface routes that currently render the most cards and reading content.
2. Add a shared tvOS performance profile contract so the highest-cost surfaces stay explicit in future work.
3. Verify with Flutter analyze, shared tests, and an unsigned native tvOS Release build.

## Implemented

### Native performance improvements

- `TVHomeScreen.swift`
  - switched the horizontal continue-journey and featured-Qur'an shelves from eager `HStack` rendering to `LazyHStack`
- `TVLearnScreen.swift`
  - switched the primary shelf, per-section shelves, stories shelf, and visuals shelf to `LazyHStack`
  - switched the main sections column to `LazyVStack`
- `TVQuranScreen.swift`
  - switched the summary shelf and browse collections to `LazyHStack`
  - switched the surah list and ayah list to `LazyVStack`
- `TVAppViewModel.swift`
  - cached `selectedAyahs` inside `TVQuranViewModel` instead of re-reading the ayah payload on every access
- `TVSeedRepository.swift`
  - replaced repeated `DateFormatter` creation in the prayer snapshot path with a reusable static formatter

### Shared performance contract

- Added `lib/features/tvos/domain/tvos_performance_models.dart`
- Added `lib/features/tvos/data/tvos_performance_profiles.dart`
- Added `lib/features/tvos/application/tvos_performance_profiles.dart`
- Added `test/features/tvos/tvos_performance_profiles_test.dart`

The shared performance contract now identifies:

- Home as an elevated large-surface route
- Qur'an as the critical large-surface route that requires lazy rendering, cached selection payloads, and media-focus recovery awareness
- Learn as an elevated large-surface route that should keep shelves lazy

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart test/features/tvos/tvos_performance_profiles_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_quality_guardrails_test.dart test/features/tvos/tvos_focus_regression_test.dart test/features/tvos/tvos_performance_profiles_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase26_modulecache`

Result:

- `** BUILD SUCCEEDED **`

## Performance review summary

Unnecessary rebuilds / repeated work reduced:

- Qur'an no longer re-queries ayahs repeatedly through a computed property for every selection-driven access path.
- Home, Learn, and Qur'an shelves now avoid eagerly instantiating all off-screen cards in horizontal rails.

Widget tree / view depth improvements:

- The heaviest scroll-backed sections now use lazy containers where off-screen content does not need immediate layout or rendering work.

State efficiency improvements:

- Qur'an selection state now keeps the active ayah payload cached in the view model, which reduces repeated repository lookups during focus and playback changes.

Memory / render pressure improvements:

- Long surah and ayah stacks now load lazily.
- Learn and Home large-screen shelves now create fewer immediate off-screen views.

Animation / focus implications:

- Focus behavior is preserved, but the rendered surface set is lighter, which should reduce focus-transition cost on large content routes.

## Search and indexing impact

- None in this phase.
- This was a native rendering and performance-hardening pass, not a discovery/indexing change.

## Follow-up enhancement options

1. Add native Instruments-guided measurement for Qur'an browse-to-reader transitions and listening-mode open or close once real Apple TV device QA begins.
2. Add image and artwork loading strategy review if later phases introduce richer visual media on Learn or Kids shelves.
3. Add a focused cache and reuse review for tvOS seeded data if the target starts consuming larger shared payload bundles instead of the current curated sets.
4. Add a reduce-motion and focus-animation tuning pass only after real-device QA confirms whether current transitions still feel heavy on older Apple TV hardware.
