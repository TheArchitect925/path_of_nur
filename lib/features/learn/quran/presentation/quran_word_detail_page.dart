import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';
import '../application/quran_words_provider.dart';
import 'widgets/quran_word_study_sections.dart';

class QuranWordDetailPage extends ConsumerWidget {
  const QuranWordDetailPage({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(quranCoreWordsProvider);
    final word = ref.watch(quranCoreWordByRankProvider(rank));
    final progress = ref.watch(quranWordsProgressProvider);
    final progressNotifier = ref.read(quranWordsProgressProvider.notifier);
    final usageIndexAsync = ref.watch(quranTopWordUsageIndexProvider);
    final settings = ref.watch(quranReaderSettingsProvider);
    final usageSummary = usageIndexAsync.valueOrNull?[rank];
    final arabicScale = settings.arabicScalePercent / 100.0;
    final transliterationScale = settings.transliterationScalePercent / 100.0;
    final translationScale = settings.translationScalePercent / 100.0;

    if (word == null) {
      return AppPageScaffold(
        title: l10n.quranTopWordsTitle,
        subtitle: l10n.batch9QuranWordsSubtitle,
        children: [
          wordsAsync.when(
            data: (_) => PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.batch9QuranWordsDetailNotFoundTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.batch9QuranWordsDetailNotFoundSubtitle),
                ],
              ),
            ),
            loading: () => const PremiumCard(child: LinearProgressIndicator()),
            error: (error, _) => PremiumCard(
              child: Text(l10n.batch9QuranWordsLoadError('$error')),
            ),
          ),
        ],
      );
    }

    final mastered = progress.masteredRanks.contains(word.rank);

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.batch9QuranWordsStudyPageTitle,
      subtitle: word.transliteration,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _MetaPill(label: '#${word.rank}'),
                  const SizedBox(width: 8),
                  _MetaPill(
                    label: l10n.batch9QuranWordsOccurrenceCount(
                      '${word.occurrences}',
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => progressNotifier.toggleMastered(word.rank),
                    icon: Icon(
                      mastered
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                    ),
                    label: Text(
                      mastered
                          ? l10n.batch9QuranWordsLearned
                          : l10n.batch9QuranWordsMarkLearned,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                word.arabic,
                style: AppTextStyles.arabicLearning(
                  size: 36 * arabicScale,
                  weight: FontWeight.w700,
                ),
                textAlign: textAlignForContent(word.arabic),
                textDirection: textDirectionForContent(word.arabic),
              ),
              const SizedBox(height: 10),
              Text(
                word.transliteration,
                style: TextStyle(
                  fontSize: 18 * transliterationScale,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF47382B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                word.meaning,
                style: TextStyle(
                  fontSize: 16 * translationScale,
                  height: 1.35,
                  color: const Color(0xFF6A5A4A),
                ),
              ),
              if (word.hasRootLetters) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.batch9QuranWordsRootLettersTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.rootLetters!,
                  style: AppTextStyles.arabicLearning(
                    size: 20 * arabicScale,
                    weight: FontWeight.w600,
                  ),
                  textAlign: textAlignForContent(word.rootLetters!),
                  textDirection: textDirectionForContent(word.rootLetters!),
                ),
              ],
              if (word.hasMeaningExpansion) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.batch9QuranWordsMeaningExpansionTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.meaningExpansion!,
                  style: TextStyle(
                    fontSize: 14.5 * translationScale,
                    height: 1.4,
                    color: const Color(0xFF6A5A4A),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9QuranWordsExampleAyahTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF47382B),
                ),
              ),
              const SizedBox(height: 10),
              if (usageIndexAsync.isLoading && usageSummary == null)
                const LinearProgressIndicator(minHeight: 3)
              else if (usageSummary != null)
                QuranWordExampleAyahSection(
                  usageSummary: usageSummary,
                  arabicScale: arabicScale,
                  transliterationScale: transliterationScale,
                  translationScale: translationScale,
                )
              else
                Text(
                  l10n.batch9QuranWordsNoUsageAvailable,
                  style: const TextStyle(
                    color: Color(0xFF6A5A4A),
                    height: 1.3,
                  ),
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
                l10n.batch9QuranWordsAllAyahsTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.batch9QuranWordsAllAyahsSubtitle(word.transliteration),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6A5A4A),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              if (usageSummary != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    onPressed: () => showQuranWordUsageSheet(
                      context,
                      summary: usageSummary,
                      arabicScale: arabicScale,
                      transliterationScale: transliterationScale,
                      translationScale: translationScale,
                    ),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: Text(
                      l10n.batch9QuranWordsViewOccurrences(
                        usageSummary.ayahCount,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  l10n.batch9QuranWordsNoUsageAvailable,
                  style: const TextStyle(
                    color: Color(0xFF6A5A4A),
                    height: 1.3,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E7D8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF47382B),
        ),
      ),
    );
  }
}
