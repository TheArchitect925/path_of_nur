import 'dart:async';

import 'package:flutter/material.dart';

enum AppTransientFeedbackTone { success, warning }

class AppTransientFeedback {
  AppTransientFeedback._();

  static OverlayEntry? _activeEntry;
  static Timer? _activeTimer;

  static void showSuccess(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle_rounded,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      icon: icon,
      duration: duration,
      backgroundColor: const Color(0xFF1F6F53),
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    IconData icon = Icons.warning_amber_rounded,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      icon: icon,
      duration: duration,
      backgroundColor: const Color(0xFF8A5A12),
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Duration duration,
    required Color backgroundColor,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _activeTimer?.cancel();
    _activeEntry?.remove();

    final theme = Theme.of(context);
    final directionality = Directionality.of(context);
    final mediaQuery = MediaQuery.of(context);

    final entry = OverlayEntry(
      builder: (overlayContext) {
        return MediaQuery(
          data: mediaQuery,
          child: Directionality(
            textDirection: directionality,
            child: InheritedTheme.captureAll(
              context,
              IgnorePointer(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Material(
                        color: Colors.transparent,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x24000000),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, color: Colors.white, size: 20),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      message,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
    _activeTimer = Timer(duration, () {
      if (_activeEntry == entry) {
        _activeEntry?.remove();
        _activeEntry = null;
      }
    });
  }
}
