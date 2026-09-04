import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_practice_provider.dart';
import '../domain/kids_arabic_models.dart';
import '../domain/kids_arabic_word_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';
import '../../../shared/widgets/section_title.dart';

class KidsArabicPracticePage extends ConsumerWidget {
  const KidsArabicPracticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plan = ref.watch(kidsArabicPracticePlanProvider);

    return LearnHubPageScaffold(
      title: l10n.kidsArabicPracticeTitle,
      subtitle: l10n.kidsArabicPracticeSubtitle,
      children: [
        _PracticeSummaryCard(plan: plan),
        const SizedBox(height: 12),
        if (plan.primaryFocus != null) ...[
          _PrimaryFocusCard(focus: plan.primaryFocus!),
          const SizedBox(height: 12),
        ],
        if (plan.continueLetter != null || plan.continueWord != null) ...[
          SectionTitle(
            title: l10n.kidsArabicPracticeContinueSectionTitle,
            subtitle: l10n.kidsArabicPracticeContinueSectionSubtitle,
          ),
          const SizedBox(height: 10),
          if (plan.continueLetter != null) ...[
            _LetterActionCard(
              title: l10n.kidsArabicPracticeContinueLetterTitle(
                plan.continueLetter!.nameAr,
              ),
              body: l10n.kidsArabicPracticeContinueLetterBody,
              actionLabel: l10n.kidsArabicPracticeContinueAction,
              letter: plan.continueLetter!,
            ),
            const SizedBox(height: 10),
          ],
          if (plan.continueWord != null)
            _WordActionCard(
              title: l10n.kidsArabicPracticeContinueWordTitle(
                plan.continueWord!.wordAr,
              ),
              body: l10n.kidsArabicPracticeContinueWordBody(
                localizedKidsArabicWordMeaning(l10n, plan.continueWord!.id),
              ),
              actionLabel: l10n.kidsArabicPracticeContinueAction,
              word: plan.continueWord!,
              openTrace: true,
            ),
          const SizedBox(height: 18),
        ],
        if (plan.reviewLetters.isNotEmpty || plan.reviewWords.isNotEmpty) ...[
          SectionTitle(
            title: l10n.kidsArabicPracticeReviewSectionTitle,
            subtitle: l10n.kidsArabicPracticeReviewSectionSubtitle,
          ),
          const SizedBox(height: 10),
          if (plan.reviewLetters.isNotEmpty) ...[
            _ReviewLettersCard(letters: plan.reviewLetters),
            const SizedBox(height: 10),
          ],
          if (plan.reviewWords.isNotEmpty)
            _ReviewWordsCard(words: plan.reviewWords),
        ],
      ],
    );
  }
}

class _PracticeSummaryCard extends StatelessWidget {
  const _PracticeSummaryCard({required this.plan});

