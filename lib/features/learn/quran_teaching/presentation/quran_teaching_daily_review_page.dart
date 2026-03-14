import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_controller.dart';
import '../application/quran_teaching_smart_review_controller.dart';
import '../domain/quran_teaching_models.dart';
import '../domain/quran_teaching_review_models.dart';
import 'quran_teaching_review_presenter.dart';
import 'quran_teaching_theme.dart';
import 'widgets/quran_teaching_asset_widgets.dart';
import 'widgets/quran_teaching_review_widgets.dart';

class QuranTeachingDailyReviewPage extends ConsumerStatefulWidget {
  const QuranTeachingDailyReviewPage({super.key});

  @override
  ConsumerState<QuranTeachingDailyReviewPage> createState() =>
      _QuranTeachingDailyReviewPageState();
}

class _QuranTeachingDailyReviewPageState
    extends ConsumerState<QuranTeachingDailyReviewPage> {
  String? _selectedOptionId;
  bool? _selectedTrueFalse;
  final List<String> _selectedTokens = <String>[];
  String? _feedback;
  bool? _wasCorrect;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final progress = ref.watch(quranTeachingProgressProvider);
    final mistakes = ref.watch(quranTeachingActiveMistakesProvider);
    final reviewState = ref.watch(quranTeachingSmartReviewProvider);
    final session = reviewState.todaySession;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = ref.read(quranTeachingSmartReviewProvider.notifier);
      controller.ensureTodaySession(
        catalog: catalog,
        progress: progress,
        mistakes: mistakes,
      );
      controller.startTodaySession();
    });

    final currentRef = _currentRef(session);
    final currentRecord = currentRef != null && currentRef.startsWith('record:')
        ? reviewState.records[currentRef.replaceFirst('record:', '')]
        : null;
    QuranTeachingMistakeItem? currentMistake;
    if (currentRef != null && currentRef.startsWith('mistake:')) {
      final quizId = currentRef.replaceFirst('mistake:', '');
      for (final item in mistakes) {
        if (item.quizId == quizId) {
          currentMistake = item;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Review')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            QuranTeachingReviewSessionHeader(
              current: session?.completedItemRefs.length ?? 0,
              total: session?.itemRefs.length ?? 0,
              summary: session?.mixSummary.isNotEmpty == true
                  ? session!.mixSummary
                  : 'A short mixed review built from what you have learned so far.',
            ),
            const SizedBox(height: 12),
            if (session == null || session.itemRefs.isEmpty)
              PremiumCard(
                child: Text(
                  reviewState.records.isEmpty
                      ? 'Start a few lessons and your daily review will appear here.'
                      : 'No review due right now. Try a new lesson or open extra practice later.',
                ),
              ),
            if (session != null &&
                session.itemRefs.isNotEmpty &&
                currentRef != null &&
                currentRecord == null &&
                currentMistake == null)
              const PremiumCard(
                child: Text('This review item is no longer available.'),
              ),
            if (currentRecord != null) ...[
              _RecordReviewCard(
                record: currentRecord,
                selectedOptionId: _selectedOptionId,
                selectedTrueFalse: _selectedTrueFalse,
                selectedTokens: _selectedTokens,
                feedback: _feedback,
                wasCorrect: _wasCorrect,
                revealed: _revealed,
                onSelectOption: (id) {
                  if (_feedback != null) return;
                  setState(() => _selectedOptionId = id);
                },
                onSelectTrueFalse: (value) {
                  if (_feedback != null) return;
                  setState(() => _selectedTrueFalse = value);
                },
                onToggleToken: (value) {
                  if (_feedback != null) return;
                  setState(() {
                    if (_selectedTokens.contains(value)) {
                      _selectedTokens.remove(value);
                    } else {
                      _selectedTokens.add(value);
                    }
                  });
                },
                onReveal: () => setState(() => _revealed = true),
                onPlayAudio: _playAudio,
              ),
              const SizedBox(height: 12),
              if (_feedback == null &&
                  QuranTeachingReviewPresenter.isSelfCheck(currentRecord))
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _submitSelfCheck(currentRecord, true),
                        child: const Text('I remembered it'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _submitSelfCheck(currentRecord, false),
                        child: const Text('Need another pass'),
                      ),
                    ),
                  ],
                ),
              if (_feedback == null &&
                  !QuranTeachingReviewPresenter.isSelfCheck(currentRecord))
                FilledButton(
                  onPressed: () => _submitRecord(currentRecord),
                  child: const Text('Check answer'),
                ),
              if (_feedback != null)
                FilledButton(
                  onPressed: () => _advance(currentRef!),
                  child: const Text('Next review item'),
                ),
            ],
            if (currentMistake != null) ...[
              _MistakeReviewCard(
                item: currentMistake,
                selectedOptionId: _selectedOptionId,
                selectedTrueFalse: _selectedTrueFalse,
                selectedTokens: _selectedTokens,
                feedback: _feedback,
                wasCorrect: _wasCorrect,
                onSelectOption: (id) {
                  if (_feedback != null) return;
                  setState(() => _selectedOptionId = id);
                },
                onSelectTrueFalse: (value) {
                  if (_feedback != null) return;
                  setState(() => _selectedTrueFalse = value);
                },
                onToggleToken: (value) {
                  if (_feedback != null) return;
                  setState(() {
                    if (_selectedTokens.contains(value)) {
                      _selectedTokens.remove(value);
                    } else {
                      _selectedTokens.add(value);
                    }
                  });
                },
                onPlayAudio: _playAudio,
              ),
              const SizedBox(height: 12),
              if (_feedback == null)
                FilledButton(
                  onPressed: () => _submitMistake(currentMistake!),
                  child: const Text('Check answer'),
                ),
              if (_feedback != null)
                FilledButton(
                  onPressed: () => _advance(currentRef!),
                  child: const Text('Next review item'),
                ),
            ],
            if (session?.isComplete == true) ...[
              QuranTeachingReviewCompletionCard(
                correctCount: session!.correctCount,
                needsMoreCount: session.needsMoreCount,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () {
                  ref.read(quranTeachingSmartReviewProvider.notifier).ensureTodaySession(
                        catalog: catalog,
                        progress: progress,
                        mistakes: mistakes,
                      );
                },
                child: const Text('Review more later'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _currentRef(QuranTeachingDailyReviewSession? session) {
    if (session == null) return null;
    for (final itemRef in session.itemRefs) {
      if (!session.completedItemRefs.contains(itemRef)) return itemRef;
    }
    return null;
  }

  void _playAudio(QuranAudioCue audio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Audio ready for ${audio.label}.')),
    );
  }

  void _submitSelfCheck(QuranTeachingReviewRecord record, bool correct) {
    ref.read(quranTeachingSmartReviewProvider.notifier).recordDailyReviewOutcome(
          recordId: record.id,
          correct: correct,
        );
    setState(() {
      _wasCorrect = correct;
      _feedback = correct
          ? 'Nice. This one is getting stronger.'
          : 'That is fine. This item will come back sooner.';
      _revealed = true;
    });
  }

  void _submitRecord(QuranTeachingReviewRecord record) {
    final correct = QuranTeachingReviewPresenter.isCorrectRecordAnswer(
      record: record,
      selectedOptionId: _selectedOptionId,
      selectedTrueFalse: _selectedTrueFalse,
      selectedTokens: _selectedTokens,
    );
    ref.read(quranTeachingSmartReviewProvider.notifier).recordDailyReviewOutcome(
          recordId: record.id,
          correct: correct,
        );
    setState(() {
      _wasCorrect = correct;
      _feedback = correct
          ? 'Correct. This item is settling in.'
          : record.hintText ?? 'Not quite. This one will return sooner.';
    });
  }

  void _submitMistake(QuranTeachingMistakeItem item) {
    final correct = QuranTeachingReviewPresenter.isCorrectMistakeAnswer(
      item: item,
      selectedOptionId: _selectedOptionId,
      selectedTrueFalse: _selectedTrueFalse,
      selectedTokens: _selectedTokens,
    );
    ref.read(quranTeachingMistakeQueueProvider.notifier).recordReviewResult(
          item.quizId,
          correct: correct,
        );
    ref.read(quranTeachingSmartReviewProvider.notifier).recordMistakeReviewOutcome(
          item: item,
          correct: correct,
        );
    setState(() {
      _wasCorrect = correct;
      _feedback = correct ? item.feedbackCorrect : item.feedbackIncorrect;
    });
  }

  void _advance(String itemRef) {
    ref.read(quranTeachingSmartReviewProvider.notifier).completeTodayItem(
          itemRef: itemRef,
          correct: _wasCorrect == true,
        );
    setState(() {
      _selectedOptionId = null;
      _selectedTrueFalse = null;
      _selectedTokens.clear();
      _feedback = null;
      _wasCorrect = null;
      _revealed = false;
    });
  }

}

class _RecordReviewCard extends StatelessWidget {
  const _RecordReviewCard({
    required this.record,
    required this.selectedOptionId,
    required this.selectedTrueFalse,
    required this.selectedTokens,
    required this.feedback,
    required this.wasCorrect,
    required this.revealed,
    required this.onSelectOption,
    required this.onSelectTrueFalse,
    required this.onToggleToken,
    required this.onReveal,
    required this.onPlayAudio,
  });

  final QuranTeachingReviewRecord record;
  final String? selectedOptionId;
  final bool? selectedTrueFalse;
  final List<String> selectedTokens;
  final String? feedback;
  final bool? wasCorrect;
  final bool revealed;
  final ValueChanged<String> onSelectOption;
  final ValueChanged<bool> onSelectTrueFalse;
  final ValueChanged<String> onToggleToken;
  final VoidCallback onReveal;
  final ValueChanged<QuranAudioCue> onPlayAudio;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.prompt,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              QuranTeachingMemoryStateChip(memoryState: record.memoryState),
            ],
          ),
          if (record.promptSecondary != null) ...[
            const SizedBox(height: 6),
            Text(record.promptSecondary!),
          ],
          if (record.promptArabic != null) ...[
            const SizedBox(height: 14),
            Center(
              child: Text(
                record.promptArabic!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 36, fontFamily: 'AmiriQuran'),
              ),
            ),
          ],
          if (record.transliteration != null && revealed) ...[
            const SizedBox(height: 8),
            Center(child: Text(record.transliteration!)),
          ],
          if (record.meaning != null && revealed) ...[
            const SizedBox(height: 6),
            Center(
              child: Text(
                record.meaning!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (record.audio != null)
                QuranTeachingAudioIconButton(
                  audio: record.audio,
                  availableIcon: Icons.volume_up_rounded,
                  label: 'Replay audio',
                  onAvailablePressed: () => onPlayAudio(record.audio!),
                ),
              if (!revealed)
                OutlinedButton.icon(
                  onPressed: onReveal,
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('Reveal'),
                ),
            ],
          ),
          if (record.options.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...record.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: feedback == null ? () => onSelectOption(option.id) : null,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: QuranTeachingTheme.borderedOptionContainer(
                      context: context,
                      selected: selectedOptionId == option.id,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (option.arabic != null)
                          Text(
                            option.arabic!,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'AmiriQuran',
                            ),
                          ),
                        Text(option.label),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (record.buildOrder.isNotEmpty && record.options.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: record.options
                  .map(
                    (option) => FilterChip(
                      label: Text(option.arabic ?? option.label),
                      selected: selectedTokens.contains(option.label),
                      onSelected: feedback == null ? (_) => onToggleToken(option.label) : null,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (feedback != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: QuranTeachingTheme.feedbackContainer(
                wasCorrect == true,
              ),
              child: Text(feedback!),
            ),
          ],
        ],
      ),
    );
  }
}

