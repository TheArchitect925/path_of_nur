# Quran Family Resume Plan — 2026-04-13

Date: 2026-04-13
Scope: continue localization audit and preparation for `quran*` key execution.

## Current quran family status (active locale files only)

- Total quran-family keys in `app_en.arb`: 1,555
- Total same-as-English occurrences: 16,857
- Total locale-key checks: 23,325 (1,555 keys × 15 locales)
- Same-as-English rate: 72.25%

### Per-locale `quran*` status

| Locale | Same-as-English | Missing | Already localized |
|---|---:|---:|---:|
| app_ar.arb | 841 | 0 | 714 |
| app_bn.arb | 1,287 | 0 | 268 |
| app_de.arb | 846 | 0 | 709 |
| app_fa.arb | 1,244 | 0 | 311 |
| app_fa_AF.arb | 1,244 | 0 | 311 |
| app_ha.arb | 1,287 | 0 | 268 |
| app_hi.arb | 1,057 | 0 | 498 |
| app_id.arb | 1,123 | 0 | 432 |
| app_ku.arb | 1,295 | 0 | 260 |
| app_ms.arb | 1,287 | 0 | 268 |
| app_pa.arb | 1,132 | 0 | 423 |
| app_ps.arb | 1,132 | 0 | 423 |
| app_tg.arb | 1,132 | 0 | 423 |
| app_tr.arb | 1,122 | 0 | 433 |
| app_ur.arb | 828 | 0 | 727 |

- `lib/l10n/app_bn.generated.arb` is a generated artifact and remains excluded from active translation work.

## What’s already known from this audit pass

- 608 `quran*` keys are still English in all 15 active locales.
- The highest-overlap candidates remain concentrated in reading mode/teaching/review sections; this aligns with current recent content additions.
- No `quran*` keys were modified during this pass because translation services are still unreachable in this environment.

## Environment check (this pass)

- A 20-key probe translation run was executed with `tools/localization_stage_translate.py` for locale `ur`.
- The staged output remained English in this environment, so translation must continue through approved manual/queue workflow.
- Use the next-tranche queue files for deterministic handoff:
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

## Next options

1. **Option A (recommended when translator access is available):** auto-stage all `quran*` keys in one sweep for all 15 active locales, then manually review high-traffic pages only.
   - `python3 tools/localization_stage_translate.py --source lib/l10n/app_en.arb --target <locale> --batch-size 40`
   - `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`

2. **Option B (lower-risk):** prioritize `quran*` keys used on high-traffic surfaces first (reader cards, action buttons, guidance labels), then move to secondary teaching text.

3. **Option C (offline queue):** generate a manual queue from remaining same-as-English `quran*` keys and pass to a human translator in small batches.

## Recommended immediate next commands

1. `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
2. `python3 tools/localization_audit.py --family quran --missing-only --output docs/localization_quran_batch_queue_2026-04-13.md` *(if the audit helper is present)
3. `flutter analyze` and targeted route/widget localization tests after replacements.
