import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import 'motion_preferences.dart';

/// Hands out arrival slots to the cards of a page as they first build.
///
/// A page wraps its body in one scope. Each [SettleIn] below it claims the
/// next slot on its first build: the first [AppMotion.staggerLimit] cards
/// that build within [AppMotion.staggerWindow] of the page opening settle in
/// one after the other, [AppMotion.staggerStep] apart. Everything that builds
/// later — below the fold, lazily, after a tap — renders at rest.
class MotionStaggerScope extends StatefulWidget {
  const MotionStaggerScope({
    super.key,
    this.enabled = true,
    required this.child,
  });

  /// False renders every card at rest (the "no animation" transition style).
  final bool enabled;
  final Widget child;

  static MotionStaggerScopeState? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_MotionStaggerInherited>()?.state;

  @override
  State<MotionStaggerScope> createState() => MotionStaggerScopeState();
}

class MotionStaggerScopeState extends State<MotionStaggerScope> {
  final Stopwatch _clock = Stopwatch()..start();
  int _next = 0;

  /// A card that names its own slot still takes it out of the sequence, so
  /// the cards after it follow rather than collide with it.
  void reserve(int index) {
    if (index + 1 > _next) _next = index + 1;
  }

  /// The next arrival slot, or null once the stagger is spent.
  int? claim() {
    if (!widget.enabled) return null;
    if (_clock.elapsed > AppMotion.staggerWindow) return null;
    if (_next >= AppMotion.staggerLimit) return null;
    return _next++;
  }

  @override
  Widget build(BuildContext context) {
    return _MotionStaggerInherited(state: this, child: widget.child);
  }
}

class _MotionStaggerInherited extends InheritedWidget {
  const _MotionStaggerInherited({required this.state, required super.child});

  final MotionStaggerScopeState state;

  @override
  bool updateShouldNotify(_MotionStaggerInherited oldWidget) => false;
}

class _SettleAnimation extends InheritedWidget {
  const _SettleAnimation({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_SettleAnimation oldWidget) =>
      oldWidget.animation != animation;
}

/// One card settling into place: it rises [AppMotion.settleDistance] and
/// comes to rest. The content inside it, marked with [SettleFade], fades in
/// a beat later; the card's own glass never changes opacity.
///
/// A card inside another settling card rides its ancestor's arrival instead
/// of claiming a slot of its own, so a hero and the chips inside it move as
/// one object.
class SettleIn extends ConsumerStatefulWidget {
  const SettleIn({
    super.key,
    required this.child,
    this.index,
    this.fade = false,
  });

  final Widget child;

  /// Explicit slot (0 = first). Null claims the next slot from the scope.
  final int? index;

  /// Also fade [child] itself. Only for content that is not glass (a title
  /// block, opaque art).
  final bool fade;

  /// The arrival animation of the nearest settling ancestor, for
  /// [SettleFade]; null when nothing above is settling.
  static Animation<double>? animationOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SettleAnimation>()?.animation;

  @override
  ConsumerState<SettleIn> createState() => _SettleInState();
}

class _SettleInState extends ConsumerState<SettleIn>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _curve;
  bool _resolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolved) return;
    _resolved = true;
    // Nested cards ride their ancestor's arrival.
    if (SettleIn.animationOf(context) != null) return;
    final scope = MotionStaggerScope.maybeOf(context);
    final explicit = widget.index;
    if (explicit != null) scope?.reserve(explicit);
    if (ref.read(effectiveReduceMotionProvider)) return;
    final index = explicit ?? scope?.claim();
    if (index == null) return;
    final delay = AppMotion.staggerStep * index;
    final total = delay + AppMotion.settleDuration;
    final controller = AnimationController(vsync: this, duration: total);
    _controller = controller;
    _curve = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppMotion.settleCurve,
      ),
    );
    controller.forward().whenComplete(_finish);
  }

  /// At rest the card drops its transform and its fade layer, so a settled
  /// page costs nothing more than one that never moved.
  void _finish() {
    if (!mounted) return;
    final finished = _controller;
    setState(() {
      _controller = null;
      _curve = null;
    });
    // Disposed after the rebuild has let the builders unsubscribe.
    WidgetsBinding.instance.addPostFrameCallback((_) => finished?.dispose());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The tree keeps one shape whether the card is moving or at rest, so
    // settling never re-creates what is inside it (a held button, a scroll
    // position). At rest the transform is identity and the opacity is one,
    // which cost no layer.
    final animation = _curve ?? kAlwaysCompleteAnimation;
    return AnimatedBuilder(
      animation: animation,
      child: _SettleAnimation(animation: animation, child: widget.child),
      builder: (context, child) {
        final t = animation.value;
        Widget out = Transform.translate(
          offset: Offset(0, (1 - t) * AppMotion.settleDistance),
          child: child,
        );
        if (widget.fade) out = Opacity(opacity: t, child: out);
        return out;
      },
    );
  }
}

/// The part of a settling card that is allowed to fade: its content. Put it
/// inside the glass, never around it.
class SettleFade extends StatelessWidget {
  const SettleFade({super.key, required this.child});

  final Widget child;

  static final Animatable<double> _fadeCurve = CurveTween(
    curve: const Interval(0.15, 1, curve: Curves.easeOut),
  );

  @override
  Widget build(BuildContext context) {
    final animation = SettleIn.animationOf(context);
    if (animation == null) return child;
    // Kept in place once complete (opacity one costs no layer) so the
    // content is never rebuilt from scratch when its card comes to rest.
    return FadeTransition(opacity: animation.drive(_fadeCurve), child: child);
  }
}
