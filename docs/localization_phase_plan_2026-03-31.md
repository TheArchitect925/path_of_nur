# Localization Phase Plan

Date: 2026-03-31

## Goal

Reduce live English fallback across active surfaces in a controlled 10-phase pass, prioritizing high-traffic routes, generated ARB-backed strings, and safe validation after each batch.

## Phase sequence

1. Settings fallback cleanup
   - target live SettingsPage ARB-backed strings still falling back to English
   - start with smaller active locales to validate the workflow safely
2. Accounts and backup flows
   - `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
   - backup/import/export/status wording
3. Home and Worship summary surfaces
   - prayer section
   - dhikr section
   - summary and empty-state wording
4. Learn landing and high-traffic browse surfaces
   - Learn landing
   - Qur'an learning hub
   - world and life browse surfaces
5. Salah and guided-worship helper surfaces
   - guided prayer
   - wudu helper/fallback text
   - prayer-settings secondary strings
6. Qur'an helper and fallback surfaces
   - shared Qur'an helper labels
   - reflection and note-adjacent copy
   - read/learn helper text
7. Dua, FAQ, and small fallback/error surfaces
   - dua detail fallback/action text
   - FAQ error/fallback strings
   - shared low-risk helper text
8. Kids and family learning follow-up
   - kids-facing wrappers
   - family management and bedtime-library helper strings
   - remaining settings-adjacent family copy
9. Non-English ARB parity sweep
   - reduce same-as-English values for active keys across the remaining locale files
   - resolve structural placeholder mismatches
10. Final QA and release audit
   - analyzer
   - localization validation
   - focused manual spot-check list for iOS/iPadOS

## Phase 1 result

- Live SettingsPage code already used `AppLocalizations` widely, so the real issue was ARB fallback rather than hardcoded widget strings.
- Phase 1 updated a safe first batch of locale resources:
  - `lib/l10n/app_de.arb`
  - `lib/l10n/app_ur.arb`
- Verified with `flutter analyze lib/features/profile/presentation/settings_page.dart`.

## Remaining note

- Additional phases are still required after Phase 1.
- We are not yet below the five-phase threshold, so Apple Watch and tvOS release-readiness work does not start yet.

## Phase 2 result

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart` already used `AppLocalizations` broadly, so this phase focused on ARB fallback cleanup rather than page refactors.
- Phase 2 updated a safe first Accounts/Profile/Sync fallback batch in:
  - `lib/l10n/app_de.arb`
  - `lib/l10n/app_ur.arb`
- The targeted top-level backup/profile/sync section strings no longer fall back to English in those locales.
- Verified with `flutter analyze lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`.

## Remaining note after Phase 2

- Additional phases are still required after Phase 2.
- We are not yet below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet.

## Phase 3 result

- `lib/features/home/presentation/home_page.dart`, `lib/features/worship/presentation/widgets/prayer_section.dart`, and `lib/features/worship/presentation/widgets/dhikr_section.dart` were already reading generated `AppLocalizations`, so this phase again focused on ARB fallback cleanup instead of widget rewrites.
- Phase 3 updated a safe Home/Worship summary batch in:
  - `lib/l10n/app_de.arb`
  - `lib/l10n/app_ur.arb`
- The targeted visible Home, prayer, and dhikr helper strings no longer fall back to English in those locales.
- Same-value Arabic source text, transliteration, and a few stable Islamic terms were intentionally left unchanged where they are not true English fallback debt.
- Verified with `flutter analyze lib/features/worship/presentation/widgets/prayer_section.dart lib/features/worship/presentation/widgets/dhikr_section.dart lib/features/home/presentation/home_page.dart`.

## Remaining note after Phase 3

- Additional phases are still required after Phase 3.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet.

## Phase 4 result

