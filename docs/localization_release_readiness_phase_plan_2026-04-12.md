# Localization Release Readiness Phase Plan

Date: 2026-04-12

## Current release-readiness audit

- Missing-key parity is now clean:
  - every non-English locale file contains the English key set
- Recent Hadith and Qur'an targeted scopes are mostly clean, but the newest pass still left a small same-as-English fallback cluster:
  - `hadithSearchMatchChapter` in every non-English locale
  - `hadithProvenanceInfoTitle`
  - `hadithProvenanceInfoBody`
  - `hadithProvenanceInfoStatusTitle`
  - `hadithProvenanceInfoPipelineBody`
  - `hadithReaderBackToLane`
  - `hadithReaderChapterPosition`
  - `hadithReaderPosition`
  - and in lower-coverage locales:
    - `hadithReaderDisplaySettingsTitle`
    - `hadithReaderDisplaySettingsSubtitle`

## Full-app same-as-English fallback counts

- `ar`: 2951
- `de`: 3025
- `ur`: 3206
- `hi`: 4997
- `tr`: 9095
- `id`: 9111
- `fa`: 9852
- `fa_AF`: 9898
- `ps`: 9908
- `tg`: 9913
- `pa`: 9916
- `ms`: 9925
- `bn`: 9901
- `ha`: 9981
- `ku`: 10196

## Highest remaining surface families by fallback volume

1. `learn`
2. `quran`
3. `kids`
4. `growth`
5. `hadith`
6. `onboarding`
7. `account`
8. `home`
9. `arabic`
10. `wudu` / `worship` / `salah`

## Release rule

For release readiness, no English fallback text should remain in shipped locale bundles for launch-enabled user-facing surfaces.

## Recommended locale tiers

### Tier A

- `ar`
- `de`
- `ur`
- `hi`

### Tier B

- `tr`
- `id`
- `bn`

### Tier C

- `fa`
- `fa_AF`
- `ha`
- `ku`
- `ms`
- `pa`
- `ps`
- `tg`

## Phases

### Phase 1: Immediate Recent Fallback Cleanup

Status: completed 2026-04-12

- Finish the newest Hadith/Qur'an reader/search keys left in English after the last enhancement pass
- Re-run:
  - `dart run tool/localization_surface_audit.dart --group broader_hadith_quran --group hadith_reader_phase3`
- Goal:
  - bring the active recent-scope groups back to `0` same-as-English fallbacks in all locales

### Phase 2: Release Shell and System Copy

Status: in progress 2026-04-12

- Onboarding
- App shell and shared navigation copy
- Settings
- Accounts / backup / restore
- Notifications and reminder strings
- Home launch surfaces
- Goal:
  - all first-run and daily-entry surfaces are translation-complete before feature-depth work

Progress checkpoint 2026-04-12:

- Completed Tier A notification/system copy cleanup for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - prayer reminder channel labels/descriptions
  - prayer-at-time titles/bodies
  - `On This Day` notification copy
  - generic prayer naming and `Tahajjud`
  - iftar body/title copy
  - fasting live Arabic-title/dua display strings
- Remaining Phase 2 scope still includes:
  - onboarding
  - settings
  - accounts / backup / restore
  - home shell/launch surfaces

Progress checkpoint 2026-04-12 (continued):

- Completed Tier A core onboarding setup copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - learning-path framing
  - skip / continue / begin journey actions
  - Shahada meaning
  - Bismillah transliteration and meaning
  - opening blessing
  - language choice
  - age range
  - experience level
  - salah consistency
  - prayer time calculation method
  - madhab selection
- Remaining onboarding work in Tier A is now the later onboarding sections rather than the first-run core setup block.

Progress checkpoint 2026-04-13 (Tier C notifications batch 2):

- Completed Tier C notification/system copy cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - prayer reminder channel labels/descriptions
  - prayer-at-time titles/bodies
  - `On This Day` notification copy
  - moonrise/moonset notification copy
  - prayer and reflection action labels
  - generic prayer naming
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Remaining exact-English carryovers in this targeted notifications batch are intentional canonical/source-text rows only:
  - Arabic fasting live titles and dua lines
  - empty canonical `notificationsFastingLiveRenewIntentionArabic`

Progress checkpoint 2026-04-13 (Tier C shared all-search batch):

- Completed Tier C shared `allSearch*` shell cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - all-search title, subtitle, and search hint
  - empty-state and no-results guidance
  - recent-search and suggestions headings
  - domain jump actions
  - suggestion chips
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Remaining exact-English carryovers in this targeted search batch are intentional canonical/shared terms only:
  - `Qur’an`
  - `Hadith`
  - shared lowercase `dua`

Progress checkpoint 2026-04-13 (Tier C assistant shell batch):

- Completed Tier C shared `assistant*` shell cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - assistant title and subtitle
  - empty-state guidance
  - message input hint
  - quick prompts, recent prompts, and quick actions headings
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `assistant*` block now has `0` exact-English matches in `ku`, `ms`, `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C learning journey stage reading batch):

- Completed Tier C `learningJourneyStageReading*` cleanup for:
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - stage card titles for Fathah, Kasrah, Dammah, Sukun, and Shaddah
  - joining-letters and checkpoint stage summaries
  - completion handoff title and summary
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `learningJourneyStageReading*` block now has `0` exact-English matches in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C learning journey stage Ramadan batch):

- Completed Tier C `learningJourneyStageRamadan*` cleanup for:
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - Ramadan overview, why-fast, suhoor/iftar, breaks-fast, Laylat al-Qadr, spiritual-goals, and common-mistakes stage cards
  - localized titles and summaries for the full Ramadan stage lane
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `learningJourneyStageRamadan*` block now has `0` exact-English matches in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C learning journey stage fiqh batch):

- Completed Tier C `learningJourneyStageFiqh*` cleanup for:
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - halal/haram, cleanliness, salah basics, fasting basics, zakat basics, daily-life scenarios, and practical-review stage cards
  - localized titles and summaries for the full fiqh stage lane
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `learningJourneyStageFiqh*` block now has `0` exact-English matches in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C learning journey stage timeline batch):

- Completed Tier C `learningJourneyStageTimeline*` cleanup for:
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - early-prophets, Prophet-era, khulafa, expansion, golden-age, modern-context, and completion stage cards
  - localized titles and summaries for the full timeline stage lane
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `learningJourneyStageTimeline*` block now has `0` exact-English matches in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C learning journey stage stories batch):

- Completed Tier C `learningJourneyStageStories*` cleanup for:
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - sky, ocean, mountains, animals, human-creation, day-and-night, and completion stage cards
  - localized titles and summaries for the full stories stage lane
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `learningJourneyStageStories*` block now has `0` exact-English matches in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C accessibility shell batch):

- Completed Tier C shared `accessibility*` shell cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - reminder/help and playback-control labels
  - dhikr, salah, qada, camera, and reflection accessibility labels
  - favorite/save/review actions
  - learning-settings and sources/licensing accessibility copy
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Targeted batch result:
  - the `accessibility*` block now has `0` exact-English matches in `ku`, `ms`, `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C Creation Explorer shell batch):

