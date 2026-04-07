# Explicit Engine Startup Migration Backlog

## Recommended Next Steps

- Replace the implicit-engine + storyboard root launch path with a single explicit `FlutterEngine` owned outside `SceneDelegate`, then have `SceneDelegate` attach that engine to a programmatic `FlutterViewController`.
- Keep `UIScene` enabled and remove only the storyboard-driven root-controller dependency from `Info.plist`.
- Preserve the existing navigation pending-route buffer and navigation method channel exactly, but bind them to the explicit engine messenger during startup.
- Keep Home/Learn scroll and overlay cleanup as a separate track; do not let those UI issues block the startup workaround for the confirmed `.ips` crash class.
