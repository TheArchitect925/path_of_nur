import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The shell's page. It never animates in — Home settles under the sky the
/// startup screen already painted, and the root tabs swap in place — but it
/// still slides back under a pushed page the way the platform transition
/// does, so drill-downs keep their depth.
class AppShellPage extends CustomTransitionPage<void> {
  const AppShellPage({required super.child})
    : super(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: _transitions,
      );

  static Widget _transitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final route = ModalRoute.of(context);
    final theme = Theme.of(context);
    final builder = theme.pageTransitionsTheme.builders[theme.platform];
    if (route is PageRoute && builder != null) {
      return builder.buildTransitions(
        route,
        context,
        kAlwaysCompleteAnimation,
        secondaryAnimation,
        child,
      );
    }
    return child;
  }
}
