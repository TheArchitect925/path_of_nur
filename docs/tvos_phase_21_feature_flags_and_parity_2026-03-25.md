# tvOS Phase 21: Shared Feature Flag and Parity System

Date: 2026-03-25

## Scope completed

- Added a shared tvOS-only release/feature-flag system in Flutter for future phases.
- Introduced explicit availability, release-stage, and parity-health contracts for:
  - tvOS surfaces
  - mirrored tvOS sections
- Bound the new flag layer to the Phase 4 parity manifest so mirrored Home and Qur'an content stays under one shared policy path.

## New shared policy pieces

- `lib/features/tvos/domain/tvos_foundation_models.dart`
  - `TVOSReleaseStage`
  - `TVOSFeatureAvailability`
  - `TVOSParityHealth`
  - `TVOSSurfaceFlag`
  - `TVOSSectionFlag`
- `lib/features/tvos/data/tvos_foundation_registry.dart`
  - canonical surface flags for all tvOS roadmap surfaces
  - section flags derived from the mirrored content manifest
- `lib/features/tvos/application/tvos_release_policy.dart`
  - route-level enablement helpers
  - sidebar visibility helpers
  - shared parity payload requirements
  - release-stage readiness checks
- `lib/features/tvos/application/tvos_feature_flags.dart`
  - provider-backed accessors for enabled surfaces, sidebar surfaces, mirrored routes, and pending-parity surfaces

## Current policy decisions encoded

- Current tvOS release stage is `testflight`.
- Enabled shell/sidebar surfaces remain:
  - `/home`
  - `/quran`
- Later-phase surfaces are staged but not enabled.
- Settings and profiles remain intentionally unavailable on tvOS for now.
- Mirrored Home and Qur'an sections are explicitly marked as shared-parity-backed sections.

## Verification

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart`
- Result: passed

## Notes

- This phase did not change any mobile/iOS runtime behavior.
- This is a tvOS foundation policy system, not a new app-wide feature flag framework.
- Future tvOS phases should query these helpers instead of hardcoding route or section availability.

## Recommended next follow-ups

1. Phase 22 should onboard future tvOS sections through the new section-flag path.
2. Future native tvOS shell work can read the sidebar-enabled surface list from one shared policy source.
3. A later bridge/export pass can serialize surface and section flags alongside the parity payload bundle for native consumption.
