# Settings + Accounts/Sync Localization Backlog

Date: 2026-03-25

## Completed In This Session

- Removed the remaining visible Accounts / Sync legacy-English fallback leak from default transport/result persistence.
- Added compatibility rendering for older saved English sync summaries and transport labels.
- Confirmed the main Settings page is already largely localized and does not need a structural localization rewrite in this phase.

## Next Recommended Batches

### Batch 1
- Run `worship/prayer` localization cleanup on:
  - `lib/features/salah/presentation/salah_page.dart`
  - `lib/features/worship/presentation/widgets/prayer_section.dart`
  - `lib/features/worship/presentation/widgets/dhikr_section.dart`

### Batch 2
- Localize high-traffic Learn browse surfaces:
  - `lib/features/learn/world/presentation/world_landing_page.dart`
  - `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart`

### Batch 3
- Start locale-by-locale fallback reduction for the most complete locales first:
  - Arabic
  - Urdu
  - German
  - Hindi

## Enhancement Options

- Add a small regression test around Accounts / Sync presentation mapping so future raw transport/result strings do not leak back into the UI.
- Add a repo script that reports legacy English status strings found in persisted-model defaults and compatibility mappers.
