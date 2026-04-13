import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/islamic_icons.dart';
import 'main_page_shortcut_stack.dart';

class MainPageShortcutPalettes {
  static const emerald = MainPageShortcutStyle(
    tintColor: Color(0xFF4D8B63),
    fillColor: Color(0xFFEAF9EB),
    borderColor: Color(0xFF9FC9AA),
    foregroundColor: Color(0xFF214933),
  );

  static const amber = MainPageShortcutStyle(
    tintColor: Color(0xFF9F7A42),
    fillColor: Color(0xFFF7E8D2),
    borderColor: Color(0xFFD9BA8D),
    foregroundColor: Color(0xFF5D3D14),
  );

  static const plum = MainPageShortcutStyle(
    tintColor: Color(0xFF7F6AA8),
    fillColor: Color(0xFFEEE8F8),
    borderColor: Color(0xFFC5B6E1),
    foregroundColor: Color(0xFF4A386A),
  );

  static const teal = MainPageShortcutStyle(
    tintColor: Color(0xFF5A8791),
    fillColor: Color(0xFFE6F1F3),
    borderColor: Color(0xFFA9C5CA),
    foregroundColor: Color(0xFF2D5158),
  );

  static const sapphire = MainPageShortcutStyle(
    tintColor: Color(0xFF5876A8),
    fillColor: Color(0xFFE9EFF9),
    borderColor: Color(0xFFB4C5E6),
    foregroundColor: Color(0xFF2E456B),
  );

  static const rose = MainPageShortcutStyle(
    tintColor: Color(0xFF9A6B7C),
    fillColor: Color(0xFFF6E9EE),
    borderColor: Color(0xFFDDB6C4),
    foregroundColor: Color(0xFF603645),
  );

  static const olive = MainPageShortcutStyle(
    tintColor: Color(0xFF6B8150),
    fillColor: Color(0xFFEEF2E4),
    borderColor: Color(0xFFC2D0A8),
    foregroundColor: Color(0xFF3F5230),
  );

  static const cedar = MainPageShortcutStyle(
    tintColor: Color(0xFF8A6243),
    fillColor: Color(0xFFF3E8DD),
    borderColor: Color(0xFFD9BEA5),
    foregroundColor: Color(0xFF563A22),
  );
}

List<MainPageShortcutItem> buildHomePageShortcuts(
  AppLocalizations l10n, {
  String? salahProgressText,
  String? dhikrProgressText,
}) {
  return [
    MainPageShortcutItem(
      label: l10n.quranTitle,
      icon: Icons.menu_book_rounded,
      routeName: 'quranExplorer',
      style: MainPageShortcutPalettes.emerald,
    ),
    MainPageShortcutItem(
      label: l10n.homeShortcutSalahLabel,
      icon: IslamicIcons.prayer,
      routeName: 'worshipPrayerPage',
      style: MainPageShortcutPalettes.amber,
      progressText: salahProgressText,
    ),
    MainPageShortcutItem(
      label: l10n.homeShortcutDhikrLabel,
      icon: IslamicIcons.tasbih,
      routeName: 'worshipDhikrPage',
      style: MainPageShortcutPalettes.plum,
      progressText: dhikrProgressText,
    ),
    MainPageShortcutItem(
      label: l10n.hadithPageTitle,
      icon: Icons.format_quote_rounded,
      routeName: 'learnHadithLanding',
      style: MainPageShortcutPalettes.rose,
    ),
    MainPageShortcutItem(
      label: l10n.homeShortcutQiblaLabel,
      icon: IslamicIcons.qibla,
      routeName: 'qiblaFinder',
      style: MainPageShortcutPalettes.teal,
    ),
  ];
}

List<MainPageShortcutItem> buildWorshipPageShortcuts(
  AppLocalizations l10n, {
  String? salahProgressText,
  String? dhikrProgressText,
}) {
  return [
    MainPageShortcutItem(
      label: l10n.worshipSectionLandingPrayerTitle,
      icon: IslamicIcons.prayer,
      routeName: 'worshipPrayerPage',
      style: MainPageShortcutPalettes.amber,
      progressText: salahProgressText,
    ),
    MainPageShortcutItem(
      label: l10n.worshipSectionLandingDhikrTitle,
      icon: IslamicIcons.tasbih,
      routeName: 'worshipDhikrPage',
      style: MainPageShortcutPalettes.emerald,
      progressText: dhikrProgressText,
    ),
    MainPageShortcutItem(
      label: l10n.worshipSectionLandingDuasTitle,
      icon: IslamicIcons.lantern,
      routeName: 'worshipDuasPage',
      style: MainPageShortcutPalettes.cedar,
    ),
    MainPageShortcutItem(
      label: l10n.homeShortcutQiblaLabel,
      icon: IslamicIcons.qibla,
      routeName: 'qiblaFinder',
      style: MainPageShortcutPalettes.teal,
    ),
    MainPageShortcutItem(
      label: l10n.worshipTrackingPageTitle,
      icon: Icons.fact_check_rounded,
      routeName: 'worshipTrackingPage',
      style: MainPageShortcutPalettes.plum,
    ),
  ];
}

