# Path of Nūr Windows Store Readiness Audit

Date: 2026-04-03

## Scope

This audit reviews the current Flutter Windows target, desktop-runtime behavior, and Microsoft Store packaging posture for Path of Nūr.

It is an honesty-first readiness check, not a claim that the app is already releasable on Windows.

## Executive summary

Current status: not Microsoft Store ready.

What exists today:
- a standard Flutter Windows runner under `windows/`
- Windows plugin registration for `file_selector`, `flutter_timezone`, `flutter_tts`, `geolocator`, `permission_handler`, `share_plus`, `sqlite3_flutter_libs`, and `url_launcher`
- desktop-safe guards for some mobile-only behaviors such as quick actions and image labeling

What is still missing:
- Microsoft Store packaging setup (`msix`, identity, publisher, signing, Store submission metadata)
- a Windows QA checklist and release doc
- explicit Windows release positioning in repo release docs and memory
- desktop-specific UX hardening for mobile-only surfaces
- a green global release gate, since `flutter analyze` currently fails in existing test code

Recommended release posture today:
- treat Windows as exploratory desktop support only
- do not market or submit it to the Microsoft Store yet

## Evidence reviewed

- `pubspec.yaml`
- `windows/` runner files
- `.codex_memory/platform_inventory.md`
- `docs/release_target_readiness.md`
- `RELEASE_READINESS_CHECKLIST.md`
- platform-sensitive app code in notifications, sync, location, Qibla, creation explorer, and shared UI
- `flutter analyze`

## Findings

### P0 blockers

1. No Microsoft Store packaging path exists in source control.
   Evidence:
   - no `msix_config` in `pubspec.yaml`
   - no Store identity, publisher, appinstaller, or submission docs were found
   Impact:
   - the app cannot be packaged and submitted through a maintained repo workflow yet

2. Global release verification is currently red.
   Evidence:
   - `flutter analyze` fails with 25 errors, concentrated in existing Qur'an test files
   Impact:
   - even before Windows-specific work, the repo is not at a clean release gate

3. Desktop device classification is wrong in Accounts/Sync.
   Evidence:
   - `lib/features/accounts_sync/application/accounts_sync_controller.dart`
   - `_platformForCurrentDevice()` maps `TargetPlatform.macOS` to `DevicePlatformKind.appleTv`
   - `_devicePlatformKindFromKey()` maps `windows`, `linux`, and `fuchsia` to `DevicePlatformKind.androidTablet`
   Impact:
   - desktop devices can be mislabeled in sync/device UI and backup metadata
   - this is incorrect platform truth and should be fixed before desktop release work

4. Windows release posture is undocumented in the canonical release docs.
   Evidence:
   - `docs/release_target_readiness.md` discusses iOS, iPadOS, macOS, watchOS, and tvOS, but not Windows
   - `.codex_memory/platform_inventory.md` had no Windows section before this audit
   Impact:
   - teams can over-assume readiness from the presence of the `windows/` folder

### P1 high-priority gaps

5. Windows branding and executable metadata are still scaffold-level.
   Evidence:
   - `windows/runner/Runner.rc` uses `com.shahab`, `path_of_nur`, and `path_of_nur.exe`
   Impact:
   - Store packaging and installed-app presentation will feel unpolished or inconsistent

6. No Windows-specific release checklist exists.
   Missing areas:
   - MSIX packaging
   - certificate/signing flow
   - Store screenshots and metadata
   - privacy/support URL verification for Microsoft Store listing
   - upgrade/install/uninstall testing
   - keyboard, mouse, window-resize, and high-DPI QA

7. Mobile-only surfaces are present and not yet clearly product-shaped for desktop.
   Evidence:
   - Creation Explorer explicitly says “Use a physical iPhone or iPad to explore with the camera.”
   - Qibla Finder depends on live location plus compass data
   Impact:
   - some surfaced routes will feel like dead ends on Windows unless they are hidden, softened, or rewritten with desktop-friendly guidance

