# Global Appearance Main Pages Audit — 2026-04-02

## Executive Summary

- The app already has a real central appearance system. The strongest global owners are:
  - `lib/core/theme/app_theme.dart`
  - `lib/core/theme/app_surfaces.dart`
  - `lib/features/profile/application/profile_settings_provider.dart`
  - `lib/shared/widgets/premium_card.dart`
  - `lib/shared/widgets/app_page_scaffold.dart`
  - `lib/shared/widgets/section_hub_scaffold.dart`
  - `lib/shared/widgets/app_scaffold.dart`
- Most main pages already sit on shared scaffolds and shared card primitives.
- The biggest remaining inconsistency is not “no theme system.” It is that a few high-traffic pages still render important content through local containers instead of the most canonical shared sacred/general surface owners.
- The clearest example is Qur'an quote presentation:
  - most shared hub pages use `QuranQuoteBlock`
  - Home uses a local `_AyahCard` with `QuranVerseContent`
  - some study/detail pages use `QuranReferenceBlock`
  - some pages use direct `QuranVerseContent` inside generic `PremiumCard`
- That means the app is already close to a global system, but still needs a stronger unification rule around sacred content presentation and a single central appearance control for shared surface style.

## Recommended Direction

- Extend the current system. Do not replace it.
- Keep these as the core authority:
  - `AppThemeMode` in `lib/core/theme/app_theme.dart`
  - `AppAppearanceTheme` tokens in `lib/core/theme/app_theme.dart`
  - `AppSurfaceTheme.resolve(...)` in `lib/core/theme/app_surfaces.dart`
  - persisted settings in `lib/features/profile/application/profile_settings_provider.dart`
- If we want one global control for “most of the look and feel,” the safest addition is:
  - a single new persisted setting such as `surfaceStyleProfile` or `materialPresentationProfile`
- That setting should flow:
  1. `ProfileSettingsState`
  2. `AppTheme.themeFor(...)`
  3. `AppAppearanceTheme`
  4. `AppSurfaceTheme.resolve(...)`
- It should not bypass the current theme system or create page-level alternatives.

## Existing Global Appearance Owners

### `lib/core/theme/app_theme.dart`

- Owns:
  - `AppThemeMode`
  - `AppAppearanceTheme`
  - glass/background/text/accent tokens
  - mode-level defaults for `defaultMode`, `easyRead`, `dark`, `noorGlass`, `midnightManuscript`
- Why it matters:
  - this is the canonical source of broad visual identity
- Recommendation:
  - this should remain the top-level global appearance owner
  - any single new “global look profile” should flow through here

### `lib/core/theme/app_surfaces.dart`

- Owns:
  - `AppSurfaceVariant`
  - `AppSurfaceTreatment`
  - `AppSurfaceTheme.resolve(...)`
  - `AppSurfaceTheme.contentColors(...)`
- Current shared treatments:
  - `standard`
  - `homepageWarmGlass`
  - `denseSanctuary`
- Why it matters:
  - this is the main shared material resolver for cards, islands, pills, panels, feature tiles, and navigation bar surfaces
- Recommendation:
  - this is the correct place for central unification logic
  - the current existence of `homepageWarmGlass` is now a drift signal, not a long-term target

### `lib/features/profile/application/profile_settings_provider.dart`

- Owns current appearance settings:
  - `appThemeMode`
  - `disableGlassTransparency`
  - `disableColoredGlass`
  - `glassTransparencyLevel`
  - `disableBackground`
  - `highContrastText`
  - `reduceMotion`
- Why it matters:
  - this is where a single global visual-control setting should live
- Recommendation:
  - extend this instead of adding any page-local or feature-local override system

### `lib/shared/widgets/premium_card.dart`

- Owns:
  - the primary shared card consumer path
  - default surface application for most cards
- Why it matters:
  - broad runtime consistency depends on this
- Recommendation:
  - preserve this as the main standard-card path

### `lib/shared/widgets/app_page_scaffold.dart`

- Owns:
  - standard page header
  - shared background ownership
  - default shared Qur'an quote block insertion through `QuranQuoteBlock`
- Why it matters:
  - many pages already inherit consistent header + quote behavior through this
- Recommendation:
  - use this more, not less

### `lib/shared/widgets/section_hub_scaffold.dart`

- Owns:
  - hub-page layout
  - section quote slot
  - shared action-island structure
- Why it matters:
  - this is the most repeated top-level hub shell for Worship, Learn-family hubs, Journey, and Settings landing
- Recommendation:
  - this is already the right reusable owner for top-level hub pages

### `lib/shared/widgets/app_scaffold.dart`

- Owns:
  - app shell
  - background layering
  - bottom navigation material
  - global mini player
- Why it matters:
  - this is the shared shell chrome owner
