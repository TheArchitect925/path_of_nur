# Localization Integrity Backlog

Scope: whole-app language correctness sweep (pass 1)
Date: 2026-03-17

## Current status
- Locale propagation is now tested and verified in app tests:
  - Locale updates reach routed pages.
  - RTL directionality is verified for Arabic.
  - Unsupported/invalid locale input falls back safely.
- Existing hardcoded strings remain across many screens and remain the main blocker for complete localization parity.

## High-priority files with hardcoded user-facing strings (`Text(...)` literals)
This is an automated count from `lib/{app,features,shared,core}` and is a starting backlog.

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart` (46)
- `lib/features/profile/presentation/settings_page.dart` (35)
- `lib/features/journey/presentation/growth_reflection_page.dart` (27)
- `lib/features/journey/presentation/growth_habit_detail_page.dart` (21)
- `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart` (23)
- `lib/features/worship/presentation/widgets/dhikr_section.dart` (18)
- `lib/features/creation_explorer/presentation/creation_explorer_page.dart` (17)
- `lib/features/worship/presentation/widgets/prayer_section.dart` (16)
- `lib/features/learn/prophets/presentation/prophets_quiz_view.dart` (16)
- `lib/features/learn/presentation/pages/learn_quran_hub_page.dart` (14)
- `lib/features/learn/world/presentation/world_landing_page.dart` (13)
- `lib/features/onboarding/presentation/onboarding_page.dart` (11)

## Additional backlog items
- Large number of non-English locale files still report untranslated entries for recently added keys.
- Legacy screens still contain many literal English labels/actions/snackbars.

## Recommended next actions
1. Start with high-traffic pages before deeper surfaces:
   - Home, Worship, Learn tabs, Prayer screens, Settings, Accounts Sync.
2. Convert screen-wide literal strings in dialogs, snackbars, button labels, and empty states first.
3. For each page, prefer reusing existing `AppLocalizations` keys before introducing new ones.
4. Keep `l10n.yaml` warnings clean and use generated report to validate untranslated key count drops.

## Validation added in this pass
- `test/app/locale_integration_test.dart`
  - verifies locale transitions, directionality, fallback for unsupported locale, and route consistency.
- `test/test_helpers/app_test_harness.dart`
  - locale-aware MaterialApp in test harness now reads from `appLocaleProvider` so locale changes update widget tree.
- `test/app/router_smoke_test.dart`
  - `/learn` route expectation updated to `LearningJourneyHomePage` to match active learn entrypoint.

## Batch 7 follow-up options — Kids Mode + UI Layer
- Add kids-specific wording for remaining non-content learning shell controls that still intentionally fall back to adult copy.
- Review whether bottom navigation labels should gain kid variants or stay stable for consistency.
- Add non-English translations for the new `kids*` keys introduced in Batch 7.
- Audit kids-mode semantics wording for screen readers after Batch 10 accessibility pass.
- Consider a small reusable kids-copy helper if Batch 8+ introduces more variant selection points.

## Batch 8 Follow-up Enhancements
- Localize seeded revelation-era metadata in `lib/features/learn/prophets/data/seeded_revelation_eras.dart` through metadata maps instead of inline English strings.
- Move prophet family-tree group titles/summaries into localized metadata helpers so lineage cards do not rely on English seed data.
- Extract provider-seeded learning metadata prompts and practice-action labels from `learn_system_engine_provider.dart` into reusable localized helper maps.
- Add non-English translations for the new Batch 8 metadata keys after English review is approved.
