# Phase 25B Regression Hardening Backlog

Date: 2026-03-23

## Completed in Phase 25B

- Stabilized the previously red high-signal regression slice:
  - `test/app/quran_route_integrity_test.dart`
  - `test/features/journey/growth_home_ia_test.dart`
  - `test/features/learn/salah/wudu_trainer_page_test.dart`
  - `test/features/learn/learn_placeholder_containment_test.dart`
- Fixed the Wudu trainer state-save bug that was undoing manual back navigation.
- Added Material ancestry to shared tappable surfaces that were failing under real widget composition and tests.
- Migrated a large set of live user-facing strings from runtime shim extensions into generated ARB-backed localization.

## Follow-up Enhancements

- Finish the remaining Qur'an live-surface localization migration and remove the leftover compatibility extension accessors that are no longer needed.
- Finish the remaining Growth live-surface localization migration so Browse All, path detail, habit detail, and related dashboards stop depending on runtime shim helpers.
- Replace the remaining Wudu bridge literals with fully generated `AppLocalizations` methods once all formatted helper variants are added cleanly to ARB resources.
- Reduce the remaining Kids Arabic runtime-localization bridge surface after the new ARB-backed keys have been exercised on device and in widget tests.
- Add a focused localization verification test batch for the migrated Qur'an, Growth, Games, Wudu, and Kids Arabic live strings so future regressions do not silently fall back to English-only shims.
- Revisit `LearnQuranHubPage` in a later ownership phase; Phase 25B intentionally did not remove or redesign it.
- Keep route alias cleanup, writing-system unification, and Learn/Qur'an ownership consolidation deferred to later scoped phases.

## Validation Targets To Preserve

- `flutter analyze`
- `flutter test test/app/router_smoke_test.dart test/app/router_deep_links_test.dart`
- `flutter test test/app/quran_route_integrity_test.dart`
- `flutter test test/features/journey/growth_home_ia_test.dart`
- `flutter test test/features/learn/salah/wudu_trainer_page_test.dart`
- `flutter test test/features/learn/learn_placeholder_containment_test.dart`
