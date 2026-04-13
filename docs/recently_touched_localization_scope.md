# Recently Touched Localization Scope

Date: 2026-04-12

## Active scope groups

- `hadith_reader_phase3`
- `broader_hadith_quran`

## Current focus

- Hadith reader provenance, chapter metadata, continuity copy, and display-settings labels
- Hadith browse/search and source-browse copy
- Qur'an memorization review
- Qur'an daily companion and recommendation continuity
- Qur'an themes/topic discovery
- Qur'an reference-detail handoff copy

## Preferred validation commands

```bash
flutter gen-l10n
flutter test test/app/localization_arb_regression_test.dart
dart run tool/localization_surface_audit.dart --group broader_hadith_quran --group hadith_reader_phase3
```

## Preferred masked translation workflow

1. Export a scoped masked batch:

```bash
dart run tool/localization_masked_translation.dart export \
  --locale lib/l10n/app_tr.arb \
  --group hadith_reader_phase3 \
  --out tmp/app_tr.hadith_reader_phase3.masked.json
```

2. Translate only the masked values while preserving `__PH_#__` tokens.

3. Validate and import:

```bash
dart run tool/localization_masked_translation.dart import \
  --locale lib/l10n/app_tr.arb \
  --input tmp/app_tr.hadith_reader_phase3.masked.json \
  --write
```

4. Re-run the validation commands above before closing the pass.
