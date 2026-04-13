# Release Version Bump Backlog

Date: 2026-04-13
Status: Version/build bumped for Xcode release prep

## Completed

- Flutter version bumped from `1.2.19+39` to `1.2.20+40`
- iOS Xcode marketing version bumped from `1.2.19` to `1.2.20`
- iOS Xcode current project version bumped from `39` to `40`

## Enhancement options

1. Add a tiny release preflight script that verifies `pubspec.yaml` and `ios/Runner.xcodeproj/project.pbxproj` stay in sync before every App Store build.
2. Add a release checklist note that records the exact Xcode archive command and latest unsigned build result for each version bump.
3. Decide whether macOS version metadata should intentionally track iOS release numbers more closely or remain on its separate cadence.
