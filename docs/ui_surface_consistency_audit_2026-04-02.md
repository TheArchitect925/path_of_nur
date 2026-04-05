# UI Surface Consistency Audit — 2026-04-02

## Scope completed

This pass audited the active shared surface layer and the most visible drift owners in the current repo state, with changes applied to the shared material resolver plus targeted learning and dua card harmonization.

Files updated in this pass:
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_theme.dart`
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
- `lib/features/learn/presentation/pages/learning_section_landing_page.dart`
- `lib/features/learn/dua/presentation/dua_hub_page.dart`
- `codex prompts/theme/2026-04-02-ui-surface-consistency-audit.md`

## What was fixed

### Shared Frosted Glass unification

The shared non-sacred surface path was warmed centrally instead of patching individual pages:
- default non-sacred surface tint resolution now falls back to a shared warm gold derived from the appearance theme rather than inheriting whatever local accent a page happens to expose
- standard Frosted Glass recipes were nudged warmer in `AppSurfaceMatrix` for classic, noor, and kids families
- milk/blend values were increased so cards, panels, islands, and feature tiles read more consistently as one golden Frosted Glass family
- base `frostedGlassTone` values were warmed across the active appearance modes so the runtime palette no longer drifts back toward parchment-beige or neutral ivory as easily

### Sacred / devotional surfaces confirmed on Dense Sanctuary

The shared sacred path remains the authority for the main devotional surfaces:
- `lib/shared/widgets/quran_quote_block.dart`
- `lib/shared/widgets/quran_reference_block.dart`
- shared Qur'an recommendation and devotional blocks already using `AppSurfaceTreatment.denseSanctuary`
- dua detail devotional reading surfaces already using Dense Sanctuary in the current repo state

### Learning card harmonization

Learning cards were brought closer to the approved Frosted Glass system while keeping useful accents:
- learn category cards now rely on shared island/feature/pill surface styles instead of a separate badge material treatment
- guided learning path cards were moved off a custom `AnimatedContainer` + local border/background recipe and onto `PremiumCard` with shared Frosted Glass ownership
- category accents remain for icon, status, and progress identity, but the material shell is now shared

### Dua card harmonization

Dua hub cards were tightened so they no longer depend on a separate warm-card subsystem for their inner material language:
- category/header banners now use shared panel Frosted Glass styling with category accents
- metadata chips now use shared pill Frosted Glass styling instead of custom filled chip surfaces
- category identity remains in icon and text accents without becoming a third surface family

## Remaining drift after this pass

The repo is more centralized than before, but it is not yet zero-drift.

Remaining notable drift areas:
- `lib/features/home/presentation/home_page.dart`
  - still contains page-owned inner hero gradients and layered local container decoration on top of shared glass shells
- `lib/features/salah/presentation/salah_page.dart`
  - still contains multiple local panel/pill containers with hardcoded text and accent styling, even though many of them already resolve through `AppSurfaceTheme`
- `lib/features/learn/quran/presentation/widgets/quran_feature_components.dart`
  - still owns some palette-specific chip decoration logic that is acceptable for Qur'an feature styling but remains more bespoke than the generalized Frosted Glass path
- `lib/shared/widgets/app_scaffold.dart`
  - still contains hand-built navigation and shell decoration that should be reviewed in any follow-up global surface cleanup

## Parchment / one-off surface replacements in this pass

Replaced or reduced:
- learning path cards that previously used custom accent-wash containers
- learn category badge treatment that previously read as a separate local subsystem
- dua hub banners and metadata chips that previously used custom filled category surfaces
- shared default non-sacred tint behavior that previously allowed broader drift into family-specific neutral or non-golden reads

Still to review later:
- page-specific inner highlight panels in Home
- some Salah support surfaces and status chips
- any preview/demo-only card comparisons that remain intentionally isolated

## Temporary comparison / demo code

Temporary comparison/demo code still exists.

Most visible known example from current repo state:
- `lib/features/home/presentation/glass_preview/`

It was left in place during this pass because it is explicitly isolated comparison code and not safe to classify as dead without a separate removal decision.

## Search / indexing impact

No search system or indexing contract was changed in this pass.

## Localization impact

No new translation keys were added in this pass.
No locale ARB/resources were updated in this pass.
No new user-facing content was added that required localization wiring.

## Verification

### Formatting
- `dart format` ran on the modified Dart files in this pass

### Analyzer
- `flutter analyze` did **not** pass
- the remaining reported failures are in existing test files outside the scope of this UI surface pass
- after fixing the one new signature issue introduced during this pass, the remaining analyzer failures are the repo's current baseline test drift around Qur'an recommendation enums and required widget harness parameters

Current analyzer failures after this pass:
- `test/features/learn/quran/quran_hub_recommendations_provider_test.dart`
- `test/features/learn/quran/quran_reader_playback_harness_test.dart`
- `test/features/learn/quran/quran_reader_playback_widget_harness_test.dart`

## Final assessment

Fully fixed in this pass:
- shared Frosted Glass warmth and default tint direction
- shared non-sacred material convergence for standard wrappers
- learn category card material consistency
- guided path card harmonization into shared Frosted Glass
- dua hub chip/banner harmonization into shared Frosted Glass
- shared sacred/devotional Dense Sanctuary authority preserved

Still drifting:
- Home inner hero layers
- parts of Salah page local card internals
- a few bespoke Qur'an feature chip/palette widgets
- app shell/nav-owned local decoration

## Recommended next cleanup slice

1. Normalize `home_page.dart` hero internals onto shared panel/pill helpers while keeping layout unchanged.
2. Convert `salah_page.dart` local support containers and pills to shared helpers plus shared content colors.
3. Decide whether the Home glass preview code should be removed, retained for internal comparison, or moved behind an explicit debug flag.
4. Review `app_scaffold.dart` shell/navigation decoration for the same two-family surface policy.