- `lib/features/learn/world/presentation/world_landing_page.dart` had a concentrated set of hardcoded live English strings, so this phase localized that screen directly through generated `AppLocalizations` instead of only patching ARBs.
- `lib/features/learn/life/presentation/life_landing_page.dart` had a smaller set of hardcoded filter and tab labels; those now also use generated localization.
- A compact ARB cleanup batch also removed visible fallback debt on the active Learn landing, Qur'an learning hub, and Hadith landing surfaces for the targeted locales.
- This phase also fixed pre-existing ICU quote-escaping blockers in `app_bn.arb`, `app_fa.arb`, and `app_fa_AF.arb` so `flutter gen-l10n` could run cleanly again.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/learn/world/presentation/world_landing_page.dart lib/features/learn/life/presentation/life_landing_page.dart lib/features/learn/presentation/pages/learning_section_landing_page.dart lib/features/learn/presentation/pages/learn_quran_hub_page.dart lib/features/learn/hadith/presentation/hadith_landing_page.dart`.

## Remaining note after Phase 4

- Additional phases are still required after Phase 4.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet.

## Phase 5 result

- `lib/features/learn/salah/presentation/salah_guided_prayer_page.dart` now uses generated localization for its live guided-prayer controls, progress labels, surah summary, and fallback states instead of hardcoded English strings.
- `lib/features/learn/presentation/pages/learn_salah_hub_page.dart` now localizes its title, guidance notice quote block, metrics, tab labels, search hints, guided-surah controls, recitation actions, and Wudu entry tiles.
- `lib/features/learn/salah/widgets/wudu_cards.dart` now uses generated localization for the required-vs-sunnah and reminder section headings.
- This phase also fixed ICU quote blockers in `app_ha.arb` so `flutter gen-l10n` can run again after the new worship keys were added.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/learn/salah/presentation/salah_guided_prayer_page.dart lib/features/learn/presentation/pages/learn_salah_hub_page.dart lib/features/learn/salah/widgets/wudu_cards.dart lib/features/learn/salah/widgets/wudu_trainer_widgets.dart lib/features/learn/salah/data/wudu_content.dart`.

## Remaining note after Phase 5

- Additional phases are still required after Phase 5.
- We are now at the five-phase boundary, not below it, so Apple Watch and tvOS release-readiness work still does not start yet under the rule you set.

## Phase 6 result

- The Phase 6 audit showed the biggest remaining visible debt in this slice was not widget logic but German and Urdu ARB fallback on smaller Qur''an helper surfaces.
- `lib/features/learn/quran/presentation/quran_search_page.dart` and `lib/features/learn/quran/presentation/quran_knowledge_search_page.dart` were already localized correctly enough for this pass, so they did not need risky page rewrites.
- Phase 6 removed the targeted same-as-English fallback on `Daily Qur''an Companion` and `Focus Recitation` labels in:
  - `lib/l10n/app_de.arb`
  - `lib/l10n/app_ur.arb`
- This clears the most visible German and Urdu fallback on the calmer Qur''an helper surfaces while leaving larger reader-scale cleanup for later phases.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/learn/quran/presentation/quran_search_page.dart lib/features/learn/quran/presentation/quran_knowledge_search_page.dart lib/features/learn/quran/presentation/quran_daily_companion_page.dart lib/features/learn/quran/presentation/quran_focus_recitation_page.dart`.

## Remaining note after Phase 6

- Additional phases are still required after Phase 6.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet under the rule you set.

## Phase 7 result

- The clearest remaining low-risk debt in this phase was on the live FAQ surfaces, where category filters, badges, detail-section headings, search-empty states, and load/not-found messages still used hardcoded English instead of generated localization.
- `lib/features/faq/pages/faq_landing_page.dart`, `lib/features/faq/pages/faq_category_page.dart`, `lib/features/faq/pages/faq_detail_page.dart`, `lib/features/faq/widgets/faq_question_tile.dart`, and `lib/features/faq/widgets/faq_category_card.dart` now use generated `AppLocalizations` for those live labels and fallback states.
- A small ARB cleanup in this phase also removed the remaining targeted German Dua title fallback for `duaHubTitle` and `duaDetailAppBarTitle`.
- This pass also fixed pre-existing ICU quote-escaping blockers in `app_ms.arb` so `flutter gen-l10n` could complete successfully again after the new FAQ keys were added.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/faq/pages/faq_landing_page.dart lib/features/faq/pages/faq_category_page.dart lib/features/faq/pages/faq_detail_page.dart lib/features/faq/widgets/faq_question_tile.dart lib/features/faq/widgets/faq_category_card.dart lib/features/learn/dua/presentation/dua_hub_page.dart lib/features/learn/dua/presentation/dua_detail_page.dart`.

## Remaining note after Phase 7

