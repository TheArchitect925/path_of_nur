# Translation Completion Phase Plan

Last updated: 2026-03-24

## Goal

Finish translation readiness across the app without a broad rewrite by working through tightly scoped implementation phases.

## Phase 1: Localization Workflow Integrity

Status: completed

- Add `untranslated-messages-file` to `l10n.yaml`.
- Regenerate localization outputs and capture the current untranslated report.
- Use the report plus existing i18n audit docs to establish the current baseline.
- Keep this phase narrow: no large UI string migration yet.

## Phase 2: Settings + Accounts + Home

Status: completed

- Localize remaining hardcoded user-facing strings in:
  - `lib/features/profile/presentation/settings_page.dart`
  - `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
  - `lib/features/home/presentation/home_page.dart`
- Replace any remaining English helper/snackbar/dialog copy in these high-traffic surfaces.
- Reuse existing ARB keys where possible before introducing new ones.
- Completed scope in this pass:
  - stabilized the untranslated-report workflow and cleared the true missing-key baseline
  - replaced the remaining English fallback values used by the Settings landing, the main Accounts/Profile/Sync surface, and the Home Names-of-Allah search subtitle in `ar`, `de`, and `ur`
  - localized the Settings Qur'an display helper subtitles that were still in English on the same release-priority locales

## Phase 3: Qur'an Core Surfaces

Status: completed

- Localize remaining reader, hub, and helper strings in the active Qur'an experience.
- Prioritize:
  - `lib/features/learn/quran/presentation/quran_reader_page.dart`
  - `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`
  - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
  - `lib/features/learn/quran/presentation/pages/quran_topic_explorer_page.dart`
- Preserve playback and highlight architecture while moving remaining live strings into ARBs.
- Completed scope in this pass:
  - localized the live hardcoded reader strings still visible in `quran_reader_page.dart`, including settings-sheet labels, continue-recitation copy, transliteration fallback/error copy, word-translation prefix, reciter sample failure, and download status snackbars
  - added matching ARB keys across all supported locales so the untranslated report stayed clean
  - provided real locale values for `ar`, `de`, and `ur`, while leaving English fallback values in the remaining locales for a later locale-value completion phase

## Phase 4: Learn + Celestial + Creation

Status: completed

- Localize remaining hardcoded strings in:
  - Hadith landing and related Learn surfaces
  - `celestial_explorer_page.dart`
  - `celestial_cycle_card.dart`
  - creation explorer / world and creation surfaces
- Align any recent homepage / celestial polish work with ARB-backed copy.
- Completed scope in this pass:
  - localized the visible hardcoded celestial copy in the homepage sky card and the sky explorer page
  - localized the visible hardcoded Creation Challenges page chrome, state labels, CTAs, and summary pills
  - confirmed Hadith presentation was already largely localized and deferred broader Learn-surface cleanup to a later pass
  - added matching locale keys across all supported locales so the untranslated report remained clean

## Phase 5: Journey + Worship Helper Debt

Status: completed

- Localize Growth Reflection and habits surfaces.
- Replace helper-level English output in prayer, fasting, and growth shared logic with presentation-safe mappings.
- Clean up any remaining UI surfaces still showing raw English from enums/helpers.
- Completed scope in this pass:
  - localized the visible hardcoded Khusū section and Khusū focus page copy in Worship
  - replaced the remaining dhikr-session duration helper with a localization-backed formatter
  - confirmed broader Growth/Journey surfaces were already largely localization-backed and deferred larger helper/domain cleanup outside the active visible Khusū path

## Phase 6: Locale Value Completion

Status: completed (scoped pass)

- Replace English fallback values in non-English ARBs with real locale text.
- Prioritize release-impact locales first:
  - `ar`
  - `ur`
  - `de`
  - `id`
  - `tr`
- Keep shape consistency and generator health intact.
- Completed scope in this pass:
  - audited the release-priority locale fallback debt and deliberately narrowed the pass to recent high-traffic surfaces rather than rewriting hundreds of older fallback entries in one step
  - replaced the recent English fallback values in `id` and `tr` for the active Qur'an playback/reader surfaces, shell mini-player, celestial surfaces, Creation Challenges, and Khusū copy introduced in earlier phases
  - regenerated localization outputs and kept the untranslated report clean so the rollout can continue safely

## Phase 7: Final Multilingual QA

Status: completed (verification pass)

- Re-run `flutter gen-l10n` and `flutter analyze`.
- Run multilingual widget/route QA on high-traffic flows.
- Check truncation, RTL, plural/placeholder rendering, and empty/failure states.
- Confirm no remaining release-blocking hardcoded strings or missing translations in scoped release locales.
- Completed scope in this pass:
  - re-ran `flutter gen-l10n` and confirmed the untranslated-messages report stayed empty
  - re-ran focused analyzer coverage across the high-traffic localized surfaces touched in Phases 2–6
  - ran route/widget tests covering the real Qur'an reader route and shell mini-player surfaces after the localization changes
  - audited remaining fallback-value debt and confirmed it is still broader than this rollout, but no new release-blocking missing-key or generator issues remain in the scoped locales

## Notes

- The untranslated generator report is now clean, but many non-English ARBs still rely on English fallback values for newer keys.
- Phase 6 improved `id` and `tr` for the most recent high-traffic keys, but broader fallback-value debt still remains across older Learn, Accounts Sync, and helper strings.
- The practical translation debt is larger than missing-key count alone because hardcoded UI strings and helper/domain English output still remain in active surfaces.
- This rollout completed the planned high-traffic localization phases and verification passes, but it does not mean every locale file now contains fully native translations for all app content.
