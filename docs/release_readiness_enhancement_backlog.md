# Release readiness enhancement backlog

These items are intentionally not bundled into the current release-readiness pass.

## Apple project structure

- Add watch-target entitlements and capability wiring only when the first real watch features require them.
- Add tvOS entitlements and capability wiring only when the first real tvOS features require them.
- Add a small Apple preflight script that prints the resolved bundle-ID and signing matrix from the Xcode project before handoff.

## Assets and metadata

- Add a release-owned checklist for final App Store icon, screenshot, subtitle, keyword, and privacy metadata preparation.
- Replace the scaffold watch app asset catalog with real release icons before any TestFlight or App Store watch submission.
- Replace the scaffold tvOS asset catalog with real release icons before any TestFlight or App Store tvOS submission.

## Validation

- Add a short Apple-specific CI or local script for archive preflight once multiple native Apple targets exist.
- Add a signed-build QA checklist for notifications, Live Activities, iCloud sync, and background audio on physical devices.
- Add a paired-device QA checklist for watch install, launch, upgrade, and companion handoff behavior.
- Add an Apple TV QA checklist for focus navigation, remote input, ambient playback, and archive validation.

## Documentation

- Add a submission checklist for extension signing and App Store Connect capability alignment.

- Add CI validation for iOS bundle identifiers, signing placeholders, and a no-codesign release build before each App Store handoff.

- Add a dedicated preflight check for the embedded watch targets so simulator/device iOS builds fail early when watch platform metadata drifts.

- Add a release-signing check that verifies the configured Apple team owns every bundle identifier in the iOS, watchOS, live activity, and tvOS targets before archive.

- Add a bundle-family consistency check to CI so iOS, watch app, watch extension, tests, live activity, and tvOS bundle identifiers stay prefixed correctly.
- add a post-`flutter run`/post-upgrade project sanity check for Apple target bundle IDs and development teams
- add a CI assertion that embedded iOS app extensions resolve to bundle IDs prefixed by the main app bundle ID on simulator builds
## Apple upload hardening follow-ups

- add a signed-archive entitlement inspection step after Organizer export when upload blockers involve provisioning versus source entitlements
- add watch icon asset completeness checks for all release Apple targets, not just the main watch app
- add a local one-command pre-upload validator for archive structure, signed entitlements, and bundle metadata
- keep a dedicated debug-vs-release entitlement doctor in CI so provisioning drift is caught before Xcode signing breaks again
