# Settings + Accounts/Sync Localization Cleanup

Date: 2026-03-25
Scope:
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
- related Accounts/Sync state normalization

## Audit Findings

### Settings

The primary Settings surface is already heavily localized through `AppLocalizations`.

Audit result:
- no major live hardcoded English blocks remained on the main Settings entry and category surfaces
- most Settings copy risk is now fallback quality in non-English ARBs rather than missing localization wiring
- one technical language subtitle still intentionally shows locale tags such as `en` or `fa-AF`, which is product-safe and not treated as untranslated copy in this pass

### Accounts / Sync

Accounts / Sync was also largely localized already, but it still had a smaller set of English fallback leaks:
- legacy raw transport label persistence:
  - `Local storage`
- legacy raw result summary persistence:
  - `Local-only mode active`
- presentation fallback paths that could still surface raw English or raw diagnostic strings for:
  - legacy transport labels
  - legacy iCloud error text
  - older sync result and sync event strings

These were the highest-value cleanup targets because they could still show visible English even on otherwise localized Accounts / Sync screens.

## What Changed

### Accounts / Sync normalization

The cleanup moved Accounts / Sync state toward locale-neutral codes instead of persisted English labels:
- default `transportLabel` now stores `syncTransportKeyLocalStorage`
- default `lastResultSummary` now stores `sync_result_local_only_mode_active`
- `applySyncReport(...)` now normalizes legacy English transport and sync-summary strings into canonical transport keys and sync feedback codes before they are stored

### Accounts / Sync compatibility rendering

The presentation layer now also maps older saved English values to localized output for backward compatibility, including:
- `Local-only mode active`
- `No changes to sync`
- `Sync completed successfully`
- `Offline`
- `Sync unavailable`
- `Transport failure`
- legacy iCloud error strings
- older uploaded/applied-change summary strings

This means:
- new state is cleaner
- older saved state is still rendered safely

## Remaining Debt

### Settings
- non-English fallback coverage still needs real translations for many settings-related keys
- this pass did not rewrite already-localized Settings structure or semantics

### Accounts / Sync
- non-English fallback coverage still needs real translations for Accounts / Sync keys
- provider/backend/platform-specific copy still needs multilingual QA on real flows

## Recommended Next Pass

- `worship/prayer surface localization`

That is the next best user-visible localization pass after onboarding and settings/accounts cleanup.
