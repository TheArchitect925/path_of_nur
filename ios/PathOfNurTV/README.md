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

`Assets.xcassets/AppIcon.brandassets` holds everything tvOS asks for:

- `App Icon.imagestack` (400x240 at 1x and 2x) for the home screen
- `App Icon - App Store.imagestack` (1280x768) for the store
- `Top Shelf Image.imageset` (1920x720) and `Top Shelf Image Wide.imageset` (2320x720), each at 1x and 2x

Each stack has three layers: the lantern and book in front, the ring of light in the middle, the night sky behind. The sky is the only opaque layer. tvOS rounds the corners and moves the layers itself, so every image is square to its edges.

Do not edit these files by hand. They are generated from the app icon source:

```
swift tooling/scripts/generate_tvos_brand_assets.swift
```

`scripts/ci_apple_bundle_consistency.sh` checks the catalog's shape, because the asset compiler does not: a catalog it cannot read is dropped without a warning and the app ships with no icon.
