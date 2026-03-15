import 'package:flutter/foundation.dart';

/// Central defaults for the app-wide expanded back-swipe gesture.
///
/// Path of Nūr uses many content-heavy drill-down screens on large phones.
/// The default iOS edge-only gesture is too narrow for comfortable one-handed
/// use, so we expand the activation zone conservatively while keeping route
/// exclusions for screens with primary horizontal interaction.
@immutable
class AppNavigationGestureConfig {
  const AppNavigationGestureConfig._();

  static const double activationZoneFraction = 0.45;
  static const double minTriggerDistance = 110;
  static const double minVelocity = 700;
  static const bool hapticOnTrigger = true;
  static const bool respectCanPop = true;
  static const bool debugLogging = false;

  static const List<String> excludedRoutePrefixes = <String>[
    '/learn/quran/surah/',
    '/learn/quran/reader',
    '/learn/quran/app',
  ];

  static bool isEnabledForLocation(String? location) {
    if (location == null || location.isEmpty) return true;
    for (final prefix in excludedRoutePrefixes) {
      if (location.startsWith(prefix)) return false;
    }
    return true;
  }
}
