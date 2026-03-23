# Hindi Locale Build Fix Backlog

Date: 2026-03-23

## Completed in this pass

- Fixed [app_hi.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_hi.arb) locale metadata from `en` to `hi`.
- Removed stray generated file `app_hi.generated.arb` from `lib/l10n/` so Flutter no longer scans it as a real locale.
- Fixed three ICU-unsafe unmatched single-quote Hindi strings that blocked `flutter gen-l10n`.
- Re-ran:
  - `flutter gen-l10n`
  - `flutter analyze`

## Remaining known debt

- Hindi is now build-safe, but not quality-complete.
- Validator still reports remaining placeholder mismatches in `app_hi.arb`; those are localization-quality debt, not the specific build blocker fixed here.

## Enhancement options

1. Run a full Hindi placeholder-parity cleanup pass until `tools/localization_validate.py --locales hi` returns clean.
2. Move all staged/generated locale artifacts outside `lib/l10n/` so Flutter never scans temporary files.
3. Add a preflight localization integrity check to catch `@@locale` mismatches and ICU quote errors before `flutter run`.
