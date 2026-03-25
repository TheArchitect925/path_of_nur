# tvOS Phase 3: App Shell, Navigation, Focus Engine, and Route Structure

Date: 2026-03-25

## Scope completed

- Replaced the default tvOS `TabView` shell with a remote-first shared shell built around a persistent navigation rail and content stage.
- Added a native route registry for the currently mirrored tvOS surfaces:
  - `home` -> `/home`
  - `quran` -> `/quran`
- Added a lightweight focus engine contract that tracks:
  - active shell column (`navigation` vs `content`)
  - preferred content section per route
  - route-aware focus restore when the user returns to Home or Qur'an
- Preserved the current Home and Qur'an content/view-model logic while wiring both screens into the new shell contract.

## New architecture pieces

- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
  - canonical tvOS route metadata
  - top-level route path labels
  - default route sections for focus restore
- `ios/PathOfNurTV/Components/TVNavigationSidebar.swift`
  - persistent navigation rail
  - route labels and route-path context
  - navigation focus restore
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
  - shell navigation store
  - preferred content-section memory
  - focus request tokens for navigation/content handoff

## Interaction decisions

- tvOS now uses a sidebar shell instead of the stock tab strip because the remote-first layout is clearer and scales better for future phases.
- Home restores focus to the last meaningful action area instead of always restarting at the top.
- Qur'an restores focus to the last active section:
  - playback
  - browse
  - reader
- Left-direction remote movement now returns from content into navigation on the shell boundaries without forking Home/Qur'an product behavior.

## Parity notes

- No iOS or Flutter routing behavior was changed.
- Mirrored surfaces remain Home and Qur'an only.
- This phase introduced native tvOS route structure and focus scaffolding only; it did not expand product scope beyond the current mirrored surfaces.

## Verification

- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO`
- Result: passed

## Recommended next follow-ups

1. Phase 4 should start consuming shared parity/domain payloads through the new route shell rather than adding more seed-only screen state.
2. Phase 5 should add a stronger continue-journey lane inside the Home content stage now that focus memory exists.
3. Phase 25 should add manual focus-order QA steps against the new shell before more content surfaces are added.
