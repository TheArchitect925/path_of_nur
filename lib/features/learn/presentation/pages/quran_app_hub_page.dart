import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../quran/application/quran_providers.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerWidget {
  const QuranAppHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
    final dailyVerse = ref.watch(quranDailyVerseProvider);
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: 'Qur’an',
      subtitle:
          'One calm entry for reading, study, memorization, words, topics, and notes without losing the wider Qur’an tools around it.',
      quote: null,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue with the Qur’an',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${continueSummary.surahName} ${continueSummary.surahNumber}:${continueSummary.ayahNumber}',
              ),
              const SizedBox(height: 4),
              Text(
                'Bookmarks ${bookmarks.length} • Notes ${notes.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {
                    'surahNumber': continueSummary.surahNumber.toString(),
                  },
                  queryParameters: {
                    'ayah': continueSummary.ayahNumber.toString(),
                  },
                ),
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: const Text('Continue Reading'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(
          title: 'Journeys',
          subtitle:
              'Use the staged paths when you want structure, continuity, and clearer next steps.',
        ),
        const SizedBox(height: 8),
        _QuranJourneyCard(
          title: 'Journey of the Qur’an',
          subtitle:
              'Open the Book, navigate it, and build a first relationship.',
          icon: Icons.route_rounded,
          onTap: () => context.pushNamed(
            'learnJourneyDetail',
            pathParameters: const {'journeyId': 'journey-quran'},
          ),
        ),
        const SizedBox(height: 10),
        _QuranJourneyCard(
          title: 'Understanding Al-Fatihah',
          subtitle:
              'Begin with the surah you recite every day and connect it to salah.',
          icon: Icons.auto_stories_rounded,
          onTap: () => context.pushNamed(
            'learnJourneyDetail',
            pathParameters: const {'journeyId': 'understanding-al-fatihah'},
          ),
        ),
        const SizedBox(height: 10),
        _QuranJourneyCard(
          title: 'Short Surahs',
          subtitle:
              'Use the shorter surahs as a bridge between recitation, prayer, and meaning.',
          icon: Icons.menu_book_outlined,
          onTap: () => context.pushNamed(
            'learnJourneyDetail',
            pathParameters: const {'journeyId': 'short-surahs'},
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(
          title: 'Modes',
          subtitle:
              'One primary Qur’an space, then simple modes for what you want to do right now.',
        ),
        const SizedBox(height: 8),
        _QuranModeGrid(
          cards: [
            _QuranModeCardData(
              title: 'Read',
              subtitle:
                  'Open the reader from where you last left off or begin a new passage.',
              icon: Icons.chrome_reader_mode_rounded,
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
            _QuranModeCardData(
              title: 'Study',
              subtitle:
                  'Open the study hub for explanation, reflection, and guided learning paths.',
              icon: Icons.school_rounded,
              onTap: () => context.pushNamed('quranLearningHub'),
            ),
            _QuranModeCardData(
              title: 'Memorize',
              subtitle:
                  'Review and strengthen recall through the current memorization-oriented tools.',
              icon: Icons.repeat_rounded,
              onTap: () => context.pushNamed('quranWordReview'),
            ),
            _QuranModeCardData(
              title: 'Words',
              subtitle:
                  'Learn recurring Qur’anic vocabulary and build recognition gradually.',
              icon: Icons.translate_rounded,
              onTap: () => context.pushNamed('quranTopWords'),
            ),
            _QuranModeCardData(
              title: 'Topics',
              subtitle:
                  'Follow themes and verses without needing to browse the whole text first.',
              icon: Icons.hub_outlined,
              onTap: () => context.pushNamed('quranTopicExplorer'),
            ),
            _QuranModeCardData(
              title: 'Notes',
              subtitle:
                  'Return to saved reflections, highlights, and verse-linked notes.',
              icon: Icons.note_alt_outlined,
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
                'Today’s Light',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
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
                  queryParameters: {
                    'ayah': dailyVerse.ayahNumber.toString()},
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: const Text('Open Verse'),
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
                'Related tools',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Secondary paths stay available here without competing with the primary Qur’an flow.',
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
                    label: 'Search',
                    icon: Icons.search_rounded,
                    onTap: () => context.pushNamed('quranSearch'),
                  ),
                  _SecondaryToolChip(
                    label: 'Bookmarks',
                    icon: Icons.bookmark_outline_rounded,
                    onTap: () => context.pushNamed('quranBookmarks'),
                  ),
                  _SecondaryToolChip(
                    label: 'Qur’anic Arabic',
                    icon: Icons.spellcheck_rounded,
                    onTap: () => context.pushNamed('quranArabic'),
                  ),
                  _SecondaryToolChip(
                    label: 'Universe',
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
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
        ),
      ],
    );
  }
}

class _QuranJourneyCard extends StatelessWidget {
  const _QuranJourneyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEADCC7),
          child: Icon(icon, color: const Color(0xFF7A6241)),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _QuranModeGrid extends StatelessWidget {
  const _QuranModeGrid({required this.cards});

  final List<_QuranModeCardData> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < cards.length; index += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _QuranModeCard(data: cards[index])),
              const SizedBox(width: 10),
              Expanded(
                child: index + 1 < cards.length
                    ? _QuranModeCard(data: cards[index + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (index + 2 < cards.length) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _QuranModeCard extends StatelessWidget {
  const _QuranModeCard({required this.data});

  final _QuranModeCardData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1E8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3D6C4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DCC8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: const Color(0xFF71593C)),
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF30281F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              style: const TextStyle(
                fontSize: 12.6,
                color: Color(0xFF675B4E),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
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

class _QuranModeCardData {
  const _QuranModeCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
