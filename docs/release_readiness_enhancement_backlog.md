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
