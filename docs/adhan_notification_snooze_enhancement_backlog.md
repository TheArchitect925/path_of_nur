# Adhan Notification Snooze Enhancement Backlog

1. Decide whether the phone-side snooze durations should later become user-configurable in Settings, or remain fixed at 5 and 10 minutes while the existing watch snooze setting stays watch-specific.
2. Add targeted tests for prayer notification payload encoding/decoding and snooze-limit behavior in `local_notification_service.dart`.
3. Run real-device QA on iOS and Android for action-button behavior, especially foreground launches, dismiss semantics, and duplicate-notification safety.
4. Decide whether future reminder actions should add a direct `Mark Salah complete` variant on phone notifications to mirror later watch/platform work.
