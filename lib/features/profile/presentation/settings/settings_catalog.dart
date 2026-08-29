import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';

/// Every settings surface the landing list can send you to.
///
/// One value per page — the landing groups, the search index, and the router
/// all read this enum so a setting can never live in two places at once.
enum SettingsCategory {
  profile,
  accountSync,
  appearance,
  prayerWorship,
  adhan,
  learning,
  notificationsReminders,
  widgetsWatch,
  languageDownloads,
  privacyData,
  about,
}

/// Route name registered for [category] in `core_support_routes.dart`.
String settingsCategoryRouteName(SettingsCategory category) {
  return switch (category) {
    SettingsCategory.profile => 'settingsProfile',
    SettingsCategory.accountSync => 'settingsAccountSync',
    SettingsCategory.appearance => 'settingsAppearance',
    SettingsCategory.prayerWorship => 'settingsPrayerWorship',
    SettingsCategory.adhan => 'settingsAdhan',
    SettingsCategory.learning => 'settingsLearning',
    SettingsCategory.notificationsReminders => 'settingsNotificationsReminders',
    SettingsCategory.widgetsWatch => 'settingsWidgetsWatch',
    SettingsCategory.languageDownloads => 'settingsLanguageDownloads',
    SettingsCategory.privacyData => 'settingsPrivacyData',
    SettingsCategory.about => 'settingsAbout',
  };
}

IconData settingsCategoryIcon(SettingsCategory category) {
  return switch (category) {
    SettingsCategory.profile => Icons.person_outline_rounded,
    SettingsCategory.accountSync => Icons.sync_outlined,
    SettingsCategory.appearance => Icons.palette_outlined,
    SettingsCategory.prayerWorship => IslamicIcons.prayer,
    SettingsCategory.adhan => Icons.volume_up_outlined,
    SettingsCategory.learning => Icons.school_outlined,
    SettingsCategory.notificationsReminders =>
      Icons.notifications_active_outlined,
    SettingsCategory.widgetsWatch => Icons.watch_later_outlined,
    SettingsCategory.languageDownloads => Icons.language_outlined,
    SettingsCategory.privacyData => Icons.shield_outlined,
    SettingsCategory.about => Icons.info_outline_rounded,
  };
}

String settingsCategoryTitle(SettingsCategory category, AppLocalizations l10n) {
  return switch (category) {
    SettingsCategory.profile => l10n.settingsProfilePersonalizationTitle,
    SettingsCategory.accountSync => l10n.settingsAccountsSyncTitle,
    SettingsCategory.appearance => l10n.profileAppearanceTitle,
    SettingsCategory.prayerWorship => l10n.profilePrayerSettingsTitle,
    SettingsCategory.adhan => l10n.settingsAdhanTitle,
    SettingsCategory.learning => l10n.learnHubTitle,
    SettingsCategory.notificationsReminders => l10n.profileNotificationsTitle,
    SettingsCategory.widgetsWatch => l10n.settingsCategoryWidgetsWatchTitle,
    SettingsCategory.languageDownloads => l10n.languageOptionsTitle,
    SettingsCategory.privacyData => l10n.profileTrackingPrivacyTitle,
    SettingsCategory.about => l10n.profileAboutTitle,
  };
}

String settingsCategorySubtitle(
  SettingsCategory category,
  AppLocalizations l10n,
) {
  return switch (category) {
    SettingsCategory.profile => l10n.settingsCategoryProfileSubtitle,
    SettingsCategory.accountSync => l10n.settingsCategoryAccountSyncSubtitle,
    SettingsCategory.appearance => l10n.settingsCategoryAppearanceSubtitle,
    SettingsCategory.prayerWorship =>
      l10n.settingsCategoryPrayerWorshipSubtitle,
    SettingsCategory.adhan => l10n.settingsCategoryAdhanSubtitle,
    SettingsCategory.learning => l10n.settingsCategoryLearningSubtitle,
    SettingsCategory.notificationsReminders =>
      l10n.settingsCategoryNotificationsSubtitle,
    SettingsCategory.widgetsWatch => l10n.settingsCategoryWidgetsWatchSubtitle,
    SettingsCategory.languageDownloads =>
      l10n.settingsCategoryLanguageDownloadsSubtitle,
    SettingsCategory.privacyData => l10n.settingsCategoryPrivacyDataSubtitle,
    SettingsCategory.about => l10n.settingsCategoryAboutSubtitle,
  };
}

/// One row on the Settings landing list.
class SettingsDestination {
  const SettingsDestination({
    required this.routeName,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.category,
  });

  final String routeName;
  final IconData icon;
  final String title;
  final String subtitle;

