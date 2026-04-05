# Global Appearance Unification Backlog — 2026-04-02

## Phase A — Audit Follow-Through

### Unify sacred quote ownership on Home
- Reason: Home still owns a local Qur'an quote card instead of using the shared sacred quote owner.
- Priority: high
- Files likely involved:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/shared/widgets/quran_quote_block.dart`

### Inventory remaining `homepageWarmGlass` runtime consumers
- Reason: older warm-glass surfaces still exist in feature cards and can confuse the final global appearance direction.
- Priority: high
- Files likely involved:
  - `lib/features/history/presentation/widgets/on_this_day_home_card.dart`
  - `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`
  - `lib/core/theme/app_surfaces.dart`

### Standardize sacred-content block policy
- Reason: the app currently mixes `QuranQuoteBlock`, `QuranReferenceBlock`, and direct `QuranVerseContent` for prominent sacred surfaces.
- Priority: high
- Files likely involved:
  - `lib/shared/widgets/quran_quote_block.dart`
  - `lib/shared/widgets/quran_reference_block.dart`
  - major sacred consumers under `lib/features/home/`, `lib/features/learn/quran/`, `lib/features/learn/dua/`, `lib/features/salah/`

## Phase B — Single Global Visual Control

### Add one shared surface-style profile setting
- Reason: the user wants one global control for most appearance differences without creating a second theme system.
- Priority: high
- Files likely involved:
  - `lib/features/profile/application/profile_settings_provider.dart`
  - `lib/core/theme/app_theme.dart`
  - `lib/core/theme/app_surfaces.dart`
  - `lib/features/profile/presentation/settings_page.dart`

### Keep `AppThemeMode` as the broad mode and add profile as a sub-control
- Reason: avoid duplicating the current theme architecture.
- Priority: high
- Files likely involved:
  - `lib/core/theme/app_theme.dart`
  - `lib/features/profile/application/profile_settings_provider.dart`

## Phase C — Main Page Harmonization

### Harmonize Home to the shared sacred/general rules
- Reason: Home is the biggest main-page outlier.
- Priority: high
- Files likely involved:
  - `lib/features/home/presentation/home_page.dart`
  - home feature cards under `lib/features/history/` and `lib/features/celestial/`

### Harmonize Salah page surface ownership
- Reason: Salah still has more local visual ownership than the other main sections.
- Priority: high
- Files likely involved:
  - `lib/features/salah/presentation/salah_page.dart`

### Harmonize Qur'an hub sacred/study block presentation
- Reason: Qur'an hub uses multiple sacred presentation styles and should become the cleanest reference implementation.
- Priority: high
- Files likely involved:
  - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
  - `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`
  - `lib/features/learn/quran/presentation/quran_summary_theme.dart`

### Tighten settings micro-surface drift
- Reason: settings is mostly correct but still has preview/configuration micro-surfaces with custom chrome.
- Priority: medium
- Files likely involved:
  - `lib/features/profile/presentation/settings_page.dart`

## Phase D — Cleanup + QA

### Decide fate of `AppSurfaceTreatment.homepageWarmGlass`
- Reason: it now reads as a legacy/transition family more than a permanent one.
- Priority: medium
- Files likely involved:
  - `lib/core/theme/app_surfaces.dart`
  - remaining runtime consumers

### Audit whether `NoorLiquidGlass` is still needed in runtime
- Reason: the package wrapper still exists, but the preview runtime path is gone.
- Priority: medium
- Files likely involved:
  - `lib/shared/widgets/noor_liquid_glass.dart`
  - `pubspec.yaml`

### Add visual regression checklist for main pages
- Reason: if we centralize more appearance behavior, we need a repeatable QA pass.
- Priority: medium
- Files likely involved:
  - documentation only or targeted widget test files

### Re-run page-by-page consistency pass after each harmonization step
- Reason: the safest way to avoid over-correcting the app is to audit again after Home, then Salah, then Qur'an.
- Priority: high
- Files likely involved:
  - audit docs under `docs/`
