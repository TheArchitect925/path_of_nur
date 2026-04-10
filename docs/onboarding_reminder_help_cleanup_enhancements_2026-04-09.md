# Onboarding Reminder Help Cleanup Enhancements

- Remove the legacy `forceAdhan` enum case and normalization path entirely once old saved onboarding states no longer need backward compatibility.
- Replace any remaining reminder-help entries with a small inline explainer under the prayer reminder section instead of a separate help affordance.
- Add a small onboarding regression test to confirm the visible reminder choices and help copy always stay in sync.
