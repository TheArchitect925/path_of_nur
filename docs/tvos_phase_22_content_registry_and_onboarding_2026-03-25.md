# tvOS Phase 22: Shared Content Registry and Modular Section Onboarding

Date: 2026-03-25

## Scope completed

- Added a shared tvOS content-module registry in Flutter for mirrored Home and Qur'an sections.
- Introduced stable module IDs, route/module ordering, module kinds, and onboarding rules.
- Bound the onboarding logic to the Phase 21 feature-flag/parity policy so module activation now follows one shared rule path.

## New shared registry pieces

- `lib/features/tvos/domain/tvos_content_registry_models.dart`
  - stable module IDs
  - module kinds
  - route content bundle model
- `lib/features/tvos/data/tvos_content_registry.dart`
  - canonical tvOS content module registry
  - route bundle definitions for `/home` and `/quran`
  - stable lookup helpers by route and section key
- `lib/features/tvos/application/tvos_content_registry.dart`
  - onboarding helper that filters modules by:
    - route enablement
    - current release stage
    - enabled section flags
    - declared module dependencies
  - provider-backed onboarded route bundles

## Registry decisions encoded

- Home module order:
  1. `home.prayerSummary`
  2. `home.continueReading`
  3. `home.dailyVerse`
- Qur'an module order:
  1. `quran.continueReading`
  2. `quran.dailyVerse`
  3. `quran.playback`
  4. `quran.browse`
- Module onboarding now depends on the shared tvOS release-stage and section-flag system from Phase 21.

## Verification

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- Result: passed

## Notes

- This phase did not add new user-facing surfaces.
- This is the onboarding contract future tvOS sections should use instead of adding route-local module lists.
- No mobile/iOS behavior was changed.

## Recommended next follow-ups

1. Phase 5 and Phase 6 should consume the onboarded module bundles when expanding Home and Qur'an instead of manually ordering sections again.
2. Future tvOS surfaces should be added through the same registry with stable IDs and route bundle definitions.
3. A later native bridge/export pass can serialize the onboarded module bundles together with feature flags and parity payloads.
