import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

enum AppPageDescriptionKey {
  learnHub,
  quranHub,
  quranStudyHub,
  worshipHub,
  growthToday,
  growthPaths,
  growthJourney,
  growthReflection,
  settingsLanding,
  assistant,
  journalTimeline,
  journalCreate,
  creationExplorer,
  creationChallenges,
  celestialExplorer,
  khusuFocus,
}

enum SettingsPageDescriptionKey {
  accountSync,
  appearance,
  prayerWorship,
  learning,
  notifications,
  widgetsWatch,
  language,
  privacy,
  kidsFamily,
  about,
}

String localizedAppPageDescription(
  BuildContext context,
  AppPageDescriptionKey key, {
  required bool kidsMode,
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    AppPageDescriptionKey.learnHub =>
      kidsMode
          ? l10n.pageDescriptionLearnHubKids
          : l10n.pageDescriptionLearnHub,
    AppPageDescriptionKey.quranHub =>
      kidsMode
          ? l10n.pageDescriptionQuranHubKids
          : l10n.pageDescriptionQuranHub,
    AppPageDescriptionKey.quranStudyHub =>
      kidsMode
          ? l10n.pageDescriptionQuranStudyHubKids
          : l10n.pageDescriptionQuranStudyHub,
    AppPageDescriptionKey.worshipHub =>
      kidsMode
          ? l10n.pageDescriptionWorshipHubKids
          : l10n.pageDescriptionWorshipHub,
    AppPageDescriptionKey.growthToday =>
      kidsMode
          ? l10n.pageDescriptionGrowthTodayKids
          : l10n.pageDescriptionGrowthToday,
    AppPageDescriptionKey.growthPaths =>
      kidsMode
          ? l10n.pageDescriptionGrowthPathsKids
          : l10n.pageDescriptionGrowthPaths,
    AppPageDescriptionKey.growthJourney =>
      kidsMode
          ? l10n.pageDescriptionGrowthJourneyKids
          : l10n.pageDescriptionGrowthJourney,
    AppPageDescriptionKey.growthReflection =>
      kidsMode
          ? l10n.pageDescriptionGrowthReflectionKids
          : l10n.pageDescriptionGrowthReflection,
    AppPageDescriptionKey.settingsLanding =>
      kidsMode
          ? l10n.pageDescriptionSettingsLandingKids
          : l10n.pageDescriptionSettingsLanding,
    AppPageDescriptionKey.assistant =>
      kidsMode
          ? l10n.pageDescriptionAssistantKids
          : l10n.pageDescriptionAssistant,
    AppPageDescriptionKey.journalTimeline =>
      kidsMode
          ? l10n.pageDescriptionJournalTimelineKids
          : l10n.pageDescriptionJournalTimeline,
    AppPageDescriptionKey.journalCreate =>
      kidsMode
          ? l10n.pageDescriptionJournalCreateKids
          : l10n.pageDescriptionJournalCreate,
    AppPageDescriptionKey.creationExplorer =>
      kidsMode
          ? l10n.pageDescriptionCreationExplorerKids
          : l10n.pageDescriptionCreationExplorer,
    AppPageDescriptionKey.creationChallenges =>
      kidsMode
          ? l10n.pageDescriptionCreationChallengesKids
          : l10n.pageDescriptionCreationChallenges,
    AppPageDescriptionKey.celestialExplorer =>
      kidsMode
          ? l10n.pageDescriptionCelestialExplorerKids
          : l10n.pageDescriptionCelestialExplorer,
    AppPageDescriptionKey.khusuFocus =>
      kidsMode
          ? l10n.pageDescriptionKhusuFocusKids
          : l10n.pageDescriptionKhusuFocus,
  };
}

String localizedSettingsPageDescription(
  BuildContext context,
  SettingsPageDescriptionKey key, {
  required bool kidsMode,
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    SettingsPageDescriptionKey.accountSync =>
      kidsMode
          ? l10n.pageDescriptionSettingsAccountSyncKids
          : l10n.pageDescriptionSettingsAccountSync,
    SettingsPageDescriptionKey.appearance =>
      kidsMode
          ? l10n.pageDescriptionSettingsAppearanceKids
          : l10n.pageDescriptionSettingsAppearance,
    SettingsPageDescriptionKey.prayerWorship =>
      kidsMode
          ? l10n.pageDescriptionSettingsPrayerWorshipKids
          : l10n.pageDescriptionSettingsPrayerWorship,
    SettingsPageDescriptionKey.learning =>
      kidsMode
          ? l10n.pageDescriptionSettingsLearningKids
          : l10n.pageDescriptionSettingsLearning,
    SettingsPageDescriptionKey.notifications =>
      kidsMode
          ? l10n.pageDescriptionSettingsNotificationsKids
          : l10n.pageDescriptionSettingsNotifications,
    SettingsPageDescriptionKey.widgetsWatch =>
      kidsMode
          ? l10n.pageDescriptionSettingsWidgetsWatchKids
          : l10n.pageDescriptionSettingsWidgetsWatch,
    SettingsPageDescriptionKey.language =>
      kidsMode
          ? l10n.pageDescriptionSettingsLanguageKids
          : l10n.pageDescriptionSettingsLanguage,
    SettingsPageDescriptionKey.privacy =>
      kidsMode
          ? l10n.pageDescriptionSettingsPrivacyKids
          : l10n.pageDescriptionSettingsPrivacy,
    SettingsPageDescriptionKey.kidsFamily =>
      kidsMode
          ? l10n.pageDescriptionSettingsKidsFamilyKids
          : l10n.pageDescriptionSettingsKidsFamily,
    SettingsPageDescriptionKey.about =>
      kidsMode
          ? l10n.pageDescriptionSettingsAboutKids
          : l10n.pageDescriptionSettingsAbout,
  };
}
