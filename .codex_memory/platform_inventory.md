# Platform Inventory

Last updated: 2026-03-18

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

- native companion app, extension, and complication target now exist in the integrated iOS project
- Flutter-side watch contract logic and tests exist
- watch simulator build now passes for:
  - `PathOfNurWatch Watch App`
  - `PathOfNurWatchComplications`
- current native watch surface includes:
  - Home, Prayer, Dhikr, Progress, Utility
  - post-prayer adhkar mini flow
  - next prayer + daily progress complications backed by shared watch cache
- not first-release ready
- needs:
  - real-device QA
  - entitlement/app-group signing verification
  - notification / sync / rollover verification

## Wear OS

- Flutter-side contract and QA expectations exist
- release posture is still incomplete
- treat as companion work, not launch-ready product surface

## tvOS

- canonical native target exists in `ios/Runner.xcodeproj` as `PathOfNurTV`
- active source lives in `ios/PathOfNurTV`
- current V1 scope is Home + Qur'an, aligned to the mobile app direction with tvOS focus adaptations
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
  - Apple Watch as a launch-ready surface, despite native V1 scaffolding now compiling
  - tvOS
  - any claimed Path of Nūr production cloud sync