- Recommendation:
  - keep it central
  - bottom nav styling should keep resolving from shared appearance tokens, not page-local behavior

## Main Page Ownership Map

## 1. Home

### Primary owner

- `lib/features/home/presentation/home_page.dart`

### Current appearance pattern

- Uses local page composition instead of `AppPageScaffold` or `SectionHubScaffold`
- Mixes:
  - local `_GlassCard`
  - `PremiumCard`
  - feature-owned cards such as:
    - `QuranDailyReflectionCard`
    - `QuranSpiritualMomentCard`
    - `QuranPersonalizedRecommendationCard`
    - `OnThisDayHomeCard`
    - `CelestialCycleCard`

### Differences from the rest of the app

- Home is the main runtime outlier in structure.
- It does not use the shared scaffold quote slot.
- Its sacred quote is local:
  - `_AyahCard` uses `_GlassCard` + `QuranVerseContent`
  - not `QuranQuoteBlock`
- It still includes feature cards using `AppSurfaceTreatment.homepageWarmGlass`:
  - `lib/features/history/presentation/widgets/on_this_day_home_card.dart`
  - `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`

### Classification

- acceptable:
  - Home being composition-heavy is normal
- problematic drift:
  - local sacred quote owner
  - older warm-glass feature-card treatment still live here

### Recommendation

- make Home the first harmonization target
- convert the Home sacred quote to the same shared owner used elsewhere:
  - prefer `QuranQuoteBlock`
- decide whether Home feature cards should remain a special “feature-card accent” family or be brought fully onto shared Frosted/Dense Sanctuary logic

## 2. Worship Hub

### Primary owner

- `lib/features/worship/presentation/worship_page.dart`

### Current appearance pattern

- Uses `SectionHubScaffold`
- Uses `QuranQuoteBlock`
- Uses `SectionHubActionGrid`

### Differences from the rest of the app

- Very close to the canonical hub pattern
- Keeps accent identity per action tile through `SectionHubAction`

### Classification

- mostly correct

### Recommendation

- treat this as a reference implementation for top-level hub structure

## 3. Learn Hub

### Primary owners

- `lib/features/learn/presentation/learn_page.dart`
- `lib/features/learn/presentation/widgets/learn_hub_page_scaffold.dart`
- `lib/features/learn/presentation/widgets/learn_category_card.dart`

### Current appearance pattern

- Uses `LearnHubPageScaffold`, which wraps `SectionHubScaffold`
- Default learning quote comes from shared learning quote builder
- Learning category islands use the shared system

### Differences from the rest of the app

- More search/filter density than the other top tabs
- More chip-heavy interaction
- Uses a dedicated Learn shell wrapper, but it still resolves through shared scaffolds

### Classification

- mostly correct
- intentional variation, not major drift

### Recommendation

- use Learn as a model for how a specialized hub can still stay inside shared scaffolds

## 4. Journey

### Primary owners

- `lib/features/journey/presentation/journey_page.dart`
- `lib/features/journey/presentation/growth_home_page.dart`

### Current appearance pattern

- `JourneyPage` is just a route alias to `GrowthHomePage`
- `GrowthHomePage` uses `SectionHubScaffold`
- uses `QuranQuoteBlock`
- uses `PremiumCard`
- uses `SectionHubActionGrid`

### Differences from the rest of the app

- Structurally very aligned with Worship
- Keeps more progress/metrics content than Worship hub

### Classification

- mostly correct

### Recommendation

- use this as another reference hub implementation

## 5. Qur'an Hub

### Primary owner

- `lib/features/learn/presentation/pages/quran_app_hub_page.dart`

### Current appearance pattern

- Uses `LearnHubPageScaffold`
- intentionally hides the default quote:
  - `showDefaultQuote: false`
- uses `PremiumCard`
- uses `SectionHubActionGrid`
- uses `QuranSummaryThemePalette` for some Qur'an-specific sacred styling

### Differences from the rest of the app

- more custom sacred palette work than generic hubs
- stronger use of Qur'an-specific subtheming
- not all sacred study surfaces are rendered through the same shared sacred block primitives

### Classification

- partially intentional
- still a likely consistency target

### Recommendation

- keep Qur'an-specific accent identity
- but standardize sacred blocks:
  - quote blocks
  - reference blocks
  - study-highlight blocks
  - summary hero panels

## 6. Settings

### Primary owner

- `lib/features/profile/presentation/settings_page.dart`

### Current appearance pattern

- landing page uses `SectionHubScaffold`
- detail pages use `AppPageScaffold`
- large use of `PremiumCard`
- some preview/configuration sub-elements still use local `Container` + `BoxDecoration`

### Differences from the rest of the app

- settings has more local control-preview UI than most pages
- this is partly legitimate because preview chips, sliders, and appearance controls sometimes need more specific rendering