- Completed Tier C shared `creationExplorer*` shell cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - Creation Explorer title, subtitle, tabs, and metrics
  - camera-access, on-device detection, and stable-label guidance
  - saved observation and reflection journal copy
  - the companion sky-explorer explainer
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Remaining exact-English carryovers in this targeted batch are intentional proper-name labels only:
  - `creationExplorerSkyExplorerAction` in `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C history/contextual/nav shell batch):

- Completed Tier C shared `history*`, `contextualLinks*`, `nav*`, and `majorPageShortcut*` shell cleanup for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - On This Day and archive titles, filters, states, categories, and metadata labels
  - contextual related-link types
  - shared nav labels
  - major page shortcut labels
- Validation result:
  - `flutter gen-l10n`
  - `flutter test test/app/localization_arb_regression_test.dart`
- Remaining exact-English carryovers in this targeted batch are intentional canonical/shared or format-only rows:
  - `historyCategoryKhulafa`
  - `historyCategorySeerah`
  - `contextualLinksTypeHadith`
  - `navDhikr`
  - format-only date templates such as `historyGregorianDateValue`, `historyHijriDateValue`, `historyTodayGregorianValue`, and `historyTodayHijriValue`

Progress checkpoint 2026-04-12 (settings shell batch):

- Completed Tier A settings shell copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - widget enablement copy
  - Midnight Manuscript theme naming and description
  - theme mode guidance / “best for” helper copy
  - page transition settings
  - learning level label
  - run-onboarding-again labels
- Remaining settings work in Tier A is now mostly:
  - prayer/madhab/calculation labels where recognized forms were intentionally preserved or still need a dedicated terminology decision
  - structural profile summary rows
  - account/sync-adjacent settings text

Progress checkpoint 2026-04-12 (accounts shell batch):

- Completed Tier A account shell copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - account status card states
  - current mode / provider / last backup labels
  - local-only and connected-account summaries
  - Apple / Google / Email / local-only actions
  - sign-in/out result copy
  - sync preference labels
  - top-level remote backup and restore comparison section copy
- Remaining accounts work in Tier A is now mostly the deeper restore-domain, auto-backup, scope, import/export, and conflict-detail strings.

Progress checkpoint 2026-04-12 (home shell visible batch):

- Completed Tier A visible home shell and launch copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - home dashboard summary cards
  - fasting and Khusu home summary labels
  - learn and journey summary tiles
  - welcome, intention, and location prompt copy
  - search tooltips and search empty-state copy
  - visible prayer-state helper copy
  - home widget labels and countdown text
- Validation result:
  - the visible `home*` launch/dashboard set now reports `0` same-as-English fallbacks in `ar`, `de`, `ur`, and `hi` once experimental/test-only keys are excluded
- Remaining home work in Tier A is now mostly:
  - experimental `homeGlassVariant*` preview copy
  - lower-priority test/debug home strings if any are still release-facing
  - non-home shell/system strings already tracked elsewhere in Phase 2

Progress checkpoint 2026-04-12 (accounts restore and auto-backup batch):

- Completed Tier A deeper accounts restore and auto-backup copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - remote restore preview comparison copy
  - remote conflict and merge-status labels
  - remote backup warning/explanation strings
  - auto-backup titles, statuses, reasons, and eligibility messages
  - placeholder-only account/profile summary rows that were still exact-English
- Validation result:
  - the targeted restore-preview and auto-backup accounts batch now reports `0` same-as-English fallbacks in `ar`, `de`, `ur`, and `hi`
- Remaining accounts work in Tier A is now mostly:
  - scope configuration copy
  - export/import picker and file-handling copy
  - backup-found / backup-success / restore-success result strings
  - provider-setup and provider-unavailable follow-up strings outside this batch

Progress checkpoint 2026-04-12 (Tier A onboarding completion batch):

- Completed the remaining Tier A onboarding copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - growth interests and tracking choices
  - Qur'an reading mode, harakat, and text-size choices
  - family-growth copy
  - dhikr feedback, sound, haptic, and visual preview copy
  - identity and final welcome copy
  - onboarding mission, disclaimer, and theme preview copy
  - optional sign-in and manual-backup onboarding explanations
- Validation result:
  - the remaining onboarding same-as-English matches in Tier A are now limited to intentional carryovers such as:
    - `onboardingProgressValue`
    - recognized transliteration and source labels
    - recognized prayer-method and madhab names
    - language labels that intentionally keep the native language name

Progress checkpoint 2026-04-12 (Tier A settings/accounts scope-import-export batch):

- Completed the remaining Tier A settings/accounts tail for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - structural settings/profile summary rows
  - prayer adjustment suggestion formatting
  - sync-scope section titles, summaries, and impact copy
  - remote backup found/success/failure/provider-status result copy
  - export/share backup copy
  - import file-picking, merge/replace, confirmation, and restore-error copy
  - sync transport/status fallback labels
- Validation result:
  - the targeted Tier A settings/accounts scope-import-export batch now reports `0` same-as-English fallbacks in `ar`, `de`, `ur`, and `hi`
- Remaining Phase 2 scope is now mostly:
  - experimental or lower-priority Tier A home preview/debug copy such as `homeGlassVariant*` if it is considered release-facing
  - Tier B shell/system rollout
  - Tier C shell/system rollout

Progress checkpoint 2026-04-12 (Tier A home preview/debug completion batch):

- Completed the remaining Tier A home preview/debug copy for:
  - `ar`
  - `de`
  - `ur`
  - `hi`
- This batch covered:
  - `homeGlassPreview*` comparison copy
  - `homeGlassVariant*` comparison copy
  - visible home test pills used by the preview tooling
- Validation result:
  - the targeted Tier A home preview/debug batch now reports `0` same-as-English fallbacks in `ar`, `de`, `ur`, and `hi`
- Remaining Phase 2 scope is now:
  - Tier B shell/system rollout
  - Tier C shell/system rollout

Progress checkpoint 2026-04-12 (Tier B notification/system batch):

- Completed Tier B notification/system copy cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - prayer reminder channel labels/descriptions
  - prayer-at-time title/body copy
  - `On This Day` notification copy
  - generic prayer naming
- Validation result:
  - the targeted Tier B notification/system batch now reports `0` same-as-English fallbacks for the translated keys in `tr`, `id`, and `bn`
- Intentional note:
  - `notificationsFastingLiveIftarArabicTitle` remains the shared Arabic label `الإفطار` across locales because it is canonical Arabic presentation, not English fallback

Progress checkpoint 2026-04-12 (Tier B onboarding core batch):

- Completed Tier B onboarding core copy cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - begin/continue onboarding actions
  - Shahada meaning and Bismillah meaning copy
  - opening blessing copy
  - age-range title/subtitle
  - experience title/subtitle and core experience options
  - salah consistency title/subtitle and core consistency options
  - prayer-method title/subtitle
  - madhab title/subtitle
- Validation result:
  - the targeted Tier B onboarding core batch now reports `0` same-as-English fallbacks for the translated keys in `tr`, `id`, and `bn`
- ICU note:
  - Turkish apostrophes were escaped to keep `flutter gen-l10n` valid after translation updates

Progress checkpoint 2026-04-12 (Tier B onboarding personalization batch):

- Completed the next Tier B onboarding cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - onboarding disclaimer and learning-path framing copy
  - language choice copy
  - growth-interest selection copy
  - Qur'an reading-mode and harakat preferences
  - reminder and tracking setup copy
  - family growth setup copy
  - dhikr feedback and preview copy
  - identity, greeting, and final welcome copy
  - onboarding disclaimer and theme-preview explanatory copy
- Validation result:
  - the targeted Tier B onboarding personalization batch now reports `0` same-as-English fallbacks for the translated keys in `tr`, `id`, and `bn` after excluding intentional carryovers like `onboardingWelcomeGreeting` and native-script language labels
- ICU note:
  - Turkish and Indonesian apostrophes were escaped where needed so `flutter gen-l10n` stayed valid

Progress checkpoint 2026-04-12 (Tier B settings shell batch):

- Completed the next Tier B settings shell cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - reminder on/off state copy
  - settings landing helper copy
  - widget enablement copy
  - Help & Guide search/browse/empty/not-found/steps copy
  - Midnight Manuscript theme naming and description
  - theme-picker helper and “best for” guidance copy
  - page-transition titles, subtitles, and transition style labels
  - learning-level and rerun-onboarding labels
- Validation result:
  - the targeted Tier B settings shell batch now reports `0` same-as-English fallbacks for the translated keys in `tr`, `id`, and `bn`
- ICU note:
  - Turkish apostrophes were escaped where needed so `flutter gen-l10n` stayed valid

Progress checkpoint 2026-04-12 (Tier B notification actions batch):

- Completed the next Tier B notification cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - before-qaza reminder channel copy
  - moonrise and moonset titles/bodies
  - Fajr prayer-time body copy
  - prayer notification action labels
  - reflection notification action labels
- Validation result:
  - the targeted Tier B notification action batch now reports `0` same-as-English fallbacks for the translated keys in `tr`, `id`, and `bn`
- Intentional note:
  - canonical Arabic fasting/iftar strings were not treated as English fallback in this batch

Progress checkpoint 2026-04-12 (Tier B accounts shell partial batch):

- Completed a shared Tier B accounts shell cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - avatar label cleanup
  - prayer-focused experience-mode label
  - shared device-platform labels
  - unknown transport and unavailable-status labels
  - Bangla provider label cleanup for Google
- Validation result:
  - the targeted shared account-status label batch now reports `0` same-as-English fallbacks in `bn`
  - in `tr` and `id`, the only remaining exact-English matches in this shared slice are intentional carryovers such as `Google`, `iPhone`, `iPad`, `Apple Watch`, and `Android TV`
- Remaining note:
  - Bangla still has a much larger deeper accounts/backup/restore translation backlog after this shared shell-label cleanup

Progress checkpoint 2026-04-12 (Tier B Bangla accounts deep batch 1):

- Completed the first deeper Bangla accounts cleanup for:
  - `bn`
- This batch covered:
  - account status card title and state bodies
  - current mode, provider, and last-backup summary copy
  - local-only and connected-account explainer copy
  - sign-in and sign-out action/result copy
  - sync preference labels
  - top-level remote-backup and remote-restore entry copy
- Validation result:
  - the targeted Bangla deep accounts batch now reports `0` same-as-English fallbacks for the translated key set
- Remaining note:
  - Bangla still retains deeper restore-preview, merge/conflict, auto-backup, scope, and import/export account copy after this batch

Progress checkpoint 2026-04-12 (Tier B Bangla accounts deep batch 2):

- Completed the next deeper Bangla accounts cleanup for:
  - `bn`
- This batch covered:
  - restore comparison bodies
  - restore-preview warning and action copy
  - per-domain summary labels
  - merge/conflict status labels
  - remote backup success and restore success result copy
  - provider-status and remote failure bodies
- Validation result:
  - the targeted Bangla restore-preview and remote-status batch now reports `0` same-as-English fallbacks for the translated key set
- Remaining note:
  - Bangla still retains deeper auto-backup, scope, and import/export account copy after this batch

Progress checkpoint 2026-04-12 (Tier B Bangla accounts deep batch 3):

- Completed the next deeper Bangla accounts cleanup for:
  - `bn`
- This batch covered:
  - auto-backup section, frequency, status, and eligibility copy
  - sync-scope section, summaries, impacts, and mismatch copy
  - export/share backup result and helper copy
  - import file-picking, mode, preview, confirmation, and error copy
- Validation result:
  - the targeted Bangla auto-backup, scope, and import/export batch now reports `0` same-as-English fallback prose
  - the only remaining exact-match inside the batch is the placeholder-only neutral bullet row `• {event}`
- Remaining note:
  - Bangla still retains some lower-priority accounts wording outside this batch, but the major auto-backup, scope, and import/export release copy is now translated

Progress checkpoint 2026-04-12 (Tier B home shell batch):

- Completed the next Tier B home shell cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - prayer timing header labels and day navigation copy
  - Daily Nur, salah summary, dhikr, reflection, and streak card copy
  - worship summary, fasting status, and Khusu quick-entry copy
  - welcome-carousel intention and salah-rhythm helper copy
  - home location-permission and search helper copy
- Validation result:
  - the targeted Tier B home shell batch now reports `0` same-as-English fallbacks for the translated key set in `tr`, `id`, and `bn`
- Remaining note:
  - broader Tier B home and shell work still remains outside this visible dashboard batch

Progress checkpoint 2026-04-12 (Tier B home learning and journey batch):

- Completed the next Tier B home cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - learning summary and featured-topic card copy
  - journey summary and unlock-progress card copy
  - quick-action labels
  - reflection reminder copy
  - prayer follow-up helper text
  - home ecosystem summary copy
- Validation result:
  - the targeted Tier B home learning/journey batch now reports `0` same-as-English fallbacks for the translated key set in `tr`, `id`, and `bn`
- Remaining note:
  - broader Tier B home and shell work still remains outside this learning/journey slice

Progress checkpoint 2026-04-12 (Tier B home prayer and widget batch):

- Completed the next Tier B home cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - prayer-forbidden-state helper copy
  - widget prayer and progress titles
  - widget empty-state helper copy
  - widget dua, hadith, ayah, reflection, and Name of Allah labels
  - widget prayer countdown labels
- Validation result:
  - the targeted Tier B home prayer/widget batch now reports `0` same-as-English fallbacks for the translated key set in `tr`, `id`, and `bn`
- Remaining note:
  - broader Tier B home and shell work still remains outside this prayer/widget slice

Progress checkpoint 2026-04-12 (Tier B home glass preview batch):

- Completed the next Tier B home cleanup for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - the temporary home glass-variant comparison section
  - all glass-variant titles, subtitles, bodies, footers, and micro labels
  - the temporary onboarding/loading test pills
- Validation result:
  - the targeted Tier B home glass-preview batch now reports `0` same-as-English fallbacks for the translated key set in `tr`, `id`, and `bn`
- Remaining note:
  - broader Tier B home and shell work still remains outside this glass-preview slice

Progress checkpoint 2026-04-12 (Tier B settings/accounts polish batch):

- Completed a Tier B settings/accounts polish pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - remaining visible account shell labels like avatar and transport title
  - Tier B theme-choice labels still left in English
  - locale-appropriate Jumu'ah naming on settings surfaces
  - the remaining Turkish suggested-adjustment row formatting that still matched English

Progress checkpoint 2026-04-12 (Tier B onboarding opening/theme/account-options batch):

- Completed a Tier B onboarding polish pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - onboarding opening mission copy and hadith lead-in
  - theme preview title, body, chips, and sample card copy
  - optional sign-in, backup, and reminder-off onboarding copy

Progress checkpoint 2026-04-12 (Tier B onboarding terminology polish batch):

- Completed a Tier B onboarding terminology pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - greeting and language labels still left in English carryover form
  - prayer method labels shown during onboarding setup
  - madhab labels shown during onboarding setup

Progress checkpoint 2026-04-12 (Tier B search-hints and loading batch):

- Completed a Tier B shell/discovery polish pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - search hint copy across dua, hadith, prophets, Qur'an, quizzes, lessons, and term discovery
  - launch/loading status text and morning/evening translation lines

Progress checkpoint 2026-04-12 (Tier B profile/help shell batch):

- Completed a Tier B shell/help polish pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - profile shell headings, summaries, mode labels, mission line, and Ramadan date-window copy
  - help-guide getting-started and salah-reminder sections

Progress checkpoint 2026-04-12 (Tier B help-guide completion batch):

- Completed the remaining Tier B help-guide pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - Qur'an help-guide section
  - learning help-guide section
  - dhikr/adhkar help-guide section
  - growth/progress help-guide section
  - notifications/settings help-guide section

Progress checkpoint 2026-04-12 (Tier B shared all-search shell batch):

- Completed a Tier B shared search-shell pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - shared All Search title, subtitle, and empty-state copy
  - recent-search and suggestions headings
  - no-results guidance and domain jump helper text
  - domain labels, "view all" actions, and suggestion chips

Progress checkpoint 2026-04-12 (Tier B accessibility shell batch):

- Completed a Tier B accessibility shell pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - reminder/help and playback control labels
  - dhikr, salah, qada, camera, and reflection-card accessibility labels
  - favorite/save/review accessibility actions
  - learning settings plus sources/licensing accessibility copy

Progress checkpoint 2026-04-12 (Tier B assistant shell batch):

- Completed a Tier B assistant shell pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - the assistant title, subtitle, and empty-state guidance
  - the message input hint
  - quick prompts, recent prompts, and quick actions headings

Progress checkpoint 2026-04-12 (Tier B history/contextual/nav shell batch):

- Completed a Tier B history/navigation shell pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - remaining history date and archive shell labels
  - contextual related-link type labels
  - nav labels for dhikr, learning, home, and growth
  - major page shortcut labels like continue journey, quick lesson, and surah list

Progress checkpoint 2026-04-12 (Tier B Creation Explorer shell batch):

- Completed a Tier B Creation Explorer shell pass for:
  - `tr`
  - `id`
  - `bn`
- This batch covered:
  - the creation explorer title, subtitle, tabs, and action labels
  - on-device camera access and detection helper text
  - saved observation and reflection journal copy
  - the “also explore the sky” companion explainer

Progress checkpoint 2026-04-12 (Tier C notifications/system copy batch):

- Started Tier C shell/system rollout with a notifications copy pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - prayer reminder channel names and descriptions
  - prayer-at-time notification title and body copy
  - On This Day, moonrise, and moonset notification copy
  - prayer notification action labels and the generic prayer naming label

Progress checkpoint 2026-04-12 (Tier C shared all-search shell batch):

- Completed a Tier C shared search-shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - the shared All Search title, subtitle, and empty-state copy
  - recent-search and suggestions headings
  - no-results guidance and domain jump helper text
  - domain labels, "view all" actions, and suggestion chips

Progress checkpoint 2026-04-12 (Tier C assistant shell batch):

- Completed a Tier C assistant shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - the assistant title, subtitle, and empty-state guidance
  - the message input hint
  - quick prompts, recent prompts, and quick actions headings

Progress checkpoint 2026-04-12 (Tier C accessibility shell batch):

- Completed a Tier C accessibility shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - reminder/help and playback control labels
  - dhikr, salah, qada, camera, and reflection-card accessibility labels
  - favorite/save/review accessibility actions
  - learning settings plus sources/licensing accessibility copy

Progress checkpoint 2026-04-12 (Tier C Creation Explorer shell batch):

- Completed a Tier C Creation Explorer shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - the Creation Explorer title, subtitle, tabs, and action labels
  - on-device camera access and detection helper text
  - saved observation and reflection journal copy
  - the "also explore the sky" companion explainer

Progress checkpoint 2026-04-12 (Tier C history/contextual/nav shell batch):

- Completed a Tier C history/contextual/nav shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - On This Day and archive titles, filters, states, categories, and metadata labels
  - contextual related-link type labels
  - shared nav labels and major page shortcut labels
  - history empty states, significance/source copy, and date-confidence text

Progress checkpoint 2026-04-12 (Tier C profile/loading shell batch):

- Completed a Tier C profile/loading shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - remaining profile headings, guidance, mode labels, and reminder labels still showing in English
  - Ramadan date-window helper copy and version/mission text
  - loading greeting translations and launch/loading status lines

Progress checkpoint 2026-04-12 (Tier C help-guide shell batch):

- Completed a Tier C help-guide shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - getting-started guidance
  - salah/reminder help steps
  - Qur'an, learning, dhikr, growth, and notifications/settings help sections

Progress checkpoint 2026-04-12 (Tier C settings shell batch):

- Completed a Tier C settings shell pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - settings landing/helper copy
  - guide-search and guide-state copy inside settings
  - theme guidance, transition labels, and rerun-onboarding text
  - remaining Hausa settings labels for adhan, prayer names, and theme choice text

Progress checkpoint 2026-04-12 (Tier C onboarding core batch):

- Completed a Tier C onboarding core pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - begin/continue actions
  - Shahada and Bismillah meaning copy plus the opening blessing
  - age-range prompts and salah-consistency prompts
  - prayer-method and madhab prompts
  - shared onboarding option labels such as off/light/medium/strong and the optional hint
- Targeted audit note:
  - `fa` and `fa_AF` are fully cleared for this onboarding-core slice
  - remaining Hausa same-as-English matches in this slice are intentional proper-name or canonical carryovers such as `Bismillahir-Rahmanir-Rahim`, `Islamic Society of North America (ISNA)`, `Hanafi`, `Shafi''i`, `Maliki`, and `Hanbali`

Progress checkpoint 2026-04-12 (Tier C onboarding personalization batch 1):

- Completed a Tier C onboarding personalization pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - language picker title, helper copy, and supported language labels
  - experience-level title, helper copy, and experience options
  - growth-interest title, helper copy, and interest options
  - Qur'an reading preference, harakat, and text-size labels
  - reminder setup labels including notification-only, adhan, daily Qur'an, daily lesson, and disable-all options
  - tracking title, helper copy, and the main tracking-area labels
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this personalization-batch-1 slice

Progress checkpoint 2026-04-12 (Tier C onboarding personalization batch 2):

- Completed a Tier C onboarding personalization pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - family onboarding copy and family-profile setup guidance
  - dhikr feedback labels across haptic, sound, and visual responses
  - identity/name personalization copy
  - final welcome title, body, focus labels, closing copy, and the knowledge dua meaning
- Targeted audit note:
  - `fa` and `fa_AF` are fully cleared for this personalization-batch-2 slice
  - the only remaining Hausa same-as-English match in this slice is the intentional canonical greeting `onboardingWelcomeGreeting`

Progress checkpoint 2026-04-12 (Tier C accounts core batch):

- Completed a Tier C accounts core pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - accounts status-card title and state bodies
  - current-mode, provider, and last-backup summary labels
  - mode labels, account section title, and local-only/connected-account helper text
  - backup-status title, sign-in actions, sign-out action, sync-preferences title, and remote-restore entry copy
- Targeted audit note:
  - `fa` and `fa_AF` are fully cleared for this accounts-core slice
  - the only remaining Hausa same-as-English match in this slice is the intentional provider proper noun `Google`

Progress checkpoint 2026-04-12 (Tier C accounts remote-backup batch 1):

- Completed a Tier C accounts remote-backup pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - remote-backup availability and not-configured explainer copy
  - remote-backup section title and primary actions
  - restore-comparison title/subtitle and remote provider/status headings
  - the newer/older/equal remote-restore state bodies
  - local-updated timestamp labeling in the remote preview
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this remote-backup-batch-1 slice

Progress checkpoint 2026-04-12 (Tier C accounts restore-preview batch 1):

- Completed a Tier C accounts restore-preview pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - per-domain comparison and warnings titles
  - restore-preview action labels for replace, merge, and keep-local flows
  - merge/replace confirmation bodies
  - restore result title/body and merged/replaced fallback labels
  - domain summary copy and provider/account mismatch warnings
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this restore-preview-batch-1 slice

Progress checkpoint 2026-04-12 (Tier C accounts restore-preview warning cleanup):

- Completed a Tier C accounts restore-preview warning cleanup pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - schema-mismatch warning copy
  - local-only and remote-only warning copy
  - the uncertain-merge warning copy
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this warning-cleanup slice

Progress checkpoint 2026-04-12 (Tier C accounts remote-domain batch 1):

- Completed a Tier C accounts remote-domain pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - remote backup domain labels
  - conflict-state labels across identical/newer/local-only/remote-only/schema/uncertain/account/provider cases
  - merge-safety labels for safe, replace-only, unsafe, and unsupported states
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this remote-domain-batch-1 slice

Progress checkpoint 2026-04-12 (Tier C accounts auto-backup batch 1):

- Completed a Tier C accounts auto-backup pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - auto-backup section title and subtitle
  - enabled/off state copy and backup frequency labels
  - meaningful-change and background-trigger labels
  - auto-backup status, last-attempt/last-success/failure labels, and retry action
  - auto-backup reason and eligibility-state labels
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this auto-backup-batch-1 slice

Progress checkpoint 2026-04-12 (Tier C accounts scope batch 1):

- Completed a Tier C accounts scope pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - sync-scope section title, subtitle, and current-summary copy
  - essential vs optional scope framing and confirmation actions
  - scope preview labels and excluded-domain copy
  - settings/journal/reminders/theme scope descriptions
  - full vs partial scope summaries and include/exclude impact messaging
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this scope-batch-1 slice

Progress checkpoint 2026-04-13 (Tier C accounts auth/results batch):

- Completed a Tier C accounts auth/results pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - local-only continuation action and result copy
  - email sign-in not-yet-connected explainer text
  - account-connected and sign-in result states
  - manual-backup and restore-suggestions preference titles
  - remote-backup found/success/restore-success result copy
  - remote provider/auth/unavailable/failure warning bodies
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this auth/results slice

Progress checkpoint 2026-04-13 (Tier C accounts import/export batch):

- Completed a Tier C accounts import/export pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - backup export created/ready/share copy
  - backup payload label
  - choose-file and file-loaded restore copy
  - merge vs replace labels and import preview text
  - restore confirmation bodies
  - import error, warning, and failed-result copy
- Targeted audit note:
  - `fa`, `fa_AF`, and `ha` now have `0` exact-English matches in this import/export slice

Progress checkpoint 2026-04-13 (Tier C accounts tail cleanup):

- Completed a Tier C accounts tail-cleanup pass for:
  - `fa`
  - `fa_AF`
  - `ha`
- This batch covered:
  - recent sync event bullet copy
  - prayer-focused experience label
  - unknown transport and unknown status labels
  - Hausa profile/account/provider summary wrappers
  - Hausa transport title/summary copy
  - Hausa device-platform labels for iPhone, iPad, Apple Watch, and Android TV
- Targeted audit note:
  - `fa` and `fa_AF` now have `0` exact-English `accountsSync*` matches
  - `ha` is reduced to one intentional proper-noun carryover: `accountsSyncProviderGoogle`

Progress checkpoint 2026-04-13 (Tier C profile/loading shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C profile/loading shell pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - profile header, intention, and summary copy
  - theme labels, mode labels, and entrust-deeds reminder copy
  - On This Day reminder labels and helper text
  - mission/version placeholder copy
  - Ramadan date-range labels and status text
  - loading greeting translations and loading status lines
- Targeted audit note:
  - all five locales now have `0` exact-English matches in the `profile*` slice
  - the only remaining exact-English `loading*` carryovers are the intentional canonical Arabic devotional source strings:
    - `loadingHeadlineAllahAkbar`
    - `loadingGreetingMorning`
    - `loadingGreetingEvening`

Progress checkpoint 2026-04-13 (Tier C help-guide shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C help-guide shell pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - getting-started guidance
  - salah/reminder helper steps
  - Qur'an usage guidance
  - learning hub guidance
  - dhikr/adhkar helper steps
  - growth/progress guidance
  - notifications/settings helper copy
- Targeted audit note:
  - `ku`, `ms`, `pa`, `ps`, and `tg` now have `0` exact-English matches in the `helpGuide*` slice

Progress checkpoint 2026-04-13 (Tier C settings shell helper/transition batch for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C settings shell helper/transition pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - reminder on/off state labels
  - settings landing helper subtitle
  - widget/live activity enable labels
  - settings-side Help & Guide search/browse/empty/not-found shell copy
  - page-transition labels and styles
  - learning-level title
  - rerun-onboarding title and subtitle
- Targeted audit note:
  - `ku`, `ms`, `pa`, `ps`, and `tg` now have `0` exact-English matches in this targeted settings shell helper/transition slice
  - broader `settings*` prayer/accounts/theme-description long-tail still remains outside this pass

Progress checkpoint 2026-04-13 (Tier C onboarding setup-core batch for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C onboarding setup-core pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - learning-path age-group selector copy
  - skip / continue / begin-journey onboarding actions
  - settings-hint helper copy
  - language and age-range setup copy
  - experience-level setup copy
  - salah-consistency setup copy
  - prayer-method and madhab titles/subtitles
- Targeted audit note:
  - the translated onboarding setup-core prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`
  - the only remaining exact-English carryovers in this slice are the intentional shared proper-name labels for prayer methods and madhabs
  - the later onboarding personalization and welcome-family long-tail for `ku`, `ms`, `pa`, `ps`, and `tg` still remains outside this pass

