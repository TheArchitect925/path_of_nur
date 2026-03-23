# Localization Mega Rollout Backlog

Date: 2026-03-23

## What is now in place

- Added [tools/localization_validate.py](/Users/shahabmansoor/Developer/path_of_nur/tools/localization_validate.py) to audit locale parity and placeholder safety against `app_en.arb`.
- Added [tools/localization_stage_translate.py](/Users/shahabmansoor/Developer/path_of_nur/tools/localization_stage_translate.py) to stage new or incomplete locales into `*.generated.arb` files without overwriting canonical locale files.
- Verified current locale status with the validator:
  - `ur`: complete
  - `ar`: complete
  - `de`: complete
  - `hi`: incomplete
  - `tr`: incomplete
  - `fr`: missing
  - `id`: incomplete

## Current structural status

- Complete locales:
  - Urdu
  - Arabic
  - German
- Incomplete locales:
  - Hindi
  - Turkish
  - Indonesian
- Missing locale:
  - French

## Safest next rollout order

1. Use `tools/localization_stage_translate.py` to generate staged files for `fr`, `hi`, `tr`, and `id`.
2. Run `tools/localization_validate.py` on each staged file until:
   - no missing keys
   - no extra keys
   - no placeholder mismatches
3. Run `flutter gen-l10n`.
4. Run `flutter analyze`.
5. Do high-traffic editorial QA for each newly completed language.

## Enhancement options

1. Add a small wrapper script that stages all incomplete locales in one command but still writes only to `*.generated.arb`.
2. Add locale-specific term glossaries for Islamic terminology so machine-assisted staging stays more consistent.
3. Add a CI/local check that fails if any locale has missing keys or placeholder mismatches.
4. Add high-traffic screen smoke tests for completed locales to catch visible fallback text and layout pressure early.
