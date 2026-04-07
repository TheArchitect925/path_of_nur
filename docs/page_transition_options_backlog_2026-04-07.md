# Page Transition Options Backlog

Date: 2026-04-07
Area: Navigation / shared glass surfaces

## Current finding

- The router is mostly using plain `MaterialPage` transitions in [app_router.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/app/app_router.dart#L114).
- The more likely cause of the dark glass flash is the shared page-entry animation in [app_page_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_page_scaffold.dart#L77), where `_AnimatedPageEntrance` combines `AnimatedSlide` with `AnimatedOpacity` from `0` to `1`.
- Fading a page full of translucent glass widgets can briefly darken the composited result, especially when the app shell, background, and mini-player layers remain underneath during navigation.

## Options

### 1. Slide-only page entrance

- Keep the subtle vertical motion.
- Remove the full-page opacity animation from `_AnimatedPageEntrance`.
- Lowest-risk first fix for glass darkening.

### 2. No transition on shell tab/page swaps

- Home, Learn, Worship, Journey, and Quran can swap instantly inside the shell.
- Best for stability and perceived speed.
- Least cinematic, but often the cleanest for dashboard-style apps.

### 3. Fade-through at router level

- Move transition responsibility from page widgets into `GoRouter` using `CustomTransitionPage`.
- Use a very light outgoing fade with incoming content appearing over it.
- More controlled than the current page-owned fade, but still needs care with glass surfaces.

### 4. Shared-axis horizontal transition

- Use a short horizontal slide plus very subtle fade for deeper pushes only.
- Good for drill-in flows like details pages, not ideal for primary tab switching.
- Better semantic motion than animating every screen the same way.

### 5. Motion tiers by route type

- No animation for shell tabs.
- Slide-only for section-to-detail pushes.
- Modal/sheet motion for temporary surfaces.
- Strongest long-term UX model if we want consistency without over-animating.

### 6. Broader reduced-motion handling

- Reuse the existing `reduceMotion` setting more aggressively for glass-heavy surfaces.
- Could disable page-entry effects whenever layered glass is present, not only when the user explicitly opts out.

## Recommended order

1. Remove page opacity and keep only a very small slide in `_AnimatedPageEntrance`.
2. If flicker remains, disable transitions for shell-level page swaps entirely.
3. If we still want more polish later, introduce route-type-specific transitions through `CustomTransitionPage`.

## Implemented in this pass

- `_AnimatedPageEntrance` in `AppPageScaffold` no longer fades the full page from `0` to `1`.
- The shared entrance motion now keeps only a lighter vertical slide (`Offset(0, 0.012)`), which should reduce dark flashing on layered glass surfaces during navigation.
- `_AnimatedQuoteHeader` in `AppPageScaffold` also no longer fades the quote block/header from `0` to `1`; it now uses a lighter slide-only entrance (`Offset(0, 0.024)`).
- Focused verification passed:
  - `flutter analyze lib/shared/widgets/app_page_scaffold.dart`
  - `flutter test test/features/home/home_and_learn_shortcuts_test.dart`
  - `flutter test test/app/router_smoke_test.dart`

## Validation ideas

- Test on Home, Learn, Worship, and Quran where layered glass is heaviest.
- Check transitions with the mini player visible.
- Check smaller phones where bottom overlays and floating pills stack more tightly.
- Compare behavior with `reduceMotion` enabled and disabled.