class _MistakeReviewCard extends StatelessWidget {
  const _MistakeReviewCard({
    required this.item,
    required this.selectedOptionId,
    required this.selectedTrueFalse,
    required this.selectedTokens,
    required this.feedback,
    required this.wasCorrect,
    required this.onSelectOption,
    required this.onSelectTrueFalse,
    required this.onToggleToken,
    required this.onPlayAudio,
  });

  final QuranTeachingMistakeItem item;
  final String? selectedOptionId;
  final bool? selectedTrueFalse;
  final List<String> selectedTokens;
  final String? feedback;
  final bool? wasCorrect;
  final ValueChanged<String> onSelectOption;
  final ValueChanged<bool> onSelectTrueFalse;
  final ValueChanged<String> onToggleToken;
  final ValueChanged<QuranAudioCue> onPlayAudio;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.prompt,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (item.promptArabic != null) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                item.promptArabic!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 34, fontFamily: 'AmiriQuran'),
              ),
            ),
          ],
          if (item.promptSecondary != null) ...[
            const SizedBox(height: 8),
            Text(item.promptSecondary!),
          ],
          if (item.audio != null) ...[
            const SizedBox(height: 10),
            QuranTeachingAudioIconButton(
              audio: item.audio,
              availableIcon: Icons.volume_up_rounded,
              label: 'Replay audio',
              onAvailablePressed: () => onPlayAudio(item.audio!),
            ),
          ],
          const SizedBox(height: 14),
          if (item.quizType == QuranTeachingQuizType.trueFalse)
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('True'),
                    selected: selectedTrueFalse == true,
                    onSelected: feedback == null ? (_) => onSelectTrueFalse(true) : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('False'),
                    selected: selectedTrueFalse == false,
                    onSelected: feedback == null ? (_) => onSelectTrueFalse(false) : null,
                  ),
                ),
              ],
            )
          else if (item.quizType == QuranTeachingQuizType.tapInOrderBuildWord)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.options
                  .map(
                    (option) => FilterChip(
                      label: Text(option.arabic ?? option.label),
                      selected: selectedTokens.contains(option.label),
                      onSelected: feedback == null ? (_) => onToggleToken(option.label) : null,
                    ),
                  )
                  .toList(growable: false),
            )
          else
            ...item.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: feedback == null ? () => onSelectOption(option.id) : null,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: QuranTeachingTheme.borderedOptionContainer(
                      context: context,
                      selected: selectedOptionId == option.id,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (option.arabic != null)
                          Text(
                            option.arabic!,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'AmiriQuran',
                            ),
                          ),
                        Text(option.label),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (feedback != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: QuranTeachingTheme.feedbackContainer(
                wasCorrect == true,
              ),
              child: Text(feedback!),
            ),
          ],
        ],
      ),
    );
  }
}
