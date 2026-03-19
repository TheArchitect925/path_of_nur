# Path of Nūr Watch Release Readiness Note

Last updated: 2026-03-18

## What is complete

- Native watch app surface is integrated for Home, Prayer, Progress, Utility, Manual Dhikr, Auto Dhikr, and post-prayer adhkar.
- Prayer and dhikr actions use the existing watch sync bridge and queue/replay path.
- Watch snapshot caching and complication data flow are in place and build cleanly.
- Implemented complications:
  - Next Prayer
  - Prayer Progress
  - Auto Dhikr
- Prayer reminder notification actions are wired for:
  - Mark as prayed
  - Mark as prayed late
  - Snooze
  - Open

## What still needs real-device verification

- Paired iPhone and Apple Watch notification action handling.
- Prayer-boundary and midnight complication freshness on device.
- Offline action replay and reconnect convergence.
- Auto Dhikr haptic comfort across fast and slow pacing.
- Already-open-app deep-link behavior from complications and notifications on hardware.

## Manual Xcode / Apple Developer steps still required

- Confirm signing and provisioning for:
  - `Runner`
  - `PathOfNurWatch Watch App`
  - `PathOfNurWatch Watch App Extension`
  - `PathOfNurWatchComplications`
- Confirm App Group capability alignment for:
  - `Runner`
  - `PathOfNurWatch Watch App Extension`
  - `PathOfNurWatchComplications`
- Confirm the watch app and complication bundle identifiers are registered and embedded correctly.
- Run the full checklist in `docs/watch_launch_qa_checklist.md` on a real paired device set before TestFlight distribution.
