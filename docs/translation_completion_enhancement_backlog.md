# Translation Completion Enhancement Backlog

Last updated: 2026-03-24

## Near-term enhancements

- Add a tiny repo helper command or script that creates the untranslated-report directory before `flutter gen-l10n` so the Flutter tool crash cannot recur in a clean checkout.
- Add a lightweight doc note beside `l10n.yaml` or in the localization backlog explaining that `.dart_tool/flutter_gen/gen_l10n/` must exist before running the untranslated report on the current Flutter version.
- Add one focused CI/local check that fails if the untranslated report contains any scoped release-locale missing keys.

## Mid-term enhancements

- Track English-fallback density per locale so the team can distinguish `missing key count` from `translated value completeness`.
- Add a reusable scan for hardcoded user-facing `Text(...)` literals on high-traffic surfaces to keep future localization debt from regressing.
- Add one multilingual smoke-test slice for `Settings`, `Accounts & Sync`, `Home`, and the `Qur'an reader` once those phases are localized.

## Deferred

- Consider a translator-facing export/review workflow once the remaining hardcoded UI surfaces are moved fully into ARBs.
