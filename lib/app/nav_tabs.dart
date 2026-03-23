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

void goToTab(BuildContext context, NavTab tab) {
  final current = GoRouterState.of(context).uri.toString();
  if (current != tab.path) {
    context.go(tab.path);
  }
}
