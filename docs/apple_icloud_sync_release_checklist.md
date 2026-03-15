# Apple iCloud Sync Release Checklist

Path of Nūr currently uses `NSUbiquitousKeyValueStore` for Apple sync.

## Required project configuration

- iOS entitlements must include `com.apple.developer.ubiquity-kvstore-identifier`
- macOS release entitlements must include `com.apple.developer.ubiquity-kvstore-identifier`
- the signed app must have iCloud capability enabled in Apple signing
- the test device must be signed into iCloud

## Current bridge

- Method channel: `path_of_nur/icloud_sync`
- Methods:
  - `isAvailable`
  - `readValue`
  - `writeValue`

## Current transport behavior

- all writes remain local-first
- sync uploads the outbox later
- inbound changes still pass through the shared conflict resolver
- each profile scope is stored as a bounded retained change document

## Operational limits

- `NSUbiquitousKeyValueStore` is acceptable for the current bounded document strategy
- it is not a replacement for a large backend event log
- release validation should confirm:
  - capability present
  - write succeeds on a signed Apple build
  - a second Apple device can observe the same change

## Local debug note

- `flutter run -d macos` uses `DebugProfile.entitlements`
- that file intentionally does not include iCloud KVS so unsigned local debug builds can run
- signed macOS release validation must still use `Release.entitlements`

## Local development signing guidance

- the macOS `Runner` target is already configured for automatic signing in the Xcode project
- if Xcode still reports signing issues for local development:
  - open `macos/Runner.xcworkspace`
  - select the `Runner` target
  - open `Signing & Capabilities`
  - choose your Apple development team
  - keep automatic signing enabled for Debug
- local debug runs do not need the iCloud KVS entitlement
- signed Release/Profile builds still require valid Apple signing if you want to exercise iCloud sync on macOS
