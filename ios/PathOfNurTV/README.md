# PathOfNurTV

Canonical tvOS source for Path of Nūr lives in this folder and is compiled by the existing `PathOfNurTV` target inside `ios/Runner.xcodeproj`.

## Current status

- native SwiftUI tvOS V1 shell
- current V1 scope:
  - Home
  - Qur'an
- Home mirrors the mobile app direction with a prayer-focused homepage section adapted for tvOS focus navigation
- Qur'an mirrors the mobile app direction with seeded browsing, reader, and audio playback structure adapted for tvOS
- local seeded data only for now
- no production prayer engine, sync, persistence, or release-grade Apple TV assets yet
- the canonical tvOS target now has a concrete brand asset set and Top Shelf image so Xcode Release/TestFlight archive work can proceed without an empty app-icon catalog

## Folder structure

- `App/`: tvOS app entry and root tab shell
- `Screens/`: current tvOS screens
- `Components/`: shared focus-friendly UI building blocks
- `Models/`: lightweight view-facing models
- `ViewModels/`: screen and shell state
- `Data/`: local seeded repository content for the current shell
- `Theme/`: colors, spacing, background, and focus behavior

## Future work should continue here

Future tvOS implementation work should extend `ios/PathOfNurTV` and the existing `PathOfNurTV` target rather than reviving a parallel tvOS app path elsewhere in the repository.

For mirrored surfaces, especially Home prayer content and the Qur'an page, future changes should review the current mobile implementation in the same pass and keep tvOS aligned unless a platform-specific deviation is required.

## Asset note

The target now includes:

- accent color assets
- a concrete `AppIcon.brandassets` set in the canonical tvOS target
- a canonical `TopShelf.imageset`

These assets are currently derived from existing Path of Nūr branding so the target can be archived and tested in Xcode/TestFlight without an empty catalog.

They should still be treated as interim assets until final Apple TV-specific layered artwork is approved.
