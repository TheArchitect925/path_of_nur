import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/shared/application/learn_system_engine_provider.dart';
import '../../features/learn/shared/domain/learn_system_models.dart';
import '../../l10n/app_localizations.dart';
import 'section_hub_scaffold.dart';
import 'shortcut_dock.dart';

enum MajorPageShortcutFamily { learn, worship, growth, quran }

List<SectionShortcutAction> buildMajorPageShortcutActions(
  BuildContext context,
  WidgetRef ref,
  MajorPageShortcutFamily family,
) {
  final l10n = AppLocalizations.of(context);
  switch (family) {
    case MajorPageShortcutFamily.learn:
      final summary = ref.watch(learnUnifiedSummaryV2Provider);
      final continueItem = summary.continueItem;
      final quickLesson = summary.dailyItem.item;
      return [
        SectionShortcutAction(
          label: l10n.majorPageShortcutContinueJourneyLabel,
          supportingText: continueItem?.title ?? l10n.learningJourneyHomeTitle,
          icon: Icons.history_edu_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF4E4034),
            borderColor: Color(0xFF8C775D),
            shadowColor: Color(0xFF8C775D),
            gradient: [Color(0xFFF7F0E1), Color(0xFFE3D2B4)],
          ),
          onTap: () => _openLearnContentItem(
            context,
            continueItem ?? quickLesson,
            fallbackRouteName: 'learnJourneyHome',
          ),
        ),
        SectionShortcutAction(
          label: l10n.majorPageShortcutQuickLessonLabel,
          supportingText: quickLesson.title,
          icon: Icons.bolt_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF4D5E2F),
            borderColor: Color(0xFF87995E),
            shadowColor: Color(0xFF87995E),
            gradient: [Color(0xFFF1F6E5), Color(0xFFD7E6B1)],
          ),
          onTap: () => _openLearnContentItem(
            context,
            quickLesson,
            fallbackRouteName: 'learnJourneyHome',
          ),
        ),
        SectionShortcutAction(
          label: l10n.learnHubSubcategoryArabicLearningTitle,
          supportingText: l10n.learnHubSubcategoryArabicLearningSubtitle,
          icon: Icons.translate_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF415A77),
            borderColor: Color(0xFF6C8CA8),
            shadowColor: Color(0xFF6C8CA8),
            gradient: [Color(0xFFEAF2FA), Color(0xFFCADBEF)],
          ),
          onTap: () => context.pushNamed('quranArabic'),
        ),
      ];
    case MajorPageShortcutFamily.worship:
      return [
        SectionShortcutAction(
          label: l10n.dhikrSectionTitle,
          supportingText: l10n.worshipSectionLandingDhikrShortcut,
          icon: Icons.favorite_outline_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF5D4520),
            borderColor: Color(0xFF8F7547),
            shadowColor: Color(0xFF8F7547),
            gradient: [Color(0xFFF6EFD8), Color(0xFFE1D0A0)],
          ),
          onTap: () => context.pushNamed('worshipDhikrPage'),
        ),
        SectionShortcutAction(
          label: l10n.worshipSectionLandingDuasTitle,
          supportingText: l10n.worshipSectionLandingDuasSubtitle,
          icon: Icons.menu_book_outlined,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF8D6143),
            borderColor: Color(0xFFB78668),
            shadowColor: Color(0xFFB78668),
            gradient: [Color(0xFFF4E8DE), Color(0xFFE6C9B1)],
          ),
          onTap: () => context.pushNamed('worshipDuasPage'),
        ),
        SectionShortcutAction(
          label: l10n.worshipRemindersPageTitle,
          supportingText: l10n.worshipRemindersPageSubtitle,
          icon: Icons.notifications_active_outlined,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF45636D),
            borderColor: Color(0xFF6F95A0),
            shadowColor: Color(0xFF6F95A0),
            gradient: [Color(0xFFE7F0F4), Color(0xFFC5D9E1)],
          ),
          onTap: () => context.pushNamed('worshipRemindersPage'),
        ),
      ];
    case MajorPageShortcutFamily.growth:
      return [
        SectionShortcutAction(
          label: l10n.gardenPageTitle,
          supportingText: l10n.gardenPageEntryHomeSubtitle,
          icon: Icons.local_florist_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF56704A),
            borderColor: Color(0xFF84A176),
            shadowColor: Color(0xFF84A176),
            gradient: [Color(0xFFEAF2E4), Color(0xFFCFE0C1)],
          ),
          onTap: () => context.pushNamed('gardenPage'),
        ),
        SectionShortcutAction(
          label: l10n.growthStatisticsTitle,
          supportingText: l10n.growthStatisticsSubtitle,
          icon: Icons.query_stats_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF5D6382),
            borderColor: Color(0xFF8690B1),
            shadowColor: Color(0xFF8690B1),
            gradient: [Color(0xFFEAEAF4), Color(0xFFCDD1E7)],
          ),
          onTap: () => context.pushNamed('growthStatisticsPage'),
        ),
        SectionShortcutAction(
          label: l10n.growthTabHabits,
          supportingText: l10n.growthHabitsPageSubtitle,
          icon: Icons.checklist_rtl_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF7A6241),
            borderColor: Color(0xFFA58A66),
            shadowColor: Color(0xFFA58A66),
            gradient: [Color(0xFFF4ECE0), Color(0xFFE3D1B7)],
          ),
          onTap: () => context.pushNamed('growthHabitsPage'),
        ),
      ];
    case MajorPageShortcutFamily.quran:
      final quranAudioEnabled = ref.watch(quranAudioFunctionEnabledProvider);
      final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
      final recitationSession = ref.watch(quranRecitationSessionProvider);
      final surahMap = ref.watch(quranSurahMapProvider);
      final listeningSurah = recitationSession == null
          ? null
          : surahMap[recitationSession.surahNumber];
      final listeningSurahName =
          listeningSurah?.englishName ?? continueSummary.surahName;
      final listeningSurahNumber =
          recitationSession?.surahNumber ?? continueSummary.surahNumber;
      final listeningAyahNumber =
          recitationSession?.ayahNumber ?? continueSummary.ayahNumber;
      final actions = <SectionShortcutAction>[
        SectionShortcutAction(
          label: l10n.majorPageShortcutContinueReadingLabel,
          supportingText: continueSummary.locationLabel,
          icon: Icons.menu_book_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF2D5E45),
            borderColor: Color(0xFF4D8B63),
            shadowColor: Color(0xFF4D8B63),
            gradient: [Color(0xFFEAF9EB), Color(0xFFBDE0C5)],
          ),
          onTap: () => context.pushNamed(
            'quranReader',
            pathParameters: {
              'surahNumber': continueSummary.surahNumber.toString(),
            },
            queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
          ),
        ),
        SectionShortcutAction(
          label: l10n.majorPageShortcutSurahListLabel,
          supportingText: l10n.quranExplorerSubtitle,
          icon: Icons.format_list_bulleted_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF69411A),
            borderColor: Color(0xFF9F7A42),
            shadowColor: Color(0xFF9F7A42),
            gradient: [Color(0xFFF8E6D2), Color(0xFFE7BE8E)],
          ),
          onTap: () => context.pushNamed('quranExplorer'),
        ),
      ];
      if (quranAudioEnabled) {
        actions.insert(
          1,
          SectionShortcutAction(
            label: l10n.majorPageShortcutContinueListeningLabel,
            supportingText:
                '$listeningSurahName • ${l10n.quranAyahNumberLabel(listeningAyahNumber)}',
            icon: Icons.headphones_rounded,
            palette: const ShortcutDockPalette(
              textColor: Color(0xFF45636D),
              borderColor: Color(0xFF6F95A0),
              shadowColor: Color(0xFF6F95A0),
              gradient: [Color(0xFFE7F0F4), Color(0xFFC5D9E1)],
            ),
            onTap: () => context.pushNamed(
              'quranReader',
              pathParameters: {'surahNumber': '$listeningSurahNumber'},
              queryParameters: {'ayah': '$listeningAyahNumber'},
            ),
          ),
        );
      }
      return actions;
  }
}

void _openLearnContentItem(
  BuildContext context,
  LearnUnifiedContentItem item, {
  required String fallbackRouteName,
}) {
  final routeName = item.routeName;
  if (routeName == null || routeName.isEmpty) {
    context.pushNamed(fallbackRouteName);
    return;
  }

  context.pushNamed(
    routeName,
    pathParameters: item.pathParameters,
    queryParameters: item.queryParameters,
  );
}
