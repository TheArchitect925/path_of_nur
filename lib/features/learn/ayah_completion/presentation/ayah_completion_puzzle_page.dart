import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../../../shared/widgets/quran_verse_content.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/application/knowledge_game_variation_engine.dart';
import '../../knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import '../../knowledge_games/domain/knowledge_game_variations.dart';
import '../../quran/application/quran_player_controller.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_playback_request.dart';
import '../application/ayah_completion_game_adapter.dart';
import '../application/ayah_completion_progress_provider.dart';
import '../application/ayah_completion_repository.dart';
import '../domain/ayah_completion_models.dart';
import 'ayah_completion_ui_helpers.dart';

class AyahCompletionPuzzlePage extends ConsumerStatefulWidget {
  const AyahCompletionPuzzlePage({
    super.key,
    this.puzzleId,
    this.dailyMode = false,
    this.packId,
  });

  final String? puzzleId;
  final bool dailyMode;
  final String? packId;

  @override
  ConsumerState<AyahCompletionPuzzlePage> createState() =>
      _AyahCompletionPuzzlePageState();
}

class _AyahCompletionPuzzlePageState
    extends ConsumerState<AyahCompletionPuzzlePage> {
  AyahCompletionPuzzle? _boundPuzzle;

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMode) {
      final dailyAsync = ref.watch(ayahCompletionDailyPuzzleProvider);
      return dailyAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildLoadError(context),
        data: (daily) => _buildLoaded(context, daily.puzzle, daily: daily),
      );
    }
    final puzzleAsync = ref.watch(
      ayahCompletionPuzzleByIdProvider(widget.puzzleId ?? ''),
    );
    return puzzleAsync.when(
      loading: () => _buildLoading(context),
      error: (_, _) => _buildLoadError(context),
      data: (puzzle) {
        if (puzzle == null) return _buildNotFound(context);
        return _buildLoaded(context, puzzle);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).ayahCompletionHomeTitle,
      subtitle: AppLocalizations.of(context).ayahCompletionLoadingSubtitle,
      children: const [Center(child: CircularProgressIndicator())],
    );
  }

  Widget _buildLoadError(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).ayahCompletionHomeTitle,
      subtitle: AppLocalizations.of(context).ayahCompletionLoadErrorSubtitle,
      children: [
        PremiumCard(
          child: Text(
            AppLocalizations.of(context).ayahCompletionLoadErrorTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).ayahCompletionHomeTitle,
      subtitle: AppLocalizations.of(context).ayahCompletionNotFoundSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).ayahCompletionNotFoundTitle),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    AyahCompletionPuzzle puzzle, {
    AyahCompletionDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    if (isChildProfile && puzzle.mode != AyahCompletionMode.kids) {
      return AppPageScaffold(
        title: l10n.ayahCompletionHomeTitle,
        subtitle: l10n.ayahCompletionNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.ayahCompletionKidsOnlyTitle))],
      );
    }

    final progressState = ref.watch(ayahCompletionProgressProvider);
    final progress = progressState.progressFor(puzzle.id);
    final dailyProgress = daily == null
        ? null
        : progressState.dailyProgressFor(daily.dateKey);
    final dailyStreak = daily == null
        ? null
        : progressState.dailyStreakSummary(DateTime.now());
    _bindPuzzleIfNeeded(puzzle, daily: daily);

    final adapter = ref.watch(ayahCompletionGameAdapterProvider);
    final variationConfig = _variationConfig(daily);
    final game = adapter.toGame(puzzle).copyWith(config: variationConfig);
    final session = adapter
        .createSession(game: puzzle, progress: progress)
        .copyWith(config: variationConfig);
    final result = adapter
        .evaluate(
          game: puzzle,
          progress: progress,
          xpEarned: progress.isCompleted ? (progress.isPerfect ? 2 : 1) : 0,
          dropsEarned: _countCorrectBlanks(puzzle, progress),
        )
        .copyWith(config: variationConfig);
    final selectedBlank = _selectedBlank(puzzle, progress);
    final title = ayahCompletionPuzzleTitle(l10n, puzzle);
    final subtitle = daily != null
        ? l10n.ayahCompletionDailyPuzzleSubtitle(
            ayahCompletionLocalizedCategory(l10n, daily.weekdayTheme),
          )
        : l10n.ayahCompletionPuzzleSubtitle(
            ayahCompletionLocalizedCategory(l10n, puzzle.category),
            puzzle.blanks.length.toString(),
          );

    final catalog = ref.watch(ayahCompletionCatalogProvider).valueOrNull;
    final pack = catalog?.packsById[widget.packId ?? ''];
    final nextPackPuzzleId = pack?.puzzleIds.firstWhere(
      (id) => id != puzzle.id && !progressState.progressFor(id).isCompleted,
      orElse: () => '',
    );

    return adapter.buildScreen(
      context: context,
      title: title,
      subtitle: subtitle,
      game: game,
      session: session,
      result: result,
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                l10n.ayahCompletionProgressCountLabel(
                  _countCorrectBlanks(puzzle, progress).toString(),
                  puzzle.blanks.length.toString(),
                ),
              ),
              _chip(
                context,
                ayahCompletionDifficultyLabel(l10n, puzzle.difficulty),
              ),
              if (daily != null)
                _chip(
                  context,
                  l10n.ayahCompletionDailyThemeLabel(
                    ayahCompletionLocalizedCategory(l10n, daily.weekdayTheme),
                  ),
                ),
              if (dailyStreak != null && dailyStreak.currentStreak > 0)
                _chip(
                  context,
                  l10n.ayahCompletionDailyStreakLabel(
                    dailyStreak.currentStreak.toString(),
                  ),
                ),
              if (pack != null)
                _chip(context, ayahCompletionPackTitle(l10n, pack)),
              if (progress.isPerfect)
                _chip(context, l10n.ayahCompletionPerfectBadge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        QuranReferenceLinkTile.forRef(
          referenceLabel: puzzle.ref.locationLabel,
          ref: puzzle.ref,
          subtitle: l10n.ayahCompletionReferenceSubtitle,
        ),
        const SizedBox(height: 4),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.ayahCompletionVerseSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _BlankedAyahView(
                puzzle: puzzle,
                progress: progress,
                onSelectBlank: (blankIndex) => _selectBlank(puzzle, blankIndex),
              ),
              const SizedBox(height: 12),
              Text(
                puzzle.translation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (variationConfig.hasVariation(GameVariationType.audio)) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.gameVariationAudioActiveSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _playAyah(puzzle),
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: Text(l10n.ayahCompletionPlayAyahAction),
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
                l10n.ayahCompletionHintSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed:
                    variationConfig.hasVariation(GameVariationType.challenge) &&
                        variationConfig.boolSetting('hintDisabled')
                    ? null
                    : _canRevealBlank(puzzle, progress)
                    ? () => _useRevealBlank(puzzle)
                    : null,
                icon: const Icon(Icons.lightbulb_outline_rounded),
                label: Text(l10n.ayahCompletionRevealBlankAction),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.ayahCompletionHintUsageLabel(
                  progress.revealBlankUses.toString(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
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
                l10n.ayahCompletionBlankSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                selectedBlank == null
                    ? l10n.ayahCompletionBlankPrompt
                    : l10n.ayahCompletionBlankSelectedLabel(
                        (selectedBlank.blankIndex + 1).toString(),
                      ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final blank in puzzle.blanks)
                    ChoiceChip(
                      label: Text(
                        l10n.ayahCompletionBlankChipLabel(
                          (blank.blankIndex + 1).toString(),
                        ),
                      ),
                      selected: progress.selectedBlankIndex == blank.blankIndex,
                      onSelected: (_) => _selectBlank(puzzle, blank.blankIndex),
                    ),
                ],
              ),
              if (selectedBlank != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in selectedBlank.options)
                      OutlinedButton(
                        onPressed: () => _applyOption(
                          puzzle,
                          blank: selectedBlank,
                          option: option,
                          daily: daily,
                        ),
                        child: Text(option, textDirection: TextDirection.rtl),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: result.completed
              ? PremiumCard(
                  key: const ValueKey('ayah-completion-complete'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ayahCompletionCompletionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.perfect
                            ? l10n.ayahCompletionPerfectSubtitle
                            : l10n.ayahCompletionCompletionSubtitle,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _rewardChip(
                            context,
                            l10n.ayahCompletionCompletionXpReward,
                          ),
                          _rewardChip(
                            context,
                            l10n.ayahCompletionBlankDropReward,
                          ),
                          if (result.perfect)
                            _rewardChip(
                              context,
                              l10n.ayahCompletionPerfectBonusReward,
                            ),
                          if (dailyProgress?.isCompleted == true)
                            _rewardChip(
                              context,
                              l10n.ayahCompletionDailyCompleteBadge,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      QuranVerseContent(
                        source: QuranVerseSource(ref: puzzle.ref),
                        dense: true,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if ((nextPackPuzzleId ?? '').isNotEmpty)
                            FilledButton.tonalIcon(
                              onPressed: () => context.pushNamed(
                                'learnAyahCompletionPuzzle',
                                pathParameters: {'puzzleId': nextPackPuzzleId!},
                                queryParameters: pack == null
                                    ? const <String, String>{}
                                    : {'pack': pack.id},
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(l10n.ayahCompletionNextPuzzleAction),
                            ),
                          if (pack != null)
                            FilledButton.tonalIcon(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.grid_view_rounded),
                              label: Text(
                                l10n.ayahCompletionReturnToPackAction,
                              ),
                            ),
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                context.goNamed('learnAyahCompletionHome'),
                            icon: const Icon(Icons.home_rounded),
                            label: Text(l10n.ayahCompletionBackHomeAction),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _bindPuzzleIfNeeded(
    AyahCompletionPuzzle puzzle, {
    AyahCompletionDailyPuzzle? daily,
  }) {
    if (_boundPuzzle?.id == puzzle.id) return;
    _boundPuzzle = puzzle;
    final now = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ayahCompletionProgressProvider.notifier)
          .markPuzzlePlayed(puzzleId: puzzle.id, occurredAt: now);
      if (daily != null) {
        ref
            .read(ayahCompletionProgressProvider.notifier)
            .markDailyStarted(
              dateKey: daily.dateKey,
              puzzleId: puzzle.id,
              weekdayTheme: daily.weekdayTheme,
              occurredAt: now,
            );
      }
    });
  }

  AyahCompletionBlank? _selectedBlank(
    AyahCompletionPuzzle puzzle,
    AyahCompletionPuzzleProgress progress,
  ) {
    final selectedIndex = progress.selectedBlankIndex;
    if (selectedIndex == null) return null;
    for (final blank in puzzle.blanks) {
      if (blank.blankIndex == selectedIndex) return blank;
    }
    return null;
  }

  int _countCorrectBlanks(
    AyahCompletionPuzzle puzzle,
    AyahCompletionPuzzleProgress progress,
  ) {
    var count = 0;
    for (final blank in puzzle.blanks) {
      final value =
          progress.filledWordsByBlankIndex[blank.blankIndex.toString()];
      if (value == blank.correctWord) count += 1;
    }
    return count;
  }

  void _selectBlank(AyahCompletionPuzzle puzzle, int blankIndex) {
    final daily = widget.dailyMode
        ? ref.read(ayahCompletionDailyPuzzleProvider).valueOrNull
        : null;
    final config = _variationConfig(daily);
    if (config.hasVariation(GameVariationType.sequential)) {
      final progress = ref
          .read(ayahCompletionProgressProvider)
          .progressFor(puzzle.id);
      final nextBlank = puzzle.blanks.firstWhere(
        (blank) =>
            progress.filledWordsByBlankIndex[blank.blankIndex.toString()] !=
            blank.correctWord,
        orElse: () => puzzle.blanks.first,
      );
      if (nextBlank.blankIndex != blankIndex) return;
    }
    ref
        .read(ayahCompletionProgressProvider.notifier)
        .setSelectedBlank(
          puzzleId: puzzle.id,
          blankIndex: blankIndex,
          occurredAt: DateTime.now(),
        );
  }

  bool _canRevealBlank(
    AyahCompletionPuzzle puzzle,
    AyahCompletionPuzzleProgress progress,
  ) {
    final unresolved = puzzle.blanks.where((blank) {
      final value =
          progress.filledWordsByBlankIndex[blank.blankIndex.toString()];
      return value != blank.correctWord;
    });
    return unresolved.isNotEmpty;
  }

  Future<void> _playAyah(AyahCompletionPuzzle puzzle) async {
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final orchestrator = ref.read(quranPlaybackOrchestratorProvider);
    final controller = ref.read(quranPlayerControllerProvider);
    final prepared = await orchestrator.preparePlayback(
      request: QuranPlaybackRequest(
        surahNumber: puzzle.ref.surah,
        ayahNumber: puzzle.ref.ayah,
        playbackReason: QuranPlaybackReason.lesson,
        isSurahEntry: puzzle.ref.ayah == 1,
      ),
      reciterId: audioSettings.reciterId,
      ayahNumbers: [puzzle.ref.ayah],
    );
    await controller.startPreparedPlayback(
      prepared,
      reciterId: audioSettings.reciterId,
      playbackSpeed: audioSettings.playbackSpeed,
      includeMediaTags: audioSettings.backgroundPlaybackEnabled,
    );
  }

  void _useRevealBlank(AyahCompletionPuzzle puzzle) {
    final progress = ref
        .read(ayahCompletionProgressProvider)
        .progressFor(puzzle.id);
    final unresolved = puzzle.blanks.firstWhere(
      (blank) =>
          progress.filledWordsByBlankIndex[blank.blankIndex.toString()] !=
          blank.correctWord,
      orElse: () => puzzle.blanks.first,
    );
    ref
        .read(ayahCompletionProgressProvider.notifier)
        .revealBlank(
          puzzleId: puzzle.id,
          blankIndex: unresolved.blankIndex,
          word: unresolved.correctWord,
          occurredAt: DateTime.now(),
        );
    ref
        .read(ayahCompletionProgressProvider.notifier)
        .setSelectedBlank(
          puzzleId: puzzle.id,
          blankIndex: unresolved.blankIndex,
          occurredAt: DateTime.now(),
        );
    _checkCompletion(
      puzzle,
      daily: widget.dailyMode
          ? ref.read(ayahCompletionDailyPuzzleProvider).valueOrNull
          : null,
    );
  }

  void _applyOption(
    AyahCompletionPuzzle puzzle, {
    required AyahCompletionBlank blank,
    required String option,
    required AyahCompletionDailyPuzzle? daily,
  }) {
    final now = DateTime.now();
    final notifier = ref.read(ayahCompletionProgressProvider.notifier);
    if (option != blank.correctWord) {
      notifier.markMistake(puzzleId: puzzle.id, occurredAt: now);
      notifier.fillBlank(
        puzzleId: puzzle.id,
        blankIndex: blank.blankIndex,
        word: option,
        occurredAt: now,
      );
      return;
    }
    final changed = notifier.fillBlank(
      puzzleId: puzzle.id,
      blankIndex: blank.blankIndex,
      word: option,
      occurredAt: now,
    );
    if (changed) {
      ref
          .read(journeyDropSummaryProvider.notifier)
          .awardLearningDrop(
            sourceRef: 'ayah_completion:blank:${puzzle.id}:${blank.blankIndex}',
            occurredAt: now,
            metadata: {
              'gameType': 'ayah_completion',
              'puzzleId': puzzle.id,
              'blankIndex': blank.blankIndex,
              'surah': puzzle.ref.surah,
              'ayah': puzzle.ref.ayah,
            },
          );
    }
    _checkCompletion(puzzle, daily: daily);
  }

  void _checkCompletion(
    AyahCompletionPuzzle puzzle, {
    AyahCompletionDailyPuzzle? daily,
  }) {
    final progress = ref
        .read(ayahCompletionProgressProvider)
        .progressFor(puzzle.id);
    final isComplete = puzzle.blanks.every(
      (blank) =>
          progress.filledWordsByBlankIndex[blank.blankIndex.toString()] ==
          blank.correctWord,
    );
    if (!isComplete) return;
    final now = DateTime.now();
    final perfect = !progress.hadMistake && !progress.usedAnyHint;
    final notifier = ref.read(ayahCompletionProgressProvider.notifier);
    final changed = notifier.markPuzzleCompleted(
      puzzleId: puzzle.id,
      perfect: perfect,
      occurredAt: now,
    );
    if (!changed) return;
    if (notifier.markCompletionRewardGranted(
      puzzleId: puzzle.id,
      occurredAt: now,
    )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'ayah_completion:completion:${puzzle.id}',
            occurredAt: now,
            metadata: {
              'gameType': 'ayah_completion',
              'puzzleId': puzzle.id,
              'surah': puzzle.ref.surah,
              'ayah': puzzle.ref.ayah,
            },
          );
      ref
          .read(journeyProgressUpdateHelperProvider)
          .addLearningStageCompletions(1);
    }
    if (perfect &&
        notifier.markPerfectRewardGranted(
          puzzleId: puzzle.id,
          occurredAt: now,
        )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'ayah_completion:perfect:${puzzle.id}',
            occurredAt: now,
            metadata: {
              'gameType': 'ayah_completion',
              'puzzleId': puzzle.id,
              'surah': puzzle.ref.surah,
              'ayah': puzzle.ref.ayah,
            },
          );
    }
    final variationBonusXp = ref
        .read(knowledgeGameVariationEngineProvider)
        .completionBonusXp(
          config: _variationConfig(daily),
          startedAt: DateTime.tryParse(progress.startedAtIso ?? '') ?? now,
          completedAt: now,
          perfect: perfect,
          usedAnyHint: progress.usedAnyHint,
        );
    if (variationBonusXp > 0) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'ayah_completion:variation_bonus:${puzzle.id}',
            occurredAt: now,
            metadata: {
              'gameType': 'ayah_completion',
              'puzzleId': puzzle.id,
              'variationBonusXp': variationBonusXp,
            },
          );
    }
    if (daily != null) {
      final startedAt = DateTime.tryParse(progress.startedAtIso ?? '') ?? now;
      final timeTaken = now.difference(startedAt).inSeconds;
      final dailyChanged = notifier.markDailyCompleted(
        dateKey: daily.dateKey,
        puzzleId: puzzle.id,
        weekdayTheme: daily.weekdayTheme,
        perfect: perfect,
        timeTakenSeconds: timeTaken,
        occurredAt: now,
      );
      if (dailyChanged &&
          notifier.markDailyRewardGranted(
            dateKey: daily.dateKey,
            occurredAt: now,
          )) {
        ref
            .read(journeyXpSummaryProvider.notifier)
            .awardLearningXp(
              sourceRef: 'ayah_completion:daily:${daily.dateKey}',
              occurredAt: now,
              metadata: {
                'gameType': 'ayah_completion',
                'puzzleId': puzzle.id,
                'surah': puzzle.ref.surah,
                'ayah': puzzle.ref.ayah,
              },
            );
      }
    }
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }

  Widget _rewardChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }

  KnowledgeGameConfig _variationConfig(AyahCompletionDailyPuzzle? daily) {
    if (daily == null) return const KnowledgeGameConfig.standard();
    return ref
        .read(knowledgeGameVariationEngineProvider)
        .resolveDailyConfig(
          gameType: DailyKnowledgeGameType.ayahCompletion,
          dateKey: daily.dateKey,
          profile: ref.read(userLearningProfileProvider),
        );
  }
}

