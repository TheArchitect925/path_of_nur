# Localization Translation Audit — Next Batch

Date: 2026-04-13  
Scope: `lib/l10n/*.arb` (14 locale files + `app_en.arb`)

## Current status

- Missing keys (same for all locales): 6  
- Same-as-English keys: substantial in every non-EN locale.

### Missing keys (all locales)

1. `@homeWidgetsPrayerCountdownInHoursMinutes`
2. `@homeWidgetsPrayerCountdownInMinutes`
3. `@rewardQuietCompletionSummaryDropsOnly`
4. `@rewardQuietCompletionSummaryXpDrops`
5. `@rewardQuietCompletionSummaryXpOnly`
6. `@triviaHomeRecentPerformanceSummaryQuiet`

## Large untranslated families to tackle next

Computed by current key-family heuristic (`first camel-word prefix`) across all non-English locales.

1. `learning` — 22,176 untranslated occurrences (2,071 keys)
2. `quran` — 16,857 untranslated occurrences (1,295 keys)
3. `learn` — 12,211 untranslated occurrences (964 keys)
4. `kids` — 10,711 untranslated occurrences (987 keys)
5. `growth` — 4,434 untranslated occurrences (380 keys)
6. `editorial` — 3,855 untranslated occurrences (257 keys)
7. `bedtime` — 3,396 untranslated occurrences (305 keys)
8. `hadith` — 1,923 untranslated occurrences (370 keys) — next queue: `docs/localization_hadith_family_queue_2026-04-13.md`
9. `wudu` — 1,698 untranslated occurrences (139 keys)
10. `guided` — 1,650 untranslated occurrences (110 keys)

## Recommended next steps

### Option A (largest impact)
- Translate/restore the `learning` family first.
- Covers most of the pending content and has highest occurrence/coverage impact.

### Option B (balanced)
- Process `quran` + `learn` together next.
- Keeps user-facing learning surfaces coherent across main and kids flows.

### Option C (content continuity)
- Start with `kids` if child-focused surfaces are highest priority in the next sprint.

### Option D (smallest-risk quick win)
- Fill the 6 missing keys with finalized localized values in all locales first, then continue high-volume families.

### Active next pass (2026-04-13 continuation)

- Chosen sequence: `learning` → `quran` → `learn` → `kids` → `growth`.
- Execution note: details and success conditions are now tracked in:
  - `docs/localization_next_batch_execution_2026-04-13.md`

### Current status (after prior learning attempt)

- `learning` batch was audited but translation application remained blocked by environment network restrictions.
- `quran` audit is now current and is the active queue to resume next.
  - `docs/localization_quran_batch_tranche2_2026-04-13.md` is prepared for the next import tranche.
- Latest quran-family audit result: `1,555` keys, `16,857` same-as-English occurrences across active locales (`72.25%` of evaluated quran-family entries).
- Validation baseline remains unchanged for this pass:
  - 6 shared missing keys in all non-English locale ARB files.
  - known placeholder-mismatch debt across locales (no new mismatches introduced by this pass).
- `quran` tranche queue is now fully staged for handoff: 
  - `docs/localization_quran_batch_tranche_2026-04-13.md`
  - `docs/localization_quran_batch_tranche2_2026-04-13.md`
  - `docs/localization_quran_batch_tranche3_2026-04-13.md`
  - `docs/localization_quran_batch_tranche4_2026-04-13.md`
  - `docs/localization_quran_batch_tranche5_2026-04-13.md`
  - `docs/localization_quran_batch_tranche6_2026-04-13.md`
  - `docs/localization_quran_batch_tranche7_2026-04-13.md`
  - `docs/localization_quran_batch_tranche8_2026-04-13.md`
  - `docs/localization_quran_batch_tranche9_2026-04-13.md`
  - `docs/localization_quran_batch_tranche10_2026-04-13.md`
  - `docs/localization_quran_batch_tranche11_2026-04-13.md`
  - `docs/localization_quran_batch_tranche12_2026-04-13.md`
  - `docs/localization_quran_batch_tranche13_2026-04-13.md`
- Next family queue is now opened for post-quran continuation:
  - `docs/localization_learn_batch_tranche_2026-04-13.md`
  - `docs/localization_learn_tranche1_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche2_2026-04-13.md`
  - `docs/localization_learn_tranche2_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche3_2026-04-13.md`
  - `docs/localization_learn_tranche3_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche4_2026-04-13.md`
  - `docs/localization_learn_tranche4_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche5_2026-04-13.md`
  - `docs/localization_learn_tranche5_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche6_2026-04-13.md`
  - `docs/localization_learn_tranche6_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche7_2026-04-13.md`
  - `docs/localization_learn_tranche7_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche8_2026-04-13.md`
  - `docs/localization_learn_tranche8_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche9_2026-04-13.md`
  - `docs/localization_learn_tranche9_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche10_2026-04-13.md`
  - `docs/localization_learn_tranche10_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche11_2026-04-13.md`
  - `docs/localization_learn_tranche11_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche12_2026-04-13.md`
  - `docs/localization_learn_tranche12_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche13_2026-04-13.md`
  - `docs/localization_learn_tranche13_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche14_2026-04-13.md`
  - `docs/localization_learn_tranche14_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche15_2026-04-13.md`
  - `docs/localization_learn_tranche15_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche16_2026-04-13.md`
  - `docs/localization_learn_tranche16_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche17_2026-04-13.md`
  - `docs/localization_learn_tranche17_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche18_2026-04-13.md`
  - `docs/localization_learn_tranche18_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche19_2026-04-13.md`
  - `docs/localization_learn_tranche19_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche20_2026-04-13.md`
  - `docs/localization_learn_tranche20_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche21_2026-04-13.md`
  - `docs/localization_learn_tranche21_source_2026-04-13.csv`
  - `docs/localization_learn_batch_tranche22_2026-04-13.md`
  - `docs/localization_learn_tranche22_source_2026-04-13.csv`
