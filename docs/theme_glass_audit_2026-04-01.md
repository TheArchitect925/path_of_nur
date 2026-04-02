# Theme + Glass Audit — 2026-04-01

Repo: `TheArchitect925/path_of_nur`

Scope: architecture audit only. This pass does not implement the winning glass style. It maps the current global appearance system, settings flow, shared surface owners, background owners, navigation owners, page-local overrides, temporary glass comparison code, and rollout risks so the next implementation pass can extend the existing system cleanly instead of creating a parallel one.

## Section 1 — Executive Summary

The app already has a valid central appearance system. The strongest global owners are:

- `lib/app/app.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/global_background.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/app_page_scaffold.dart`
- `lib/features/profile/application/profile_settings_provider.dart`

That means the correct strategy for the final winning glass variant is to extend the current central appearance stack rather than replace it.

### Current strengths

- Appearance state is already centralized and persisted through profile settings.
- Theme resolution is already parameterized by theme mode and glass/background accessibility toggles.
- Shared surface styling already has a central resolver through `AppSurfaceTheme.resolve(...)`.
- Shared cards already funnel through `PremiumCard`, which makes broad rollout possible without widget-by-widget rewrites.
- Global background ownership is already centralized and page scaffolds are already wired to it.
- Liquid glass package usage is already isolated behind a wrapper instead of scattered across the app.

### Current weaknesses

- Homepage styling still layers substantial page-local visual behavior on top of the shared surface system.
- `AppSurfaceTreatment.homepageWarmGlass` exists, but the shared resolver currently keeps it intentionally close to `standard`, so the visible warm pilot effect still depends partly on homepage-local decoration.
- A few important pages still own significant local styling instead of leaning fully on the shared system, especially `salah_page.dart`.
- Theme mode history has at least one legacy path: `calmBeautiful` still exists in the enum and token defaults, but settings remap it back to `defaultMode` and it is not surfaced in the current appearance picker.
- Temporary glass comparison code is still present on the homepage and should not be confused with the real rollout path.
- A few docs still reference the old removed `glass_preview` folder, which is now stale.

### Recommendation

Use the existing architecture. Do not build a second theme system. The winning glass variant should be implemented centrally in:

- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_backgrounds.dart`

Then harmonize page-local owners, with homepage handled after the shared system is stable.

## Section 2 — Global Appearance Ownership Map

### `lib/app/app.dart`

- Symbol: `PathOfNurApp`
- Controls:
  - bootstraps theme selection
  - reads appearance settings from `profileSettingsProvider`
  - passes resolved appearance controls into `AppTheme.themeFor(...)`
- Why it matters:
  - this is the runtime bridge from persisted settings into actual app-wide `ThemeData`
- Final implementation guidance:
  - modify only if the winning variant needs a new global setting or a new theme-mode input
  - otherwise leave this file thin

### `lib/core/theme/app_theme.dart`

- Symbols:
  - `AppThemeMode`
  - `AppAppearanceTheme`
  - `AppTheme.themeFor(...)`
- Controls:
  - canonical appearance tokens
  - global text/surface/accent/border/nav/chip/button colors
  - accessibility-aware glass flags
  - mode-specific defaults for `defaultMode`, `easyRead`, `dark`, `noorGlass`, `midnightManuscript`, and legacy `calmBeautiful`
- Why it matters:
  - this is the main global appearance owner
- Final implementation guidance:
  - should be modified
  - this is the correct place for any winning-variant token changes or a new shared glass treatment baseline

### `lib/core/theme/app_surfaces.dart`

- Symbols:
  - `AppSurfaceVariant`
  - `AppSurfaceTreatment`
  - `AppSurfaceTheme.resolve(...)`
  - `AppSurfaceTheme.contentColors(...)`
- Controls:
  - shared card/island/pill/panel/featureTile/navigationBar surface decoration
  - tint behavior
  - alpha behavior
  - border/shadow/gradient policy
  - content text color pairing
- Why it matters:
  - this is the shared material layer for almost every reusable card family
- Final implementation guidance:
  - should be modified
  - this is the best insertion point for the final winning glass treatment logic

### `lib/core/theme/app_backgrounds.dart`

- Symbols:
  - `AppBackgroundAtmosphere`
  - `AppBackgroundTheme.resolve(...)`
- Controls:
  - theme-aware global background gradients and atmosphere behavior
  - special Qur'an atmosphere
- Why it matters:
  - glass surfaces will only look correct if the background system and surface translucency are aligned
- Final implementation guidance:
  - may need modification if the winning glass style relies on different glow, tint, or wallpaper interaction

### `lib/shared/widgets/global_background.dart`

- Symbol: `GlobalBackground`
- Controls:
  - real runtime background rendering
  - wallpaper overlay composition
  - interaction with `disableBackground`
- Why it matters:
  - this is the concrete global background owner under shell and page scaffolds
- Final implementation guidance:
  - may be modified if the winning variant requires different blur/tint interplay with wallpaper
  - otherwise keep stable

### `lib/shared/widgets/app_scaffold.dart`

- Symbol: `AppShellScaffold`
- Controls:
  - shell background layering
  - bottom navigation surface
  - nav icon fill, active highlight, glow, and label states
- Why it matters:
  - the shell is a major visual owner and one of the most noticeable consistency points
- Final implementation guidance:
  - may be modified
  - only after shared surface behavior is finalized

### `lib/shared/widgets/app_page_scaffold.dart`

- Symbol: `AppPageScaffold`
- Controls:
  - page-level background ownership
  - header chrome
  - route-level overlay hooks
  - `backgroundAtmosphere`, `backgroundAssetPath`, `backgroundOverlayColor`, `ownsBackground`
- Why it matters:
  - this is the main shared scaffold for page-level appearance
- Final implementation guidance:
  - preferably leave alone unless the winning glass style needs new page-level background hooks

### `lib/shared/widgets/section_hub_scaffold.dart`

- Symbols:
  - `SectionHubScaffold`
  - `LearnHubPageScaffold`
  - `SectionHubActionCard`
- Controls:
  - repeated hub layouts and shared island-like action styling
- Why it matters:
  - this is a strong reuse layer for learning/journey hub surfaces
- Final implementation guidance:
  - may be modified only if the winning variant must tune shared hub card behavior

## Section 3 — Settings Ownership Map

### State owner

File:
- `lib/features/profile/application/profile_settings_provider.dart`

Important settings affecting visuals:

- `appThemeMode`
- `disableGlassTransparency`
- `disableColoredGlass`
- `glassTransparencyLevel`
- `disableBackground`
- `highContrastText`
- `reduceMotion`

Flow:

1. `ProfileSettingsController` loads settings from `LocalStore` key `settings.profile`
2. state is exposed through `profileSettingsProvider`
3. `lib/app/app.dart` watches that provider
4. `AppTheme.themeFor(...)` receives those settings and resolves `ThemeData`

Notes:

- `glassTransparencyLevel` is converted into `glassSurfaceAlpha`
- `resetAppearance()` resets to a known shared baseline
- `calmBeautiful` is remapped back to `defaultMode` on load, which is a strong legacy signal

### UI owner

File:
- `lib/features/profile/presentation/settings_page.dart`

Appearance UI includes:

- theme mode selection
- glass transparency disable toggle
- colored glass disable toggle
- glass transparency slider
- background disable toggle
- high contrast text toggle
- reduce motion toggle

Theme modes currently surfaced in UI:

- `defaultMode`
- `easyRead`
- `noorGlass`
- `dark`
- `midnightManuscript`

Theme mode present in code but not surfaced:

- `calmBeautiful`

Runtime preview behavior:

- `_themePreviewData(...)` in `settings_page.dart` builds a page-local preview model from `AppAppearanceTheme.defaults(...)` and `AppBackgroundTheme.resolve(...)`

Final implementation guidance:

- keep state ownership in `profile_settings_provider.dart`
- if the winning glass style adds a user-facing choice, add it here instead of inventing a new settings path
- if the winning glass style is meant to replace the current shared behavior, prefer reusing existing toggles before adding new ones

## Section 4 — Shared Surface / Material Ownership Map

### `lib/core/theme/app_surfaces.dart`

Centralized:

- card families by variant
- treatment routing
- tint policy
- border/shadow/gradient policy
- content color pairing

Still page-local:

- specialized icon capsules
- feature-specific radial glows
- certain nested panel treatments
- some homepage and feature-local inner decorations

Correct place for winning glass logic:

- yes, this is the primary shared surface insertion point

### `lib/shared/widgets/premium_card.dart`

Centralized:

- standard reusable shared card shell
- uses `AppSurfaceTheme.resolve(...)`
- surface variants and optional treatment selection

Still page-local:

- content structure
- some local extra decorations inside the card body

Correct place for winning glass logic:

- secondary
- useful for rollout coverage, but it should consume the new shared logic rather than owning it

### `lib/shared/widgets/segmented_pill_control.dart`

Centralized:

- pill-style selection control appearance

Correct place for winning glass logic:

- probably not primary
- only adjust if the new shared tokens require contrast tuning

### `lib/shared/widgets/section_hub_scaffold.dart`

Centralized:

- `SectionHubActionCard` uses shared island treatment

Correct place for winning glass logic:

- only if hub action cards need shared refinements after central surface changes

### `lib/shared/widgets/noor_liquid_glass.dart`

Centralized:

- app-local wrapper around `liquid_glass_renderer`
- preset/spec mapping
- fallback behavior

Correct place for winning glass logic:

- only if the winning direction explicitly chooses liquid glass
- if used, this wrapper is the correct package boundary
- do not spread direct package imports elsewhere

## Section 5 — Background Ownership Map

### `lib/core/theme/app_backgrounds.dart`

- shared background theme resolver
- reacts to theme mode and atmosphere
- defines main background glow/tint direction

### `lib/shared/widgets/global_background.dart`

- real rendering owner for app backgrounds
- reads selected wallpaper
- reads appearance settings
- reacts to `disableBackground`

### `lib/shared/widgets/app_page_scaffold.dart`

- per-page ownership switchboard
- routes can inherit or override background behavior through:
  - `ownsBackground`
  - `backgroundAtmosphere`
  - `backgroundOverlayColor`
  - `backgroundAssetPath`

### Shared vs page-local ownership

Shared ownership:

- shell background
- wallpaper/tint behavior
- most page background defaults
- Qur'an atmosphere support

Page-local ownership:

- some feature pages still provide local overlay colors
- some pages still bypass shared scaffolds entirely

Final implementation guidance:

- adjust the shared background system only if needed for the winning glass style
- do not move wallpaper logic into page widgets
- prefer background/system tuning over page-specific gradient duplication

## Section 6 — Island / Category Card Ownership

### Main Learning Hub island owner

File:
- `lib/features/learn/presentation/widgets/learn_category_card.dart`

What it owns:

- category island structure
- shape and base material from `AppSurfaceTheme.resolve(... variant: island ...)`
- local icon panel gradient
- local micro-badge and decorative dust treatment
- some local palette behavior

Reuse status:

- partially shared
- the island shell is already connected to the shared surface system
- some decorative language is still local to Learn

Standardization readiness:

- high
- because the outer shell already routes through shared surface resolution

### Related island-like owners

- `lib/shared/widgets/section_hub_scaffold.dart`
- `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`

Recommendation:

- standardize the material treatment centrally through `AppSurfaceTheme`
- let Learn keep some local decorative identity unless it conflicts with the final chosen glass language

## Section 7 — Standalone or Page-Local Visual Owners

### `lib/features/home/presentation/home_page.dart`

Classification:
- problematic drift if the goal is app-wide glass consistency

Why:

- repeated use of `AppSurfaceTreatment.homepageWarmGlass`
- additional local gradients, fills, icon capsules, and internal panel styles
- the homepage is currently a major visual owner beyond simple composition

Recommendation:
- keep for now
- refactor only after shared winning variant behavior is defined

### `lib/features/salah/presentation/salah_page.dart`

Classification:
- problematic drift

Why:

- uses `Scaffold` + `GlobalBackground` directly
- owns many local decorations and hardcoded color decisions

Recommendation:
- audit carefully before final rollout
- likely needs harmonization after the shared system is updated

### `lib/features/profile/presentation/settings_page.dart`

Classification:
- acceptable local customization

Why:

- settings preview tiles are preview-only and intentionally local

Recommendation:
- keep
- only update if theme preview accuracy needs tuning after final rollout

### `lib/features/learn/quran/presentation/quran_summary_theme.dart`

Classification:
- acceptable feature-level theming with risk

Why:

- Qur'an summary surfaces intentionally own a more specific palette
- this is not random drift, but it does sit on top of the global appearance system

Recommendation:
- keep
- audit for compatibility during rollout, especially under `noorGlass` and `midnightManuscript`

### `lib/shared/widgets/quran_presentation_style.dart`

Classification:
- small problematic drift

Why:

- includes a direct `Colors.black` path in helper logic

Recommendation:
- leave for this audit phase
- likely clean up during rollout polish

## Section 8 — Temporary / Demo / Preview Code

### Current temporary comparison code

File:
- `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`

Status:

- temporary
- isolated
- safe to remove later

Notes:

- imported only by `lib/features/home/presentation/home_page.dart`
- explicitly marked temporary in file header
- uses `NoorLiquidGlassContainer`
- currently the only live feature using the liquid glass wrapper in the app UI

Interference risk:

- moderate
- safe structurally, but it can create confusion during the winning-variant rollout if left beside the real implementation

Recommendation:

- remove before or during the real winning-variant rollout

### Stale preview docs

Files:

- `docs/home_glass_preview_islands_2026-04-01.md`

Issue:

- still references the old removed `lib/features/home/presentation/glass_preview/` path

Recommendation:

- clean up before rollout documentation begins so the repo does not imply two preview systems exist

## Section 9 — Liquid Glass Package Audit

Package:

- `pubspec.yaml` line with dependency: `liquid_glass_renderer: ^0.2.0-dev.4`

Imported in:

- `lib/shared/widgets/noor_liquid_glass.dart`
- `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`

Used in live runtime surfaces:

- yes, but only in the temporary homepage comparison section

Not used globally in:

- `PremiumCard`
- `AppSurfaceTheme`
- `AppShellScaffold`
- standard page/card system

Assessment:

- the package is installed and actually used
- but its usage is local and temporary, not part of the app-wide appearance system

Integration recommendation:

- if the winning style chooses liquid glass, integrate it through:
  - `lib/shared/widgets/noor_liquid_glass.dart`
  - shared surface wrappers consuming that layer selectively
- do not spread direct package imports across feature pages

If the winning style does not require true liquid rendering:

- the in-house surface system is already strong enough for a convincing app-wide glass style

## Section 10 — Legacy / Duplication / Dead-Path Audit

### `AppThemeMode.calmBeautiful`

Classification:
- leave for now, clean up first before final rollout if practical

Why:

- still exists in enum/defaults
- no longer exposed in current settings UI
- remapped back to `defaultMode` on load

### `AppSurfaceTreatment.homepageWarmGlass`

Classification:
- merge into shared system

Why:

- currently used beyond Home in:
  - `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`
  - `lib/features/history/presentation/widgets/on_this_day_home_card.dart`
- shared resolver intentionally keeps it close to standard, while pages add their own warmth on top

### Temporary glass variant section

Classification:
- remove later

Why:

- explicitly temporary
- useful for comparison only
- should not coexist with final rollout for long

### Old preview-path references in docs

Classification:
- clean up first

Why:

- stale repo guidance creates confusion

### Local hardcoded feature styling

Examples:

- `lib/features/home/presentation/home_page.dart`
- `lib/features/salah/presentation/salah_page.dart`
- pockets of local palette logic in feature headers and preview tiles

Classification:
- leave or harmonize later, depending on scope

Why:

- not all local styling is bad
- only some of it conflicts with a future shared glass rollout

## Section 11 — Final Implementation Recommendation

### Files that should be modified

- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`