class _BlankedAyahView extends StatelessWidget {
  const _BlankedAyahView({
    required this.puzzle,
    required this.progress,
    required this.onSelectBlank,
  });

  final AyahCompletionPuzzle puzzle;
  final AyahCompletionPuzzleProgress progress;
  final ValueChanged<int> onSelectBlank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final blankByWordIndex = {
      for (final blank in puzzle.blanks) blank.wordIndex: blank,
    };
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 10,
        spacing: 8,
        children: [
          for (var i = 0; i < puzzle.arabicWords.length; i += 1)
            if (blankByWordIndex.containsKey(i))
              _BlankToken(
                label: _blankLabel(blankByWordIndex[i]!, progress, l10n),
                selected:
                    progress.selectedBlankIndex ==
                    blankByWordIndex[i]!.blankIndex,
                completed:
                    progress.filledWordsByBlankIndex[blankByWordIndex[i]!
                        .blankIndex
                        .toString()] ==
                    blankByWordIndex[i]!.correctWord,
                onTap: () => onSelectBlank(blankByWordIndex[i]!.blankIndex),
              )
            else
              Text(
                puzzle.arabicWords[i],
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
        ],
      ),
    );
  }

  String _blankLabel(
    AyahCompletionBlank blank,
    AyahCompletionPuzzleProgress progress,
    AppLocalizations l10n,
  ) {
    final value = progress.filledWordsByBlankIndex[blank.blankIndex.toString()];
    if ((value ?? '').isNotEmpty) return value!;
    return l10n.ayahCompletionBlankPlaceholder(
      (blank.blankIndex + 1).toString(),
    );
  }
}

class _BlankToken extends StatelessWidget {
  const _BlankToken({
    required this.label,
    required this.selected,
    required this.completed,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: completed
                ? Theme.of(context).colorScheme.tertiaryContainer
                : selected
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: completed
                  ? Theme.of(context).colorScheme.primary
                  : selected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            label,
            textDirection: TextDirection.rtl,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
