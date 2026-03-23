import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

import 'app_router.dart';
import 'nav_tabs.dart';

const _qaOpenToday = 'growth.open_today';
const _qaOpenReflection = 'growth.open_reflection';
const _qaReadQuran = 'growth.read_quran';
const _qaMorningAdhkar = 'growth.morning_adhkar';
const _qaEveningAdhkar = 'growth.evening_adhkar';
const _qaLogGratitude = 'growth.log_gratitude';
const _qaDailyLearning = 'learn.prophets.daily_learning';

final appQuickActionsBootstrapProvider = Provider<void>((ref) {
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    return;
  }

  final quickActions = const QuickActions();
  final router = ref.read(appRouterProvider);

  quickActions.initialize((shortcutType) {
    final route = switch (shortcutType) {
      _qaOpenToday => '/journey/today',
      _qaOpenReflection => '/journey/reflection',
      _qaReadQuran => NavTab.quran.path,
      _qaMorningAdhkar => '/journey/habit/h_morning_adhkar',
      _qaEveningAdhkar => '/journey/habit/h_evening_adhkar',
      _qaLogGratitude => '/journey/reflection',
      _qaDailyLearning => '/learn/prophets',
      _ => null,
    };
    if (route != null) {
      router.go(route);
    }
  });

  quickActions.setShortcutItems(const <ShortcutItem>[
    ShortcutItem(type: _qaOpenToday, localizedTitle: 'Open Today'),
    ShortcutItem(type: _qaOpenReflection, localizedTitle: 'Open Reflection'),
    ShortcutItem(type: _qaReadQuran, localizedTitle: 'Read Qur’an'),
    ShortcutItem(type: _qaMorningAdhkar, localizedTitle: 'Morning Adhkar'),
    ShortcutItem(type: _qaEveningAdhkar, localizedTitle: 'Evening Adhkar'),
    ShortcutItem(type: _qaLogGratitude, localizedTitle: 'Log Gratitude'),
    ShortcutItem(type: _qaDailyLearning, localizedTitle: 'Daily Learning'),
  ]);
});
