import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_content_refs.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerWidget {
  const QuranAppHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
    final dailyVerse = ref.watch(quranDailyVerseProvider);
    ref.watch(quranBookmarksProvider);
    ref.watch(quranNotesProvider);

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.quran,
      title: l10n.quranHubTitle,
      subtitle: l10n.quranHubSubtitle,
      headerActions: [
        IconButton(
          onPressed: () => openQuranQuoteLocation(
            context,
            QuranQuote(
              ref: QuranQuoteRef(
                surah: dailyVerse.surahNumber,
                ayah: dailyVerse.ayahNumber,
              ),
            ),
          ),
          icon: const Icon(Icons.auto_stories_rounded),
          tooltip: l10n.quranReferenceViewerOpenInReader,
        ),
      ],
      shortcutActions: <LearnHubShortcutAction>[
        LearnHubShortcutAction(
          label: l10n.learnQuranContinueTitle,
          supportingText: continueSummary.locationLabel,
          icon: Icons.play_circle_fill_rounded,
          onTap: () => context.pushNamed(
            'quranReader',
            pathParameters: {
              'surahNumber': continueSummary.surahNumber.toString(),
            },
            queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
          ),
        ),
      ],
      children: [
        _SectionHeader(
          title: l10n.quranHubJourneysTitle,
          subtitle: l10n.quranHubJourneysSubtitle,
        ),
        const SizedBox(height: 8),
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.quranHubJourneyOfQuranTitle,
              subtitle: l10n.quranHubJourneyOfQuranSubtitle,
              icon: Icons.route_rounded,
              color: const Color(0xFFECE5D7),
              accentColor: const Color(0xFF6F5A3E),
              onTap: () => context.pushNamed(
                'learnJourneyDetail',
                pathParameters: const {'journeyId': 'journey-quran'},
              ),
            ),
            SectionHubAction(
              title: l10n.quranHubFatihahJourneyTitle,
              subtitle: l10n.quranHubFatihahJourneySubtitle,
              icon: Icons.auto_stories_rounded,
              color: const Color(0xFFE4ECD9),
              accentColor: const Color(0xFF597045),
              onTap: () => context.pushNamed(
                'learnJourneyDetail',
                pathParameters: const {'journeyId': 'understanding-al-fatihah'},
              ),
            ),
            SectionHubAction(
              title: l10n.quranHubShortSurahsJourneyTitle,
              subtitle: l10n.quranHubShortSurahsJourneySubtitle,
              icon: Icons.menu_book_outlined,
              color: const Color(0xFFE9E0EB),
              accentColor: const Color(0xFF755C7C),
              onTap: () => context.pushNamed(
                'learnJourneyDetail',
                pathParameters: const {'journeyId': 'short-surahs'},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SectionHeader(
          title: l10n.quranHubModesTitle,
          subtitle: l10n.quranHubModesSubtitle,
        ),
        const SizedBox(height: 8),
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.quranHubReadTitle,
              subtitle: l10n.quranHubReadSubtitle,
              icon: Icons.chrome_reader_mode_rounded,
              color: const Color(0xFFF0E2D6),
              accentColor: const Color(0xFF8D6143),
              onTap: () => context.pushNamed(
                'quranReader',
                pathParameters: {
                  'surahNumber': continueSummary.surahNumber.toString(),
                },
                queryParameters: {
                  'ayah': continueSummary.ayahNumber.toString(),
                },
              ),
            ),
            SectionHubAction(
              title: l10n.quranHubStudyTitle,
              subtitle: l10n.quranHubStudySubtitle,
              icon: Icons.school_rounded,
              color: const Color(0xFFE2E5F3),
              accentColor: const Color(0xFF545E8D),
              onTap: () => context.pushNamed('quranLearningHub'),
            ),
            SectionHubAction(
              title: l10n.quranHubMemorizeTitle,
              subtitle: l10n.quranHubMemorizeSubtitle,
              icon: Icons.repeat_rounded,
              color: const Color(0xFFEADFEB),
              accentColor: const Color(0xFF7D5D81),
              onTap: () => context.pushNamed('quranWordReview'),
            ),
            SectionHubAction(
              title: l10n.quranHubWordsTitle,
              subtitle: l10n.quranHubWordsSubtitle,
              icon: Icons.translate_rounded,
              color: const Color(0xFFE6EEF1),
              accentColor: const Color(0xFF45636D),
              onTap: () => context.pushNamed('quranTopWords'),
            ),
            SectionHubAction(
              title: l10n.quranHubTopicsTitle,
              subtitle: l10n.quranHubTopicsSubtitle,
              icon: Icons.hub_outlined,
              color: const Color(0xFFE5EFE9),
              accentColor: const Color(0xFF4F6B59),
              onTap: () => context.pushNamed('quranTopicExplorer'),
            ),
            SectionHubAction(
              title: l10n.quranHubNotesTitle,
              subtitle: l10n.quranHubNotesSubtitle,
              icon: Icons.note_alt_outlined,
              color: const Color(0xFFEFE7DE),
              accentColor: const Color(0xFF6D5740),
              onTap: () => context.pushNamed('quranNotes'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranHubDailyLightTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(dailyVerse.locationLabel),
              const SizedBox(height: 4),
              Text(
                dailyVerse.translation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {
                    'surahNumber': dailyVerse.surahNumber.toString(),
                  },
                  queryParameters: {'ayah': dailyVerse.ayahNumber.toString()},
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: Text(l10n.quranHubOpenVerseAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranHubRelatedToolsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranHubRelatedToolsSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SecondaryToolChip(
                    label: l10n.quranSearchTitle,
                    icon: Icons.search_rounded,
                    onTap: () => context.pushNamed('quranSearch'),
                  ),
                  _SecondaryToolChip(
                    label: l10n.learnQuranBookmarksTitle,
                    icon: Icons.bookmark_outline_rounded,
                    onTap: () => context.pushNamed('quranBookmarks'),
                  ),
                  _SecondaryToolChip(
                    label: l10n.learnCategoryQuranicArabicTitle,
                    icon: Icons.spellcheck_rounded,
                    onTap: () => context.pushNamed('quranArabic'),
                  ),
                  _SecondaryToolChip(
                    label: l10n.quranHubUniverseToolTitle,
                    icon: Icons.travel_explore_rounded,
                    onTap: () => context.pushNamed('quranUniverse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
      ],
    );
  }
}

class _SecondaryToolChip extends StatelessWidget {
  const _SecondaryToolChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
