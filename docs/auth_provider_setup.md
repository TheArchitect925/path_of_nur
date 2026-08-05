# Sign-in provider setup

The sign-in buttons on the Accounts & Sync page are gated by
`lib/features/accounts_sync/application/auth_provider_availability.dart` so
users never see a button that can only fail. Complete the steps below, then
flip the corresponding switch.

## Sign in with Apple (iOS/macOS)

Code side (already done):
- `com.apple.developer.applesignin` entitlement is present in
  `ios/Runner/Runner.entitlements` and `ios/Runner/RunnerDebug.entitlements`.

Remaining manual steps:
1. In the Apple Developer portal, enable the **Sign in with Apple**
   capability on the `com.pathofnur` App ID (and regenerate provisioning
   profiles if not using automatic signing).
2. Nothing else — the button already shows on Apple platforms.

## Google Sign-In

Remaining manual steps:
1. Create OAuth client IDs in Google Cloud console
   (<https://console.cloud.google.com/apis/credentials>):
   - **iOS** client for the bundle id `com.pathofnur`. Add to
     `ios/Runner/Info.plist`:
     - `GIDClientID` → the iOS client ID
     - a `CFBundleURLTypes` entry whose scheme is the matching
       `REVERSED_CLIENT_ID`
   - **Android** client registered against the release keystore SHA-1 (and
     the debug SHA-1 for local testing). No file changes needed — Google
     resolves it by package name + SHA.
2. Because the app requests the `drive.appdata` scope for remote backups,
   configure the OAuth consent screen and add that scope; unverified apps
   are limited to test users until Google review passes.
3. Build with `--dart-define=PON_GOOGLE_AUTH_CONFIGURED=true` (add it to CI
   release lanes / launch configs). This reveals the Google button.
