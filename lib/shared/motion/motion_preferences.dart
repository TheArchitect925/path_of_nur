import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/application/profile_settings_provider.dart';

WidgetsBinding? _bindingOrNull() {
  try {
    return WidgetsBinding.instance;
  } catch (_) {
    // No binding yet: a bare ProviderContainer in a unit test.
    return null;
  }
}

/// The OS accessibility switch (iOS "Reduce Motion", Android "Remove
/// animations"), kept current through the binding's accessibility events.
final osReduceMotionProvider =
    StateNotifierProvider<OsReduceMotionNotifier, bool>(
      (ref) => OsReduceMotionNotifier(),
    );

class OsReduceMotionNotifier extends StateNotifier<bool>
    with WidgetsBindingObserver {
  OsReduceMotionNotifier() : super(_read()) {
    _bindingOrNull()?.addObserver(this);
  }

  static bool _read() =>
      _bindingOrNull()
          ?.platformDispatcher
          .accessibilityFeatures
          .disableAnimations ??
      false;

  @override
  void didChangeAccessibilityFeatures() {
    state = _read();
  }

  @override
  void dispose() {
    _bindingOrNull()?.removeObserver(this);
    super.dispose();
  }
}

/// True when motion should collapse to an instant state change: the app's
/// own Reduce Motion setting or the OS switch, whichever is on. Every motion
/// primitive reads this, never the profile setting on its own.
final effectiveReduceMotionProvider = Provider<bool>((ref) {
  final inApp = ref.watch(
    profileSettingsProvider.select((value) => value.reduceMotion),
  );
  return inApp || ref.watch(osReduceMotionProvider);
});

/// Whether the app is in the foreground, from the binding's lifecycle. Widget
/// tests never report a resumed lifecycle, so anything gated on this stays
/// off there.
final appForegroundProvider =
    StateNotifierProvider<AppForegroundNotifier, bool>(
      (ref) => AppForegroundNotifier(),
    );

class AppForegroundNotifier extends StateNotifier<bool>
    with WidgetsBindingObserver {
  AppForegroundNotifier() : super(_read()) {
    _bindingOrNull()?.addObserver(this);
  }

  static bool _read() =>
      _bindingOrNull()?.lifecycleState == AppLifecycleState.resumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    _bindingOrNull()?.removeObserver(this);
    super.dispose();
  }
}

/// Whether continuous motion — the ambient ticker, the loading sweep — may
/// run: only while the app is in the foreground, and never under Reduce
/// Motion. One-shot motion (arrivals, moments) does not read this; it reads
/// [effectiveReduceMotionProvider] alone.
final continuousMotionProvider = Provider<bool>((ref) {
  if (ref.watch(effectiveReduceMotionProvider)) return false;
  return ref.watch(appForegroundProvider);
});
