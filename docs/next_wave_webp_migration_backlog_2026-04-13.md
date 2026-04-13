# Next Wave WebP Migration Backlog

1. Completed 2026-04-13: Ranked the remaining runtime PNG folders after the completed backgrounds, Wudu, and prophets work, and selected `assets/images/kids_dua_stories` as the next clean batch because it is the largest remaining pure-runtime PNG folder with consistent scenic illustration assets and a centralized runtime owner.
2. Completed 2026-04-13: Deferred `assets/icons/` from this batch because it mixes Flutter runtime imagery with launcher/build-tooling and branding references, making it a weaker candidate for a same-pass fully verified conversion plus policy cleanup.
3. Completed 2026-04-13: Ran a readiness pass and tiny lossy sample validation for `assets/images/kids_dua_stories`, confirming all `12` scenes were 1200x800 scenic illustrations and fit a consistent `LOSSY_Q85` conversion strategy.
4. Completed 2026-04-13: Generated real sibling `.webp` files for all `12` kids dua story scenes, migrated the centralized illustration service and focused tests to `.webp`, removed the folder allowlist exemption, and confirmed analyzer, test, and policy all passed.
5. Completed 2026-04-13: Archived and deleted all `12` verified legacy PNGs for `assets/images/kids_dua_stories` after policy and reference validation, leaving the folder fully WebP-backed with no intentional PNG holdouts.

## Notes

- Batch readiness status: `READY`
- Conversion mode used for the full batch: `LOSSY_Q85`
- No manual-review holdouts were needed in this kids dua story wave.
- The runtime PNG policy now passes without any `kids_dua_stories` exception or migrated-legacy fallback remaining for that folder.

## Exact Savings

- Original PNG total: `2,031,384` bytes
- New WebP total: `84,596` bytes
- Saved: `1,946,788` bytes
- Saved: `1.86 MB`
- Reduction: `95.84%`

## Validation

- `flutter analyze lib/features/kids_dua_learning/application/kids_dua_story_illustration_service.dart test/features/kids_dua_learning/kids_dua_story_illustration_service_test.dart` passed.
- `flutter test test/features/kids_dua_learning/kids_dua_story_illustration_service_test.dart` passed.
- `bash tooling/scripts/check_runtime_png_policy.sh` passed after policy tightening and again after verified cleanup.

## Enhancement Options

- Next safest conversion batch: split `assets/icons/` into runtime-safe subgroups versus launcher/build-tooling references, then migrate only the truly app-owned runtime icon assets.
- Separate track: resolve the unrelated `kids_stories` and `quran_teacher` missing-asset integrity debt so later audits stay cleaner.
- Follow-up policy hardening: once icon/runtime asset debt is smaller, tighten the runtime PNG allowlist even further toward explicit one-file exceptions only.