8. Notification behavior is not validated for Windows.
   Evidence:
   - `LocalNotificationService` initializes iOS, macOS, and Android settings explicitly
   - no Windows-specific notification contract or QA notes were found
   Impact:
   - prayer reminders are a core product feature, and desktop notification posture is currently unproven

9. Account provider UX is not desktop-shaped yet.
   Evidence:
   - Apple Sign In is intentionally Apple-only
   - Google Sign-In is not gated by platform in `PlatformAccountsAuthRepository.signInWithGoogle()`
   - Windows plugin registration does not show a Windows Google Sign-In implementation
   Impact:
   - Windows account/backup flows may degrade unpredictably or feel misleading

### P2 medium-priority gaps

10. Windows-specific docs and contributor workflow are missing.
    Missing:
    - local Windows build instructions
    - Visual Studio prerequisites
    - packaging command examples
    - Store submission checklist

11. Desktop UX hardening is not audited.
    Missing:
    - keyboard traversal review
    - focus states
    - minimum window size behavior
    - resize behavior on large displays
    - desktop pointer affordances
    - text scaling and DPI review on Windows

12. Shared visual system has Windows fallbacks, but premium glass expectations need QA.
    Evidence:
    - `NoorLiquidGlassCapability` explicitly disables the liquid implementation on Windows and falls back away from real liquid rendering
    Impact:
    - the app may remain functional, but high-end visual polish needs Windows-specific review

## Platform behavior notes

### Good signs

- quick actions are disabled on desktop platforms rather than assumed available
- creation image labeling is gated to Android/iOS
- local-first persistence should translate reasonably well to desktop
- `file_selector` and `share_plus` Windows plugins are present

### Risky or unfinished areas

- Qibla and compass-centered flows are still mobile-oriented
- notification scheduling is not documented or validated for Windows
- account and remote-backup UX still leans Apple/mobile in tone and assumptions
- Windows branding/package identity is absent

## Microsoft Store readiness checklist

### Phase 1: truth and stability

- fix analyzer failures so the repo has a clean baseline
- fix incorrect desktop device-kind mapping in accounts/sync
- decide the honest Windows product scope for V1:
  - full parity target
  - limited desktop companion target
  - internal/beta only for now

### Phase 2: package and brand

- add a maintained MSIX packaging workflow
- choose final Windows app identity, display name, publisher, and versioning policy
- prepare Store assets:
  - app icons
  - screenshots
  - square/wide tiles if needed by tooling
- document signing and certificate handling

### Phase 3: desktop UX hardening

- audit all Windows-visible routes for mobile-only dependencies
- hide, restate, or adapt unsupported experiences
- review keyboard navigation, focus order, pointer states, and window resize behavior
- validate high-DPI behavior and large-screen readability

### Phase 4: feature validation

- validate prayer schedule behavior on Windows
- validate local notifications or explicitly narrow the Windows reminder promise
- validate backup/export/import on Windows
- validate Google sign-in behavior or hide unsupported paths
- validate audio playback and background behavior expectations on desktop

### Phase 5: Store submission readiness

- prepare Windows-specific privacy/support listing data
- write a Windows QA runbook
- run install, upgrade, uninstall, and first-run checks on real Windows hardware
- document known limitations honestly in release notes if needed

## Suggested first implementation slice

1. Fix platform/device classification bugs in accounts/sync.
2. Add Windows status to release docs and continuity memory.
3. Add MSIX configuration and a draft Windows packaging doc.
4. Audit route-level desktop UX for Qibla, Creation Explorer, reminders, and account sync.
5. Run real Windows build and QA on a machine with Visual Studio + Windows SDK.

## Verification notes

Verified in this pass:
- repo structure and Windows runner presence
- plugin registration snapshot
- platform-guarded code paths
- current `flutter analyze` status

Not verified in this pass:
- actual `flutter build windows`
- actual MSIX generation
- real Windows notification behavior
- keyboard/mouse QA on Windows hardware
- Microsoft Store Partner Center submission flow
