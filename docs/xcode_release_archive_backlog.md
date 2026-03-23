# Xcode Release Archive Backlog

Date: 2026-03-23
Task: Xcode release archive for iOS

## Completed

- Bumped app version/build to `1.2.3 (23)`.
- Created a successful iOS archive at `build/ios/archive/PathOfNur-1.2.3-23.xcarchive`.
- Verified archive metadata reports:
  - `CFBundleIdentifier = com.shahab.pathOfNur`
  - `CFBundleShortVersionString = 1.2.3`
  - `CFBundleVersion = 23`

## Enhancement Options

- Add an `ExportOptions.plist` and a one-command export script for App Store / TestFlight IPA generation.
- Audit the iOS asset catalog and add the missing iPhone/iPad icon sizes reported by `actool`.
- Add a release checklist script that validates version/build, locale generation, archive creation, and archive metadata before distribution.
