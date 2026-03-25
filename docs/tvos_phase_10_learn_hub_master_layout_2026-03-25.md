# tvOS Phase 10: Learn Hub Master Layout

Date: 2026-03-25

## Goal

Add a real Learn route to the tvOS shell with a remote-first master layout that follows the current mobile Learn direction without blindly porting dense touch-first dashboards.

## What shipped

- Added a new native tvOS `Learn` route to the sidebar and route registry.
- Built a curated Learn hub with:
  - a hero stage
  - a primary `Start with a path` shelf
  - a `Stories and reflection` shelf cluster
  - a `Knowledge domains` shelf cluster
  - a persistent right-side detail rail for the currently focused Learn item
- Added a native Learn view model and seeded content for:
  - `Learning Journey`
  - `Explore all knowledge`
  - `Family-safe learning`
  - `Prophets`
  - `Seerah`
  - `Daily Wisdom`
  - `Hadith`
  - `World and Creation`
  - `Life lessons`
- Added remote-first focus ownership for the Learn route so navigation escape, section memory, and item selection behave like the existing Home and Qur'an tvOS surfaces.
- Extended the shared Flutter tvOS policy/registry layer so `/learn` is now a real enabled mirrored route during the current `testflight` stage.

## Product rationale

- tvOS is not a blind port. Learn starts with broad, calm shelves and obvious next steps rather than copying mobile density.
- Shared product ownership is preserved. The route is explicitly tied to the existing Learn system instead of inventing a separate tvOS-only knowledge product.
- Family-room use drove the layout: large cards, minimal input, guided entry points, and readable summaries.
- Future story, reflection, and visual-learning phases can plug into the same route without reworking the shell.

## Files changed

- `ios/PathOfNurTV/Screens/TVLearnScreen.swift`
- `ios/PathOfNurTV/Components/TVLearnHubItemCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/App/TVRootView.swift`
- `ios/PathOfNurTV/Components/TVNavigationSidebar.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/features/tvos/domain/tvos_content_registry_models.dart`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `lib/features/tvos/application/tvos_content_registry.dart`
- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `test/features/tvos/tvos_foundation_registry_test.dart`
- `test/features/tvos/tvos_feature_flags_test.dart`
- `test/features/tvos/tvos_content_registry_test.dart`

## Verification

Commands run:

```bash
flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart
flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart
xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO
```

Results:

- tvOS Flutter test slice passed
- `flutter analyze` found no issues
- unsigned native tvOS Release build succeeded

## Search / indexing impact

- No user-facing search UI was added in this phase.
- The shared tvOS registry now gives Learn stable route/module structure so later search or indexed discovery can be layered onto one canonical `/learn` surface instead of page-local logic.

## Enhancement options

1. Replace seeded Learn shelves with shared manifest-fed data when a native parity bridge exists, so tvOS follows the live mobile Learn taxonomy more directly.
2. Add a stronger resume entry once the shared Learn journey exposes a true next-lesson continuation payload.
3. Add focus QA coverage for moving between primary Learn paths, secondary shelves, and the navigation rail.
4. Add a later-phase detail screen pattern for stories and reflection content without fragmenting the Learn route into too many early subroutes.

## Localization report

New translation keys added:

- `Learn`
- `Journey-first learning and broad knowledge shelves adapted for calm TV browsing.`
- `A curated large-screen Learn hub shaped for calm browsing, family-room study, and simple next steps.`
- `Learn on tvOS starts with guided paths and broad knowledge shelves instead of a dense mobile-style dashboard.`
- `Start here`
- `Learning Journey`
- `Open the journey-first path for guided study, structured growth, and a clear next lesson.`
- `Best for steady weekly learning with one strong path instead of scattered browsing.`
- `Journey-first learning stays closest to the mobile Learn direction.`
- `Works well on TV because the next step is obvious and typing is not required.`
- `Sets the foundation for deeper story and reflection phases later.`
- `Browse all`
- `Explore all knowledge`
- `Move across the main Learn domains without leaving one calm master layout.`
- `Best for evening browsing, family discovery, and choosing a topic together.`
- `Explore keeps the Learn route broad without copying every mobile screen.`
- `Shared content ownership remains on the existing mobile Learn systems.`
- `tvOS can grow by adding more shelves to this hub instead of inventing parallel routes too early.`
- `Family room`
- `Family-safe learning`
- `Surface stories, reflection, and calm educational shelves that fit shared viewing.`
- `Best for mixed-age household use where simple choices matter more than deep controls.`
- `Family-room usage favors large visuals, simple remote input, and calm pacing.`
- `This route avoids heavy typing, account setup, or dense settings on TV.`
- `Later kids and stories phases can plug into the same master Learn structure.`
- `Stories and reflection`
- `The strongest TV-friendly Learn families: story, meaning, and short reflective return.`
- `Stories`
- `Prophets`
- `Revisit prophetic lives through a simple story-first entry point built for shared viewing.`
- `A natural TV fit because narrative content works better than dense reading lists.`
- `Prophetic stories anchor moral lessons in memorable narrative form.`
- `The TV layout should surface selected highlights before deeper later-phase detail screens.`
- `Companion`
- `Seerah`
- `Keep the Prophetic biography close through guided viewing paths and calm reflection.`
- `Useful for family-room learning because it supports listening, discussion, and repeat visits.`
- `Seerah content belongs in a companion-style shelf, not a cluttered library port.`
- `This master layout prepares for later story and reflection phases without overbuilding early.`
- `Short return`
- `Daily Wisdom`
- `Use short reflective prompts for a brief shared learning moment on the main TV.`
- `Best for quiet evening use when the room wants one meaningful reminder, not a long lesson.`
- `Daily Wisdom keeps Learn lightweight and re-openable.`
- `Short-form reflection is one of the safest and most natural TV-native learning surfaces.`
- `Knowledge domains`
- `Broad content shelves that can expand later without changing the master layout.`
- `Knowledge`
- `Hadith`
- `Open short thematic hadith learning through calmer browse-first entry points.`
- `A strong fit for TV when presented as themed selections instead of dense study controls.`
- `Hadith on TV should emphasize themes, authenticity, and short takeaways.`
- `This route can later expand into stronger thematic shelves without changing shell ownership.`
- `Signs`
- `World and Creation`
- `Bring visual learning and signs in creation into a format that suits the largest screen in the home.`
- `Especially strong for future TV because creation content benefits from scale and shared viewing.`
- `Creation and signs content should stay visual, calm, and discussion-friendly on TV.`
- `This master layout gives those later visual phases one clear Learn home.`
- `Practice`
- `Life lessons`
- `Use practical Islamic guidance shelves for daily questions, adab, and thoughtful living.`
- `Works best on TV as curated themes, not long searchable forms or dense text controls.`
- `Life lessons should remain curated and readable at distance.`
- `This route keeps future practical-learning surfaces inside one stable Learn hub.`
- `Start with a path`
- `Use one clear entry point first, then browse the wider Learn shelves without leaving the route.`
- `Selected learning path`
- `tvOS Learn direction`
- `This Learn hub is intentionally curated for television: large choices, simple focus movement, and no heavy typing or settings-first setup.`
- `Built for remote-first navigation and curated Home, Qur'an, and Learn parity.`

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
