# Localization Next Batch Execution

Date: 2026-04-13
Scope: `lib/l10n/*.arb` gap reduction, starting with largest families first.

## What the fresh scan says

- Total same-as-English debt snapshot (all locales combined):
  - `learning`: 22,176 occurrences (2,071 keys)
  - `quran`: 16,857 occurrences (1,295 keys)
  - `learn`: 12,211 occurrences (964 keys)
  - `kids`: 10,711 occurrences (987 keys)
  - `growth`: 4,434 occurrences (380 keys)
  - `editorial`: 3,855 occurrences (257 keys)
- Hard missing keys across locales remain unchanged: 6 shared keys are absent in non-English files.
  - `homeWidgetsPrayerCountdownInHoursMinutes`
  - `homeWidgetsPrayerCountdownInMinutes`
  - `rewardQuietCompletionSummaryDropsOnly`
  - `rewardQuietCompletionSummaryXpDrops`
  - `rewardQuietCompletionSummaryXpOnly`
  - `triviaHomeRecentPerformanceSummaryQuiet`

## Priority sequence (large-to-small)

1. **Batch 1 (large-impact): `learning` family**
   - Rationale: highest untranslated incidence and key volume.
   - Success condition: reduce same-as-English rate for `learning*` keys by at least 30% in a single run.
   - QA check: run a family-specific validation after changes to ensure placeholders and ICU metadata still match.
   - Status: first manual tranche prepared for translation handoff (`tranche 1` + source CSV created); application still blocked by DNS/network limits.

2. **Batch 2: `quran` family**
   - Rationale: second-largest and high user-surface impact.
   - Success condition: measurable reduction in `quran*` untranslated occurrences across locales.
   - Status: currently on hold until a translation-capable handoff or network-assisted flow is available.

3. **Batch 3: `learn` + `kids` families**
   - Run together only if translator throughput/QA bandwidth permits.

4. **Batch 4: `growth` + `editorial` families**
   - Lower volume than top 3 but still high visibility in profile/home-learning surfaces.

## “Next-step” options after Batch 1

- **Option A (recommended):** auto-stage `learning` using machine translation for all supported locales, then manually curate top user-facing subsets (buttons, section headers, short labels).
- **Option B (lower risk):** first localize the top 30 highest-visibility `learning*` keys (as determined by usage counts), then scale remaining body-copy keys in a second pass.
- **Option C:** normalize to smaller locale subset (`ar`, `ur`, `de`, `tr`) for first production pass, then expand to full locale set.

Current implementation-ready next step for this audit run:

- `learning` tranche 2 is now prepared and queued:
  - `docs/localization_learning_batch_tranche2_2026-04-13.md`
  - `docs/localization_learning_tranche2_source_2026-04-13.csv`
- `learn` tranche 1 is now prepared and queued as the next post-quran family handoff:
  - `docs/localization_learn_batch_tranche_2026-04-13.md`
  - `docs/localization_learn_tranche1_source_2026-04-13.csv`
- `learn` tranche 2 is now prepared and queued:
  - `docs/localization_learn_batch_tranche2_2026-04-13.md`
  - `docs/localization_learn_tranche2_source_2026-04-13.csv`
- `learn` tranche 3 is now prepared and queued:
  - `docs/localization_learn_batch_tranche3_2026-04-13.md`
  - `docs/localization_learn_tranche3_source_2026-04-13.csv`
- `learn` tranche 4 is now prepared and queued:
  - `docs/localization_learn_batch_tranche4_2026-04-13.md`
  - `docs/localization_learn_tranche4_source_2026-04-13.csv`
- `learn` tranche 5 is now prepared and queued:
  - `docs/localization_learn_batch_tranche5_2026-04-13.md`
  - `docs/localization_learn_tranche5_source_2026-04-13.csv`
- `learn` tranche 6 is now prepared and queued:
  - `docs/localization_learn_batch_tranche6_2026-04-13.md`
  - `docs/localization_learn_tranche6_source_2026-04-13.csv`
- `learn` tranche 7 is now prepared and queued:
  - `docs/localization_learn_batch_tranche7_2026-04-13.md`
  - `docs/localization_learn_tranche7_source_2026-04-13.csv`
- `learn` tranche 8 is now prepared and queued:
  - `docs/localization_learn_batch_tranche8_2026-04-13.md`
  - `docs/localization_learn_tranche8_source_2026-04-13.csv`
- `learn` tranche 9 is now prepared and queued:
  - `docs/localization_learn_batch_tranche9_2026-04-13.md`
  - `docs/localization_learn_tranche9_source_2026-04-13.csv`
- `learn` tranche 10 is now prepared and queued:
  - `docs/localization_learn_batch_tranche10_2026-04-13.md`
  - `docs/localization_learn_tranche10_source_2026-04-13.csv`
