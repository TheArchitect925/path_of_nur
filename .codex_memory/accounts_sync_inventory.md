# Accounts / Sync Inventory

Last updated: 2026-03-17

## Shared-device flow

- launch gate route: `/profiles/launch`
- trigger conditions:
  - shared device mode enabled
  - require profile selection on launch
  - no unlocked profile session
- picker supports:
  - switching profiles
  - protected profiles with PIN
  - add profile
  - sign in another account
  - manage shared-device settings

## Profile / account model

Core model enums already in code:

- account providers:
  - `signInWithApple`
  - `google`
  - `emailMagicLink`
  - `localOnly`
- profile kinds:
  - `adult`
  - `youth`
  - `child`
  - `guest`
- profile experience modes:
  - `full`
  - `simplified`
  - `learningFocused`
  - `prayerFocused`
- profile sync modes:
  - `pathOfNurCloud`
  - `iCloud`
  - `localOnly`
  - `manualBackupOnly`

Important continuity note:

- `pathOfNurCloud` exists in the model, but production cloud transport does not exist in this repository

## Manual backup / import / export

Routes:

- `/accounts-sync/backup`
- `/accounts-sync/backup/export`
- `/accounts-sync/backup/import`

Reality:

- manual backup is part of the intended safe release posture
- backup/export/import is already surfaced in settings and accounts sync pages

## iCloud / local-first behavior

- implemented transport:
  - `ICloudSyncTransport`
  - method channel: `path_of_nur/icloud_sync`
  - methods:
    - `isAvailable`
    - `readValue`
    - `writeValue`
- behavior:
  - local-first writes
  - bounded retained change document per scope
  - conflict resolution still handled locally/in-app

## What is not production cloud sync

- there is no real backend event journal
- there is no production server sync transport in this repo
- do not describe current sync as full cross-platform cloud sync
- current safe shipping posture is:
  - local-only
  - manual backup/import/export
  - Apple iCloud sync on signed Apple devices

## Device inventory already modelled

- iPhone
- iPad
- Apple Watch
- Apple TV
- Android phone
- Android tablet
- Android watch
- Android TV

## Risk notes

- account/sync UI is ahead of real backend transport capability
- future work must keep docs and product copy honest about local-first constraints
