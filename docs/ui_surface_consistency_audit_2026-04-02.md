# UI Surface Consistency Audit — 2026-04-02

## Executive Summary
- The app already had the correct shared ownership path in `lib/core/theme/app_surfaces.dart` and `lib/shared/widgets/premium_card.dart`, but several high-traffic consumers were still bypassing or diluting that shared system.
- Before this pass, the main runtime drift came from:
  - Home still using `AppSurfaceTreatment.homepageWarmGlass`
  - hub/action cards using feature-local base colors as actual surface bodies
  - learning category cards keeping a parchment-like inner panel
  - Qur'an summary pages still using a legacy local parchment palette
  - Salah and Dhikr still containing several handcrafted warm boxes and pills
- After this pass, the active runtime surface families are:
  - `Dense Sanctuary Glass` for sacred/devotional containers
  - `Frosted Glass` for general cards, islands, pills, panels, and hub surfaces
- The temporary homepage comparison code still exists and is the only remaining active place where `homepageWarmGlass` is still referenced.

## Files Audited
- `lib/core/theme/app_surfaces.dart`
- `lib/shared/widgets/premium_card.dart`
- `lib/shared/widgets/section_hub_scaffold.dart`
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/learn/quran/presentation/quran_summary_theme.dart`
- `lib/features/salah/presentation/salah_page.dart`
- `lib/features/worship/presentation/widgets/dhikr_section.dart`
- supporting sacred owners already on Dense Sanctuary:
  - `lib/shared/widgets/quran_quote_block.dart`
  - `lib/shared/widgets/quran_reference_block.dart`
  - `lib/features/learn/dua/presentation/dua_detail_page.dart`
  - `lib/features/learn/quran/presentation/widgets/quran_ayah_explanation_section.dart`

## What Was Correct Already
- `PremiumCard` already resolved through the shared surface system.
- `QuranQuoteBlock` and `QuranReferenceBlock` were already using `Dense Sanctuary Glass`.
- dua detail devotional surfaces and ayah explanation surfaces were already on the sacred treatment.
- `PrayerSection` tabs were already using shared panel surfaces.

## What Was Corrected

### 1. Home runtime material drift removed
- `lib/features/home/presentation/home_page.dart`
- Removed active `homepageWarmGlass` usage from:
  - `_PrayerTimingPill`
  - `_PrayerSummaryMiniStat`
  - `_CompactPrayerMetaChip`
  - `_GlassCard`
  - `_ModeAwareHomeCard`
  - `_HomeLearningActionsCard`
  - `_ModeActionChip`
  - `_QuickActionButton`
  - embedded `DailyRevelationCard`
  - embedded `DailyProphetQuizCard`
- Result: Home now resolves general non-sacred surfaces through shared Frosted Glass instead of the old third runtime family.

### 2. Hub/action cards unified into Frosted Glass
- `lib/shared/widgets/section_hub_scaffold.dart`
- `SectionHubActionCard` no longer uses `action.color` as the actual surface body.
- Accent identity is still preserved through the icon panel tint and accent text, but the card material itself now comes from shared Frosted Glass.

### 3. Learning category islands harmonized
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
- The outer island now uses the shared island decoration directly.
- The inner icon/content panel now uses a shared `featureTile` Frosted Glass treatment instead of the previous custom parchment radial panel.
- Result: learning cards keep their icon/accent identity, but their material family is no longer a one-off parchment subsystem.

### 4. Qur'an summary family rebased onto Dense Sanctuary
- `lib/features/learn/quran/presentation/quran_summary_theme.dart`
- The Qur'an summary palette now derives from shared `Dense Sanctuary Glass` surface resolution instead of hardcoded parchment-era light/dark card constants.
- Result: Qur'an summary pages and related summary/detail surfaces now visually align with the sacred/devotional family while preserving Qur'an-specific accenting.

### 5. Salah utility containers moved onto shared surfaces
- `lib/features/salah/presentation/salah_page.dart`
- Rebased these local containers onto shared surfaces:
  - `_SummaryTile`
  - `_DailySalahProgressStrip`
  - `_SalahVerseHeader`
  - `_SalahTrackerInlineSection`
  - `_QuickTrackChip`
  - `_TrackerSummaryPill`
- Result: Salah no longer relies as heavily on handcrafted parchment-tint panels for its main utility surfaces.

### 6. Dhikr target chips aligned
- `lib/features/worship/presentation/widgets/dhikr_section.dart`
- `_TargetChip` now uses shared Frosted Glass pill styling as its base instead of a local surface fill/border system.

## Sacred Surface Ownership After This Pass
The following sacred/devotional runtime surfaces now clearly use `Dense Sanctuary Glass`:
- `lib/shared/widgets/quran_quote_block.dart`
- `lib/shared/widgets/quran_reference_block.dart`
- `lib/features/learn/dua/presentation/dua_detail_page.dart`
- `lib/features/learn/quran/presentation/widgets/quran_ayah_explanation_section.dart`
- `lib/features/learn/quran/presentation/quran_summary_theme.dart` consumers
- `lib/features/salah/presentation/salah_page.dart` `_SalahVerseHeader`

## Frosted Glass Unification After This Pass
The following non-sacred systems were unified or tightened onto Frosted Glass:
- Home general cards and utility chips in `lib/features/home/presentation/home_page.dart`
- Section hub action cards in `lib/shared/widgets/section_hub_scaffold.dart`
- learning category islands in `lib/features/learn/presentation/widgets/learn_category_card.dart`
- Salah utility panels and pills in `lib/features/salah/presentation/salah_page.dart`
- Dhikr target chips in `lib/features/worship/presentation/widgets/dhikr_section.dart`

## Parchment Leftovers Replaced
- Learning category inner panel parchment gradient replaced with shared Frosted Glass feature-tile treatment.
- Section hub action card body no longer uses local colored/parchment card bodies.
- Qur'an summary light-theme parchment constants replaced with shared Dense Sanctuary-derived palette values.
- Several Salah local warm panels were replaced with shared Frosted or Dense Sanctuary decorations.

## Remaining Drift
- `lib/features/salah/presentation/salah_page.dart`
  - still contains some local text-color and badge-color logic for semantic emphasis
  - those are now accent-level customizations rather than separate surface systems
- `lib/features/profile/presentation/settings_page.dart`
  - still includes preview/configuration-specific local sub-elements, but primary cards continue to use shared `PremiumCard`
- `lib/features/worship/presentation/widgets/prayer_section.dart`
  - primary containers are largely on shared surfaces already, but there are still smaller local visualization blocks inside charts/heatmaps that are accent-level rather than core material drift

## Temporary / Demo Code Status
- The temporary homepage comparison/demo runtime section has been removed.
- Archived copy saved outside the repo at:
  - `/Users/shahabmansoor/Developer/Path of Nur Deleted and Cleaned Items/2026-04-02/home-glass-variants/`
- Home no longer imports or renders the preview section.

## Analyzer
- `flutter analyze lib/shared/widgets/section_hub_scaffold.dart lib/features/learn/presentation/widgets/learn_category_card.dart lib/features/home/presentation/home_page.dart lib/features/learn/quran/presentation/quran_summary_theme.dart lib/features/salah/presentation/salah_page.dart lib/features/worship/presentation/widgets/dhikr_section.dart`
- Result: `No issues found!`

## Final Audit Conclusion
- Fully fixed:
  - removal of `homepageWarmGlass` from active production screens
  - hub/action card material unification
  - learning card parchment drift
  - Qur'an summary sacred surface drift
  - major Salah and Dhikr utility-surface drift
- additional cleanup complete:
  - temporary homepage comparison/demo runtime code removed
  - prayer-history micro rows moved onto shared Frosted Glass in `prayer_section.dart`
  - custom-adjustments active chip moved onto shared Frosted Glass in `settings_page.dart`
- Still intentionally present:
  - some accent-level page-local styling in Salah, Prayer analytics, and Settings previews
- Recommended next cleanup:
  - do one narrow secondary pass for chart/analytics micro-surfaces if a stricter “no local accent containers at all” rule is desired
