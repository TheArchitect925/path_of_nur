# Path of Nūr Release Target Readiness

This document is the honest first-release scope, based on the currently validated codebase.

## Recommended first release scope

- iOS
- iPadOS

## Conditional release targets

- macOS
  - viable if signed-build validation confirms:
    - iCloud key-value sync works
    - local notifications permission flow works
    - backup/export/import works with the signed sandboxed app
  - local unsigned debug runs are supported, but signed Release/Profile validation is still required before claiming macOS as a release target

## Not first-release ready

- Apple Watch
  - native watchOS companion targets now exist, but they are only scaffolded
  - do not advertise it as shipping until the watch feature set, assets, signing, and paired-device flows are validated end to end

- tvOS
  - a canonical native tvOS shell now exists under `ios/PathOfNurTV` in the `PathOfNurTV` target
  - the current V1 scope is Home + Qur'an, aligned to the mobile app direction as closely as practical
  - it is still not first-release ready
  - do not include tvOS in the first public release scope until tvOS features, assets, signing, and Apple TV QA are complete

- Path of Nūr Cloud Sync
  - not release-ready because there is no real production backend transport in this repository
  - current safe release path is:
    - local-only
    - manual backup
    - Apple iCloud sync on Apple devices

## Current Apple sync posture

- iCloud sync is implemented through `NSUbiquitousKeyValueStore`
- it is suitable for the current bounded profile sync document
- it is not a substitute for a full backend event journal

## Release recommendation

Ship the first release as a stable local-first app with:

- structured local persistence
- profile isolation
- manual backup/import/export
- Apple iCloud sync on signed Apple devices

Hold back unvalidated companion and TV surfaces until their native build and QA paths are complete.
