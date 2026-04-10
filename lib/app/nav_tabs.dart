import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/theme/islamic_icons.dart';

enum NavTab { worship, learn, home, journey, quran }

extension NavTabExt on NavTab {
  String get path {
    switch (this) {
      case NavTab.worship:
        return '/worship';
      case NavTab.learn:
        return '/learn';
      case NavTab.home:
        return '/home';
      case NavTab.journey:
        return '/journey';
      case NavTab.quran:
        return '/quran';
    }
  }

  IconData get icon {
    switch (this) {
      case NavTab.worship:
        return IslamicIcons.prayer;
      case NavTab.learn:
        return Icons.school_rounded;
      case NavTab.home:
        return IslamicIcons.mosque;
      case NavTab.journey:
        return Icons.auto_graph_rounded;
      case NavTab.quran:
        return IslamicIcons.quran;
    }
  }
}

NavTab? adjacentNavTab(NavTab tab, {required bool forward}) {
  final index = NavTab.values.indexOf(tab);
  if (index < 0) return null;
  final nextIndex = forward ? index + 1 : index - 1;
  if (nextIndex < 0 || nextIndex >= NavTab.values.length) {
    return null;
  }
  return NavTab.values[nextIndex];
}

void goToTab(BuildContext context, NavTab tab) {
  final current = GoRouterState.of(context).uri.toString();
  if (current != tab.path) {
    context.go(tab.path);
  }
}
