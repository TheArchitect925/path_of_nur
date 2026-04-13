# Quran Translation Next Steps — 2026-04-13

## Current status

- Arabic-family quran translation debt remains large and is concentrated in newly added teaching/learning surfaces.
- Current totals from this pass:
  - `quran*` keys in `app_en.arb`: 1,555
  - Same-as-English occurrences: 16,857 across 15 active locales
  - Keys fully untranslated in all 15 locales: 608
- Highest-burden locales to clear first:
  - `ur` 828
  - `ar` 841
  - `de` 846

## Enhancement options

### Option A — Auto-stage one tranche + reviewer

Use machine translation on a constrained quran slice, then run strict human review before merge.

- Keep the feature safe:
  - Translate only `docs/localization_quran_batch_tranche_2026-04-13.md` tranche files.
  - Merge into `lib/l10n/app_<locale>.arb` only after human approval.
- Risks:
  - Current environment stage translation returned English for at least one spot-check tranche; likely due translation service mismatch in this environment.

### Option B — Manual assisted translation batch (recommended for quality)

- Translate the next batch manually in the same order as `docs/localization_quran_batch_tranche_2026-04-13.md` tranche 1.
- Validate placeholders and plural/select ICU patterns by running:
  - `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
- Then run route-level localization QA.

### Option C — Locale-priority chunking

- Finish `ur`, `ar`, `de` first with the same tranche files because they carry the largest untranslated overlap, then fan out to other locales.
- Rebalance once those three are materially reduced.

## Next concrete queue

- Continue directly with:
  - `docs/localization_quran_batch_tranche_2026-04-13.md`
- Current tranche ordering:
  - `Tranche 1` (120 keys)
  - `Tranche 2` (next 120 keys: `docs/localization_quran_batch_tranche2_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche2_source_2026-04-13.csv`
  - `Tranche 3` (next 120 keys: `docs/localization_quran_batch_tranche3_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche3_source_2026-04-13.csv`
  - `Tranche 4` (next 120 keys: `docs/localization_quran_batch_tranche4_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche4_source_2026-04-13.csv`
  - `Tranche 5` (next 120 keys: `docs/localization_quran_batch_tranche5_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche5_source_2026-04-13.csv`
  - `Tranche 6` (next 120 keys: `docs/localization_quran_batch_tranche6_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche6_source_2026-04-13.csv`
  - `Tranche 7` (next 120 keys: `docs/localization_quran_batch_tranche7_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche7_source_2026-04-13.csv`
  - `Tranche 8` (next 120 keys: `docs/localization_quran_batch_tranche8_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche8_source_2026-04-13.csv`
  - `Tranche 9` (next 120 keys: `docs/localization_quran_batch_tranche9_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche9_source_2026-04-13.csv`
  - `Tranche 10` (next 120 keys: `docs/localization_quran_batch_tranche10_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche10_source_2026-04-13.csv`
  - `Tranche 11` (next 120 keys: `docs/localization_quran_batch_tranche11_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche11_source_2026-04-13.csv`
  - `Tranche 12` (next 120 keys: `docs/localization_quran_batch_tranche12_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche12_source_2026-04-13.csv`
  - `Tranche 13` (final remaining 115 keys: `docs/localization_quran_batch_tranche13_2026-04-13.md`)
  - Source: `docs/localization_quran_tranche13_source_2026-04-13.csv`

## Validation commands

1. `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
2. `flutter analyze`
3. Route-level localization sweep on Qur'an learning and reader-related surfaces.
