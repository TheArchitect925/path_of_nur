# tvOS TestFlight Release Checklist

Date: 2026-03-25

Scope:
- Canonical tvOS target: `PathOfNurTV`
- Project: `ios/Runner.xcodeproj`
- Current governed TestFlight scope:
  - Home
  - Profiles
  - Qur'an
  - Saved
  - Settings
  - Arabic
  - Learn
  - Games
  - Prayer
  - Dhikr
  - Kids

## Repo-side status from this pass

- canonical tvOS source remains under `ios/PathOfNurTV`
- Release build now succeeds locally via:
  - `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO`
- canonical tvOS asset catalog now includes:
  - `AppIcon.brandassets`
  - `TopShelf.imageset`

## What is now ready

- Xcode release build validation
- device install/testing once signing is configured
- TestFlight archive preparation from the canonical target
- governed TestFlight route scope is now defined by the shared tvOS release-policy and update-governance layer, not by ad hoc checklist text

## What still must be done in Xcode before upload

1. Open `ios/Runner.xcodeproj` in Xcode.
2. Select the `PathOfNurTV` target.
3. Confirm:
   - Team is correct
   - bundle identifier is correct
   - signing is valid for the tvOS app id
4. Build for:
   - `Any tvOS Device (arm64)`
5. Archive from:
   - `Product` -> `Archive`
6. In Organizer, validate:
   - icon/top-shelf assets render correctly
   - display name and version/build are correct
   - no signing/provisioning issues remain

## TestFlight-focused QA before upload

1. Verify Home loads and focus navigation is stable with the Siri Remote.
2. Verify Profiles switches household context cleanly and resume continuity stays sane.
3. Verify Home -> Qur'an action opens the Qur'an route.
4. Verify Qur'an browse, reader, playback, and listening-mode exit all restore focus sanely.
5. Verify Saved opens and returns to resume lanes without focus loss.
6. Verify Settings persists startup and listening defaults and shows diagnostics summary state.
7. Verify Arabic, Learn, Games, Prayer, Dhikr, and Kids all support left-edge sidebar return and stable first-focus sections.
8. Verify audio playback starts, pauses, resumes, and surfaces local playback failures on Apple TV hardware.
9. Verify the interim Top Shelf image and app icon appear correctly in the archive/app metadata.

## Known product limitations for this tvOS test build

- shared route governance exists, but public-store release remains blocked by missing real-device QA evidence
- local-first diagnostics and crash guardrails exist, but no backend analytics pipeline is claimed
- sync, backup authoring, and deeper account management remain companion-device responsibilities
- the active route set is larger than the original shell build, but tvOS is still not public-release ready

## Recommended archive command for local validation

Use this as a repo-side release smoke check:

```sh
xcodebuild -project ios/Runner.xcodeproj \
  -target PathOfNurTV \
  -configuration Release \
  -sdk appletvos \
  -destination generic/platform=tvOS \
  build
```

For a signed archive, prefer Xcode Organizer unless you are also standardizing export options in-repo.
