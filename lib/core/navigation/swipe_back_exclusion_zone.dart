import 'package:flutter/material.dart';

class SwipeBackExclusionRegistry {
  final Set<Element> _elements = <Element>{};

  void register(BuildContext context) {
    final element = context as Element;
    _elements.add(element);
  }

  void unregister(BuildContext context) {
    _elements.remove(context as Element);
  }

  bool containsGlobalPosition(Offset globalPosition) {
    final stale = <Element>[];
    for (final element in _elements) {
      final renderObject = element.renderObject;
      if (renderObject is! RenderBox || !renderObject.attached) {
        stale.add(element);
        continue;
      }
      final rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
      if (rect.contains(globalPosition)) {
        return true;
      }
    }
    _elements.removeAll(stale);
    return false;
  }
}

class _SwipeBackExclusionScope extends InheritedWidget {
  const _SwipeBackExclusionScope({
    required this.registry,
    required super.child,
  });

  final SwipeBackExclusionRegistry registry;

  static SwipeBackExclusionRegistry? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SwipeBackExclusionScope>()
        ?.registry;
  }

  @override
  bool updateShouldNotify(_SwipeBackExclusionScope oldWidget) {
    return !identical(registry, oldWidget.registry);
  }
}

class SwipeBackExclusionScope extends StatelessWidget {
  const SwipeBackExclusionScope({
    super.key,
    required this.registry,
    required this.child,
  });

  final SwipeBackExclusionRegistry registry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SwipeBackExclusionScope(registry: registry, child: child);
  }
}

/// Marks a subtree as off-limits for the expanded back-swipe gesture.
///
/// Use this around horizontal controls like sliders, scrubbing bars, carousels,
/// galleries, or any widget where right-swiping should stay local to the child.
class SwipeBackExclusionZone extends StatefulWidget {
  const SwipeBackExclusionZone({super.key, required this.child});

  final Widget child;

  @override
  State<SwipeBackExclusionZone> createState() => _SwipeBackExclusionZoneState();
}

class _SwipeBackExclusionZoneState extends State<SwipeBackExclusionZone> {
  SwipeBackExclusionRegistry? _registry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextRegistry = _SwipeBackExclusionScope.maybeOf(context);
    if (!identical(_registry, nextRegistry)) {
      _registry?.unregister(context);
      _registry = nextRegistry;
      _registry?.register(context);
    }
  }

  @override
  void dispose() {
    _registry?.unregister(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
