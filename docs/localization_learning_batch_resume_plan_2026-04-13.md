# Localization Learning Batch Resume Plan

Date: 2026-04-13
Scope: Continue translation debt reduction after offline-safe audit.

## Latest status snapshot

- Active target remained `learning` family first (`learning*` keys), then `quran`, then `learn`.
- We executed an automated same-as-English pass for `learning*`, but translation calls could not reach external services (DNS to `translate.google.com` fails).
- No effective `learning*` translations were applied in this pass.
- The first manual tranche handoff has been prepared for the highest-impact `learning*` keys:
  - `docs/localization_learning_batch_tranche_2026-04-13.md`
  - `docs/localization_learning_tranche1_source_2026-04-13.csv`
- The second manual tranche handoff has now been prepared:
  - `docs/localization_learning_batch_tranche2_2026-04-13.md`
  - `docs/localization_learning_tranche2_source_2026-04-13.csv`
- Each tranche contains 120 `learning*` keys and includes English source text for translation.
- The tranches are queued for the same-as-English handoff workflow.

## Current `learning*` same-as-English counts

- `ar`: 224 / 2,095
- `bn`: 2,055 / 2,095
- `de`: 242 / 2,095
- `fa`: 2,055 / 2,095
- `fa_AF`: 2,055 / 2,095
- `ha`: 2,055 / 2,095
- `hi`: 727 / 2,095
- `id`: 2,055 / 2,095
- `ku`: 2,055 / 2,095
- `ms`: 2,055 / 2,095
- `pa`: 1,432 / 2,095
- `ps`: 1,432 / 2,095
- `tg`: 1,432 / 2,095
- `tr`: 2,055 / 2,095
- `ur`: 247 / 2,095

## Queue impact snapshot for top families after this run

| Family | ar | bn | de | fa | fa_AF | ha | hi | id | ku | ms | pa | ps | tg | tr | ur |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| learning (2,095) | 224 | 2,055 | 242 | 2,055 | 2,055 | 2,055 | 727 | 2,055 | 2,055 | 1,432 | 1,432 | 1,432 | 2,055 | 247 |
| quran (1,555) | 841 | 1,287 | 846 | 1,244 | 1,244 | 1,287 | 1,057 | 1,123 | 1,295 | 1,287 | 1,132 | 1,132 | 1,122 | 828 |
| learn (1,054) | 453 | 949 | 436 | 949 | 949 | 957 | 669 | 833 | 952 | 951 | 951 | 949 | 949 | 831 |
| kids (988) | 142 | 976 | 154 | 976 | 976 | 976 | 328 | 898 | 987 | 977 | 653 | 653 | 653 | 898 | 464 |
| growth (381) | 24 | 380 | 35 | 380 | 380 | 380 | 172 | 380 | 380 | 380 | 380 | 380 | 380 | 380 | 23 |

## Enhancement options

1. **Option A (Recommended when network is available):**
   - Run a full `learning*` auto-translation pass from an environment with `deep_translator`/Google connectivity.
   - Re-run `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`.

2. **Option B (Lower risk, partial):**
   - Start with the highest-impact locales for `learning*` by count (`bn`, `de`, `fa`, `fa_AF`, `ha`, `id`, `ku`, `ms`, `tr`).
   - For each locale, translate only `learning*` keys where locale value equals English, then run family validation.

3. **Option C (Offline-friendly follow-up):**
 - Keep current file state unchanged.
   - Use the prepared tranche files and assign them to your preferred translator workflow (human or internal MT tool), then import in small batches.
   - The same-as-English queue file can be regenerated later using the current `learning*` family scan if needed.

## Next command set once translation service is available

- `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
- `python3 tools/localization_stage_translate.py --source lib/l10n/app_en.arb --target <locale> --batch-size 40`
- `flutter analyze` and targeted localization tests.
