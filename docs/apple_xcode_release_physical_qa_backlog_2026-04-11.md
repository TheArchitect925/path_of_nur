# Apple Xcode Release Physical QA Backlog

Date: 2026-04-11

## Purpose

Follow-up enhancement and hardening items after the Apple release-prep audit and build validation pass.

## Recommended next steps

1. Run the full signed physical QA pass on:
   - iPhone
   - Apple Watch
   - Apple Watch complications
   - iPhone widgets
   - live activities
   - Apple TV
2. Resolve the `AppIcon` warning by assigning the remaining unassigned icon children in `ios/Runner/Assets.xcassets/AppIcon.appiconset`.
3. Verify production signing and provisioning for:
   - `Runner`
   - `PrayerLiveActivityExtension`
   - `PathOfNurHomeWidgets`
   - `PathOfNurWatch Watch App`
   - `PathOfNurWatch Watch App Extension`
   - `PathOfNurWatchComplications`
   - `PathOfNurTV`
4. Decide whether the shared app group name `group.com.pathofnur.watch` should remain canonical for widgets plus watch, or whether a rename is worth the migration cost before public release.
5. Triage high-volume Apple warning sources that may become future blockers with newer Xcode versions:
   - `home_widget`
   - `audio_service`
   - `flutter_local_notifications`
   - `AppAuth`
   - `sqlite3`
6. Add a small repo script or documented command set for repeatable Apple release validation so future Xcode checks always use the workspace for iPhone/widget builds.
