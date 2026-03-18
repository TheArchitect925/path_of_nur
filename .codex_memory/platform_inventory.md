# Platform Inventory

Last updated: 2026-03-17

## iPhone / iPad

- current first-release target
- release docs treat iOS + iPadOS as the recommended launch scope
- local app code and routing are actively maintained for this path

## macOS

- conditional only
- viable if signed-build validation confirms:
  - iCloud KVS works
  - local notifications permission flow works
  - backup/export/import works under sandboxed signed build
- unsigned local debug is supported, but not sufficient for release-readiness claims

## Apple Watch

- native companion code exists
- Flutter-side watch contract logic and tests exist
- not first-release ready
- needs:
  - dedicated build validation
  - real-device QA
  - notification / sync / rollover verification

## Wear OS

- Flutter-side contract and QA expectations exist
- release posture is still incomplete
- treat as companion work, not launch-ready product surface

## tvOS

- scaffolding exists
- not first-release ready
- should not be advertised as shipping until release-grade validation is complete

## Simulator / device-specific conditions

- active iOS backlog items include:
  - Apple Silicon simulator config hardening
  - Xcode 26+ local setup documentation
  - plugin compatibility review
  - Creation Explorer camera latency tuning
- open non-fatal investigation:
  - `This FlutterEngine was already invoked.`

## Release-readiness summary

- ready enough for primary focus:
  - iOS
  - iPadOS
- conditional:
  - macOS
- not ready:
  - Apple Watch
  - tvOS
  - any claimed Path of Nūr production cloud sync
