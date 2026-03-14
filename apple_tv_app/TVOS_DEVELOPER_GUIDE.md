# Path of Nūr tvOS Developer Guide

## Why tvOS is native instead of Flutter

Flutter does not officially support tvOS as a production Apple TV target. Shipping a fake tvOS build path through iOS Flutter plumbing would be brittle and misleading. This companion app is therefore implemented as a native SwiftUI tvOS app foundation inside the same repository.

## Structure

- `PathOfNurTV/App`: app entry and navigation shell
- `PathOfNurTV/Theme`: colors, spacing, focus styling
- `PathOfNurTV/Models`: tvOS-facing content and state models
- `PathOfNurTV/Data`: seeded local content for prayer, learning, prophets, audio, and progress
- `PathOfNurTV/ViewModels`: screen-level state and presentation models
- `PathOfNurTV/Views/Components`: reusable hero banners, shelves, focusable cards, prayer cards, detail templates, and audio cards
- `PathOfNurTV/Views/Screens`: Home, Prayer, Learn, Prophets, Library, Progress, Settings, Dhikr
- `PathOfNurTV/Assets.xcassets`: tvOS-specific icon, top shelf, and color scaffolding
- `TopShelf`: placeholder for future top shelf extension implementation

## Shared vs duplicated logic

### Reused conceptually
- Path of Nūr visual language
- prayer-focused daily overview
- learning content categories
- prophets and reflection philosophy
- audio/listen-first experience

### Ported or mirrored natively
- tvOS navigation
- prayer summary data models
- content shelf structures
- family-safe ambient display flows

### Not directly shared
- Flutter widgets and routing
- mobile-only input-heavy workflows
- Live Activities, mobile notifications, sensors, and touch-first interactions

## Current limitations

- This commit provides a production-minded tvOS app foundation in SwiftUI, but does not modify the existing Flutter Xcode target graph.
- Prayer calculation is represented as a native local summary model for tvOS; direct parity with the Dart prayer engine should be added as a dedicated Swift port in a later phase.
- Content is seeded locally in Swift for now instead of attempting fragile Dart runtime reuse.
- Top Shelf is scaffolded but not implemented.
- Asset catalogs are scaffolded and need final branded layered icon artwork.

## Recommended next steps

1. Add a real tvOS target and optional Top Shelf extension in Xcode.
2. Port the required prayer calculation subset to Swift so tvOS prayer state is fully local and deterministic.
3. Move shared content into platform-neutral bundled assets where appropriate.
4. Add AVPlayer-backed audio playback and Now Playing support.
5. Add household ambient mode and resume state persistence.
