# Language And Translation Audit Backlog

Date: 2026-03-25

## Completed In This Session

- Onboarding localization end-to-end is now cleaned up in the live onboarding flow.
- The next localization pass should move to settings/accounts fallback cleanup rather than returning to onboarding first.

## Recommended Next Batches

### Batch 1
- Localize `lib/features/onboarding/presentation/onboarding_page.dart` end-to-end.
- Audit `Skip`, helper hints, progress text, reminder labels, and any literal onboarding option text.

### Batch 2
- Review `lib/features/profile/presentation/settings_page.dart` and `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart` for fallback-heavy labels, dialogs, and snackbar copy.
- Replace English fallback values for their newest keys in all non-English ARBs.

### Batch 3
- Localize high-traffic worship surfaces:
  - `lib/features/salah/presentation/salah_page.dart`
  - `lib/features/worship/presentation/widgets/prayer_section.dart`
  - `lib/features/worship/presentation/widgets/dhikr_section.dart`

### Batch 4
- Localize high-traffic learn browse surfaces:
  - `lib/features/learn/world/presentation/world_landing_page.dart`
  - `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart`
  - `lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart`

### Batch 5
- Reduce English fallback in non-English ARBs, prioritizing:
  - `app_ar.arb`
  - `app_ur.arb`
  - `app_de.arb`
  - `app_hi.arb`
  - then the largest-fallback locale files

## Enhancement Options

- Add a small repo script that reports:
  - hardcoded literal counts by file
  - same-as-English ARB keys by locale
  - missing localization usage on routed pages
- Add a CI check that blocks new hardcoded strings in high-traffic surfaces.
- Add a CI check that warns when newly added ARB keys remain English in all non-English locale files.
- Create a translation-priority list grouped by traffic tier instead of by file count only.
