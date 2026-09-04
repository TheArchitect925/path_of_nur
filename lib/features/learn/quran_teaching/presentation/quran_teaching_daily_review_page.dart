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
import '../domain/quran_teaching_review_models.dart';
import 'quran_teaching_review_presenter.dart';
import 'quran_teaching_theme.dart';
import 'widgets/quran_teaching_asset_widgets.dart';
import 'widgets/quran_teaching_review_widgets.dart';
import '../../../../core/theme/app_fonts.dart';

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
    final l10n = AppLocalizations.of(context);
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

    return AppPageScaffold(
      title: l10n.batch9DailyReviewTitle,
      subtitle: l10n.batch9DailyReviewFallbackSummary,
      children: [
        QuranTeachingReviewSessionHeader(
          current: session?.completedItemRefs.length ?? 0,
          total: session?.itemRefs.length ?? 0,
          summary: session?.mixSummary.isNotEmpty == true
              ? session!.mixSummary
              : l10n.batch9DailyReviewFallbackSummary,
        ),
        const SizedBox(height: 12),
        if (session == null || session.itemRefs.isEmpty)
          PremiumCard(
            child: Text(
              reviewState.records.isEmpty
                  ? l10n.quranTeachingDailyReviewEmptyStart
                  : l10n.quranTeachingDailyReviewEmptyNoDue,
            ),
          ),
        if (session != null &&
            session.itemRefs.isNotEmpty &&
            currentRef != null &&
            currentRecord == null &&
            currentMistake == null)
          PremiumCard(
            child: Text(l10n.quranTeachingDailyReviewItemUnavailable),
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
                    child: Text(l10n.quranTeachingDailyReviewRememberedAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _submitSelfCheck(currentRecord, false),
                    child: Text(
                      l10n.quranTeachingDailyReviewNeedAnotherPassAction,
                    ),
                  ),
                ),
              ],
            ),
          if (_feedback == null &&
              !QuranTeachingReviewPresenter.isSelfCheck(currentRecord))
            FilledButton(
              onPressed: () => _submitRecord(currentRecord),
              child: Text(l10n.batch9CheckAnswerAction),
            ),
          if (_feedback != null)
            FilledButton(
              onPressed: () => _advance(currentRef!),
              child: Text(l10n.quranTeachingDailyReviewNextItemAction),
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
              child: Text(l10n.batch9CheckAnswerAction),
            ),
          if (_feedback != null)
            FilledButton(
              onPressed: () => _advance(currentRef!),
              child: Text(l10n.quranTeachingDailyReviewNextItemAction),
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
              ref
                  .read(quranTeachingSmartReviewProvider.notifier)
                  .ensureTodaySession(
                    catalog: catalog,
                    progress: progress,
                    mistakes: mistakes,
                  );
            },
            child: Text(l10n.quranTeachingDailyReviewMoreLaterAction),
          ),
        ],
      ],
    );
  }

  String? _currentRef(QuranTeachingDailyReviewSession? session) {
    if (session == null) return null;
    for (final itemRef in session.itemRefs) {
      if (!session.completedItemRefs.contains(itemRef)) return itemRef;
    }
    return null;
  }

  Future<void> _playAudio(QuranAudioCue audio) async {
    final l10n = AppLocalizations.of(context);
    final played = await ref
        .read(quranTeachingAudioPlaybackServiceProvider)
        .playCue(audio);
    if (!mounted || played) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.batch9AudioNotAddedYet(audio.label))),
    );
  }

  void _submitSelfCheck(QuranTeachingReviewRecord record, bool correct) {
    final l10n = AppLocalizations.of(context);
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .recordDailyReviewOutcome(recordId: record.id, correct: correct);
    setState(() {
      _wasCorrect = correct;
      _feedback = correct
          ? l10n.batch9ReviewCorrectFeedback
          : l10n.batch9ReviewRetryFeedback;
      _revealed = true;
    });
  }

  void _submitRecord(QuranTeachingReviewRecord record) {
    final l10n = AppLocalizations.of(context);
    final correct = QuranTeachingReviewPresenter.isCorrectRecordAnswer(
      record: record,
      selectedOptionId: _selectedOptionId,
      selectedTrueFalse: _selectedTrueFalse,
      selectedTokens: _selectedTokens,
    );
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .recordDailyReviewOutcome(recordId: record.id, correct: correct);
    setState(() {
      _wasCorrect = correct;
      _feedback = correct
          ? l10n.quranTeachingDailyReviewCorrectFeedback
          : record.hintText ?? l10n.quranTeachingDailyReviewRetryFeedback;
    });
  }

  void _submitMistake(QuranTeachingMistakeItem item) {
    final correct = QuranTeachingReviewPresenter.isCorrectMistakeAnswer(
      item: item,
      selectedOptionId: _selectedOptionId,
      selectedTrueFalse: _selectedTrueFalse,
      selectedTokens: _selectedTokens,
    );
    ref
        .read(quranTeachingMistakeQueueProvider.notifier)
        .recordReviewResult(item.quizId, correct: correct);
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .recordMistakeReviewOutcome(item: item, correct: correct);
    setState(() {
      _wasCorrect = correct;
      _feedback = correct ? item.feedbackCorrect : item.feedbackIncorrect;
    });
  }

  void _advance(String itemRef) {
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .completeTodayItem(itemRef: itemRef, correct: _wasCorrect == true);
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
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.prompt,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
                style: const TextStyle(fontSize: 36, fontFamily: AppFonts.quranArabic),
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
                  color: context.palette.onSurfaceSubtle,
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
                  label: l10n.quranTeachingDailyReviewReplayAudioAction,
                  onAvailablePressed: () => onPlayAudio(record.audio!),
                ),
              if (!revealed)
                OutlinedButton.icon(
                  onPressed: onReveal,
                  icon: const Icon(Icons.visibility_rounded),
                  label: Text(l10n.quranTeachingDailyReviewRevealAction),
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
                  onTap: feedback == null
                      ? () => onSelectOption(option.id)
                      : null,
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
                              fontFamily: AppFonts.quranArabic,
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
                      onSelected: feedback == null
                          ? (_) => onToggleToken(option.label)
                          : null,
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
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.prompt,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (item.promptArabic != null) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                item.promptArabic!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 34, fontFamily: AppFonts.quranArabic),
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
              label: l10n.quranTeachingDailyReviewReplayAudioAction,
              onAvailablePressed: () => onPlayAudio(item.audio!),
            ),
          ],
          const SizedBox(height: 14),
          if (item.quizType == QuranTeachingQuizType.trueFalse)
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.quranTeachingDailyReviewTrue),
                    selected: selectedTrueFalse == true,
                    onSelected: feedback == null
                        ? (_) => onSelectTrueFalse(true)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.quranTeachingDailyReviewFalse),
                    selected: selectedTrueFalse == false,
                    onSelected: feedback == null
                        ? (_) => onSelectTrueFalse(false)
                        : null,
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
                      onSelected: feedback == null
                          ? (_) => onToggleToken(option.label)
                          : null,
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
                  onTap: feedback == null
                      ? () => onSelectOption(option.id)
                      : null,
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
                              fontFamily: AppFonts.quranArabic,
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
