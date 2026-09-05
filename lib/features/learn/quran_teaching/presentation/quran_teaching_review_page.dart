import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_audio_playback_service.dart';
import '../application/quran_teaching_controller.dart';
import '../application/quran_teaching_smart_review_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'widgets/quran_teaching_asset_widgets.dart';
import '../../../../core/theme/app_fonts.dart';

enum _ReviewSessionFilter { all, quick, recent, hardest }

class QuranTeachingReviewPage extends ConsumerStatefulWidget {
  const QuranTeachingReviewPage({super.key});

  @override
  ConsumerState<QuranTeachingReviewPage> createState() =>
      _QuranTeachingReviewPageState();
}

class _QuranTeachingReviewPageState
    extends ConsumerState<QuranTeachingReviewPage> {
  _ReviewSessionFilter _filter = _ReviewSessionFilter.all;
  int _index = 0;
  String? _selectedOptionId;
  bool? _selectedTrueFalse;
  final List<String> _selectedTokens = <String>[];
  String? _feedback;
  bool? _wasCorrect;
  bool _sessionStarted = false;
  int _improvedCount = 0;
  int _stillNeedsCount = 0;

  @override
  Widget build(BuildContext context) {
    final mistakes = ref.watch(quranTeachingActiveMistakesProvider);
    final sessionItems = _filteredItems(mistakes);
    final current = sessionItems.isEmpty || _index >= sessionItems.length
        ? null
        : sessionItems[_index];
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return AppPageScaffold(
      title: l10n.triviaReviewMistakesTitle,
      subtitle: l10n.triviaReviewMistakesSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranTeachingReviewPageIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                mistakes.isEmpty
                    ? l10n.quranTeachingReviewPageEmptyBody
                    : l10n.quranTeachingReviewPageCountBody(mistakes.length),
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
                l10n.quranTeachingReviewPageSessionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              SegmentedButton<_ReviewSessionFilter>(
                segments: [
                  ButtonSegment(
                    value: _ReviewSessionFilter.all,
                    label: Text(l10n.quranTeachingReviewPageFilterAll),
                  ),
                  ButtonSegment(
                    value: _ReviewSessionFilter.quick,
                    label: Text(l10n.quranTeachingReviewPageFilterQuick),
                  ),
                  ButtonSegment(
                    value: _ReviewSessionFilter.recent,
                    label: Text(l10n.quranTeachingReviewPageFilterRecent),
                  ),
                  ButtonSegment(
                    value: _ReviewSessionFilter.hardest,
                    label: Text(l10n.quranTeachingReviewPageFilterHardest),
                  ),
                ],
                selected: <_ReviewSessionFilter>{_filter},
                onSelectionChanged: (selection) {
                  setState(() {
                    _filter = selection.first;
                    _index = 0;
                    _sessionStarted = false;
                    _clearAnswerState();
                  });
                },
              ),
              if (!_sessionStarted && sessionItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => setState(() => _sessionStarted = true),
                  child: Text(
                    _filter == _ReviewSessionFilter.quick
                        ? l10n.quranTeachingReviewPageStartQuickAction
                        : l10n.quranTeachingReviewPageStartAction,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (!_sessionStarted && sessionItems.isEmpty)
          PremiumCard(
            child: Text(
              l10n.quranTeachingReviewPageFilterEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        if (_sessionStarted && current != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.quranTeachingReviewPageItemCounter(
                    _index + 1,
                    sessionItems.length,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  current.prompt,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (current.promptArabic != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    current.promptArabic!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 34,
                      fontFamily: AppFonts.quranArabic,
                    ),
                  ),
                ],
                if (current.promptSecondary != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    current.promptSecondary!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (current.audio != null) ...[
                  const SizedBox(height: 10),
                  QuranTeachingAudioIconButton(
                    audio: current.audio,
                    availableIcon: Icons.volume_up_rounded,
                    label: l10n.quranTeachingReviewPageReplayAudioAction,
                    onAvailablePressed: () async {
                      final played = await ref
                          .read(quranTeachingAudioPlaybackServiceProvider)
                          .playCue(current.audio!);
                      if (!mounted || played) {
                        return;
                      }
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.batch9AudioNotAddedYet(current.audio!.label),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 14),
                ..._reviewOptions(current, context),
                if (_feedback != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: (_wasCorrect == true ? Colors.green : Colors.red)
                          .withValues(alpha: 0.10),
                    ),
                    child: Text(_feedback!),
                  ),
                ],
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _feedback == null
                      ? () => _submit(current)
                      : () => _advance(sessionItems),
                  child: Text(
                    _feedback == null
                        ? l10n.quranTeachingReviewPageCheckAnswerAction
                        : l10n.quranTeachingReviewPageNextItemAction,
                  ),
                ),
              ],
            ),
          ),
        if (_sessionStarted && current == null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranTeachingReviewPageCompleteTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.quranTeachingReviewPageImprovedCount(_improvedCount)),
                Text(
                  l10n.quranTeachingReviewPageStillNeedsCount(_stillNeedsCount),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _sessionStarted = false;
                      _index = 0;
                      _clearAnswerState();
                      _improvedCount = 0;
                      _stillNeedsCount = 0;
                    });
                  },
                  child: Text(l10n.quranTeachingReviewPageStartAnotherAction),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<QuranTeachingMistakeItem> _filteredItems(
    List<QuranTeachingMistakeItem> items,
  ) {
    final sorted = [...items];
    switch (_filter) {
      case _ReviewSessionFilter.all:
        return sorted;
      case _ReviewSessionFilter.quick:
        return sorted.take(5).toList(growable: false);
      case _ReviewSessionFilter.recent:
        sorted.sort((a, b) => b.lastWrongAt.compareTo(a.lastWrongAt));
        return sorted;
      case _ReviewSessionFilter.hardest:
        sorted.sort((a, b) => b.totalWrongCount.compareTo(a.totalWrongCount));
        return sorted;
    }
  }

  List<Widget> _reviewOptions(
    QuranTeachingMistakeItem item,
    BuildContext context,
  ) {
    if (item.quizType == QuranTeachingQuizType.trueFalse) {
      return [
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Text(
                  AppLocalizations.of(
                    context,
                  ).quranTeachingReviewPageTrueAction,
                ),
                selected: _selectedTrueFalse == true,
                onSelected: (_) => setState(() => _selectedTrueFalse = true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                label: Text(
                  AppLocalizations.of(
                    context,
                  ).quranTeachingReviewPageFalseAction,
                ),
                selected: _selectedTrueFalse == false,
                onSelected: (_) => setState(() => _selectedTrueFalse = false),
              ),
            ),
          ],
        ),
      ];
    }
    if (item.quizType == QuranTeachingQuizType.tapInOrderBuildWord) {
      return [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: item.options
              .map(
                (option) => FilterChip(
                  label: Text(option.arabic ?? option.label),
                  selected: _selectedTokens.contains(option.label),
                  onSelected: (_) {
                    setState(() {
                      if (_selectedTokens.contains(option.label)) {
                        _selectedTokens.remove(option.label);
                      } else {
                        _selectedTokens.add(option.label);
                      }
                    });
                  },
                ),
              )
              .toList(growable: false),
        ),
      ];
    }
    return item.options
        .map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => setState(() => _selectedOptionId = option.id),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _selectedOptionId == option.id
                        ? Theme.of(context).colorScheme.primary
                        : context.palette.surfaceSoft,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (option.arabic != null)
                      Text(
                        option.arabic!,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: AppFonts.quranArabic,
                        ),
                      ),
                    Text(option.label),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList(growable: false);
  }

  void _submit(QuranTeachingMistakeItem item) {
    final correct = switch (item.quizType) {
      QuranTeachingQuizType.trueFalse => _selectedTrueFalse == item.truthAnswer,
      QuranTeachingQuizType.tapInOrderBuildWord =>
        _selectedTokens.join('|') == item.buildOrder.join('|'),
      _ => item.correctOptionIds.contains(_selectedOptionId),
    };
    ref
        .read(quranTeachingMistakeQueueProvider.notifier)
        .recordReviewResult(item.quizId, correct: correct);
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .recordMistakeReviewOutcome(item: item, correct: correct);
    setState(() {
      _wasCorrect = correct;
      _feedback = correct ? item.feedbackCorrect : item.feedbackIncorrect;
      if (correct) {
        _improvedCount += 1;
      } else {
        _stillNeedsCount += 1;
      }
    });
  }

  void _advance(List<QuranTeachingMistakeItem> sessionItems) {
    setState(() {
      _index += 1;
      _clearAnswerState();
    });
    if (_index >= sessionItems.length) {
      setState(() {});
    }
  }

  void _clearAnswerState() {
    _selectedOptionId = null;
    _selectedTrueFalse = null;
    _selectedTokens.clear();
    _feedback = null;
    _wasCorrect = null;
  }
}
