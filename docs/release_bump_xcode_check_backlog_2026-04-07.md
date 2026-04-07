# Release Bump + Xcode Check Follow-up

Date: 2026-04-07

1. Archive the iOS build from Xcode Organizer using version `1.2.14` build `34` and confirm signing/export are clean.
2. Run a real-device cold launch and TestFlight smoke check to verify the explicit-engine startup crash no longer reproduces outside the debugger.
3. If the startup issue still appears, collect the fresh `.ips` log from the new build so we can compare it against the previous `VSyncClient` crash family.