### Classification

- mostly correct
- moderate micro-surface drift remains

### Recommendation

- leave most settings structure alone
- if doing a future polish pass, unify only the micro-surfaces that are clearly visual chrome rather than control-specific previews

## 7. Salah

### Primary owner

- `lib/features/salah/presentation/salah_page.dart`

### Current appearance pattern

- large feature page with many local containers
- uses:
  - `PremiumCard`
  - `QuranQuoteBlock`
  - direct `AppSurfaceTheme.resolve(...)`
  - several local `Container` + `BoxDecoration` blocks

### Differences from the rest of the app

- Salah remains one of the heaviest local visual owners
- much more handcrafted composition than Worship hub or Journey hub

### Classification

- still the clearest major page-local visual owner after Home

### Recommendation

- after Home, Salah is the next best page for one-by-one harmonization

## Shared Sacred Content Owners

### Canonical shared sacred owners already in the repo

- `lib/shared/widgets/quran_quote_block.dart`
- `lib/shared/widgets/quran_reference_block.dart`

### Why they matter

- These are the best candidates for the rule:
  - “Qur'an quotes should all look the same across the app”

### Current quote/reference inconsistency

- `QuranQuoteBlock` is used on:
  - `lib/shared/widgets/app_page_scaffold.dart`
  - `lib/features/worship/presentation/worship_page.dart`
  - `lib/features/worship/presentation/worship_section_pages.dart`
  - `lib/features/journey/presentation/growth_home_page.dart`
  - `lib/features/salah/presentation/salah_page.dart`
- `QuranReferenceBlock` is used on:
  - `lib/features/learn/dua/presentation/dua_detail_page.dart`
  - several Learn/World/Divine Life/Hadith pages
- direct local `QuranVerseContent` sacred blocks still exist on:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`
  - `lib/features/learn/quran/presentation/quran_daily_companion_page.dart`
  - `lib/features/learn/journey/presentation/learning_journey_island_page.dart`

### Recommendation

- define one shared sacred presentation policy:
  - standalone daily/hero quote -> `QuranQuoteBlock`
  - structured ayah/surah citation block -> `QuranReferenceBlock`
  - inline verse content inside learning or puzzle UI -> `QuranVerseContent`
- this would remove the current ambiguity

## Main Differences By Page Family

### Structurally aligned pages

- Worship
- Journey
- most Learn hubs
- many detail pages built on `AppPageScaffold`

### Main outliers

- Home
  - custom page shell
  - local sacred quote card
  - older warm feature-card surfaces still visible
- Salah
  - much heavier local container ownership
- Qur'an Hub
  - custom sacred palette logic and multiple sacred content presentation styles
- Settings
  - more local preview/configuration micro-surfaces

## Best Single Global Setting Recommendation

If we want one control that affects most look-and-feel without replacing the current architecture, add:

- `AppSurfaceProfile` or `SurfacePresentationProfile`

Suggested enum shape:

- `balanced`
- `sacredEmphasis`
- `highClarity`

What it should control centrally:

- Frosted surface softness
- Dense Sanctuary opacity/readability
- border strength
- highlight strength
- shadow intensity
- layer density
- maybe panel/card/pill contrast bias

Where it should live:

- persisted state:
  - `lib/features/profile/application/profile_settings_provider.dart`
- theme token bridge:
  - `lib/core/theme/app_theme.dart`
- surface resolution:
  - `lib/core/theme/app_surfaces.dart`

What it should not do:

- not replace `AppThemeMode`
- not create page-specific modes
- not directly set layout differences
- not bypass sacred-vs-general content rules

## Suggested One-by-One Harmonization Order

1. Home
   - unify sacred quote owner
   - resolve older warm feature-card exceptions
2. Salah
   - reduce local surface ownership
3. Qur'an hub and Qur'an study surfaces
   - standardize sacred block presentation
4. Settings micro-surfaces
   - only where visual chrome drifts from shared rules

## Risks

- Over-correcting accent identity and making all hubs feel identical
- Replacing meaningful sacred presentation differences with overly generic cards
- Adding a new setting that duplicates `AppThemeMode` instead of complementing it
- Leaving `homepageWarmGlass` alive as a semi-supported third family
- Unifying quote style inconsistently if inline learning verses are treated the same as sacred hero quotes

## Final Conclusion

- The app does not need a new theme system.
- It does need a stronger rulebook around:
  - sacred content presentation
  - remaining page-local surface drift
  - a single central surface-style profile
- If the goal is “Qur'an quotes should all look the same across the app,” the best path is not page-by-page imitation. It is:
  - standardize on `QuranQuoteBlock` and `QuranReferenceBlock`
  - reduce direct local sacred quote rendering
  - then add one global surface profile setting to tune the overall material behavior from the shared system
