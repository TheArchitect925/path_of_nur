# iOS Crash Audit Confirmation Backlog

## Best Next Steps

- Capture one more symbolicated device or TestFlight crash after the bootstrap-migration fix to confirm the top three frames remain `VSyncClient`, `createTouchRateCorrectionVSyncClientIfNeeded`, and `FlutterViewController viewDidLoad`.
- Test the same binary by manual icon launch after Xcode install versus debugger-attached launch to verify whether the trigger still matches the known Flutter launch-shape reports.
- Track the upstream Flutter engine issue path first before doing Home/Learn UI surgery, because the current `.ips` shape points to startup before page ownership.
- Keep a separate secondary audit bucket for Home/Learn scroll-density and floating-overlay polish, but treat that as a different risk class unless a Dart exception or Flutter framework stack proves otherwise.
