import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Compile-time switch flipped via
/// `--dart-define=PON_GOOGLE_AUTH_CONFIGURED=true` once the native Google
/// OAuth clients exist (iOS: `GIDClientID` plus the `REVERSED_CLIENT_ID` URL
/// scheme in Info.plist; Android: an OAuth client registered for the signing
/// SHA). Until then the Google button is hidden because sign-in can only
/// fail at runtime. See docs/auth_provider_setup.md.
const bool kGoogleAuthConfigured = bool.fromEnvironment(
  'PON_GOOGLE_AUTH_CONFIGURED',
);

class AuthProviderAvailability {
  const AuthProviderAvailability({
    required this.appleSignInAvailable,
    required this.googleSignInAvailable,
  });

  final bool appleSignInAvailable;
  final bool googleSignInAvailable;
}

final authProviderAvailabilityProvider = Provider<AuthProviderAvailability>((
  ref,
) {
  // Sign in with Apple needs an Apple platform and the applesignin
  // entitlement (present for Runner); the App ID capability must also be
  // enabled in the Apple Developer portal before release.
  final isApplePlatform = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
  return AuthProviderAvailability(
    appleSignInAvailable: isApplePlatform,
    googleSignInAvailable: kGoogleAuthConfigured,
  );
});
