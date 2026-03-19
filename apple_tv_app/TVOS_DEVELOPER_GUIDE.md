# Path of Nūr tvOS Developer Guide

## Canonical ownership

The canonical tvOS implementation now lives in:

- `ios/PathOfNurTV`
- target: `PathOfNurTV` in `ios/Runner.xcodeproj`

This `apple_tv_app/` directory is archive/reference-only and should not be treated as an active second app path.

## Why tvOS remains native instead of Flutter

Flutter does not officially support tvOS as a production Apple TV target. Path of Nūr therefore keeps tvOS native in SwiftUI rather than pretending the iOS Flutter target is a supported Apple TV product path.

## What was migrated into the canonical target

The current integrated shell in `ios/PathOfNurTV` adopts the useful foundation from this earlier prototype:

- native shell structure
- calm tvOS theme and background treatment
- focus-friendly card patterns
- simple seeded models and placeholder data flow
- large-screen first typography and spacing

## Current implementation status

The canonical target now provides:

- a real native SwiftUI app shell
- first-phase mirrored surfaces for:
  - Home
  - Qur'an
- a prayer-focused Home experience adapted from the current mobile direction
- a Qur'an browsing/reader/playback shell adapted from the current mobile direction
- local seeded content and playback wiring suitable for next-phase feature work

It does not yet provide:

- production prayer calculation logic
- Top Shelf content
- sync or persistence
- release-ready Apple TV assets
- full mobile-feature parity beyond the current Home + Qur'an scope

## What remains in this archive

This directory still contains earlier exploration code, richer placeholder screens, and a Top Shelf stub. Those files may be consulted for future migration ideas, but active tvOS implementation should continue only in `ios/PathOfNurTV`.

## Recommended next build phases

1. Replace seeded Home prayer data with shared or bridged prayer-state logic that matches the mobile app more closely.
2. Deepen Qur'an parity around reader state, browsing depth, and playback behavior without forking product direction.
3. Decide whether Top Shelf is worth integrating into the main project.
4. Finish release-grade Apple TV icon and Top Shelf artwork.
5. Add focused Apple TV QA around navigation, playback, and parity with mirrored mobile surfaces.
