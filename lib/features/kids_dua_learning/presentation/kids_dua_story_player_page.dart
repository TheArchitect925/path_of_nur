import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../kids/shared/application/kids_read_aloud.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_illustration_service.dart';
import '../application/kids_dua_story_repository.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class KidsDuaStoryPlayerPage extends ConsumerStatefulWidget {
  const KidsDuaStoryPlayerPage({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<KidsDuaStoryPlayerPage> createState() =>
      _KidsDuaStoryPlayerPageState();
}

class _KidsDuaStoryPlayerPageState
    extends ConsumerState<KidsDuaStoryPlayerPage> {
  int _sceneIndex = 0;
  bool _autoplay = false;

  /// Bumped when autoplay stops so a running loop knows to end.
  int _autoplayRun = 0;

  /// How long a scene stays up in autoplay when there is no voice, and the
  /// least it stays up when there is.
  static const _sceneDwell = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final progress = ref
          .read(kidsDuaLearningProvider)
          .storyProgressById[widget.storyId];
      ref.read(kidsDuaLearningProvider.notifier).openStory(widget.storyId);
      ref.read(kidsReadAloudControllerProvider.notifier).prepare();
      if (progress != null && progress.viewedSceneCount > 0) {
        setState(() => _sceneIndex = progress.viewedSceneCount - 1);
      }
    });
  }

  @override
  void dispose() {
    _autoplayRun++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(kidsDuaStoryByIdProvider(widget.storyId));
    if (story == null) {
      return AppPageScaffold(
        title: l10n.kidsDuaStoriesTitle,
        children: [PremiumCard(child: Text(l10n.routerNotFoundTitle))],
      );
    }
    final lesson = ref.watch(kidsDuaLessonByIdProvider(story.duaId));
    final scene = story.scenes[_sceneIndex];
    final isLast = _sceneIndex == story.scenes.length - 1;
    final illustrationService = ref.watch(
      kidsDuaStoryIllustrationServiceProvider,
    );
    final sceneVisual = scene.resolvedVisual;
    final sceneAsset = illustrationService.getSceneAsset(scene);
    final textTheme = Theme.of(context).textTheme;
    final readAloud = ref.watch(kidsReadAloudControllerProvider);
    final canHear = readAloud.available ?? false;
    final sceneLineId = 'scene-$_sceneIndex';

    // The scene controls float above the tab bar so the primary action is
    // always reachable; the trailing spacer keeps the last line of a scene
    // from sliding underneath them.
    return AppPageScaffold(
      title: story.title,
      floatingBottom: PremiumCard(
        density: PremiumCardDensity.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sceneIndex == 0
                        ? null
                        : () {
                            _stopAutoplay();
                            setState(() => _sceneIndex -= 1);
                          },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(l10n.kidsDuaStoriesBackAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _toggleAutoplay(story.sceneCount),
                    icon: Icon(
                      _autoplay
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_rounded,
                    ),
                    label: Text(
                      _autoplay
                          ? l10n.kidsDuaStoriesPauseAction
                          : l10n.kidsDuaStoriesAutoplayAction,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: isLast
                  ? () => _finishStory(context, story.duaId)
                  : () {
                      _stopAutoplay();
                      _nextScene(story.sceneCount);
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: Text(
                isLast
                    ? l10n.kidsDuaStoriesSayDuaAction
                    : l10n.kidsDuaStoriesNextAction,
              ),
            ),
          ],
        ),
      ),
      children: [
        PremiumCard(
          onTap: isLast
              ? null
              : () {
                  _stopAutoplay();
                  _nextScene(story.sceneCount);
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsDuaStoriesSceneValue(
                  _sceneIndex + 1,
                  story.sceneCount,
                ),
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    sceneAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: context.palette.surfaceSoft,
                        child: Center(
                          child: Icon(
                            illustrationService.fallbackIconForVisual(
                              sceneVisual,
                            ),
                            size: 72,
                            color: context.palette.accent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Every line has a voice: tap it to hear it (K2).
              InkWell(
                onTap: canHear
                    ? () => ref
                          .read(kidsReadAloudControllerProvider.notifier)
                          .speak(
                            KidsReadAloudLine(
                              id: sceneLineId,
                              text: scene.text,
                            ),
                          )
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    scene.text,
                    style: textTheme.headlineSmall?.copyWith(
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: readAloud.speakingId == sceneLineId
                          ? context.palette.accent
                          : null,
                    ),
                  ),
                ),
              ),
              if (canHear) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.kidsStoryReaderTapToHearHint,
                  style: textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        if (lesson != null) ...[
          const SizedBox(height: 12),
          Text(
            l10n.kidsDuaStoriesLessonHint(lesson.title),
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 168),
      ],
    );
  }

  void _nextScene(int sceneCount) {
    if (_sceneIndex >= sceneCount - 1) {
      return;
    }
    final next = _sceneIndex + 1;
    ref
        .read(kidsDuaLearningProvider.notifier)
        .viewStoryScene(storyId: widget.storyId, viewedSceneCount: next + 1);
    setState(() => _sceneIndex = next);
  }

  void _toggleAutoplay(int sceneCount) {
    if (_autoplay) {
      _stopAutoplay();
      return;
    }
    setState(() => _autoplay = true);
    unawaited(_runAutoplay(sceneCount));
  }

  void _stopAutoplay() {
    if (!_autoplay) return;
    _autoplayRun++;
    ref.read(kidsReadAloudControllerProvider.notifier).stop();
    setState(() => _autoplay = false);
  }

  /// Reads each scene aloud and turns to the next when the voice finishes,
  /// never sooner than [_sceneDwell]; without a voice it is a slide show.
  Future<void> _runAutoplay(int sceneCount) async {
    final run = ++_autoplayRun;
    final voice = ref.read(kidsReadAloudControllerProvider.notifier);
    while (mounted && _autoplay && run == _autoplayRun) {
      final story = ref.read(kidsDuaStoryByIdProvider(widget.storyId));
      if (story == null) break;
      final index = _sceneIndex;
      await Future.wait<void>([
        voice.speak(
          KidsReadAloudLine(id: 'scene-$index', text: story.scenes[index].text),
        ),
        Future<void>.delayed(_sceneDwell),
      ]);
      if (!mounted || !_autoplay || run != _autoplayRun) return;
      if (_sceneIndex >= sceneCount - 1) {
        setState(() => _autoplay = false);
        return;
      }
      _nextScene(sceneCount);
    }
  }

  void _finishStory(BuildContext context, String duaId) {
    _stopAutoplay();
    ref.read(kidsDuaLearningProvider.notifier).completeStory(widget.storyId);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final textTheme = Theme.of(context).textTheme;
        final mediaQuery = MediaQuery.of(context);
        final maxHeight = mediaQuery.size.height * 0.82;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            24 + mediaQuery.viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.kidsDuaStoriesCompleteTitle,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ref
                              .read(kidsDuaStoryByIdProvider(widget.storyId))!
                              .closingLine,
                          style: textTheme.bodyMedium?.copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pushNamed(
                      'kidsDuaLesson',
                      pathParameters: {'lessonId': duaId},
                    );
                  },
                  child: Text(l10n.kidsDuaStoriesSayDuaAction),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.context.pop();
                  },
                  child: Text(l10n.kidsDuaStoriesBackToStoriesAction),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
