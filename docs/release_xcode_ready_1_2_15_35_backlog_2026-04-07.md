# Release Xcode Ready Backlog

Date: 2026-04-07

## Enhancement options

- Run one cold-launch TestFlight/device check on `1.2.15 (35)` specifically for the explicit-engine iOS startup path outside the debugger.
- Archive and validate signing in Xcode Organizer, then confirm the embedded version/build fields match `1.2.15 (35)` in the final `.ipa`.
- Do one quick camera-permission sanity check on the Qibla AR flow after install so the updated iOS usage description reads naturally in production.
- If this build is the startup-crash verification build, collect a fresh device/TestFlight result and attach the exact launch outcome to the release notes for future comparison.
