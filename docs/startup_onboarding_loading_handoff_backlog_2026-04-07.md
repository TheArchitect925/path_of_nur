# Startup Onboarding Loading Handoff Follow-up

Date: 2026-04-07

1. Consider adding a dedicated widget test for the full onboarding-finish to startup to home flow if we want end-to-end coverage beyond the controller-level regression test.
2. Review whether the router provider should be stabilized to avoid recreating the whole GoRouter on onboarding state flips.
3. Run one real-device onboarding completion pass to confirm the spinner no longer gets stuck outside the test harness.
