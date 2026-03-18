# Post-final i18n Release Readiness

## Current Status

### Development readiness
- Status: `Safe`
- Reason:
  - `flutter gen-l10n` passes
  - `flutter analyze` passes
  - localization architecture is functional and recent batches are wired in correctly

### QA readiness
- Status: `Safe with caveats`
- Reason:
  - QA can proceed on current code
  - remaining code-side localization issues are concentrated and trackable
  - multilingual QA will still see large English fallback areas due to missing translations

### English-only release readiness
- Status: `Mostly safe`
- Caveats:
  - some older screens still use hardcoded English and inconsistent wording
  - formatting/semantics quality is not fully normalized across the entire app
  - global format cleanliness is not repo-wide verified because `dart format --set-exit-if-changed lib` fails on many unrelated files

### Multilingual beta/release readiness
- Status: `Not safe yet`
- Blocking reasons:
  - remaining code-side localization debt in several high-traffic feature surfaces
  - massive non-English key gaps in all supported locales
  - placeholder mismatches in every non-English locale checked
  - a few shared helpers still rely on implicit locale resolution or English helper text

## Remaining Must-fix Before Multilingual Release

1. One final focused code pass for remaining user-visible English surfaces:
   - Celestial
   - Quran Teaching section/review
   - Learning Salah
   - Hadith landing/review shell
   - Baby Names browse and related life-shell surfaces
   - World / Divine Life shell pages

2. Shared helper cleanup for remaining user-visible English output:
   - celestial services
   - salah page helper labels
   - growth helper category/recurrence/weekday labels
   - dhikr duration helper
   - shared Quran quote fallback label

3. Translation coverage repair:
   - fill missing keys for target release locales
   - fix all 12 placeholder mismatches in each non-English locale

4. Multilingual QA validation:
   - app-selected locale vs device locale
   - notifications/live activities
   - date/time/number formatting in prayer, celestial, growth, ocean, and learning
   - accessibility labels and tooltip wording on older screens

## Recommendation

Recommended next step: `one final micro-pass needed, then translation pass`

Why:
- The codebase is no longer in a broad localization-migration state.
- The remaining code work is now narrow enough to finish in one additional targeted pass.
- Translation completeness remains the dominant release blocker after that.
