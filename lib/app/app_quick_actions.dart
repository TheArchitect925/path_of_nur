import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

import '../core/localization/locale_provider.dart';
import '../features/arabic/application/arabic_learning_quick_resume_provider.dart';
import '../features/arabic/domain/arabic_learning_continuity_models.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';
import 'nav_tabs.dart';

const _qaOpenToday = 'growth.open_today';
const _qaOpenReflection = 'growth.open_reflection';
const _qaReadQuran = 'growth.read_quran';
const _qaMorningAdhkar = 'growth.morning_adhkar';
const _qaEveningAdhkar = 'growth.evening_adhkar';
const _qaLogGratitude = 'growth.log_gratitude';
const _qaDailyLearning = 'learn.prophets.daily_learning';
const _qaAdultArabicContinue = 'learn.arabic.adult_continue';
const _qaAdultArabicReview = 'learn.arabic.adult_review';
const _qaKidsArabicContinue = 'learn.arabic.kids_continue';

final appQuickActionsBootstrapProvider = Provider<void>((ref) {
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    return;
  }

  final quickActions = const QuickActions();
  final router = ref.read(appRouterProvider);
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final adultQuickResume = ref.watch(
    arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.adult),
  );
  final kidsQuickResume = ref.watch(
    arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.kids),
  );

  quickActions.initialize((shortcutType) {
    final route = switch (shortcutType) {
      _qaAdultArabicContinue => adultQuickResume.primaryLocation,
      _qaAdultArabicReview =>
        adultQuickResume.reviewLocation ?? adultQuickResume.primaryLocation,
      _qaKidsArabicContinue => kidsQuickResume.primaryLocation,
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

  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
      type: _qaAdultArabicContinue,
      localizedTitle: l10n.arabicQuickActionAdultContinue,
    ),
    ShortcutItem(
      type: _qaAdultArabicReview,
      localizedTitle: l10n.arabicQuickActionAdultReview,
    ),
    ShortcutItem(
      type: _qaKidsArabicContinue,
      localizedTitle: l10n.arabicQuickActionKidsContinue,
    ),
    ShortcutItem(
      type: _qaOpenToday,
      localizedTitle: l10n.appQuickActionOpenToday,
    ),
    ShortcutItem(
      type: _qaReadQuran,
      localizedTitle: l10n.appQuickActionReadQuran,
    ),
    ShortcutItem(
      type: _qaDailyLearning,
      localizedTitle: l10n.appQuickActionDailyLearning,
    ),
  ]);
});
