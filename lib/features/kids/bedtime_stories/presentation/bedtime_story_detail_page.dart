import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../application/bedtime_story_audio_service.dart';
import '../application/bedtime_story_learning_loop_service.dart';
import '../application/bedtime_story_learning_progress_service.dart';
import '../application/bedtime_story_learning_repository.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_player_controller.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_learning_models.dart';
import '../domain/bedtime_story_models.dart';
import 'bedtime_story_cover_card.dart';
import 'bedtime_story_completion_banner.dart';
import 'bedtime_story_full_player_sheet.dart';
import 'bedtime_story_mini_player.dart';
import 'bedtime_story_player_bar.dart';
import 'bedtime_story_transcript_view.dart';

class BedtimeStoryDetailPage extends ConsumerStatefulWidget {
  const BedtimeStoryDetailPage({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<BedtimeStoryDetailPage> createState() =>
      _BedtimeStoryDetailPageState();
}

class _BedtimeStoryDetailPageState
    extends ConsumerState<BedtimeStoryDetailPage> {
  late final ScrollController _scrollController;
  final GlobalKey _transcriptKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bedtimeStoryProgressProvider.notifier).openStory(widget.storyId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryByIdProvider(widget.storyId));
    if (story == null) {
      return AppPageScaffold(
        title: l10n.bedtimeStoriesTitle,
        children: [PremiumCard(child: Text(l10n.routerNotFoundTitle))],
      );
    }
    final progress = ref.watch(
      bedtimeStoryProgressProvider.select(
        (value) =>
            value.storyProgressById[story.id] ?? const BedtimeStoryProgress(),
      ),
    );
    final libraryProgress = ref.watch(bedtimeStoryProgressProvider);
    final related = ref.watch(relatedBedtimeStoriesProvider(story.id));
    final series = story.isMultipart
        ? ref.watch(bedtimeStorySeriesProvider(story.effectiveStoryFamilyId))
        : const <BedtimeStorySeed>[];
    final seriesCompleted = story.isMultipart
        ? ref.watch(
            bedtimeStorySeriesCompletionProvider(story.effectiveStoryFamilyId),
          )
        : false;
    final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
    final audioState = ref.watch(bedtimeStoryAudioControllerProvider);
    final nextQueueStory = ref.watch(bedtimeStoryNextQueueStoryProvider);
    final quiz = ref.watch(bedtimeStoryQuizByStoryIdProvider(story.id));
    final memoryDeck = ref.watch(
      bedtimeStoryMemoryDeckByStoryIdProvider(story.id),
    );
    final nextLearning = ref.watch(
      bedtimeStoryNextLearningSuggestionByStoryIdProvider(story.id),
    );
    final learningState = ref.watch(bedtimeStoryLearningProgressProvider);
    final quizProgress = quiz == null
        ? null
        : learningState.progressByActivityId[quiz.quizId];
    final memoryProgress = memoryDeck == null
        ? null
        : learningState.progressByActivityId[memoryDeck.deckId];

    return AppPageScaffold(
      scrollController: _scrollController,
      title: story.title,
      subtitle: story.lesson,
      headerActions: [
        IconButton(
          onPressed: () => showBedtimeStoryFullPlayerSheet(context, ref),
          icon: const Icon(Icons.queue_music_rounded),
          tooltip: l10n.bedtimeStoriesOpenPlayerAction,
        ),
      ],
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        mediaAsync.when(
          loading: () => PremiumCard(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 220,
              child: Center(child: Text(l10n.bedtimeStoriesMediaLoadingLabel)),
            ),
          ),
          error: (_, _) => _fallbackCoverCard(context, story, progress, l10n),
          data: (media) => BedtimeStoryCoverCard(
            story: story,
            media: media,
            overlayChips: <Widget>[
              _DetailMetaChip(
                label: l10n.bedtimeStoriesDurationMinutesLabel(
                  (story.estimatedDurationSeconds / 60).ceil(),
                ),
              ),
              _DetailMetaChip(
                label: _detailAgeGroupLabel(l10n, story.ageGroup),
              ),
              _DetailMetaChip(
                label: _completionLabel(l10n, progress.completionState),
              ),
              if (story.isMultipart)
                _DetailMetaChip(
                  label: l10n.bedtimeStoriesPartLabel(
                    story.partNumber,
                    story.totalParts,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Without narration, reading is the whole point of the page: one
        // large button under the cover takes the reader straight to the text.
        if (!(mediaAsync.valueOrNull?.audio.isAvailable ?? false)) ...[
          FilledButton.icon(
            onPressed: _scrollToTranscript,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            icon: const Icon(Icons.menu_book_rounded),
            label: Text(
              story.bedtimeEligible
                  ? l10n.bedtimeStoriesReadTonightAction
                  : l10n.kidsStoryReadStoryAction,
            ),
          ),
          const SizedBox(height: 12),
        ],
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.bedtimeEligible
                    ? l10n.bedtimeStoriesLessonSectionTitle
                    : l10n.kidsStoryLessonSectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(story.summary.isNotEmpty ? story.summary : story.lesson),
              const SizedBox(height: 10),
              Text(story.lesson),
              // A narrator is credited only once there is narration to hear.
              if (mediaAsync.valueOrNull?.audio.isAvailable ?? false) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.bedtimeStoriesNarratedByLabel(
                    mediaAsync.valueOrNull?.audio.entry.narratorDisplayName ??
                        story.narratorDisplayName,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (story.hasQuranReference) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoriesQuranQuoteSectionTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  story.quranQuote!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 10),
                QuranReferenceLinkTile.forRef(
                  referenceLabel: story.quranReference!,
                  ref: story.quranQuoteRef!,
                  subtitle: l10n.bedtimeStoriesQuranTapSubtitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (story.hasHadithReference) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsStoryHadithSectionTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  story.hadithQuote!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 10),
                Text(
                  story.hadithReference!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if ((story.sourceNote ?? '').isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsStorySourceNoteSectionTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(story.sourceNote!),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        mediaAsync.when(
          loading: () =>
              PremiumCard(child: Text(l10n.bedtimeStoriesAudioCheckingLabel)),
          error: (_, _) => PremiumCard(
            child: Text(
              story.bedtimeEligible
                  ? l10n.bedtimeStoriesAudioUnavailableSubtitle
                  : l10n.kidsStoryAudioUnavailableSubtitle,
            ),
          ),
          // With narration the player bar carries the controls. Without it
          // the story is read, so the only action is the one that gets the
          // reader to the text; the transcript card below carries it.
          data: (media) => media.audio.isAvailable
              ? BedtimeStoryPlayerBar(
                  story: story,
                  media: media,
                  onReadAlong: _scrollToTranscript,
                )
              : const SizedBox.shrink(),
        ),
        if (story.sceneIllustrations.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.kidsStoryScenesSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...story.sceneIllustrations.map(
            (scene) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(scene.description),
                    const SizedBox(height: 8),
                    Text(
                      scene.caption,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (audioState.isCompleted &&
            audioState.currentStoryId == story.id) ...[
          const SizedBox(height: 12),
          BedtimeStoryCompletionBanner(
            story: story,
            nextStory: nextQueueStory,
            onReplay: () => ref
                .read(bedtimeStoryQueueControllerProvider.notifier)
                .playCurrent(restartCompleted: true),
            onNext: nextQueueStory == null
                ? null
                : () => ref
                      .read(bedtimeStoryQueueControllerProvider.notifier)
                      .next(),
          ),
        ],
        if (story.isMultipart) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoriesSeriesProgressTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: series.isEmpty
                      ? 0
                      : series
                                .where(
                                  (item) =>
                                      (libraryProgress
                                          .storyProgressById[item.id]
                                          ?.isCompleted ??
                                      false),
                                )
                                .length /
                            series.length,
                ),
                const SizedBox(height: 8),
                Text(
                  seriesCompleted
                      ? l10n.bedtimeStoriesSeriesCompletedLabel
                      : l10n.bedtimeStoriesSeriesProgressLabel(
                          series
                              .where(
                                (item) =>
                                    (libraryProgress
                                        .storyProgressById[item.id]
                                        ?.isCompleted ??
                                    false),
                              )
                              .length,
                          series.length,
                        ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        KeyedSubtree(
          key: _transcriptKey,
          child: BedtimeStoryTranscriptView(
            title: story.bedtimeEligible
                ? l10n.bedtimeStoriesTranscriptSectionTitle
                : l10n.kidsStoryTranscriptSectionTitle,
            rawText: story.ttsText,
            // The card *is* the reading; a button that scrolls to itself
            // only adds a third "read" control to the page.
            completionButton: FilledButton.icon(
              onPressed: () => _markComplete(context, story),
              icon: Icon(
                progress.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.done_all_rounded,
              ),
              label: Text(
                progress.isCompleted
                    ? l10n.bedtimeStoriesCompletedAction
                    : l10n.bedtimeStoriesMarkCompleteAction,
              ),
            ),
          ),
        ),
        if (quiz != null || memoryDeck != null) ...[
          const SizedBox(height: 12),
          Text(
            l10n.bedtimeStoryLearningLoopTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(l10n.bedtimeStoryLearningLoopSubtitle),
          const SizedBox(height: 10),
          if (quiz != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LearningActivityCard(
                title: l10n.bedtimeStoryQuizTitle,
                subtitle: quiz.shortDescription,
                statusLabel: _learningCompletionLabel(
                  l10n,
                  quizProgress?.completionState,
                ),
                actionLabel: quizProgress?.isCompleted == true
                    ? l10n.bedtimeStoryQuizReviewAction
                    : l10n.bedtimeStoryQuizStartAction,
                icon: Icons.quiz_rounded,
                onTap: () => context.pushNamed(
                  'kidsStoryQuiz',
                  pathParameters: {'storyId': story.id},
                ),
              ),
            ),
          if (memoryDeck != null)
            _LearningActivityCard(
              title: l10n.bedtimeStoryMemoryTitle,
              subtitle: memoryDeck.shortDescription,
              statusLabel: _learningCompletionLabel(
                l10n,
                memoryProgress?.completionState,
              ),
              actionLabel: memoryProgress?.isCompleted == true
                  ? l10n.bedtimeStoryMemoryPlayAgainAction
                  : l10n.bedtimeStoryMemoryStartAction,
              icon: Icons.style_rounded,
              onTap: () => context.pushNamed(
                'kidsStoryMemory',
                pathParameters: {'storyId': story.id},
              ),
            ),
          if (nextLearning != null) ...[
            const SizedBox(height: 10),
            PremiumCard(
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nextLearning.mode == BedtimeStoryLearningMode.quiz
                          ? l10n.bedtimeStoryLearningContinueQuizPrompt
                          : l10n.bedtimeStoryLearningContinueMemoryPrompt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
        if (related.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.bedtimeStoriesRelatedStoriesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...related.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.pushNamed(
                  'kidsStoryDetail',
                  pathParameters: {'storyId': item.id},
                ),
                child: PremiumCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.lesson,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _markComplete(
    BuildContext context,
    BedtimeStorySeed story,
  ) async {
    final outcome = ref
        .read(bedtimeStoryProgressProvider.notifier)
        .completeStory(story, completionSource: 'manual_read_along');
    if (!mounted || !outcome.firstCompletion) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.bedtimeStoriesCompletionSnackQuiet)),
    );
  }

  Widget _fallbackCoverCard(
    BuildContext context,
    BedtimeStorySeed story,
    BedtimeStoryProgress progress,
    AppLocalizations l10n,
  ) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.shortTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DetailMetaChip(
                label: l10n.bedtimeStoriesDurationMinutesLabel(
                  (story.estimatedDurationSeconds / 60).ceil(),
                ),
              ),
              _DetailMetaChip(
                label: _detailAgeGroupLabel(l10n, story.ageGroup),
              ),
              _DetailMetaChip(
                label: _completionLabel(l10n, progress.completionState),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _scrollToTranscript() async {
    final context = _transcriptKey.currentContext;
    if (context == null) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      alignment: 0.08,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}

class _LearningActivityCard extends StatelessWidget {
  const _LearningActivityCard({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.actionLabel,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _DetailMetaChip(label: statusLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle),
          const SizedBox(height: 12),
          FilledButton(onPressed: onTap, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _DetailMetaChip extends StatelessWidget {
  const _DetailMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

String _detailAgeGroupLabel(
  AppLocalizations l10n,
  BedtimeStoryAgeGroup ageGroup,
) {
  switch (ageGroup) {
    case BedtimeStoryAgeGroup.kidsEarly:
      return l10n.bedtimeStoriesAgeGroupKidsEarly;
    case BedtimeStoryAgeGroup.kids:
      return l10n.bedtimeStoriesAgeGroupKids;
    case BedtimeStoryAgeGroup.kidsPlus:
      return l10n.bedtimeStoriesAgeGroupKidsPlus;
  }
}

String _completionLabel(
  AppLocalizations l10n,
  BedtimeStoryCompletionState completionState,
) {
  switch (completionState) {
    case BedtimeStoryCompletionState.notStarted:
      return l10n.bedtimeStoriesStatusNotStarted;
    case BedtimeStoryCompletionState.inProgress:
      return l10n.bedtimeStoriesStatusInProgress;
    case BedtimeStoryCompletionState.completed:
      return l10n.bedtimeStoriesStatusCompleted;
  }
}

String _learningCompletionLabel(
  AppLocalizations l10n,
  BedtimeStoryLearningCompletionState? completionState,
) {
  switch (completionState ?? BedtimeStoryLearningCompletionState.notStarted) {
    case BedtimeStoryLearningCompletionState.notStarted:
      return l10n.bedtimeStoryLearningNotStarted;
    case BedtimeStoryLearningCompletionState.inProgress:
      return l10n.bedtimeStoryLearningInProgress;
    case BedtimeStoryLearningCompletionState.completed:
      return l10n.bedtimeStoryLearningCompleted;
  }
}