  /// Null for destinations that are their own page rather than a
  /// [SettingsCategory] rendered by `SettingsPage` (currently Help & Guide).
  final SettingsCategory? category;
}

/// A titled run of destinations, rendered as one `HubListGroup`.
class SettingsGroup {
  const SettingsGroup({required this.title, required this.destinations});

  final String title;
  final List<SettingsDestination> destinations;
}

SettingsDestination _destinationFor(
  SettingsCategory category,
  AppLocalizations l10n,
) {
  return SettingsDestination(
    category: category,
    routeName: settingsCategoryRouteName(category),
    icon: settingsCategoryIcon(category),
    title: settingsCategoryTitle(category, l10n),
    subtitle: settingsCategorySubtitle(category, l10n),
  );
}

/// The Settings landing, as four short groups instead of one ten-tile grid.
List<SettingsGroup> settingsGroups(AppLocalizations l10n) {
  return [
    SettingsGroup(
      title: l10n.settingsGroupYouTitle,
      destinations: [
        _destinationFor(SettingsCategory.profile, l10n),
        _destinationFor(SettingsCategory.accountSync, l10n),
        _destinationFor(SettingsCategory.learning, l10n),
      ],
    ),
    SettingsGroup(
      title: l10n.settingsGroupWorshipTitle,
      destinations: [
        _destinationFor(SettingsCategory.prayerWorship, l10n),
        _destinationFor(SettingsCategory.adhan, l10n),
        _destinationFor(SettingsCategory.notificationsReminders, l10n),
        _destinationFor(SettingsCategory.widgetsWatch, l10n),
      ],
    ),
    SettingsGroup(
      title: l10n.settingsGroupAppTitle,
      destinations: [
        _destinationFor(SettingsCategory.appearance, l10n),
        _destinationFor(SettingsCategory.languageDownloads, l10n),
        _destinationFor(SettingsCategory.privacyData, l10n),
      ],
    ),
    SettingsGroup(
      title: l10n.settingsGroupSupportTitle,
      destinations: [
        SettingsDestination(
          routeName: 'settingsHelpGuide',
          icon: Icons.help_center_outlined,
          title: l10n.settingsHelpGuideTitle,
          subtitle: l10n.settingsCategoryHelpGuideSubtitle,
        ),
        _destinationFor(SettingsCategory.about, l10n),
      ],
    ),
  ];
}

/// One individual control, indexed so it can be found by name.
class SettingsSearchEntry {
  const SettingsSearchEntry({
    required this.title,
    required this.category,
    this.keywords = const <String>[],
  });

  /// The control's own label, as it reads on its page.
  final String title;
  final SettingsCategory category;

  /// Extra English search terms for controls whose label is not what people
  /// type ("dark" for the theme picker, "vibrate" for reminders). Localized
  /// titles still match on their own, so this only ever widens the net.
  final List<String> keywords;
}

bool _matches(SettingsSearchEntry entry, String query, AppLocalizations l10n) {
  if (entry.title.toLowerCase().contains(query)) return true;
  if (settingsCategoryTitle(
    entry.category,
    l10n,
  ).toLowerCase().contains(query)) {
    return true;
  }
  for (final keyword in entry.keywords) {
    if (keyword.contains(query)) return true;
  }
  return false;
}