- `learn` tranche 11 is now prepared and queued:
  - `docs/localization_learn_batch_tranche11_2026-04-13.md`
  - `docs/localization_learn_tranche11_source_2026-04-13.csv`
- `learn` tranche 12 is now prepared and queued:
  - `docs/localization_learn_batch_tranche12_2026-04-13.md`
  - `docs/localization_learn_tranche12_source_2026-04-13.csv`
- `learn` tranche 13 is now prepared and queued:
  - `docs/localization_learn_batch_tranche13_2026-04-13.md`
  - `docs/localization_learn_tranche13_source_2026-04-13.csv`
- `learn` tranche 14 is now prepared and queued:
  - `docs/localization_learn_batch_tranche14_2026-04-13.md`
  - `docs/localization_learn_tranche14_source_2026-04-13.csv`
- `learn` tranche 15 is now prepared and queued:
  - `docs/localization_learn_batch_tranche15_2026-04-13.md`
  - `docs/localization_learn_tranche15_source_2026-04-13.csv`
- `learn` tranche 16 is now prepared and queued:
  - `docs/localization_learn_batch_tranche16_2026-04-13.md`
  - `docs/localization_learn_tranche16_source_2026-04-13.csv`
- `learn` tranche 17 is now prepared and queued:
  - `docs/localization_learn_batch_tranche17_2026-04-13.md`
  - `docs/localization_learn_tranche17_source_2026-04-13.csv`
- `learn` tranche 18 is now prepared and queued:
  - `docs/localization_learn_batch_tranche18_2026-04-13.md`
  - `docs/localization_learn_tranche18_source_2026-04-13.csv`
- `learn` tranche 19 is now prepared and queued:
  - `docs/localization_learn_batch_tranche19_2026-04-13.md`
  - `docs/localization_learn_tranche19_source_2026-04-13.csv`
- `learn` tranche 20 is now prepared and queued:
  - `docs/localization_learn_batch_tranche20_2026-04-13.md`
  - `docs/localization_learn_tranche20_source_2026-04-13.csv`
- `learn` tranche 21 is now prepared and queued:
  - `docs/localization_learn_batch_tranche21_2026-04-13.md`
  - `docs/localization_learn_tranche21_source_2026-04-13.csv`
- `learn` tranche 22 is now prepared and queued:
  - `docs/localization_learn_batch_tranche22_2026-04-13.md`
  - `docs/localization_learn_tranche22_source_2026-04-13.csv`
- `quran` tranche queue is now prepared and queued:
  - `docs/localization_quran_batch_tranche2_2026-04-13.md`
  - `docs/localization_quran_tranche2_source_2026-04-13.csv`
- `quran` tranche 3 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche3_2026-04-13.md`
  - `docs/localization_quran_tranche3_source_2026-04-13.csv`
- `quran` tranche 4 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche4_2026-04-13.md`
  - `docs/localization_quran_tranche4_source_2026-04-13.csv`
- `quran` tranche 5 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche5_2026-04-13.md`
  - `docs/localization_quran_tranche5_source_2026-04-13.csv`
- `quran` tranche 6 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche6_2026-04-13.md`
  - `docs/localization_quran_tranche6_source_2026-04-13.csv`
- `quran` tranche 7 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche7_2026-04-13.md`
  - `docs/localization_quran_tranche7_source_2026-04-13.csv`
- `quran` tranche 8 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche8_2026-04-13.md`
  - `docs/localization_quran_tranche8_source_2026-04-13.csv`
- `quran` tranche 9 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche9_2026-04-13.md`
  - `docs/localization_quran_tranche9_source_2026-04-13.csv`
- `quran` tranche 10 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche10_2026-04-13.md`
  - `docs/localization_quran_tranche10_source_2026-04-13.csv`
- `quran` tranche 11 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche11_2026-04-13.md`
  - `docs/localization_quran_tranche11_source_2026-04-13.csv`
- `quran` tranche 12 is prepared and queued for the next handoff:
  - `docs/localization_quran_batch_tranche12_2026-04-13.md`
  - `docs/localization_quran_tranche12_source_2026-04-13.csv`
- `quran` tranche 13 is prepared as the final remaining tail batch in this queue:
  - `docs/localization_quran_batch_tranche13_2026-04-13.md`
  - `docs/localization_quran_tranche13_source_2026-04-13.csv`

## Next commands to run

1. `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
2. `flutter analyze` and `flutter test` for the changed surface (or full suite if scope allows).

## Open question

Choose one of the options above for Batch 1 execution order:
- A (full `learning` auto-stage)
- B (high-visibility-first learning pass)
- C (partial locale-first learning pass)