  final KidsArabicPracticePlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.practicedToday
                ? l10n.kidsArabicPracticeTodayDoneTitle
                : l10n.kidsArabicPracticeTodayTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            plan.practicedToday
                ? l10n.kidsArabicPracticeTodayDoneBody
                : l10n.kidsArabicPracticeTodayBody,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryPill(
                label: l10n.kidsArabicLettersCompletedValue(
                  plan.completedLettersCount,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicWordsCompletedValue(
                  plan.completedWordsCount,
                ),
              ),
              if (plan.practicedToday)
                _SummaryPill(label: l10n.kidsArabicPracticeTodayDoneBadge),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryFocusCard extends StatelessWidget {
  const _PrimaryFocusCard({required this.focus});

  final KidsArabicPracticeFocus focus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (focus.type) {
      KidsArabicPracticeFocusType.dailyNewLetter =>
        l10n.kidsArabicPracticeDailyNewLetterTitle(focus.letter!.nameAr),
      KidsArabicPracticeFocusType.dailyReviewLetter =>
        l10n.kidsArabicPracticeDailyReviewTitle(focus.letter!.nameAr),
      KidsArabicPracticeFocusType.dailyTraceLetter =>
        l10n.kidsArabicPracticeDailyTraceTitle(focus.letter!.nameAr),
      KidsArabicPracticeFocusType.continueLetter =>
        l10n.kidsArabicPracticeContinueLetterTitle(focus.letter!.nameAr),
      KidsArabicPracticeFocusType.continueWord =>
        l10n.kidsArabicPracticeContinueWordTitle(focus.word!.wordAr),
      KidsArabicPracticeFocusType.reviewLetter =>
        l10n.kidsArabicPracticeReviewLetterTitle(focus.letter!.nameAr),
      KidsArabicPracticeFocusType.reviewWord =>
        l10n.kidsArabicPracticeReviewWordTitle(focus.word!.wordAr),
    };
    final body = switch (focus.type) {
      KidsArabicPracticeFocusType.dailyNewLetter =>
        l10n.kidsArabicPracticeDailyNewLetterBody,
      KidsArabicPracticeFocusType.dailyReviewLetter =>
        l10n.kidsArabicPracticeDailyReviewBody,
      KidsArabicPracticeFocusType.dailyTraceLetter =>
        l10n.kidsArabicPracticeDailyTraceBody,
      KidsArabicPracticeFocusType.continueLetter =>
        l10n.kidsArabicPracticeContinueLetterBody,
      KidsArabicPracticeFocusType.continueWord =>
        l10n.kidsArabicPracticeContinueWordBody(
          localizedKidsArabicWordMeaning(l10n, focus.word!.id),
        ),
      KidsArabicPracticeFocusType.reviewLetter =>
        l10n.kidsArabicPracticeReviewLetterBody,
      KidsArabicPracticeFocusType.reviewWord =>
        l10n.kidsArabicPracticeReviewWordBody,
    };
    final actionLabel = switch (focus.type) {
      KidsArabicPracticeFocusType.dailyReviewLetter ||
      KidsArabicPracticeFocusType.reviewLetter =>
        l10n.kidsArabicPracticeReviewAction,
      KidsArabicPracticeFocusType.reviewWord =>
        l10n.kidsArabicPracticeReadAction,
      KidsArabicPracticeFocusType.continueWord =>
        l10n.kidsArabicPracticeContinueAction,
      _ => l10n.kidsArabicPracticeTodayAction,
    };

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
            l10n.kidsArabicPracticePrimaryTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.palette.successInk,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(color: context.palette.successInk, height: 1.35),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _openFocus(context, focus),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }

  static void _openFocus(BuildContext context, KidsArabicPracticeFocus focus) {
    switch (focus.type) {
      case KidsArabicPracticeFocusType.dailyNewLetter:
      case KidsArabicPracticeFocusType.dailyTraceLetter:
      case KidsArabicPracticeFocusType.continueLetter:
        context.pushNamed(
          'kidsArabicLesson',
          pathParameters: {'letterId': focus.letter!.id},
        );
      case KidsArabicPracticeFocusType.dailyReviewLetter:
      case KidsArabicPracticeFocusType.reviewLetter:
        context.pushNamed('kidsArabicReview');
      case KidsArabicPracticeFocusType.continueWord:
        context.pushNamed(
          'kidsArabicWordLesson',
          pathParameters: {'wordId': focus.word!.id},
        );
      case KidsArabicPracticeFocusType.reviewWord:
        context.pushNamed(
          'kidsArabicReadingMode',
          queryParameters: {'word': focus.word!.id},
        );
    }
  }
}

class _LetterActionCard extends StatelessWidget {
  const _LetterActionCard({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.letter,
  });

  final String title;
  final String body;
  final String actionLabel;
  final KidsArabicLetter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              letter.glyph,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 34,
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.pushNamed(
                    'kidsArabicLesson',
                    pathParameters: {'letterId': letter.id},
                  ),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WordActionCard extends StatelessWidget {
  const _WordActionCard({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.word,
    required this.openTrace,
  });

  final String title;
  final String body;
  final String actionLabel;
  final KidsArabicBeginnerWord word;
  final bool openTrace;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD1E2F4)),
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
              word.wordAr,
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF24324A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF4A5870),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.pushNamed(
                    openTrace
                        ? 'kidsArabicWordLesson'
                        : 'kidsArabicReadingMode',
                    pathParameters: openTrace
                        ? {'wordId': word.id}
                        : <String, String>{},
                    queryParameters: openTrace
                        ? <String, String>{}
                        : {'word': word.id},
                  ),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewLettersCard extends StatelessWidget {
  const _ReviewLettersCard({required this.letters});

  final List<KidsArabicLetter> letters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D0B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicPracticeReviewLettersTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicPracticeReviewLettersBody,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: letters
                .map((letter) => _CompletedChip(label: letter.glyph))
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.pushNamed('kidsArabicReview'),
            child: Text(l10n.kidsArabicPracticeReviewAction),
          ),
        ],
      ),
    );
  }
}

class _ReviewWordsCard extends StatelessWidget {
  const _ReviewWordsCard({required this.words});

  final List<KidsArabicBeginnerWord> words;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD5E6CF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicPracticeReviewWordsTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicPracticeReviewWordsBody,
            style: TextStyle(color: context.palette.successInk, height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words
                .map(
                  (word) => ActionChip(
                    label: Text(word.wordAr, textDirection: TextDirection.rtl),
                    onPressed: () => context.pushNamed(
                      'kidsArabicReadingMode',
                      queryParameters: {'word': word.id},
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      fillColor: Colors.white,
      borderColor: const Color(0xFFE3D7C8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6F5A43),
        ),
      ),
    );
  }
}

class _CompletedChip extends StatelessWidget {
  const _CompletedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DCCF)),
      ),
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Noto Naskh Arabic',
          fontWeight: FontWeight.w700,
          color: context.palette.onSurface,
        ),
      ),
    );
  }
}
