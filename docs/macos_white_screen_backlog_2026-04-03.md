# macOS White Screen Backlog

Date: 2026-04-03

## Completed now

- Fixed a macOS runner compatibility bug in `macos/Runner/MainFlutterWindow.swift` where `Date.ISO8601Format()` was used even though the macOS target supports 10.15.
- Replaced it with a shared `ISO8601DateFormatter` path that works on the current deployment target.

## Follow-up options

1. Audit macOS startup bootstraps and consider reducing early notification scheduling churn if white-screen-like launch lag is still visible on slower Macs.
2. Investigate the repeated debug-only `HardwareKeyboard` duplicate `KeyDownEvent` assertion on macOS and confirm whether it is environment-specific or worth a Flutter SDK workaround.
3. Run a signed release/archive validation for macOS once signing is configured, since `flutter build macos` currently stops at the expected code-signing requirement.