### Files that may be modified if needed

- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/global_background.dart`
- `lib/shared/widgets/premium_card.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/noor_liquid_glass.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
- `lib/features/profile/presentation/settings_page.dart`

### Files that should preferably not be touched first

- route owners
- unrelated feature pages with isolated decorative styling
- the broader localization/runtime architecture
- shared reader logic
- unrelated kids flows

### Correct implementation order

1. Clean up stale preview/doc confusion and confirm whether the temporary homepage comparison section stays during rollout or is removed first.
2. Define the winning shared glass behavior in `app_theme.dart` and `app_surfaces.dart`.
3. Tune background interplay only if the new shared glass style needs it.
4. Apply the new shared treatment to core reusable cards through existing shared consumers.
5. Harmonize homepage local overrides against the new shared system.
6. Harmonize shell/navigation if needed.
7. Audit standout local pages such as Salah and Qur'an summary surfaces for compatibility.
8. Remove the temporary comparison section once the real implementation is verified.

### Central vs local implementation split

Implement centrally:

- core glass color/tint/alpha policy
- border/highlight/shadow policy
- variant-level material behavior
- text contrast pairing
- shared theme-mode responsiveness

Implement locally only where necessary:

- homepage-specific warm content emphasis
- feature-specific accent art
- settings preview tiles
- specialized feature motifs that are intentionally not generic cards

