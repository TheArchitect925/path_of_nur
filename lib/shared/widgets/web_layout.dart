import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// How the web build fills a browser window. Every screen is laid out for a
/// phone; on the web the app still fills the window, but past
/// [sidebarBreakpoint] the tab bar becomes a sidebar, and page content stops
/// widening at [contentMaxWidth], centred, so lines stay readable. Native
/// builds are untouched.
abstract final class WebLayout {
  static const double sidebarBreakpoint = 1000;
  static const double sidebarWidth = 232;
  static const double contentMaxWidth = 960;

  /// Setup and other single-column flows read best narrower still.
  static const double flowMaxWidth = 720;

  /// Lets widget tests exercise the web layout on the Dart VM.
  @visibleForTesting
  static bool debugForceWeb = false;

  static bool get isWeb => kIsWeb || debugForceWeb;

  static bool usesSidebar(BuildContext context) =>
      isWeb && MediaQuery.sizeOf(context).width >= sidebarBreakpoint;

  /// Side padding that centres content no wider than [maxWidth] within
  /// [availableWidth], and never less than [minimum]. Always [minimum] on
  /// native builds.
  static double sidePadding(
    double availableWidth, {
    double minimum = 16,
    double maxWidth = contentMaxWidth,
  }) {
    if (!isWeb) return minimum;
    final centred = (availableWidth - maxWidth) / 2;
    return centred > minimum ? centred : minimum;
  }
}