Progress checkpoint 2026-04-13 (Tier C onboarding personalization batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C onboarding personalization pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - growth-interest titles and helper copy
  - Qur'an reading preference labels
  - harakat and text-size labels
  - reminder setup titles, subtitles, and reminder-mode labels
  - daily Qur'an and lesson reminder labels
  - tracking titles, helper copy, and tracking-category labels
- Targeted audit note:
  - the translated onboarding personalization batch 1 prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`
  - the later family, dhikr feedback, identity/name, and final welcome onboarding tail still remains outside this pass

Progress checkpoint 2026-04-13 (Tier C onboarding personalization batch 2 for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C onboarding personalization pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - family onboarding guidance and family-profile helper copy
  - dhikr feedback labels across haptic, sound, and visual response modes
  - identity, greeting, name, and optional-helper copy
  - final welcome title, body, focus-list, and closing copy
  - the knowledge dua meaning
- Targeted audit note:
  - the translated onboarding personalization batch 2 prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`
  - the only remaining exact-English carryover in this slice is the intentional canonical greeting template `onboardingWelcomeGreeting`

Progress checkpoint 2026-04-13 (Tier C accounts core batch for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C accounts core pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - accounts status-card title and mode bodies
  - current-mode, provider, and last-backup summary labels
  - mode labels
  - account section title and connected/local-only helper copy
  - backup-status title
  - sign-in continuation actions
  - sign-out action
  - sync-preferences title
  - remote-restore entry action
- Targeted audit note:
  - the translated accounts core prose is now cleared for this slice in `ku`, `ms`, `pa`, `ps`, and `tg`
  - the only remaining exact-English carryover in this slice is the intentional proper noun `accountsSyncProviderGoogle` in `ku`, `ms`, `pa`, and `tg`

Progress checkpoint 2026-04-13 (Tier C accounts remote-backup batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C accounts remote-backup pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - remote-backup availability and not-configured explainer copy
  - remote-backup section title and primary actions
  - restore-comparison title and subtitle
  - remote provider / last-backup / remote-status headings
  - newer / older / equal remote-restore state bodies
  - local-updated timestamp label in the remote preview
- Targeted audit note:
  - the translated accounts remote-backup batch 1 prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C accounts restore-preview batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C accounts restore-preview pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - per-domain comparison and warnings titles
  - restore-preview action labels for replace / merge / keep-local flows
  - merge and replace confirmation bodies
  - restore result title and summary body
  - no-merged / no-replaced fallback labels
  - domain summary copy
  - provider and account mismatch warning copy
- Targeted audit note:
  - the translated accounts restore-preview batch 1 prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C accounts restore-preview warning cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C accounts restore-preview warning cleanup pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - schema-mismatch warning copy
  - local-only warning copy
  - remote-only warning copy
  - uncertain-merge warning copy
- Targeted audit note:
  - the translated accounts restore-preview warning prose is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`

Progress checkpoint 2026-04-13 (Tier C accounts remote-domain batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`):

- Completed a Tier C accounts remote-domain pass for:
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
- This batch covered:
  - remote backup domain labels
  - conflict-state labels across identical / newer / local-only / remote-only / schema / uncertain / account / provider cases
  - merge-safety labels for safe / replace-only / unsafe / unsupported states
- Targeted audit note:
  - the translated accounts remote-domain vocabulary is now cleared for `ku`, `ms`, `pa`, `ps`, and `tg`










### Phase 3: Worship Core Completion

- Salah / prayer timing
- Worship dashboards
- Wudu trainer and helper flows
- Fasting support
- Qibla / prayer utility messaging
- Goal:
  - no English fallback inside core ibadah flows

### Phase 4: Learn and Qur'an Core Completion

- Remaining Learn hub and discovery copy
- Remaining Qur'an reader / hub / memorization / insight surfaces
- Guided paths
- Arabic learning
- Remaining Hadith long-tail strings outside the already cleaned recent scopes
- Goal:
  - no English fallback in the main knowledge and study paths

### Phase 5: Kids and Family Release Surfaces

- Kids Qur'an
- Kids learning surfaces
- Bedtime stories
- Baby names
- Prophet stories
- Kid-facing quiz/game launch surfaces if they are shipping in the release scope
- Goal:
  - remove English fallback from all shipping child/family experiences

### Phase 6: Journey, Growth, and Rewards

- Growth / journey home
- Garden
- XP titles
- Ocean drops
- Spiritual growth
- Cross-feature motivation/reward strings
- Goal:
  - remove English fallback from continuity and motivation systems

### Phase 7: Long-tail Surfaces and Release QA Freeze

- Remaining secondary surfaces:
  - editorial/internal if still included in production builds
  - less-frequent tool/game surfaces
  - leftover one-off hubs
- Do a final full-locale audit pass
- Build a locale-by-locale zero-fallback checklist
- Goal:
  - zero meaningful same-as-English fallbacks across all supported shipped locales

## Recommended execution order

1. Phase 1 first
2. Phase 2 second
3. Phase 3 third
4. Phase 4 fourth
5. Phase 5 fifth
6. Phase 6 sixth
7. Phase 7 last

## Why this order

- Phase 1 closes the fresh regressions before they spread into release builds
- Phases 2 and 3 protect first-run and core worship quality
- Phase 4 clears the main study surfaces with the highest ongoing user time
- Phases 5 and 6 finish high-traffic but less release-blocking secondary product areas
- Phase 7 is the final audit/freeze pass rather than another translation-discovery phase

## Latest checkpoints

- Completed 2026-04-13: Tier C accounts auto-backup batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `accountsSyncAutoBackup*` family:
    - section title/subtitle
    - enabled/off explainer copy
    - frequency labels
    - meaningful-change and background-trigger labels
    - auto-backup status labels
    - last-attempt / last-success / failure labels
    - retry action
    - trigger-reason and eligibility-state labels
  - Verification target for this checkpoint:
    - no exact-English carryovers in the targeted auto-backup slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C accounts auth/results batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared auth/results `accountsSync*` family:
    - account-connected result copy
    - sign-in cancelled / unavailable / not-configured / failed result states
    - local-only continuation and signed-out result states
    - manual-backup and restore-suggestions titles
    - remote-backup found / success / restore-success result copy
    - provider-setup, auth-expired, iCloud unavailable, email unavailable, and remote-backup failed warning copy
  - Verification target for this checkpoint:
    - no exact-English carryovers in the targeted auth/results slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C accounts scope batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `accountsSyncScope*` family:
    - scope section title and subtitle
    - current-summary, essential, and optional framing
    - confirm actions and manual-export note
    - preview labels and mismatch/excluded-domain messaging
    - settings, journal, reminders, and theme descriptions
    - full/partial summaries and include/exclude impact messaging
  - Verification target for this checkpoint:
    - no exact-English carryovers in the targeted scope slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C accounts import/export batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared import/export `accountsSync*` family:
    - export created/ready/share copy
    - choose-file and file-loaded restore copy
    - import preview title plus restore mode/exported-at values
    - restore confirmation bodies
    - import error/warning/failure result messages
  - Verification target for this checkpoint:
    - no exact-English carryovers in the targeted import/export slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C accounts tail cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the remaining small `accountsSync*` tail:
    - import mode merge/replace labels
    - import preview summary plural copy
    - prayer-focused experience label
    - iPhone / iPad / Apple Watch device-platform labels
    - unknown transport and unknown-status labels
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the targeted tail slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C onboarding opening/theme/account-options batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `onboarding*` opening slice:
    - opening blessing, title, hadith lead and quote, mission body copy, support line, and platform footer
    - disclaimer body plus the fatwa/sources/neutrality/not-a-ruling/seek-scholar/feedback/footer copy
    - theme chooser title and subtitle, live-preview labels, sample card copy, and prayer/reading/reflection chips
    - reminders disable-all and no-notification labels
    - optional sign-in and manual-backup onboarding account-option copy
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the targeted onboarding opening slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C onboarding terminology/preferences batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `onboarding*` terminology and preference slice:
    - family heading copy
    - language picker labels for system default plus the localized language names
    - growth-interest labels across Qur’an, Hadith, prophets, salah, dhikr, habits, knowledge, growth, and daily inspiration
    - shared size labels for small, large, and extra large
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the targeted onboarding terminology/preferences slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C settings theme-guidance batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `settings*` theme-guidance slice:
    - Midnight Manuscript description copy
    - theme picker helper copy
    - the default, calm, easy-read, dark, no-glass, Noor dark, manuscript, and kids “best for” helper lines
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the targeted settings theme-guidance slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C settings theme-label cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Covered the shared `settings*` label cleanup slice:
    - localized the `Jumu‘ah` prayer-name label
    - localized the `Midnight Manuscript` theme label
    - localized the `Noor Midnight Manuscript` and `Noor Kids` theme labels where those variants were still English
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the targeted settings label slice for `ku`, `ms`, `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Malay settings prayer-label cleanup.
  - Covered the remaining Malay-only `settings*` prayer/admin label slice:
    - localized the manual salah-times title
    - localized the `Isha` prayer-name label
    - localized the masjid-time summary label
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in this targeted Malay settings slice
- Completed 2026-04-13: Tier C settings fresh audit pass for `ku`, `ms`, `pa`, `ps`, and `tg`.
  - Re-audited the remaining exact-English `settings*` carryovers after the helper, theme-guidance, theme-label, and Malay prayer-label cleanup passes.
  - Audit conclusion:
    - `ku` still carries the only large remaining real `settings*` translation backlog
    - `ms` is reduced to a very small tail that is mostly proper labels plus format wrappers
    - `pa`, `ps`, and `tg` are now down to format wrappers, `iCloud`, and one small settings adjustment summary row each
  - Verification target for this checkpoint:
    - use this audit checkpoint to drive the next locale-specific cleanup rather than forcing another mixed batch
- Completed 2026-04-13: Tier C Kurdish settings shell batch 1.
  - Covered the high-visibility top settings shell in `app_ku.arb`:
    - settings landing and category shell subtitles
    - widgets/watch, language/downloads, privacy, kids/family, and help/about shell copy
    - learning hub and Qur’an/Arabic display-preference helper copy
    - current-location, profile/personalization, what’s new, coming soon, and accounts/sync entry copy
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in the targeted Kurdish settings shell slice
- Completed 2026-04-13: Tier C Kurdish settings prayer/admin batch 2.
  - Covered the deeper `app_ku.arb` settings prayer/admin slice:
    - adhan and preview/audio settings copy
    - stable widget/display labels and visual-preference controls
    - prayer notification, prayer-time mode, adjustment, manual-times, and masjid-comparison copy
    - Jumu’ah settings, notification-mode labels, and settings adjustment summary labels
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in the targeted Kurdish settings prayer/admin slice
- Completed 2026-04-13: Tier C Kurdish settings tail cleanup.
  - Covered the final remaining real `app_ku.arb` settings copy:
    - calendar-display title and subtitle
    - remaining sync-mode and sync-state helper labels
  - Verification target for this checkpoint:
    - only intentional exact-English carryovers remain in the remaining Kurdish `settings*` tail
- Completed 2026-04-13: Tier C `pa` / `ps` / `tg` settings-onboarding tail audit.
  - Re-audited the remaining exact-English carryovers in the small `settings*` and `onboarding*` tails for:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - Audit conclusion:
    - these locales no longer have a meaningful shared cleanup batch in the targeted settings/onboarding tails
    - the remaining exact-English carryovers in those slices are format wrappers, canonical source/transliteration rows, prayer-method and madhhab proper names, and `iCloud`
  - Verification target for this checkpoint:
    - use this audit checkpoint to pivot away from forced tail cleanups and into the next real untranslated surface family
- Completed 2026-04-13: Tier C Hadith shell batch for `pa`, `ps`, and `tg`.
  - Covered the top shared Hadith navigation/action slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the Hadith page title and subtitle
    - tabs for themes, collections, saved, daily, review, and paths
    - core actions for open detail, save, saved, copy, share, random review, review by theme, and review by learning path
    - top section titles/subtitles for essential starter, featured themes, collections, saved, review, spaced repetition, and learning paths
    - browse sources and browse all Hadith actions
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith reader-metadata and empty-state batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith continuity slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - reader metadata labels for Arabic matn, transliteration, translation, source, reference, grade, narrator, theme, and collection
    - reader section headings for related hadith, text, meaning, lessons, reflection, Qur’an connection, prompts, practice action, related verses, and collection/theme entries
    - saved-state and clipboard feedback copy
    - theme / collection / lesson / narrator not-found copy
    - collection page title, subcategory heading/count, and the grade-info title
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith reader-metadata and empty-state slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith path/progress batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith learning-path slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - lesson-completed feedback
    - path page title and not-found copy
    - default path subtitle
    - progress, milestone, lesson, and chapter headings
    - lesson/completed/progress counters
    - last-score, Qur’an-connections, and next-lesson labels
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith path/progress slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith reflection-home and review-due batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith reflection slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - daily reflection title and empty state
    - completed chapter quizzes and lessons-due-for-review copy
    - reflection-home titles, subtitles, load/loading/not-found states, and kids-profile restriction copy
    - daily mode, kids mode, and adult mode labels/subtitles
    - featured-pack, history, continue, theme, and reflection stat labels
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith reflection-home and review-due slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith quiz/theme-card/path-streak batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith action-and-summary slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - lesson-completion and reflection-completion action labels
    - weekly knowledge check and chapter-quiz actions
    - quiz-unlock guidance
    - path-streak summary
    - theme-card counts/progress/start labels
    - all-themes title and collection-card summary
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith quiz/theme-card/path-streak slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith short labels and narrator-count batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith short-label slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - grade label
    - current and best streak labels
    - reflection completed XP and already-completed-today feedback
    - theme and collection chip counts
    - narrator hadith-section count title
  - Verification target for this checkpoint:
    - only the intentional format-only `hadithCollectionEntrySubtitle` wrapper remains same-as-English in this targeted slice
- Completed 2026-04-13: Tier C Hadith reflection interaction batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith reflection interaction slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - reflection theme subtitle
    - pack difficulty, progress, and best-choice labels
    - continue/recommended/resume/completed badges and actions
    - kids/adult puzzle titles and puzzle subtitles
    - scenario, teaching summary, prompt, help, choice, outcome, and feedback labels
    - completion titles/subtitles and XP/drop/best-choice rewards
    - next puzzle, back to pack, and back home actions
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith reflection interaction slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith reflection taxonomy and pack-title batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Hadith reflection taxonomy slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - reflection difficulty labels
    - reflection category labels
    - kids kindness, honesty, patience, anger, family, community, repentance, speech, and daily pack titles/subtitles
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Hadith reflection taxonomy and pack-title slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Hadith source-browse and completion-status batch for `pa`, `ps`, and `tg`.
  - Covered the remaining real shared Hadith browse/status copy in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the grade-info subtitle
    - related Qur’an / duas / canonical hadith section labels
    - mark complete / completed / mark incomplete actions
    - complete / incomplete confirmation feedback
  - Verification target for this checkpoint:
    - only three intentional format-only wrappers remain same-as-English in this narrowed Hadith slice:
      - `hadithCollectionEntrySubtitle`
      - `hadithReflectionXpLabel`
      - `hadithSourceBrowseEntrySubtitle`
- Completed 2026-04-13: Tier C Hadith fresh audit checkpoint for `pa`, `ps`, and `tg`.
  - Re-audited the remaining exact-English `hadith*` values after the shell, reader metadata, path/progress, reflection-home, quiz/theme-card, short-label, reflection interaction, reflection taxonomy, and source-browse status batches.
  - Audit conclusion:
    - `app_pa.arb`, `app_ps.arb`, and `app_tg.arb` are now down to the same three intentional format-only wrappers:
      - `hadithCollectionEntrySubtitle`
      - `hadithReflectionXpLabel`
      - `hadithSourceBrowseEntrySubtitle`
    - no additional real shared Hadith prose cleanup batch is justified for these locales right now
  - Verification target for this checkpoint:
    - use this audit checkpoint to pivot to the next surface family instead of forcing wrapper-only edits
- Completed 2026-04-13: Tier C kids dua My Day batch for `pa`, `ps`, and `tg`.
  - Covered the shared `kidsDuaMyDay*`, `kidsDuaSuggested*`, and `kidsDuaLight*` shell in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the My Day title/subtitle and start/continue/review actions
    - section labels, journey labels, question/recap prompts, and recap reward copy
    - right-now reason text, landing-detail text, and completion reward text
    - suggested-dua title/actions/reason labels
    - the light-card title, today-light title, and light value label
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted kids dua My Day slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C kids dua library/practice shell batch for `pa`, `ps`, and `tg`.
  - Covered the shared outer `kidsDua*` shell in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the landing title/subtitle, continue/today/category shell labels, and learning-state labels
    - the quick-practice flow labels, empty state, and summary body
    - rewards/meaning/when/source/audio/complete shell labels
    - reward/count/progress labels, hero title/subtitle, next/back/today actions, and sticker collection labels
  - Verification target for this checkpoint:
    - only three intentional shared carryovers remain same-as-English in this targeted shell slice:
      - `kidsDuaPracticeMashaAllah`
      - `kidsDuaCompletionXpValue`
      - `kidsDuaCompletionCelebrateTitle`
- Completed 2026-04-13: Tier C kids dua starter-lessons and reward batch for `pa`, `ps`, and `tg`.
  - Covered the first starter-dua lesson and reward family in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the before-eating, after-eating, before-sleep, and after-waking title/meaning/when/lesson/situation rows
    - the entering-washroom, leaving-washroom, leaving-home, and entering-home title/meaning/when/lesson/situation rows
    - the `Rabbi zidni ilma` and parents dua title/meaning/when/lesson/situation rows
    - the first reward family titles/subtitles from first-dua star through parent-heart
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted starter-lessons and reward slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C kids dua stickers/light/reminders batch for `pa`, `ps`, and `tg`.
  - Covered the next shared kids-dua support slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - sticker lock/count labels and sticker family names
    - streak value, light-stage labels, and light-state messages
    - My Day light continuation/completion copy
    - morning, midday, evening, bedtime, and recovery reminder titles/bodies
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted stickers/light/reminders slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C kids dua stories batch for `pa`, `ps`, and `tg`.
  - Covered the shared `kidsDuaStories*` slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - story action, landing subtitle, and duration value
    - featured/continue/browse/all stories labels
    - story category titles across bedtime, daily life, feelings, learning, and travel/nature
    - scene value, back/autoplay/pause/next actions, complete title, and say-dua/back-to-stories actions
    - the lesson hint and My Day story detail
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted stories slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C kids dua interaction/tools batch for `pa`, `ps`, and `tg`.
  - Covered the shared interaction and lesson-tooling `kidsDua*` slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - learning mode titles and labels
    - gentle-practice, saved-practice, and listen-then-read / tap-repeat / mark-practiced actions
    - lesson hero subtitle and audio-unavailable/audio-section copy
    - pause/resume/play/restart/repeat actions
    - read-along and tap-repeat section copy
    - bedtime-link title/subtitle/action
    - learning progress, listens/repeats/views labels, and source-tap subtitle
  - Verification target for this checkpoint:
    - only the format-only wrapper `kidsDuaPlaybackProgressLabel` remains same-as-English in this targeted interaction/tools slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C kids dua drawing/parent-view batch for `pa`, `ps`, and `tg`.
  - Covered the remaining meaningful kids-dua drawing and parent-view slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - drawing actions, brush-size labels, save/delete/undo states, and drawings titles/empty-state labels
    - parent-view titles, toggle body, landing labels, overview/today/progress labels
    - parent activity labels and activity event rows
    - parent drawings titles/empty state and gallery action
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted drawing/parent-view slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C `pa` / `ps` / `tg` fresh audit checkpoint after the kids dua completion run.
  - Re-audited the remaining exact-English carryovers after the shared kids dua My Day, library/practice shell, starter-lessons/rewards, stickers/light/reminders, stories, interaction/tools, and drawing/parent-view batches.
  - Audit conclusion:
    - the shared kids-dua prose tail for `pa`, `ps`, and `tg` is now effectively cleared
    - the remaining same-as-English carryovers in that area are now limited to intentional wrappers or tiny isolated labels rather than another worthwhile shared prose batch
    - the next real shared family is no longer kids dua; the next substantial localization opportunity is in broader non-kids surface families, with `arabicLearning*` currently the clearest large shared backlog
  - Verification target for this checkpoint:
    - use this audit checkpoint to pivot away from kids-dua cleanup and choose the next real untranslated family
- Completed 2026-04-13: Tier C `arabicLearning` shell batch for `pa`, `ps`, and `tg`.
  - Covered the first shared `arabicLearning*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - playback mode labels
    - kids/adult Arabic search titles, subtitles, hints, filters, type labels, no-results, locked, and open states
    - kids/adult Arabic progress titles, summaries, counters, milestone/recent/next values, and start/continue/review actions
    - lesson-pack titles, subtitles, actions, recommended badge, pack-type labels, and kids/adult pack titles plus subtitles
    - mini-assessment intro, question counter, see/hear prompts, feedback, finish/continue/review actions, completion copy, and content-type labels
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted `arabicLearning` shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C `arabicLearning` quick-resume and mini-practice batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Arabic-learning continuation slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - adult/kids quick-continue and quick-review actions
    - Arabic quick-resume widget titles, subtitles, section labels, and actions
    - kids Arabic mini-assessment card/page titles, subtitles, and actions
    - adult `quranTeaching` mini-assessment card/page copy
    - adult Arabic overview title, start/progress/completed bodies, last-studied / next-step / milestone values, and review action
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted quick-resume / mini-practice slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Qur’an bridge opening batch for `pa`, `ps`, and `tg`.
  - Covered the next shared Qur’an-learning bridge opening slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `quranReadiness` kids/adult page titles and subtitles
    - `quranReadiness` kids/adult intro titles and subtitles
    - `quranShortSurahs` kids/adult page titles and subtitles
    - `quranShortSurahs` kids/adult intro titles and subtitles
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted Qur’an bridge opening slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C short-surah action/card batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `quranShortSurahs*` continuation slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - play/pause actions
    - known-snippets heading
    - kids/adult card titles and subtitles
    - kids/adult start/continue/review actions
    - adult bridge subtitle
    - ayah label
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted short-surah action/card slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Qur’an bridge progression/help batch for `pa`, `ps`, and `tg`.
  - Covered the next shared readiness / short-surah progression slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `quranReadiness` count/progress values plus Arabic-built/start/play helper rows
    - `quranShortSurahs` count/ayah-count values
    - `quranShortSurahs` built-from-bridge/start helper rows
    - `quranShortSurahs` progression title/subtitle and stage 1-3 titles plus subtitles
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted progression/help slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Qur’an readiness descriptive/help batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `quranReadiness*` descriptive slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - progression title/subtitle
    - level 1-3 titles and subtitles
    - known-phrase and recognition helper titles/subtitles
    - pronunciation-hint title/subtitle, open action, and hint labels/descriptions
    - ayah-context titles plus open-full-ayah, previous, next, review-again, and audio-unavailable helper rows
    - kids/adult card titles, subtitles, start subtitles, and start/continue/review actions
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted readiness descriptive/help slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C Qur’an guided-passage batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `quranGuidedPassages*` slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - kids/adult page titles, subtitles, and intro copy
    - count/ayah-count values plus short-surah-built/start helper rows
    - progression title/subtitle and stage 1-3 titles/subtitles
    - opening, response, and full Al-Fatihah titles/subtitles plus passage meta
    - play/pause/open-reader actions, known-snippets labels, flow hint, and next action
    - kids/adult card titles, subtitles, start subtitles, start/continue/review actions, and bridge subtitles
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted guided-passage slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C `arabicLearning` pack-tail cleanup for `pa`, `ps`, and `tg`.
  - Covered the remaining small shared `arabicLearningPack*` subtitle tail in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `arabicLearningPackKidsReviewSubtitle`
    - `arabicLearningPackAdultPhraseReadingSubtitle`
    - `arabicLearningPackAdultReviewSubtitle`
  - Verification target for this checkpoint:
    - no exact-English embedded carryovers remain in this targeted `arabicLearningPack*` subtitle slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C `arabicLearning` fresh audit checkpoint for `pa`, `ps`, and `tg`.
  - Re-audited the remaining shared `arabicLearning*` values in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - Audit result for this checkpoint:
    - no meaningful exact-English prose carryovers remain in the shared `arabicLearning*` family for `pa`, `ps`, and `tg`
  - Follow-up direction:
    - move to the next real untranslated shared family instead of forcing another `arabicLearning*` micro-batch
- Completed 2026-04-13: Tier C learning landing-shell opening batch for `pa`, `ps`, and `tg`.
  - Covered the first shared `learningSectionLanding*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `learningSectionLandingShortcutJourneys`
    - `learningSectionLandingFoundationsTitle`
    - `learningSectionLandingFoundationsSubtitle`
    - `learningSectionLandingBeliefTitle`
    - `learningSectionLandingBeliefSubtitle`
    - `learningSectionLandingQuranTitle`
    - `learningSectionLandingQuranSubtitle`
    - `learningSectionLandingWorshipTitle`
    - `learningSectionLandingWorshipSubtitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted learning landing-shell opening slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C learning landing-shell continuation batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared learning landing slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `learnSectionLandingSubtitle`
    - `learningSectionLandingProphetsTitle`
    - `learningSectionLandingProphetsSubtitle`
    - `learningSectionLandingCharacterTitle`
    - `learningSectionLandingCharacterSubtitle`
    - `learningSectionLandingBrowseAllTitle`
    - `learningSectionLandingBrowseAllSubtitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted learning landing-shell continuation slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship landing-shell opening batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `worshipSectionLanding*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipSectionLandingPrayerShortcut`
    - `worshipSectionLandingDhikrShortcut`
    - `worshipSectionLandingPrayerTitle`
    - `worshipSectionLandingPrayerSubtitle`
    - `worshipSectionLandingDhikrTitle`
    - `worshipSectionLandingDhikrSubtitle`
    - `worshipSectionLandingDuasTitle`
    - `worshipSectionLandingDuasSubtitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship landing-shell opening slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship tracking/fasting handoff batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent worship landing-to-tracking slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipSectionLandingFastingSubtitle`
    - `worshipTrackingPageTitle`
    - `worshipTrackingPageSubtitle`
    - `worshipTrackingPrayerSummary`
    - `worshipTrackingDhikrSummary`
    - `worshipTrackingFastingSummary`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship tracking/fasting handoff slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship reminders mini-shell batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent worship reminders slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipRemindersPageTitle`
    - `worshipRemindersPageSubtitle`
    - `worshipRemindersPrayerSummary`
    - `worshipRemindersGeneralSummary`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship reminders mini-shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship reminders devices-tail cleanup for `pa`, `ps`, and `tg`.
  - Covered the final remaining shared `worshipReminders*` tail row in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipRemindersDevicesSummary`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted `worshipReminders*` tail slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship Qibla shell batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `worshipQibla*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipQiblaFinderTitle`
    - `worshipQiblaFinderSubtitle`
    - `worshipQiblaCompassDirectionTitle`
    - `worshipQiblaDetectingLocation`
    - `worshipQiblaUnableToDetermineLocation`
    - `worshipQiblaArOptionTitle`
    - `worshipQiblaArOptionSubtitle`
    - `worshipQiblaDisableArMode`
    - `worshipQiblaEnableArMode`
    - `worshipQiblaArModeBetaHint`
    - `worshipQiblaArLiveTitle`
    - `worshipQiblaArLiveSubtitle`
    - `worshipQiblaArPrayerMatHint`
    - `worshipQiblaArOverlayTitle`
    - `worshipQiblaArHorizonLineLabel`
    - `worshipQiblaArKaabaLabel`
    - `worshipQiblaArCameraUnavailableTitle`
    - `worshipQiblaArCameraPermissionBody`
    - `worshipQiblaArCameraUnavailableBody`
    - `worshipQiblaArCameraLoadingBody`
    - `worshipQiblaArRetryCameraAction`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship Qibla shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship Qibla direction/location batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `worshipQibla*` direction-and-location slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipQiblaLocationServicesDisabled`
    - `worshipQiblaLocationPermissionRequired`
    - `worshipQiblaUnableToReadLocation`
    - `worshipQiblaCompassUnavailable`
    - `worshipQiblaCardinalNorth`
    - `worshipQiblaCardinalSouth`
    - `worshipQiblaCardinalWest`
    - `worshipQiblaCardinalEast`
    - `worshipQiblaBearingValue`
    - `worshipQiblaDeviceHeadingValue`
    - `worshipQiblaAlignmentOffsetValue`
    - `worshipQiblaAlignedMessage`
    - `worshipQiblaRotateMessage`
    - `worshipQiblaCalibrationHint`
    - `worshipQiblaCurrentHeadingLabel`
    - `worshipQiblaDirectionValue`
    - `worshipQiblaTurnRightValue`
    - `worshipQiblaTurnLeftValue`
    - `worshipQiblaFacingQibla`
    - `worshipQiblaLocationLabel`
    - `worshipQiblaLocationUnknown`
    - `worshipQiblaRefreshLocation`
    - `worshipQiblaMajorSitesTitle`
    - `worshipQiblaDistanceKmValue`
    - `worshipQiblaSiteMasjidAlHaram`
    - `worshipQiblaSiteProphetsMosque`
    - `worshipQiblaSiteAlAqsa`
    - `worshipQiblaSiteQubaMosque`
    - `worshipQiblaLocationMakkah`
    - `worshipQiblaLocationMadinah`
    - `worshipQiblaLocationJerusalem`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship Qibla direction/location slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship Qibla iPad-availability tail cleanup for `pa`, `ps`, and `tg`.
  - Covered the final remaining shared iPad-specific `worshipQibla*` tail rows in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipQiblaUnavailableOnIpadTitle`
    - `worshipQiblaUnavailableOnIpadBody`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship Qibla iPad-availability tail slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship shell/prayer-tracking cleanup batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared non-Qibla `worship*` shell and prayer-tracking tail rows in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `worshipTitle`
    - `worshipSubtitle`
    - `worshipPrayerNextPrefix`
    - `worshipPrayerUpcomingPrefix`
    - `worshipPrayerAutoAdjustRemindersSubtitle`
    - `worshipPrayerHijriDateValue`
    - `worshipPrayerPercentValue`
    - `worshipPrayerOverlayLabel`
    - `worshipPrayerCadenceQueueClear`
    - `worshipPrayerNoQueuedQadaLeft`
    - `worshipPrayerNoRecordsThisMonth`
    - `worshipPrayerHeatmapTitle`
    - `worshipPrayerHeatmapSubtitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted worship shell/prayer-tracking cleanup slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C worship fresh audit checkpoint for `pa`, `ps`, and `tg`.
  - Re-audited the remaining shared `worship*` values in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - Audit conclusion for this checkpoint:
    - no worthwhile shared `worship*` prose batch remains for `pa`, `ps`, and `tg`
    - future work should move into another untranslated family instead of forcing additional worship micro-batches
- Completed 2026-04-13: Tier C search hints batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `search*` hint slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `searchDuasHint`
    - `searchHadithHint`
    - `searchQuizzesHint`
    - `searchLifeLessonsHint`
    - `searchSurahHint`
    - `searchQuranTeachingHint`
    - `searchProphetsHint`
    - `searchDivineLessonsHint`
    - `searchTermsHint`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted search-hint slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C settings/accounts summary-tail batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `settings*` and `accountsSync*` summary-tail slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `settingsProfileDisplayNameSummary`
    - `settingsProfileLevelStreakSummary`
    - `settingsPercentValue`
    - `settingsCalculationMethodIsna`
    - `settingsSyncModeICloud`
    - `settingsCurrentProfileSummary`
    - `settingsSuggestedAdjustmentChangeRow`
    - `accountsSyncProfileStatusSummary`
    - `accountsSyncAccountSummary`
    - `accountsSyncProviderGoogle`
    - `accountsSyncCurrentProviderSummary`
    - `accountsSyncPendingUploadsTitle`
    - `accountsSyncPendingChangesCount`
    - `accountsSyncRecentSyncEventBullet`
    - `accountsSyncPendingChangesTitle`
    - `accountsSyncPendingChangesWaiting`
    - `accountsSyncTransportTitle`
    - `accountsSyncTransportSummary`
    - `accountsSyncDevicePlatformAndroidTv`
    - `accountsSyncThisDeviceAppleWatch`
    - `accountsSyncThisDeviceAndroidTv`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted settings/accounts summary-tail slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home opening shell batch for `pa`, `ps`, and `tg`.
  - Covered the opening shared `home*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `homePrayerSectionTitle`
    - `homePrayerDateToday`
    - `homePrayerDateYesterday`
    - `homePrayerDateTomorrow`
    - `homePrayerPreviousDayTooltip`
    - `homePrayerNextDayTooltip`
    - `homePrayerCompletedCountValue`
    - `homeSectionDailyNurTitle`
    - `homeSectionDailyNurSubtitle`
    - `homePrayerSummaryTitle`
    - `homePrayerSummarySubtitle`
    - `homeDhikrLearningTitle`
    - `homeDhikrLearningSubtitle`
    - `homeReflectionTitle`
    - `homeReflectionSubtitle`
    - `homeLevelStreakTitle`
    - `homeLevelStreakSubtitle`
    - `homePrayerProgressTitle`
    - `homeDhikrProgressTitle`
    - `homeCurrentStreakTitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted home opening shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home summary labels batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `home*` summary-label slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `homeXpLevelTitle`
    - `homeDaysLabel`
    - `homeWorshipSummaryTitle`
    - `homeWorshipSummarySubtitle`
    - `homeFastingStatusTitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted home summary-label slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home journey/learn/welcome batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `home*` continuity slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `homeKhusuQuickEntryTitle`
    - `homeKhusuQuickEntryValue`
    - `homeKhusuQuickEntryShort`
    - `homeLearnSummaryTitle`
    - `homeLearnSummarySubtitle`
    - `homeLearnContinueQuran`
    - `homeLearnContinueQuranValue`
    - `homeLearnFeaturedLife`
    - `homeLearnFeaturedLifeValue`
    - `homeLearnFeaturedWorld`
    - `homeLearnFeaturedWorldValue`
    - `homeLearnFeaturedHadith`
    - `homeLearnFeaturedHadithValue`
    - `homeLearnResumeNotes`
    - `homeLearnResumeNotesValue`
    - `homeJourneySummaryTitle`
    - `homeJourneySummarySubtitle`
    - `homeJourneyXpProgressTitle`
    - `homeJourneyDailyRingsTitle`
    - `homeJourneyNextUnlockTitle`
    - `homeJourneyNextUnlockValue`
    - `homeQuickActionsTitle`
    - `homeQuickActionsSubtitle`
    - `appQuickActionOpenToday`
    - `appQuickActionReadQuran`
    - `appQuickActionDailyLearning`
    - `homeReflectionReminder`
    - `homeWelcomeDailyIntentionTitle`
    - `homeWelcomeDailyIntentionSubtitle`
    - `homeWelcomePrayerRhythmTitle`
    - `homeWelcomePrayerRhythmSubtitle`
    - `homeWelcomeDhikrQuietTitle`
    - `homeWelcomeDhikrQuietSubtitle`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted home journey/learn/welcome slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home helpers batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent shared `home*` operational-helper slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - `homeEcosystemSummaryTitle`
    - `homeEcosystemSummarySubtitle`
    - `homeFastingBroken`
    - `homeFastingCompleted`
    - `homeFastingIntending`
    - `homeFastingNotFasting`
    - `homeLocationPromptTitle`
    - `homeLocationPromptSubtitle`
    - `homeLocationEnabledWhileUsing`
    - `homeLocationAllowWhileUsingForPrayer`
    - `homeLocationBlockedOpenSettings`
    - `homeLocationStatusCanUpdate`
    - `homePrayerCompletedTapHint`
    - `homePrayerForbiddenSunrise`
    - `homePrayerForbiddenSunset`
    - `homePrayerForbiddenZenith`
    - `homePrayerPostSalahDhikrAction`
    - `homePrayerPostSalahDhikrLogged`
    - `homeSearchTooltip`
    - `homeSearchHint`
    - `homeSearchNoResults`
    - `homeSearchClearTooltip`
    - `homeSearchCloseTooltip`
    - `homeTapVerseCardHint`
    - `homeTimeRemainingToOffer`
    - `homeTitle`
    - `homeTestLoadingScreenPill`
    - `homeTestOnboardingPill`
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted home helpers slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home widgets batch for `pa`, `ps`, and `tg`.
  - Covered the shared `homeWidgets*` slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - widget card titles and inline labels for ayah, hadith, reflection, daily dhikr, daily dua, journey progress, and the name of Allah
    - current/next prayer labels
    - morning/evening/night and daily-dua ready states
    - level, streak, target, and today XP labels
    - prayer-times and spiritual-content unavailable titles/bodies
    - prayer countdown formats and the prayer overview title
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted `homeWidgets*` slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home glass-preview batch for `pa`, `ps`, and `tg`.
  - Covered the shared `homeGlassVariant*` slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the glass-preview section title, subtitle, and footnote
    - all warm / milky / crystal / night / tinted / frosted / layered / edge-lit / adaptive / soft-matte / dense-sanctuary / clear-showcase titles, subtitles, body copy, footer labels, and micro-labels
  - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted `homeGlassVariant*` slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C home fresh audit checkpoint for `pa`, `ps`, and `tg`.
  - Re-audited the remaining shared `home*` values in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - Audit result:
    - the `home*` family is now down to five shared format-style wrappers only:
      - `homeContinueQuranValue`
      - `homeCountAndLabel`
      - `homeFractionValue`
      - `homeJourneyRingsValue`
      - `homeXpValue`
  - Audit target for this checkpoint:
    - confirm no worthwhile shared `home*` prose batch remains for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C learning journey shell batch for `pa`, `ps`, and `tg`.
  - Covered the next shared `learningJourney*` shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - lesson section labels for introduction, Arabic/meaning, takeaways, reflection, references, and explore-now
 - Completed 2026-04-13: Tier C learning journey browse/home batch for `pa`, `ps`, and `tg`.
  - Covered the next visible `learningJourney*` browse and home continuation slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - home continuation and recommendation rows
    - islands / browse-all / legacy home cards
    - learning-journey card stage-count, progress, and action labels
    - browse-all, featured, all-journeys, islands, tools, Qur'an, notes, bookmarks, and knowledge-constellation labels/subtitles
    - lesson action labels for Qur’an study, dhikr counter, complete/incomplete flow, next lesson, and return to journey
    - Qur’an reader / study / Arabic / salah tool-card titles and subtitles
    - Learning Journey home title, subtitle, continue/completed badges, completed message, and next-action label
 - Verification target for this checkpoint:
    - no exact-English carryovers remain in this targeted `learningJourney*` shell slice for `pa`, `ps`, and `tg`
- Completed 2026-04-13: Tier C learning journey islands/detail/tool shell batch for `pa`, `ps`, and `tg`.
  - Covered the next visible `learningJourney*` operational shell slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - island home cards plus legacy/tools/browse-all rows
    - stage badges and island/detail missing-state and placeholder rows
    - detail-page action and helper rows
    - learning-journey tool titles and short subtitles
- Completed 2026-04-13: Tier C learning journey Today Light batch for `pa`, `ps`, and `tg`.
  - Covered the next visible `learningJourneyTodayLight*` fallback-card slice in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - daily hadith / verse / reflection / trivia / dhikr fallback titles and subtitles
    - prophet fallback subtitle
    - the Today Light streak fallback row
- Completed 2026-04-13: Tier C learning journey recitation-meanings prose batch for `pa`, `ps`, and `tg`.
  - Covered the first deeper `learningJourneyStageRecite*` lesson family in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the Al-Fatihah understanding lesson
    - the common salah phrases lesson
    - the simple dhikr meanings lesson
- Completed 2026-04-13: Tier C learning journey reading-basics prose batch for `pa`, `ps`, and `tg`.
  - Covered the next deeper `learningJourneyStageReadingBasics*` lesson family in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the harakat and reading-clues lesson
    - the joining-letters reading lesson
    - the reading checkpoint lesson
- Completed 2026-04-13: Tier C learning journey Seerah opening prose batch for `pa`, `ps`, and `tg`.
  - Covered the first opening `learningJourneySeerah*` lesson pair in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the early life of the Prophet ﷺ lesson
    - the first revelation lesson
- Completed 2026-04-13: Tier C learning journey Seerah Makkah/Hijrah prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneySeerah*` lesson pair in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the Makkah-period lesson
    - the Hijrah lesson
- Completed 2026-04-13: Tier C learning journey Seerah Madinah/leadership prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneySeerah*` lesson pair in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the Madinah-society lesson
    - the leadership-and-character lesson
- Completed 2026-04-13: Tier C learning journey Seerah final-sermon prose batch for `pa`, `ps`, and `tg`.
  - Covered the remaining adjacent `learningJourneySeerahFinalSermon*` lesson in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the final-sermon lesson
    - titles, intro, section bodies, bullet points, takeaways, and reflection prompt
- Completed 2026-04-13: Tier C learning journey Dhikr opening/morning prose batch for `pa`, `ps`, and `tg`.
  - Covered the opening `learningJourneyDhikr*` lesson block in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `What Is Dhikr?` lesson
    - the `Morning Adhkar` lesson
    - the morning opening invocation title, meaning, and context
- Completed 2026-04-13: Tier C learning journey Dhikr evening/after-salah prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneyDhikr*` lesson block in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `Evening Adhkar` lesson
    - the `After Salah Dhikr` lesson
    - the evening and post-salah invocation title, meaning, and context rows
- Completed 2026-04-13: Tier C learning journey Dhikr routine/istighfar prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneyDhikr*` lesson block in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `Simple Daily Routine` lesson
    - the `Istighfar` lesson
    - the simple istighfar invocation title, meaning, and context
- Completed 2026-04-13: Tier C learning journey Dhikr salawat prose batch for `pa`, `ps`, and `tg`.
  - Covered the remaining adjacent `learningJourneyDhikrSalawat*` lesson in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `Salawat` lesson
    - the short salawat invocation title, meaning, and context
- Completed 2026-04-13: Tier C learning journey Dhikr fresh audit checkpoint for `pa`, `ps`, and `tg`.
  - Re-audited the remaining shared `learningJourneyDhikr*` values in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - Cleared the final shared carryover:
    - `learningJourneyDhikrRoutineActionStep`
- Completed 2026-04-13: Tier C learning journey faith books/prophets prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneyFaith*` lesson pair in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `Books` lesson
    - the `Prophets` lesson
    - titles, intros, section bodies, bullet points, takeaways, and reflection prompts
- Completed 2026-04-13: Tier C learning journey faith judgment/qadr prose batch for `pa`, `ps`, and `tg`.
  - Covered the next adjacent `learningJourneyFaith*` lesson pair in:
    - `app_pa.arb`
    - `app_ps.arb`
    - `app_tg.arb`
  - This batch translated:
    - the `Judgment` lesson
    - the `Qadr` lesson
    - titles, intros, section bodies, bullet points, takeaways, and reflection prompts
