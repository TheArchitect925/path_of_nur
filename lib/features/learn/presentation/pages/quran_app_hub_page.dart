import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/page_description_copy.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../quran/application/quran_khatm_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_icons.dart';

/// The Qur'an tab, reader-first: continue exactly where you left off, keep a
/// khatm moving, then Read / Understand / Practice — every destination once.
class QuranAppHubPage extends ConsumerWidget {
  const QuranAppHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );

    return LearnHubPageScaffold(
      headerIcon: AppIcons.quran,
      title: l10n.quranAppHubTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.quranHub,
        kidsMode: isKidsMode,
      ),
      headerActions: [
        IconButton(
          onPressed: () => context.pushNamed('quranSearch'),
          icon: const Icon(Icons.search_rounded),
          tooltip: l10n.quranAppHubSearchHint,
        ),
      ],
      children: [
        const _ContinueReadingHero(),
        const SizedBox(height: 12),
        const _ReadingPlanRow(),
        const SizedBox(height: 6),
        const _TodayAyahRow(),
        const SizedBox(height: 8),
        HubListGroup(
          title: l10n.quranTabGroupRead,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.surahs),
              title: l10n.quranTabAllSurahsTitle,
              subtitle: l10n.quranTabAllSurahsSubtitle,
              onTap: () => context.pushNamed('quranExplorer'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.bookmarkOff),
              title: l10n.quranTabBookmarksTitle,
              subtitle: l10n.quranTabBookmarksSubtitle,
              onTap: () => context.pushNamed('quranBookmarks'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.listen),
              title: l10n.quranTabListenTitle,
              subtitle: l10n.quranTabListenSubtitle,
              onTap: () => context.pushNamed('quranFocusRecitation'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.quranTabGroupUnderstand,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.summary),
              title: l10n.quranTabSummariesTitle,
              subtitle: l10n.quranTabSummariesSubtitle,
              onTap: () => context.pushNamed('quranSummaryPage'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.topics),
              title: l10n.quranTabTopicsTitle,
              subtitle: l10n.quranTabTopicsSubtitle,
              onTap: () => context.pushNamed('quranTopicExplorer'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.path),
              title: l10n.quranTabPathwaysTitle,
              subtitle: l10n.quranTabPathwaysSubtitle,
              onTap: () => context.pushNamed('quranLearningPaths'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.quranTabGroupPractice,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.arabic),
              title: l10n.quranTabLearnArabicTitle,
              subtitle: l10n.quranTabLearnArabicSubtitle,
              trailing: HubNewBadge(label: l10n.quranTabStartHereBadge),
              onTap: () => context.pushNamed('quranArabic'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.memorize),
              title: l10n.quranTabMemorizationTitle,
              subtitle: l10n.quranTabMemorizationSubtitle,
              onTap: () => context.pushNamed('quranMemorizationReview'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.wordDeck),
              title: l10n.quranTabWordPracticeTitle,
              subtitle: l10n.quranTabWordPracticeSubtitle,
              onTap: () => context.pushNamed('quranTopWords'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Resume state as the hero: the Arabic name of where you are, how far along
/// the surah you are, and one tap to keep going.
class _ContinueReadingHero extends ConsumerWidget {
  const _ContinueReadingHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(quranContinueReadingSummaryProvider);
    final surahs = ref.watch(quranRepositoryProvider).getSurahs();
    final surah = surahs[summary.surahNumber - 1];
    final percent = ((summary.ayahNumber / surah.verseCount) * 100)
        .round()
        .clamp(0, 100);

    void openReader() => context.pushNamed(
      'quranReader',
      pathParameters: {'surahNumber': '${summary.surahNumber}'},
      queryParameters: {'ayah': '${summary.ayahNumber}'},
    );

    return AppHeroGlassShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranTabContinueEyebrow.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.arabicName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.transliteratedName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.pushNamed('quranExplorer'),
                child: Text(l10n.quranTabAllSurahsTitle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.quranTabContinueProgressLabel(
              summary.ayahNumber,
              surah.verseCount,
              percent,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: openReader,
                  child: Text(l10n.quranTabContinueAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    'quranFocusRecitation',
                    queryParameters: {
                      'surah': '${summary.surahNumber}',
                      'ayah': '${summary.ayahNumber}',
                    },
                  ),
                  icon: const Icon(AppIcons.listen, size: 18),
                  label: Text(l10n.quranTabListenAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingPlanRow extends ConsumerWidget {
  const _ReadingPlanRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(quranKhatmStatusProvider);
    final subtitle = status == null
        ? l10n.quranTabPlanNoneSubtitle
        : '${l10n.quranTabPlanJuzLabel(status.currentJuz)} · '
              '${status.portionDoneToday ? l10n.quranTabPlanDoneSuffix : l10n.quranTabPlanTodaySuffix(status.portionLabel)}';
    return CompactListTile(
      leading: const HubLeadingIcon(AppIcons.readingPlan),
      title: l10n.quranTabPlanTitle,
      subtitle: subtitle,
      onTap: () => context.pushNamed('quranKhatmPlan'),
    );
  }
}

class _TodayAyahRow extends ConsumerWidget {
  const _TodayAyahRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final verse = ref.watch(quranDailyVerseProvider);
    return CompactListTile(
      leading: const HubLeadingIcon(AppIcons.daily),
      title: l10n.quranTabTodayAyahTitle,
      subtitle: l10n.quranTabTodayAyahSubtitle(verse.locationLabel),
      onTap: () => context.pushNamed('quranDailyCompanion'),
    );
  }
}
