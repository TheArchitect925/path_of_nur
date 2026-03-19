# Watch Phase 3 Enhancement Backlog

Items intentionally left out of the current Phase 3 refinement pass.

## Trust and recovery

- Add a small stale-snapshot badge style for the watch Home and Progress cards after paired-device QA confirms the best wording.
- Add a user-facing "last synced" detail row in Utility if real-device testing shows users need more sync reassurance.

## Post-prayer adhkar

- Add phone-authored custom post-prayer adhkar sets once the iPhone side exposes a structured payload.
- Add a shorter child-friendly adhkar set variant for kids mode rather than hardcoding a second watch-only sequence.
- Add per-prayer resume prompts only after confirming they do not make the Prayer screen feel crowded.

## Notifications and deep links

- Wire notification categories and deep links on the Apple side once paired-device notification routing is validated.
- Add a prayer-reminder-to-watch-screen route matrix so taps can open Prayer, Dhikr, or post-prayer adhkar intentionally.

## Complications

- Add family-specific polish for any less-used complication families only after the main rectangular, circular, and inline families are approved on device.
- Consider a tomorrow-first fallback for the next-prayer complication after all-today-complete if the phone snapshot exports next-day prayer times cleanly.

## Validation

- Run a full paired-device QA pass covering rollout, reachability recovery, complication freshness, and haptic feel on real Apple Watch hardware.
