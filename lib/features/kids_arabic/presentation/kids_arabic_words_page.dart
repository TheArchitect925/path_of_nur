import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_phrases_provider.dart';
import '../application/kids_arabic_words_provider.dart';
import '../widgets/kids_arabic_audio_learning_widgets.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicWordsPage extends ConsumerWidget {
  const KidsArabicWordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statuses = ref.watch(kidsArabicWordStatusesProvider);
    final completedCount = ref.watch(kidsArabicCompletedWordsCountProvider);
    final nextWord = ref.watch(kidsArabicNextRecommendedWordProvider);
    final readingWord = ref.watch(kidsArabicReadingRecommendedWordProvider);
    final phrase = ref.watch(kidsArabicMiniPhraseRecommendedProvider);
    final heardPhrases = ref.watch(kidsArabicMiniPhraseHeardCountProvider);
    final readyCount = statuses.where((item) => item.unlocked).length;

    return LearnHubPageScaffold(
      title: l10n.kidsArabicWordsTitle,
      subtitle: l10n.kidsArabicWordsSubtitle,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.palette.surfaceSoft),
          ),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryPill(
                label: l10n.kidsArabicWordsCompletedValue(completedCount),
              ),
              _SummaryPill(label: l10n.kidsArabicWordsReadyValue(readyCount)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (nextWord != null)
          _NextWordCard(wordId: nextWord.id, wordAr: nextWord.wordAr),
        if (nextWord != null) const SizedBox(height: 12),
        _ReadingModeCard(initialWordId: readingWord?.id),
        const SizedBox(height: 12),
        _MiniPhrasesCard(initialPhraseId: phrase?.id, heardCount: heardPhrases),
        const SizedBox(height: 12),
        _SectionHeader(
          title: l10n.kidsArabicWordsJoiningTitle,
          subtitle: l10n.kidsArabicWordsJoiningSubtitle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: statuses
              .take(3)
              .expand(
                (status) => status.word.joiningExamples
                    .take(1)
                    .map(
                      (example) => _JoiningCard(
                        letterName: localizedKidsArabicJoiningLetterName(
                          l10n,
                          example.letterId,
                        ),
                        standaloneGlyph: example.standaloneGlyph,
                        joinedGlyph: example.joinedGlyph,
                      ),
                    ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicWordsStartSetTitle,
          subtitle: l10n.kidsArabicWordsStartSetSubtitle,
        ),
        const SizedBox(height: 10),
        ...statuses.map(
          (status) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _WordCard(status: status),
          ),
        ),
      ],
    );
  }
}

class _NextWordCard extends StatelessWidget {
  const _NextWordCard({required this.wordId, required this.wordAr});

  final String wordId;
  final String wordAr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.success.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.palette.success.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicWordsNextTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicWordsNextSubtitle(wordAr),
            textDirection: TextDirection.rtl,
            style: TextStyle(color: context.palette.successInk, height: 1.35),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.pushNamed(
              'kidsArabicWordLesson',
              pathParameters: {'wordId': wordId},
            ),
            child: Text(l10n.kidsArabicWordsContinueAction),
          ),
        ],
      ),
    );
  }
}

class _ReadingModeCard extends StatelessWidget {
  const _ReadingModeCard({required this.initialWordId});

  final String? initialWordId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD1E2F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicReadingModeTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24324A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicReadingModeHomeSubtitle,
            style: const TextStyle(color: Color(0xFF4A5870), height: 1.35),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.pushNamed(
              'kidsArabicReadingMode',
              queryParameters: initialWordId == null
                  ? <String, String>{}
                  : {'word': initialWordId!},
            ),
            child: Text(l10n.kidsArabicReadingModeOpenAction),
          ),
        ],
      ),
    );
  }
}

class _WordCard extends ConsumerWidget {
  const _WordCard({required this.status});

  final KidsArabicWordStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final body = status.unlocked
        ? localizedKidsArabicWordSummary(l10n, status.word.id)
        : localizedKidsArabicRequiredLettersLabel(
            l10n,
            status.word.joiningExamples,
          );
    final actionLabel = status.unlocked
        ? status.completed
              ? l10n.kidsArabicWordsPracticeAgainAction
              : l10n.kidsArabicWordsStartAction
        : l10n.kidsArabicWordsLockedLabel;
    return InkWell(
      onTap: status.unlocked
          ? () => context.pushNamed(
              'kidsArabicWordLesson',
              pathParameters: {'wordId': status.word.id},
            )
          : null,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: status.unlocked
              ? context.palette.surface
              : context.palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: status.completed
                ? const Color(0xFFC4DAA9)
                : status.unlocked
                ? context.palette.surfaceSoft
                : context.palette.surfaceSoft,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                status.word.wordAr,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Noto Naskh Arabic',
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.word.transliteration,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizedKidsArabicWordMeaning(l10n, status.word.id),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        actionLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: context.palette.onSurfaceSubtle,
                        ),
                      ),
                      if (status.unlocked)
                        KidsArabicAudioChipButton(
                          label: l10n.kidsArabicWordsListenAction,
                          onPlay: () => ref
                              .read(kidsArabicAudioServiceProvider)
                              .speakWord(status.word),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPhrasesCard extends StatelessWidget {
  const _MiniPhrasesCard({
    required this.initialPhraseId,
    required this.heardCount,
  });

  final String? initialPhraseId;
  final int heardCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7EE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD6E3CC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicMiniPhrasesTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF264032),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicMiniPhrasesWordsCardSubtitle(heardCount),
            style: const TextStyle(color: Color(0xFF4A6456), height: 1.35),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.pushNamed(
              'kidsArabicMiniPhrases',
              queryParameters: initialPhraseId == null
                  ? <String, String>{}
                  : {'phrase': initialPhraseId!},
            ),
            child: Text(l10n.kidsArabicMiniPhrasesOpenAction),
          ),
        ],
      ),
    );
  }
}

class _JoiningCard extends StatelessWidget {
  const _JoiningCard({
    required this.letterName,
    required this.standaloneGlyph,
    required this.joinedGlyph,
  });

  final String letterName;
  final String standaloneGlyph;
  final String joinedGlyph;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D7C5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            letterName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.kidsArabicWordsAloneLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          Text(
            standaloneGlyph,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Noto Naskh Arabic',
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsArabicWordsInWordLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          Text(
            joinedGlyph,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Noto Naskh Arabic',
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
        ],
      ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.palette.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: context.palette.onSurfaceSubtle,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      fillColor: Colors.white,
      borderColor: context.palette.surfaceSoft,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: context.palette.onSurfaceSubtle,
        ),
      ),
    );
  }
}
