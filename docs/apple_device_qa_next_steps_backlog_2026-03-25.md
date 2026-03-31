# Apple Device QA Next Steps Backlog

Date: 2026-03-25
Related task: version bump, Apple build sweep, and physical-device QA prep

## Immediate next steps

- Connect the target iPhone by cable or enable trusted wireless debugging so Flutter or Xcode can see the device reliably.
- Open `ios/Runner.xcodeproj` in Xcode and confirm signing for `Runner`, `PathOfNurTV`, `PathOfNurWatch Watch App`, `PathOfNurWatch Watch App Extension`, and `PathOfNurWatchComplications`.
- Run on real hardware in this order:
  - iPhone `Runner`
  - Apple Watch companion flow from the paired iPhone build
  - Apple TV `PathOfNurTV`
- After hardware validation, archive signed builds in Xcode Organizer and record signed archive / TestFlight proof in the shared tvOS launch-readiness contract.

## Focus areas during QA

- iPhone launch, onboarding, core tabs, Qur'an playback, and profile/sync posture
- Watch install, launch, complication rendering, prayer/dhikr flows, and paired-app continuity
- tvOS focus restore, playback, sparse-data routes, and large-screen readability
