import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_navigation_gesture_config.dart';
import 'swipe_back_exclusion_zone.dart';

/// Expanded, route-safe back-swipe wrapper.
///
/// This does not replace the platform back model. It complements it by tracking
/// touch input from a wider left-side zone and committing a pop only after a
/// clear horizontal swipe. PopScope remains in place so modern back navigation,
/// including Android predictive back, is not regressed.
class AppSwipeBackWrapper extends StatefulWidget {
  const AppSwipeBackWrapper({
    super.key,
    required this.child,
    this.enabled = true,
    this.activationZoneFraction =
        AppNavigationGestureConfig.activationZoneFraction,
    this.minTriggerDistance = AppNavigationGestureConfig.minTriggerDistance,
    this.minVelocity = AppNavigationGestureConfig.minVelocity,
    this.respectCanPop = AppNavigationGestureConfig.respectCanPop,
    this.hapticOnTrigger = AppNavigationGestureConfig.hapticOnTrigger,
  });

  final Widget child;
  final bool enabled;
  final double activationZoneFraction;
  final double minTriggerDistance;
  final double minVelocity;
  final bool respectCanPop;
  final bool hapticOnTrigger;

  @override
  State<AppSwipeBackWrapper> createState() => _AppSwipeBackWrapperState();
}

class _AppSwipeBackWrapperState extends State<AppSwipeBackWrapper> {
  final SwipeBackExclusionRegistry _registry = SwipeBackExclusionRegistry();
  VelocityTracker? _velocityTracker;
  int? _pointer;
  Offset? _startGlobal;
  bool _tracking = false;
  bool _blockedByExclusion = false;
  bool _verticalRejected = false;
  bool _backCommitted = false;

  @override
  Widget build(BuildContext context) {
    return SwipeBackExclusionScope(
      registry: _registry,
      child: PopScope(
        canPop: true,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _reset,
          child: widget.child,
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!_isEnabledForContext()) {
      _reset();
      return;
    }
    if (event.kind != PointerDeviceKind.touch) {
      _reset();
      return;
    }
    final width = context.size?.width;
    if (width == null) {
      _reset();
      return;
    }
    if (event.localPosition.dx > width * widget.activationZoneFraction) {
      _reset();
      return;
    }
    _pointer = event.pointer;
    _startGlobal = event.position;
    _tracking = true;
    _blockedByExclusion = _registry.containsGlobalPosition(event.position);
    _verticalRejected = false;
    _backCommitted = false;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_isActivePointer(event.pointer) ||
        _blockedByExclusion ||
        _verticalRejected) {
      return;
    }
    _velocityTracker?.addPosition(event.timeStamp, event.position);
    final start = _startGlobal;
    if (start == null) return;
    final delta = event.position - start;
    final horizontal = delta.dx;
    final vertical = delta.dy.abs();

    if (vertical > 18 && vertical > horizontal.abs() * 1.1) {
      _verticalRejected = true;
      return;
    }

    if (horizontal < -16) {
      _tracking = false;
    }
  }

  Future<void> _handlePointerUp(PointerUpEvent event) async {
    if (!_isActivePointer(event.pointer)) {
      _reset();
      return;
    }
    _velocityTracker?.addPosition(event.timeStamp, event.position);

    if (_tracking && !_blockedByExclusion && !_verticalRejected) {
      final start = _startGlobal;
      final velocity = _velocityTracker?.getVelocity();
      final dx = start == null ? 0.0 : event.position.dx - start.dx;
      final dy = start == null ? 0.0 : (event.position.dy - start.dy).abs();
      final horizontalIntent = dx > 0 && dx > dy * 1.1;
      final fastEnough =
          (velocity?.pixelsPerSecond.dx ?? 0) >= widget.minVelocity;
      final farEnough = dx >= widget.minTriggerDistance;
      if (horizontalIntent && (farEnough || fastEnough)) {
        await _commitBack();
      }
    }

    _reset();
  }

  Future<void> _commitBack() async {
    if (_backCommitted) return;
    if (widget.respectCanPop && !Navigator.of(context).canPop()) return;
    _backCommitted = true;
    if (widget.hapticOnTrigger) {
      unawaited(HapticFeedback.lightImpact());
    }
    if (AppNavigationGestureConfig.debugLogging) {
      debugPrint('navigation: swipe-back committed');
    }
    await Navigator.of(context).maybePop();
  }

  bool _isEnabledForContext() {
    if (!widget.enabled) return false;
    if (!mounted) return false;
    if (ModalRoute.of(context)?.isCurrent != true) return false;
    return true;
  }

  bool _isActivePointer(int pointer) => _tracking && _pointer == pointer;

  void _reset([PointerEvent? _]) {
    _pointer = null;
    _startGlobal = null;
    _tracking = false;
    _blockedByExclusion = false;
    _verticalRejected = false;
    _backCommitted = false;
    _velocityTracker = null;
  }
}
