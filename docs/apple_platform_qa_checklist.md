# Apple Platform QA Checklist

Short manual smoke checklist for iPhone, Apple Watch, widgets, complications, live activities, and Apple TV entry points.

## iPhone

- Launch app from cold start and confirm no onboarding/profile-routing regressions.
- Open a `pathofnur://` deep link for:
  - `/home`
  - `/worship`
  - `/quran`
  - `/journey/today`
- Confirm the app lands on the expected screen each time.
- Open Hadith search and source browse and confirm both open cleanly into the canonical reader.

## iPhone Widgets / Live Activities

- Add each supported home-screen widget and confirm it renders real data rather than a placeholder.
- Tap each widget and confirm it deep-links into the expected iPhone route.
- Start a prayer live activity and confirm:
  - lock-screen state is visible
  - Dynamic Island state is visible on supported devices
  - prayer-boundary state transitions are coherent
- Confirm widget and live-activity state update after prayer completion and dhikr changes.

## Notifications

- Trigger a prayer reminder and confirm tapping it opens the app to Worship.
- Trigger a dhikr reminder and confirm tapping it opens the app to Worship.
- Trigger a Qur'an reminder and confirm tapping it opens the app to Qur'an.
- Trigger a reflection reminder and confirm tapping it opens the app to Growth Reflection.
- Confirm Settings is reached from the Home/settings entry point rather than a bottom-tab Profile destination.
- Check recovered reminder behavior after reopening the app within the grace window.

## Apple Watch

- Install the watch app on a paired device and confirm first launch shows either cached state or a graceful sync-empty state.
- Confirm Home, Prayer, Dhikr, Progress, and Utility all load without crashes when the phone is unreachable.
- Mark a prayer complete and confirm:
  - Home updates immediately
  - Progress updates immediately
  - post-prayer adhkar prompt appears
- Complete or skip the post-prayer adhkar flow and confirm the state settles cleanly.
- Start dhikr, background the watch app briefly, reopen, and confirm state restoration is coherent.

## Complications / Widgets

- Add the next-prayer complication and confirm it shows:
  - next prayer name
  - time / due state
  - graceful stale/no-data fallback
- Add the daily progress complication and confirm it shows:
  - completed/total prayers
  - sensible stale/no-data fallback
- Tap each complication and confirm it opens the intended watch screen.
- Check near-prayer boundary behavior and day rollover behavior.
- Add the spiritual prompt complication and confirm it renders a synced prompt or a graceful fallback.

## Apple TV

- Launch the tvOS app on a real Apple TV.
- Confirm Home focus movement is predictable with the Siri Remote.
- Open the Qur'an area and confirm focus, scrolling, and back-navigation remain stable.
- Confirm no view traps focus or requires touch-only interaction.

## Sync / Offline

- Turn the phone unreachable, perform a prayer update on watch, then reconnect and confirm the queue flushes.
- Repeat for a dhikr session checkpoint and a completed dhikr session.
- Confirm the watch cache still powers Home, Prayer, Progress, and complications while offline.

## Release Readiness

- Build signed `Runner` from `Runner.xcworkspace`, not only `Runner.xcodeproj`.
- Verify signing and capability alignment for:
  - `Runner`
  - `PrayerLiveActivityExtension`
  - `PathOfNurHomeWidgets`
  - `PathOfNurWatch Watch App`
  - `PathOfNurWatch Watch App Extension`
  - `PathOfNurWatchComplications`
- Verify app group capability alignment for Runner, widgets, watch extension, and complications.
- Archive once and confirm extension bundle identifiers, icons, and capabilities look correct before TestFlight upload.