/// Everything a user can change, flattened. Feeds the settings search page.
List<SettingsSearchEntry> settingsSearchIndex(AppLocalizations l10n) {
  return [
    // Profile & personalization
    SettingsSearchEntry(
      title: l10n.profileDisplayNameLabel,
      category: SettingsCategory.profile,
      keywords: const ['name', 'display name', 'rename'],
    ),
    SettingsSearchEntry(
      title: l10n.profileAddressMeAs,
      category: SettingsCategory.profile,
      keywords: const ['brother', 'sister', 'address', 'gender'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsCareModesTitle,
      category: SettingsCategory.profile,
      keywords: const ['care', 'modes', 'life moments'],
    ),
    SettingsSearchEntry(
      title: l10n.profileRamadanModeTitle,
      category: SettingsCategory.profile,
      keywords: const ['ramadan', 'ramadhan', 'fasting mode'],
    ),
    SettingsSearchEntry(
      title: l10n.profileLossModeTitle,
      category: SettingsCategory.profile,
      keywords: const ['loss', 'grief', 'bereavement'],
    ),
    SettingsSearchEntry(
      title: l10n.profileGentleModeTitle,
      category: SettingsCategory.profile,
      keywords: const ['gentle', 'fewer notifications', 'quiet'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsUnwellModeTitle,
      category: SettingsCategory.profile,
      keywords: const ['unwell', 'sick', 'illness'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsCycleDaysTitle,
      category: SettingsCategory.profile,
      keywords: const ['cycle', 'period', 'menses', 'haid'],
    ),
    SettingsSearchEntry(
      title: l10n.familyLearningSettingsTitle,
      category: SettingsCategory.profile,
      keywords: const ['family', 'children', 'kids management'],
    ),

    // Accounts, profiles & sync
    SettingsSearchEntry(
      title: l10n.settingsCurrentProfileTitle,
      category: SettingsCategory.accountSync,
      keywords: const ['profile', 'account', 'switch profile'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsSyncStatusTitle,
      category: SettingsCategory.accountSync,
      keywords: const ['sync', 'icloud', 'cloud'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsBackupRestoreTitle,
      category: SettingsCategory.accountSync,
      keywords: const ['backup', 'restore', 'export', 'import'],
    ),
    SettingsSearchEntry(
      title: l10n.kidsUiThemeSettingTitle,
      category: SettingsCategory.accountSync,
      keywords: const ['kids', 'child', 'children theme'],
    ),

    // Salah times
    SettingsSearchEntry(
      title: l10n.profileLocationLabel,
      category: SettingsCategory.prayerWorship,
      keywords: const ['location', 'city', 'gps', 'coordinates'],
    ),
    SettingsSearchEntry(
      title: l10n.profileCalculationMethodLabel,
      category: SettingsCategory.prayerWorship,
      keywords: const ['calculation', 'method', 'isna', 'umm al-qura'],
    ),
    SettingsSearchEntry(
      title: l10n.profileMadhabLabel,
      category: SettingsCategory.prayerWorship,
      keywords: const ['madhab', 'hanafi', 'shafii', 'asr'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsPrayerCalendarDisplayTitle,
      category: SettingsCategory.prayerWorship,
      keywords: const ['calendar', 'hijri', 'gregorian', 'islamic date'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsPrayerTimeAdjustmentsTitle,
      category: SettingsCategory.prayerWorship,
      keywords: const ['adjust', 'offset', 'minutes', 'manual times'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsJumuahSettingsTitle,
      category: SettingsCategory.prayerWorship,
      keywords: const ['jumuah', 'friday', 'khutbah', 'mosque'],
    ),

    // Adhan
    SettingsSearchEntry(
      title: l10n.settingsAdhanChoiceTitle,
      category: SettingsCategory.adhan,
      keywords: const ['adhan', 'azan', 'call to prayer', 'sound', 'muadhin'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsAdhanPreviewVolume,
      category: SettingsCategory.adhan,
      keywords: const ['volume', 'loud', 'quiet', 'sound level'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsUseAppVolumeTitle,
      category: SettingsCategory.adhan,
      keywords: const ['app volume', 'system volume'],
    ),

    // Notifications & reminders
    SettingsSearchEntry(
      title: l10n.profilePrayerReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['prayer reminder', 'salah reminder', 'alert'],
    ),
    SettingsSearchEntry(
      title: l10n.profileDhikrReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['dhikr', 'zikr', 'remembrance reminder'],
    ),
    SettingsSearchEntry(
      title: l10n.profileQuranReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['quran reminder', 'reading reminder'],
    ),
    SettingsSearchEntry(
      title: l10n.profileReflectionReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['reflection', 'journal reminder'],
    ),
    SettingsSearchEntry(
      title: l10n.profileFastingReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['fasting', 'sawm', 'suhoor', 'iftar'],
    ),
    SettingsSearchEntry(
      title: l10n.profileOnThisDayReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['on this day', 'history'],
    ),
    SettingsSearchEntry(
      title: l10n.profileMoonriseReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['moon', 'moonrise', 'celestial'],
    ),
    SettingsSearchEntry(
      title: l10n.profileMoonsetReminders,
      category: SettingsCategory.notificationsReminders,
      keywords: const ['moon', 'moonset', 'celestial'],
    ),

    // Widgets, Live Activities & Watch
    SettingsSearchEntry(
      title: l10n.settingsWidgetsEnabledTitle,
      category: SettingsCategory.widgetsWatch,
      keywords: const ['widget', 'home screen'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsStableDynamicIslandTitle,
      category: SettingsCategory.widgetsWatch,
      keywords: const ['dynamic island', 'live activity'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsStableLockScreenWidgetTitle,
      category: SettingsCategory.widgetsWatch,
      keywords: const ['lock screen', 'lockscreen', 'watch'],
    ),

    // Appearance
    SettingsSearchEntry(
      title: l10n.profileThemeModeLabel,
      category: SettingsCategory.appearance,
      keywords: const [
        'theme',
        'dark',
        'dark mode',
        'light',
        'night',
        'midnight',
        'colour',
        'color',
      ],
    ),
    SettingsSearchEntry(
      title: l10n.settingsFollowSystemThemeTitle,
      category: SettingsCategory.appearance,
      keywords: const ['system theme', 'auto dark'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsLivingSkyTitle,
      category: SettingsCategory.appearance,
      keywords: const ['sky', 'atmosphere', 'background'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDressUpFridaysTitle,
      category: SettingsCategory.appearance,
      keywords: const ['friday', 'jumuah theme'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDressUpRamadanTitle,
      category: SettingsCategory.appearance,
      keywords: const ['ramadan theme', 'lantern'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDressUpQadrTitle,
      category: SettingsCategory.appearance,
      keywords: const ['qadr', 'laylat al-qadr'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDressUpEidTitle,
      category: SettingsCategory.appearance,
      keywords: const ['eid', 'festival'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDisableColoredGlassTitle,
      category: SettingsCategory.appearance,
      keywords: const ['glass', 'transparency', 'blur'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsDisableBackgroundTitle,
      category: SettingsCategory.appearance,
      keywords: const ['background', 'wallpaper'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsPageTransitionsTitle,
      category: SettingsCategory.appearance,
      keywords: const ['transition', 'animation'],
    ),
    SettingsSearchEntry(
      title: l10n.profileReduceMotion,
      category: SettingsCategory.appearance,
      keywords: const ['motion', 'animation', 'accessibility'],
    ),
    SettingsSearchEntry(
      title: l10n.profileHighContrastText,
      category: SettingsCategory.appearance,
      keywords: const ['contrast', 'readable', 'accessibility', 'text size'],
    ),

    // Learning
    SettingsSearchEntry(
      title: l10n.settingsLearningLevelTitle,
      category: SettingsCategory.learning,
      keywords: const ['level', 'path', 'beginner', 'advanced'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsRunOnboardingTitle,
      category: SettingsCategory.learning,
      keywords: const ['onboarding', 'setup', 'tour', 'walkthrough'],
    ),
    SettingsSearchEntry(
      title: l10n.kidsUiAgeRangeTitle,
      category: SettingsCategory.learning,
      keywords: const ['age', 'age range', 'child'],
    ),

    // Language
    SettingsSearchEntry(
      title: l10n.languageOptionsTitle,
      category: SettingsCategory.languageDownloads,
      keywords: const ['language', 'locale', 'english', 'german', 'translate'],
    ),

    // Privacy & data
    SettingsSearchEntry(
      title: l10n.profileLocationWhileUsingApp,
      category: SettingsCategory.privacyData,
      keywords: const ['location permission', 'gps permission'],
    ),
    SettingsSearchEntry(
      title: l10n.profilePrivateTrackingModeTitle,
      category: SettingsCategory.privacyData,
      keywords: const ['private', 'tracking', 'hide'],
    ),
    SettingsSearchEntry(
      title: l10n.profileMinimalTrackingModeTitle,
      category: SettingsCategory.privacyData,
      keywords: const ['minimal', 'tracking'],
    ),
    SettingsSearchEntry(
      title: l10n.profileHideGrowthVisualsTitle,
      category: SettingsCategory.privacyData,
      keywords: const ['growth', 'streak', 'stats', 'hide'],
    ),
    SettingsSearchEntry(
      title: l10n.profileReflectionOnlyModeTitle,
      category: SettingsCategory.privacyData,
      keywords: const ['reflection only', 'no tracking'],
    ),

    // About
    SettingsSearchEntry(
      title: l10n.settingsWhatsNewTitle,
      category: SettingsCategory.about,
      keywords: const ['whats new', 'changelog', 'release notes'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsComingSoonTitle,
      category: SettingsCategory.about,
      keywords: const ['coming soon', 'roadmap'],
    ),
    SettingsSearchEntry(
      title: l10n.legalPrivacyTitle,
      category: SettingsCategory.about,
      keywords: const ['privacy policy', 'legal', 'data'],
    ),
    SettingsSearchEntry(
      title: l10n.legalTermsTitle,
      category: SettingsCategory.about,
      keywords: const ['terms', 'conditions', 'legal'],
    ),
    SettingsSearchEntry(
      title: l10n.legalSupportTitle,
      category: SettingsCategory.about,
      keywords: const ['support', 'help', 'contact', 'feedback', 'bug'],
    ),
    SettingsSearchEntry(
      title: l10n.settingsAttributionsLicensesTitle,
      category: SettingsCategory.about,
      keywords: const ['licenses', 'attributions', 'credits'],
    ),
  ];
}

/// Case-insensitive substring search over [settingsSearchIndex].
List<SettingsSearchEntry> searchSettings(String query, AppLocalizations l10n) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return const <SettingsSearchEntry>[];
  return settingsSearchIndex(
    l10n,
  ).where((entry) => _matches(entry, trimmed, l10n)).toList(growable: false);
}
