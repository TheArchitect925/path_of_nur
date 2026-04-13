# Localization Enhancement Backlog — 2026-04-13

## Priority options for the next pass

1. **Option A (Recommended): quran tranche-series**
   - Execute `quran` tranche 2 immediately using `docs/localization_quran_batch_tranche2_2026-04-13.md`.
   - Keep existing tranche 3 order and continue in 120-key increments.
   - Best for highest-impact user-visible learn surfaces after the prepared learning tranches.

2. **Option B: language-priority first**
   - Translate top-overlap locales for `learning` and `quran` together (`ur`, `ar`, `de`, `tr`), applying both tranches in parallel.
   - Useful if one locale coordinator is already staffed for both families.

3. **Option C: smaller-family stabilization**
   - Pause large-family work, clear remaining hard-missing keys, then run `learn` and `kids` focused passes.
   - Useful when translator availability is constrained and quality QA needs smaller batches.

4. **Option D: quality-first manual review**
   - Before machine/auto translation, route only one 120-key tranche at a time through trusted manual review.
   - Run validation after each locale batch and keep rollout incremental.

## Current queue recommendation

- Queue now prepared for immediate import workflow:
  1. `docs/localization_learning_batch_tranche2_2026-04-13.md` (+ source CSV)
  2. `docs/localization_quran_batch_tranche2_2026-04-13.md` (+ source CSV)
  3. `docs/localization_quran_batch_tranche_2026-04-13.md` (+ source CSV) if needed for rebalancing
  4. `docs/localization_quran_batch_tranche3_2026-04-13.md` (+ source CSV)
  5. `docs/localization_quran_batch_tranche4_2026-04-13.md` (+ source CSV)
  6. `docs/localization_quran_batch_tranche5_2026-04-13.md` (+ source CSV)
  7. `docs/localization_quran_batch_tranche6_2026-04-13.md` (+ source CSV)
  8. `docs/localization_quran_batch_tranche7_2026-04-13.md` (+ source CSV)
  9. `docs/localization_quran_batch_tranche8_2026-04-13.md` (+ source CSV)
  10. `docs/localization_quran_batch_tranche9_2026-04-13.md` (+ source CSV)
  11. `docs/localization_quran_batch_tranche10_2026-04-13.md` (+ source CSV)
  12. `docs/localization_quran_batch_tranche11_2026-04-13.md` (+ source CSV)
  13. `docs/localization_quran_batch_tranche12_2026-04-13.md` (+ source CSV)
  14. `docs/localization_quran_batch_tranche13_2026-04-13.md` (+ source CSV, final short tail batch)
  15. `docs/localization_learn_batch_tranche_2026-04-13.md` (+ source CSV, first post-quran family batch)
  16. `docs/localization_learn_batch_tranche2_2026-04-13.md` (+ source CSV)
  17. `docs/localization_learn_batch_tranche3_2026-04-13.md` (+ source CSV)
  18. `docs/localization_learn_batch_tranche4_2026-04-13.md` (+ source CSV)
  19. `docs/localization_learn_batch_tranche5_2026-04-13.md` (+ source CSV)
  20. `docs/localization_learn_batch_tranche6_2026-04-13.md` (+ source CSV)
  21. `docs/localization_learn_batch_tranche7_2026-04-13.md` (+ source CSV)
  22. `docs/localization_learn_batch_tranche8_2026-04-13.md` (+ source CSV)
  23. `docs/localization_learn_batch_tranche9_2026-04-13.md` (+ source CSV)
  24. `docs/localization_learn_batch_tranche10_2026-04-13.md` (+ source CSV)
  25. `docs/localization_learn_batch_tranche11_2026-04-13.md` (+ source CSV)
  26. `docs/localization_learn_batch_tranche12_2026-04-13.md` (+ source CSV)
  27. `docs/localization_learn_batch_tranche13_2026-04-13.md` (+ source CSV)
  28. `docs/localization_learn_batch_tranche14_2026-04-13.md` (+ source CSV)
  29. `docs/localization_learn_batch_tranche15_2026-04-13.md` (+ source CSV)
  30. `docs/localization_learn_batch_tranche16_2026-04-13.md` (+ source CSV)
  31. `docs/localization_learn_batch_tranche17_2026-04-13.md` (+ source CSV)
  32. `docs/localization_learn_batch_tranche18_2026-04-13.md` (+ source CSV)
  33. `docs/localization_learn_batch_tranche19_2026-04-13.md` (+ source CSV)
  34. `docs/localization_learn_batch_tranche20_2026-04-13.md` (+ source CSV)
  35. `docs/localization_learn_batch_tranche21_2026-04-13.md` (+ source CSV)
  36. `docs/localization_learn_batch_tranche22_2026-04-13.md` (+ source CSV)
- Validation command for each stage:  
  `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`

## Success criteria per stage

- Translator handoff files are received and merged without placeholder/ICU corruption.
- `quran` same-as-English occurrences decrease measurably after each stage.
- No new hard-missing keys introduced in non-English ARB files.
