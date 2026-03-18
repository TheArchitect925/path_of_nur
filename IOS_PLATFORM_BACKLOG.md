# iOS Platform Backlog

Last updated: 2026-03-16

1. Add a lightweight CI check that fails when `arm64` is excluded for `iphonesimulator` in committed iOS config files.
2. Document the supported local iOS setup for Apple Silicon, including simulator/runtime expectations for Xcode 26+.
3. Review iOS plugin versions for simulator compatibility and remove any stale workarounds that were added for Intel-era builds.
4. Measure Creation Explorer camera inference latency after the native bridge replacement and tune frame throttling separately for iOS and Android.