### Homepage-first or shared-system-first

Shared-system-first is the safer path.

Why:

- homepage currently contains the most local experimentation
- if homepage is restyled first, it risks becoming another one-off layer instead of validating the shared system
- the learn/category islands and `PremiumCard` family already provide better shared rollout anchors

### Safest rollout strategy

- implement the winning material centrally
- validate on `PremiumCard`, section-hub islands, and Learn category islands
- then reconcile homepage local layers
- then check nav shell
- then audit specialized pages

## Section 12 — Final Risk List

- breaking settings behavior if new appearance options bypass `profile_settings_provider.dart`
- over-styling page-local content that was intentionally feature-specific
- conflicting background and wallpaper tint behavior if surface and background changes happen independently
- mismatch between homepage cards, Learn islands, and premium cards if only one family is updated
- nav bar inconsistency if shell chrome is left behind after a shared surface shift
- temporary demo code confusing QA and masking the real rollout path
- hidden legacy theme mode `calmBeautiful` creating ambiguity during theme-mode testing
- Qur'an feature-local palette logic drifting from the new shared system
- performance risk if true liquid rendering is applied too broadly to scroll-dense surfaces

## Files Inspected For This Audit

- `pubspec.yaml`
- `lib/app/app.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/global_background.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/app_page_scaffold.dart`
- `lib/shared/widgets/section_hub_scaffold.dart`
- `lib/shared/widgets/premium_card.dart`
- `lib/shared/widgets/noor_liquid_glass.dart`
- `lib/shared/widgets/quran_presentation_style.dart`
- `lib/features/profile/application/profile_settings_provider.dart`
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
- `lib/features/learn/presentation/learn_page.dart`
- `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
- `lib/features/learn/quran/presentation/quran_summary_theme.dart`
- `lib/features/journey/presentation/growth_home_page.dart`
- `lib/features/salah/presentation/salah_page.dart`
- `lib/features/onboarding/presentation/onboarding_page.dart`
- `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`
- `lib/features/history/presentation/widgets/on_this_day_home_card.dart`
- `docs/glass_surface_theming_enhancement_backlog.md`
- `docs/home_glass_preview_backlog_2026-04-01.md`
- `docs/homepage_warm_glass_surface_pilot_backlog_2026-03-31.md`
- `docs/liquid_glass_renderer_backlog_2026-03-31.md`

## Final Audit Conclusion

The app is already structured around a real central appearance system. The right move for the winning glass variant is to extend the current theme and shared surface layers, not replace them.

Best insertion point:

- `lib/core/theme/app_surfaces.dart`
- supported by `lib/core/theme/app_theme.dart`

Most important pre-rollout cleanup:

- stale preview docs
- clarity around temporary homepage comparison code
- awareness of homepage and Salah page local drift

Most important systems to preserve as-is:

- `profile_settings_provider.dart` appearance state flow
- `AppPageScaffold` and `GlobalBackground` ownership model
- `PremiumCard` as the shared card consumer
- `NoorLiquidGlass` as the only package wrapper boundary