- Additional phases are still required after Phase 7.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet under the rule you set.

## Phase 8 result

- The Phase 8 audit showed the active kids/family wrapper pages were already using generated localization correctly in code, so this phase focused on ARB parity rather than unnecessary widget rewrites.
- The targeted live parent/family surfaces were:
  - `lib/features/kids_arabic/presentation/kids_arabic_parent_settings_page.dart`
  - `lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart`
  - `lib/features/learn/journey/presentation/family_learning_management_page.dart`
- Phase 8 removed the targeted German and Urdu same-as-English fallback on the visible parent/family labels used by those pages, especially Kids Arabic parent-settings copy and bedtime parent-dashboard helper text.
- This phase also fixed pre-existing ICU quote-escaping blockers in `app_pa.arb` so `flutter gen-l10n` could complete successfully again after the ARB updates.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/kids_arabic/presentation/kids_arabic_parent_settings_page.dart lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart lib/features/learn/journey/presentation/family_learning_management_page.dart`.

## Remaining note after Phase 8

- Additional phases are still required after Phase 8.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet under the rule you set.

## Phase 9 result

- The Phase 9 parity audit showed the biggest remaining structural issue was a shared block of `116` missing keys across the broader non-English locale set, not a new wave of widget-level localization mistakes.
- This phase synced that common missing-key block into the affected locale files so they now have structural parity with English for the active FAQ, Learn browse, and Salah-helper keys added in earlier phases.
- The affected locales were:
  - `app_ar.arb`
  - `app_hi.arb`
  - `app_id.arb`
  - `app_tr.arb`
  - `app_bn.arb`
  - `app_fa.arb`
  - `app_fa_AF.arb`
  - `app_ha.arb`
  - `app_ku.arb`
  - `app_ms.arb`
  - `app_pa.arb`
  - `app_ps.arb`
  - `app_tg.arb`
- After this pass, those locales moved from `116 missing` keys each to `0 missing` keys each for the current English keyset. Residual debt is now mostly same-as-English content quality rather than structural key absence.
- This phase also fixed pre-existing ICU quote-escaping blockers in `app_pa.arb` so `flutter gen-l10n` could complete successfully again after the parity sync.
- Verified with `flutter gen-l10n` and `flutter analyze lib/features/faq/pages/faq_landing_page.dart lib/features/learn/world/presentation/world_landing_page.dart lib/features/learn/life/presentation/life_landing_page.dart lib/features/learn/salah/presentation/salah_guided_prayer_page.dart lib/features/learn/presentation/pages/learn_salah_hub_page.dart lib/features/learn/salah/widgets/wudu_cards.dart`.

## Remaining note after Phase 9

- One additional phase is still required after Phase 9.
- We are still not below the five-phase threshold, so Apple Watch and tvOS release-readiness work still does not start yet under the rule you set.

## Phase 10 result

- Phase 10 focused on final localization QA and release-facing audit rather than another broad UI rewrite.
- Verified:
  - `flutter gen-l10n` passes
  - full `flutter analyze` passes
  - direct key-parity checks now show `0 missing` user-facing keys across the active locale files audited in this pass
- The stricter repo validator still reports follow-up debt:
  - metadata-only missing entries remain, most visibly:
    - `@quranTeachingPracticeRecommendationPhrasesSubtitle`
    - `@quranTeachingPracticeRecommendationWordsSubtitle`
    - plus additional generated metadata entries missing in `de` and `ur`
  - placeholder-shape drift remains in several locales, especially:
    - `bn`
    - `fa`
    - `fa_AF`
    - `ha`
    - `hi`
    - `id`
    - `ku`
    - `ms`
    - `pa`
    - `tr`
- This means the ten-phase plan successfully removed the high-value live-surface and structural key-gap blockers, but it did not finish the deeper locale-quality cleanup.

## Assessment after Phase 10

- Yes, additional work is still needed beyond the planned ten phases.
- The remaining work is narrower than when this pass started:
  - structural user-facing key absence is no longer the main problem
  - the remaining debt is mostly ARB metadata parity, placeholder mismatch repair, and replacing same-as-English fallback with real translations in the broader non-English locale set
- Apple Watch and tvOS release-readiness work still does not start under the rule you set, because the localization program still requires additional follow-up after the planned ten phases.
