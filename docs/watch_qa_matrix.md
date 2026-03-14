# Path of Nūr Watch QA Matrix

## Scope

This document covers:
- Apple Watch companion
- Wear OS companion
- Flutter phone-side watch contract
- sync, rewards, notifications, rollover, and glance surfaces

## Pass / fail rules

### Prayer completion
- `Pass`: one watch action updates the correct prayer once, queues or reconciles once, and results in at most one Ocean Drop.
- `Fail`: duplicate completion changes summary twice, rewards twice, or leaves phone/watch state inconsistent.

### Dhikr session
- `Pass`: one tap increments exactly once, milestone/completion occurs once, reset clears session but not today total, reward applies once.
- `Fail`: count regresses unexpectedly, duplicate completion rewards twice, or today total is corrupted.

### Day rollover
- `Pass`: today-only summaries reset cleanly, active dhikr session is preserved safely, next prayer is valid for the new day, stale prior-day reminders are not left active.
- `Fail`: yesterday leaks into today, next prayer is invalid, or prior-day pending actions become untraceable.

### Notifications
- `Pass`: one initial reminder per prayer event, at most one follow-up, completion cancels follow-up, action buttons work.
- `Fail`: repeated nags, duplicate reminders, stale reminders after completion, or broken action routing.

### Sync
- `Pass`: duplicate actions are acknowledged without reapplying, stale actions are deterministic, reconnect safely drains pending actions.
- `Fail`: duplicate application, reward duplication, or inconsistent summaries after reconnect.

## Automated test domains

### Shared domain logic
- `SnapshotFreshnessPolicy`
- `PrayerPhaseEvaluator`
- `DayRolloverEngine`
- `PrayerReminderPolicy`
- notification dedup state
- `DhikrMilestonePolicy`
- watch action dedup / conflict resolution
- reward safety rules
- watch settings snapshot defaults
- watch contract validation helpers

### Phone-side integration
- watch action envelope parsing and validation
- duplicate prayer completion suppression
- duplicate dhikr session completion suppression
- malformed action acknowledgment
- watch settings snapshot builder defaults

## Manual QA checklist

### Apple Watch
- open app after long inactivity and verify stale cache loads immediately
- mark one prayer complete and confirm Today, Prayers, Progress, and complication values converge
- complete a `33` dhikr set and verify one completion haptic and one reward
- leave app across midnight and confirm today totals reset while active dhikr session survives
- trigger one prayer reminder and verify `Mark prayed` cancels follow-up

### Wear OS
- verify round and square layouts keep dhikr tap target readable
- confirm tile opens correct destination for Today, Prayers, and Dhikr
- confirm repeated Compose recomposition does not double-count dhikr taps
- verify tile refresh after prayer completion and dhikr increment
- verify notification deep links and snooze behavior

### Phone integration
- ingest a valid Apple Watch prayer action and confirm phone prayer state updates
- ingest the same prayer action again and confirm duplicate suppression
- ingest a completed dhikr session twice and confirm reward remains single
- rebuild watch snapshot after manual prayer time change and verify next prayer/time reflect the phone schedule
- verify watch settings snapshot remains compact and watch-safe

### Offline / reconnect
- watch offline prayer completion -> later reconnect -> one applied completion
- watch offline long dhikr session -> later reconnect -> one merged result, no duplicate reward
- watch offline through midnight -> reconnect -> new day summary corrected, prior-day actions still traceable

### Battery / refresh sanity
- no minute-by-minute polling loops
- refreshes occur on launch, resume, completion, sync, rollover, or phase transition only
- tile / complication refresh only after meaningful visible changes

## Test matrix by domain

### Prayer flow
- pending -> complete on watch -> queue/reconcile -> snapshot count increments
- duplicate complete -> ignored duplicate
- prior-day logical date -> only applied if valid to that day record
- complete near rollover -> still attached to correct logical date

### Dhikr flow
- `preset_33`: 0 -> 33, one milestone/completion, one reward
- `preset_99`: milestones at 33/66/99, one completion reward
- `free`: no reward per tap, reward only per 100 count threshold
- session spanning midnight preserves session, resets today total

### Notification flow
- initial reminder only for enabled pending prayer
- follow-up only once and only if still pending
- completion cancels follow-up
- snooze does not stack duplicates

### Background refresh
- app launch
- app resume
- sync complete
- prayer completion
- dhikr update
- next-prayer transition
- day rollover

### Glance surfaces
- next prayer complication/tile matches snapshot
- prayer progress reflects current completion count
- dhikr glance value reflects latest safe visible count
- stale display corrected on next refresh opportunity

## Developer diagnostics categories

Use grep-friendly categories:
- `snapshot_generated`
- `settings_snapshot_generated`
- `snapshot_returned`
- `watch_action_received`
- `watch_action_failed_validation`
- `watch_action_duplicate`
- `prayer_action_applied`
- `prayer_action_duplicate`
- `prayer_action_stale`
- `dhikr_increment_applied`
- `dhikr_increment_duplicate`
- `dhikr_session_duplicate`
- `reward_applied`

## Minimum regression pass before release

1. Run Flutter watch-contract tests.
2. Manually verify one prayer completion end-to-end from each watch platform.
3. Manually verify one completed `33` dhikr session from each watch platform.
4. Verify one offline prayer action and one offline dhikr session reconcile correctly.
5. Verify one midnight rollover scenario on each watch platform.
