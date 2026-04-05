# Windows Store Readiness Backlog

Date: 2026-04-03

This file is the enhancement/options backlog requested for the Windows desktop and Microsoft Store path.

## Recommended next steps

1. Fix desktop platform labeling in `lib/features/accounts_sync/application/accounts_sync_controller.dart`.
2. Add a Windows section to `docs/release_target_readiness.md` and the main `README.md`.
3. Introduce `msix_config` in `pubspec.yaml` and document the packaging flow.
4. Add a Windows QA checklist covering install, upgrade, uninstall, keyboard, mouse, resize, DPI, and notifications.
5. Review all Windows-visible routes and explicitly handle unsupported mobile-only features.

## Enhancement options

### Option A: Honest beta desktop release

Goal:
- ship a limited Windows desktop build with clear scope and reduced feature promises

Work:
- keep desktop-safe reading, learning, journaling, and backup flows
- soften or hide mobile-only features like camera-heavy and compass-heavy surfaces
- defer deep notification parity if Windows behavior is weak

Best when:
- the goal is near-term desktop availability without overpromising parity

### Option B: Near-parity Windows app

Goal:
- make Windows feel like a first-class Path of Nūr desktop app

Work:
- broader route-by-route UX adaptation
- desktop-first polish for navigation, resize, focus, and large displays
- validated notification, sign-in, backup, and playback behavior
- Windows-specific release and support documentation

Best when:
- the goal is a serious long-term desktop channel, not just Store presence

### Option C: Internal desktop hardening before public Store submission

Goal:
- use Windows builds internally or with a small beta group before Store launch

Work:
- fix correctness bugs
- add packaging and build docs
- run manual QA on Windows
- defer Store metadata and submission steps until product scope is settled

Best when:
- the team wants lower-risk validation before external release

## Specific feature hardening ideas

- Qibla desktop mode:
  - replace live compass expectations with a static bearing + manual city/location flow on Windows
- Creation Explorer desktop mode:
  - hide camera mode on Windows and promote the discover/journal paths instead
- Notifications:
  - define whether Windows supports prayer reminders fully, partially, or not in V1
- Accounts/Sync:
  - hide unsupported auth providers per platform instead of letting them fail at runtime
- Desktop shell:
  - audit minimum window size, keyboard shortcuts, tab traversal, and scroll behavior

## Store packaging work

- add MSIX tooling/configuration
- choose publisher identity and signing model
- define version/build numbering for Store releases
- prepare Store copy, screenshots, privacy URL, support URL, and age/content answers

## Verification backlog

- run `flutter build windows` on a real Windows machine
- generate and install an MSIX package
- verify first-run onboarding on Windows
- verify backup export/import on Windows
- verify audio playback behavior
- verify notification behavior or explicitly remove that promise from Windows scope

## Notes

- Do not treat the presence of the `windows/` folder as proof of Microsoft Store readiness.
- Keep release claims honest and aligned with validated platform behavior.
