# Apple Deployment Backlog

Date: 2026-04-03

## Current status

- iOS release validation is green using:
  - `flutter build ios --no-codesign --no-tree-shake-icons`
- tvOS versioning is updated and the target config is tighter, but local tvOS build validation is still blocked by unstable CoreSimulator / `simdiskimaged` state on this machine

## Enhancement options

- Fix the non-constant `IconData` usage in the Learn/Home surfaces so iOS release packaging no longer requires `--no-tree-shake-icons`
- Stabilize the local Apple toolchain by fixing the CoreSimulator / `simdiskimaged` runtime issue, then rerun the `PathOfNurTV` scheme build
- If tvOS remains dependent on simulator services during asset compilation, validate whether a clean Xcode reinstall or simulator runtime reinstall is needed on this machine
- Add one small release script for Codex deployment that performs:
  - version verification
  - iOS no-codesign build
  - tvOS scheme build
  - compact result summary

## Do-not-break notes

- keep iOS and tvOS version numbers aligned in both `pubspec.yaml` and `ios/Runner.xcodeproj/project.pbxproj`
- keep the `PathOfNurTV` target on explicit tvOS supported platforms
- do not revert the tvOS build-setting fix while the target still contains tvOS-only SwiftUI APIs