List<MainPageShortcutItem> buildLearnPageShortcuts(AppLocalizations l10n) {
  return [
    MainPageShortcutItem(
      label: l10n.learnHubJourneyIslandTitle,
      icon: Icons.alt_route_rounded,
      routeName: 'learnJourneyHome',
      style: MainPageShortcutPalettes.emerald,
    ),
    MainPageShortcutItem(
      label: l10n.learnHubExploreAllTitle,
      icon: Icons.explore_rounded,
      routeName: 'learnExploreAllKnowledge',
      style: MainPageShortcutPalettes.sapphire,
    ),
    MainPageShortcutItem(
      label: l10n.learnHubCategoryQuizzesChallengesTitle,
      icon: Icons.extension_rounded,
      routeName: 'learnQuizzesHub',
      style: MainPageShortcutPalettes.plum,
    ),
    MainPageShortcutItem(
      label: l10n.learnHubCategoryNotesTitle,
      icon: Icons.note_alt_outlined,
      routeName: 'learnNotesLanding',
      style: MainPageShortcutPalettes.rose,
    ),
    MainPageShortcutItem(
      label: l10n.learnHubCategoryFaqTitle,
      icon: Icons.help_outline_rounded,
      routeName: 'faqLanding',
      style: MainPageShortcutPalettes.amber,
    ),
  ];
}

List<MainPageShortcutItem> buildJourneyPageShortcuts(AppLocalizations l10n) {
  return [
    MainPageShortcutItem(
      label: l10n.growthTabToday,
      icon: Icons.today_rounded,
      routeName: 'growthTodayPage',
      style: MainPageShortcutPalettes.amber,
    ),
    MainPageShortcutItem(
      label: l10n.growthTabPaths,
      icon: Icons.alt_route_rounded,
      routeName: 'growthPathsPage',
      style: MainPageShortcutPalettes.emerald,
    ),
    MainPageShortcutItem(
      label: l10n.growthTabHabits,
      icon: Icons.checklist_rtl_rounded,
      routeName: 'growthHabitsPage',
      style: MainPageShortcutPalettes.teal,
    ),
    MainPageShortcutItem(
      label: l10n.growthStatisticsTitle,
      icon: Icons.query_stats_rounded,
      routeName: 'growthStatisticsPage',
      style: MainPageShortcutPalettes.sapphire,
    ),
    MainPageShortcutItem(
      label: l10n.gardenPageTitle,
      icon: Icons.local_florist_rounded,
      routeName: 'gardenPage',
      style: MainPageShortcutPalettes.olive,
    ),
  ];
}

List<MainPageShortcutItem> buildQuranPageShortcuts(AppLocalizations l10n) {
  return [
    MainPageShortcutItem(
      label: l10n.quranHubReadQuranSectionTitle,
      icon: Icons.menu_book_rounded,
      routeName: 'quranExplorer',
      style: MainPageShortcutPalettes.emerald,
    ),
    MainPageShortcutItem(
      label: l10n.quranDailyCompanionTitle,
      icon: Icons.wb_sunny_outlined,
      routeName: 'quranDailyCompanion',
      style: MainPageShortcutPalettes.amber,
    ),
    MainPageShortcutItem(
      label: l10n.quranSummaryIslandTitle,
      icon: Icons.auto_stories_rounded,
      routeName: 'quranSummaryPage',
      style: MainPageShortcutPalettes.cedar,
    ),
    MainPageShortcutItem(
      label: l10n.quranPathwaysIslandTitle,
      icon: Icons.route_rounded,
      routeName: 'quranLearningPaths',
      style: MainPageShortcutPalettes.plum,
    ),
    MainPageShortcutItem(
      label: l10n.learnQuranBookmarksTitle,
      icon: Icons.bookmark_outline_rounded,
      routeName: 'quranBookmarks',
      style: MainPageShortcutPalettes.teal,
    ),
    MainPageShortcutItem(
      label: l10n.quranReflectionsHubEntryTitle,
      icon: Icons.collections_bookmark_outlined,
      routeName: 'quranReflections',
      style: MainPageShortcutPalettes.rose,
    ),
  ];
}
