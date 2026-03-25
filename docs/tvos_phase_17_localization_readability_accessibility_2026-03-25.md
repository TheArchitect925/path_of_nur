# tvOS Phase 17 — Localization, Readability, and Accessibility

Date: 2026-03-25
Status: Complete

## Scope

Phase 17 hardened the existing tvOS surfaces for television readability and accessibility without changing route ownership, shell structure, or the current phased rollout map.

This pass focused on:

- shared native localization formatting support
- shared readability helpers for large-screen text treatment
- combined accessibility labels, hints, and values on reusable cards and mirrored Qur'an surfaces
- focus-selected accessibility traits for remote navigation
- tvOS-safe text color compatibility across the native target

## What changed

- Added a shared formatted localization helper in `ios/PathOfNurTV/Support/TVLocalized.swift`.
- Added a shared readability/accessibility helper layer in `ios/PathOfNurTV/Support/TVReadableAccessibility.swift`.
- Updated reusable cards and shell primitives so key titles, subtitles, and supporting lines scale down more safely on television layouts.
- Added combined accessibility descriptions on hero cards, section headers, action cards, saved-item cards, prayer cards, ayah cards, and navigation items.
- Improved Qur'an playback and listening controls with clearer accessibility labels and hints for play/pause, previous/next ayah, reciter switching, and opening listening mode.
- Hardened Home daily-verse and Qur'an summary surfaces so the mirrored route remains more readable and easier to understand with VoiceOver-style navigation.
- Normalized touched tvOS native views onto tvOS-safe `foregroundColor(...)` usage so the target continues to compile at the current deployment floor.

## Verification

Verified with:

`xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase17_modulecache`

Result:

- `** BUILD SUCCEEDED **`

## Notes

- This phase did not change tvOS route ownership or introduce new routes.
- This phase did not add search UI or indexing changes.
- The pass intentionally focused on active mirrored surfaces and shared native primitives rather than rewriting every remaining native screen at once.
