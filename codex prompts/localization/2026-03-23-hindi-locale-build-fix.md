Build error report from `flutter run`:

Error: The locale specified in @@locale and the arb filename do not match.
Current @@locale value: en
Current filename extension: hi

Follow-up:
- `app_hi.arb` had `@@locale: en`
- stray `app_hi.generated.arb` was present in `lib/l10n/`
- after fixing that, `flutter gen-l10n` exposed three ICU-unsafe unmatched single-quote issues in Hindi strings

Goal:
- restore buildable localization generation without broader locale-rollout work
