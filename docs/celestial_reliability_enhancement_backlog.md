# Celestial Reliability Enhancement Backlog

Last updated: 2026-03-19

## Follow-up options

1. Add a small Celestial widget capability check so `HomeWidget` sync is skipped unless an actual `PathOfNurCelestialWidget` target exists on the current platform.
2. Add provider-level diagnostics around `celestialSnapshotProvider` so location, prayer-time calculation, and widget-sync failures are distinguishable in telemetry.
3. Add a focused test that verifies widget bridge failures do not force the Celestial home card or explorer into the unavailable state.
