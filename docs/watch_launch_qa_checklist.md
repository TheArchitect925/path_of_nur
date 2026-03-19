# Path of Nūr Watch Launch QA Checklist

## Watch App

- Launch the watch app with a fresh paired install and confirm Home loads without broken empty states.
- Open Home, Prayer, Dhikr, Progress, and Utility and confirm navigation is stable.
- Mark one pending prayer as prayed and verify Home and Progress update immediately.
- Mark one prayer as prayed late and verify the prayer row status and summary update correctly.
- Mark a prayer complete and run the optional post-prayer adhkar flow through completion and skip paths.
- Complete one manual dhikr preset and verify reset and finish still behave correctly.
- Start Auto Dhikr, change pace, pause, resume, and end the session.
- Background the app during Auto Dhikr and confirm the session restores safely in a paused or completed state.

## Complications

- Add Next Prayer, Prayer Progress, and Auto Dhikr complications to a real watch face.
- Confirm Next Prayer matches the phone-authored snapshot and updates around a prayer boundary.
- Confirm Prayer Progress reflects the current completed count and resets after day rollover.
- Confirm Auto Dhikr shows last-used setup when idle and active-session summary only while running.
- Tap each complication and verify it opens the intended screen and context.

## Notifications

- Receive a prayer reminder and verify `Mark as prayed`, `Mark as prayed late`, `Snooze`, and `Open` appear.
- Tap `Mark as prayed` and confirm the prayer updates without opening the phone.
- Tap `Mark as prayed late` and confirm the timing value reconciles correctly.
- Tap `Snooze` twice for the same prayer and confirm reminders do not stack.
- Tap the notification body and confirm it opens the Prayer screen with the relevant prayer context.
- Trigger the same notification route while the Prayer screen is already open and confirm the intended prayer row is re-focused.

## Sync

- Disconnect the phone, update a prayer from the watch, then reconnect and confirm one clean reconciliation.
- Run a short Auto Dhikr session while the phone is unreachable and confirm completion syncs after reconnect.
- Leave the watch app idle until the snapshot is stale, reopen it, and confirm cached data appears first and then refreshes cleanly.
- Keep the watch open during a prayer boundary transition and confirm Home and complications converge to the updated next prayer.
- Change reminder/theme-related settings on the phone and confirm the watch settings snapshot updates after the next sync.

## Rollover

- Verify yesterday’s prayer progress does not persist after midnight.
- Verify Next Prayer no longer points to a prior-day prayer after rollover.
- Verify stale prior-day notifications or follow-ups are not still actionable for the new day.

## Final Smoke

- Add all three complications and verify their tap destinations.
- Reopen the watch app several times in one session and confirm no tab or focus state gets stuck.
- Confirm no user-facing watch screen shows placeholder or broken fallback copy.
