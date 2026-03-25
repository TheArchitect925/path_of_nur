# tvOS Full Audit

Date: 2026-03-25

## Scope

This audit covered the current tvOS code path under `ios/PathOfNurTV`, the shared tvOS Flutter contracts under `lib/features/tvos`, and repo-side validation relevant to tvOS release posture.

## Commands run

- `flutter doctor -v`
- `flutter analyze lib/features/tvos test/features/tvos`
- `flutter test test/features/tvos`
- `flutter analyze`
- `flutter pub outdated`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_tvos_audit_modulecache`
- source inspection with `rg` and line-level review across active tvOS screens

## Validation results

### Passed

- Flutter environment is healthy on this machine.
- `flutter doctor -v` reported no toolchain issues.
- `flutter analyze lib/features/tvos test/features/tvos` passed.
- `flutter test test/features/tvos` passed.
- tvOS native Release build passed.
- No `TODO` / `FIXME` / `HACK` markers were found under the active tvOS source and shared tvOS layers.

### Failed

- Global `flutter analyze` failed outside the tvOS slice.
- Failure:
  - `test/features/learn/quran/quran_reader_playback_harness_test.dart:40`
  - `QuranReaderPlaybackControlsCard` is no longer defined for `_ReaderPlaybackHarness`

## Findings

### 1. Repo-wide static analysis is still red outside tvOS

Severity: high for release confidence, medium for tvOS specifically.

The tvOS code path is analyzer-clean, but the repo is not globally analyzer-clean. A broken non-tvOS test harness still causes `flutter analyze` to fail, which means a repo-wide CI or release gate can still fail even when tvOS itself is green.

Affected file:
- `test/features/learn/quran/quran_reader_playback_harness_test.dart:40`

Recommended fix:
- Repair or remove the stale harness reference before claiming a fully clean repo state for coordinated release work.

### 2. Dhikr still has a real empty-state regression path

Severity: medium.

The Dhikr route still assumes a selected mode exists. If the seeded mode list or later shared payload becomes empty, the route will render blank title/supporting strings and an empty phrase area instead of a deliberate fallback card.

Affected file:
- `ios/PathOfNurTV/Screens/TVDhikrScreen.swift:23`
- `ios/PathOfNurTV/Screens/TVDhikrScreen.swift:48`
- `ios/PathOfNurTV/Screens/TVDhikrScreen.swift:52`
- `ios/PathOfNurTV/Screens/TVDhikrScreen.swift:80`

Recommended fix:
- Apply the same shelf and rail fallback pattern used in Phase 27 for Learn, Saved, Profiles, Arabic, and Kids.

### 3. Games still has launch-facing blank-rail behavior

Severity: medium.

The Games route still assumes primary items and challenges exist. If those collections are ever empty, the route will leave shelves empty and render mostly decorative rails rather than a calm explicit fallback state.

Affected file:
- `ios/PathOfNurTV/Screens/TVGamesScreen.swift:25`
- `ios/PathOfNurTV/Screens/TVGamesScreen.swift:60`
- `ios/PathOfNurTV/Screens/TVGamesScreen.swift:130`
- `ios/PathOfNurTV/Screens/TVGamesScreen.swift:181`

Recommended fix:
- Extend `TVEmptyStateCard` coverage to Games.

### 4. Qur'an still depends on seeded content being present

Severity: medium.

The Qur'an route has strong happy-path behavior, but it still assumes browse collections, surah data, and selected ayahs exist. Focus fallback is partially defensive, but the route does not yet provide the same explicit empty-state handling added to the other hardened routes.

Affected file:
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift:18`
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift:60`
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift:82`
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift:112`
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift:233`

Recommended fix:
- Add empty-state handling for browse collections, surah lists, and reader ayah stacks before public launch.

### 5. Public-launch blockers remain procedural, not source-level

Severity: medium.

There were no source-level build failures in the audited tvOS slice. The remaining blockers are release-process blockers:

- no real Apple TV device QA evidence
- no signed archive / distribution proof in the release-readiness contract
- no validation yet for focus, playback, and readability on actual Apple TV hardware

## Dependency audit

Package drift exists but is not currently a tvOS blocker by itself.

High-signal items from `flutter pub outdated`:

- major drift exists in:
  - `flutter_riverpod`
  - `go_router`
  - `flutter_local_notifications`
  - `google_sign_in`
  - `share_plus`
  - `sign_in_with_apple`
  - `timezone`
- 7 dependencies are locked in `pubspec.lock` behind older upgradable versions
- 29 dependencies are constrained below a resolvable newer version

Assessment:
- treat as maintenance debt, not an immediate tvOS ship blocker
- do not batch-upgrade during release hardening without a dedicated compatibility pass

## Current verdict

### tvOS slice

- build status: green
- shared tvOS tests: green
- shared tvOS analysis: green
- launch posture: TestFlight-ready at repo side

### whole repo

- not globally analyzer-clean
- broader release confidence is still reduced by the unrelated Qur'an harness analyzer failure

## Recommended next steps

1. Fix the non-tvOS `flutter analyze` failure so the repo is globally clean again.
2. Extend Phase 27 empty-state coverage to Dhikr, Games, and Qur'an first.
3. Run real-device Apple TV QA for focus restore, playback, readability, and route-entry behavior.
4. Produce a signed archive and TestFlight upload proof, then update the shared launch-readiness gates.
