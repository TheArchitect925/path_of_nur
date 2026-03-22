import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_illustration_service.dart';
import '../application/kids_dua_story_repository.dart';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = ref
          .read(kidsDuaLearningProvider)
          .storyProgressById[widget.storyId];
      ref.read(kidsDuaLearningProvider.notifier).openStory(widget.storyId);
      if (progress != null && progress.viewedSceneCount > 0) {
        setState(() => _sceneIndex = progress.viewedSceneCount - 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(kidsDuaStoryByIdProvider(widget.storyId));
    if (story == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.routerNotFoundTitle)),
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

    return Scaffold(
      appBar: AppBar(title: Text(story.title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE8DDD0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.kidsDuaStoriesSceneValue(
                      _sceneIndex + 1,
                      story.sceneCount,
                    ),
                    style: const TextStyle(color: Color(0xFF675B4E)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: isLast ? null : () => _nextScene(story.sceneCount),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE8DDD0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          sceneAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return ColoredBox(
                              color: const Color(0xFFFFF8EF),
                              child: Center(
                                child: Icon(
                                  illustrationService.fallbackIconForVisual(
                                    sceneVisual,
                                  ),
                                  size: 72,
                                  color: const Color(0xFF8A6A45),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        scene.text,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF40372F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sceneIndex == 0
                        ? null
                        : () => setState(() => _sceneIndex -= 1),
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
                  : () => _nextScene(story.sceneCount),
              child: Text(
                isLast
                    ? l10n.kidsDuaStoriesSayDuaAction
                    : l10n.kidsDuaStoriesNextAction,
              ),
            ),
            if (lesson != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.kidsDuaStoriesLessonHint(lesson.title),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF675B4E)),
              ),
            ],
          ],
        ),
      ),
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
    setState(() => _autoplay = !_autoplay);
    _timer?.cancel();
    if (_autoplay) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_sceneIndex >= sceneCount - 1) {
          timer.cancel();
          if (mounted) {
            setState(() => _autoplay = false);
          }
          return;
        }
        if (mounted) {
          _nextScene(sceneCount);
        }
      });
    }
  }

  void _finishStory(BuildContext context, String duaId) {
    ref.read(kidsDuaLearningProvider.notifier).completeStory(widget.storyId);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ref
                              .read(kidsDuaStoryByIdProvider(widget.storyId))!
                              .closingLine,
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.4,
                          ),
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
