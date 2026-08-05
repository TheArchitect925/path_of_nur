import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/reward_feedback.dart';
import '../../../shared/widgets/quran_reference_link.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../learn/quran/domain/quran_content_refs.dart';
import '../application/kids_dua_active_learner_service.dart';
import '../application/kids_dua_audio_service.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_learning_repository.dart';
import '../application/kids_dua_my_day_practice_service.dart';
import '../application/kids_dua_my_day_provider.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_repository.dart';
import '../domain/kids_dua_learning_models.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_read_along_view.dart';
import 'kids_dua_tap_repeat_view.dart';

class KidsDuaLessonPage extends ConsumerStatefulWidget {
  const KidsDuaLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<KidsDuaLessonPage> createState() => _KidsDuaLessonPageState();
}

class _KidsDuaLessonPageState extends ConsumerState<KidsDuaLessonPage> {
  KidsDuaRepeatMode _mode = KidsDuaRepeatMode.listen;
  KidsDuaReadAlongMode _readAlongMode = KidsDuaReadAlongMode.full;
  String? _selectedSegmentId;
  bool _repeatWhole = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kidsDuaLearningProvider.notifier).openLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lesson = ref.watch(kidsDuaLessonByIdProvider(widget.lessonId));
    final learningItem = ref.watch(
      kidsDuaLearningItemByIdProvider(widget.lessonId),
    );
    final nextLesson = ref.watch(
      kidsDuaNextLessonByIdProvider(widget.lessonId),
    );
    final stories = ref.watch(kidsDuaStoriesForLessonProvider(widget.lessonId));
    final progress = ref
        .watch(kidsDuaLearningProvider)
        .progressByLessonId[widget.lessonId];
    final audioState = ref.watch(kidsDuaAudioControllerProvider);
    final learner = ref.watch(kidsDuaActiveLearnerProvider);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.routerNotFoundTitle)),
      );
    }

    final audioVariant = learningItem?.audioVariants.firstOrNull;
    final audioAvailable = audioVariant == null
        ? const AsyncValue<bool>.data(false)
        : ref.watch(kidsDuaAudioAvailabilityProvider(audioVariant));
    final isCurrentAudio = audioState.currentDuaId == lesson.id;
    final activeSegmentId = audioState.activeSegmentId ?? _selectedSegmentId;

    return LearnHubPageScaffold(
      headerIcon: lesson.icon,
      title: lesson.title,
      subtitle: lesson.whenToSay,
      children: [
        _HeroCard(
          lesson: lesson,
          learnerName: learner.displayName,
          categoryTitle:
              ref
                  .watch(kidsDuaCategoryByIdProvider(lesson.categoryId))
                  ?.title ??
              '',
        ),
        const SizedBox(height: 12),
        _Frame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsDuaLearningModesTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<KidsDuaRepeatMode>(
                segments: <ButtonSegment<KidsDuaRepeatMode>>[
                  ButtonSegment<KidsDuaRepeatMode>(
                    value: KidsDuaRepeatMode.listen,
                    label: Text(l10n.kidsDuaModeListen),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                  ButtonSegment<KidsDuaRepeatMode>(
                    value: KidsDuaRepeatMode.readAlong,
                    label: Text(l10n.kidsDuaModeReadAlong),
                    icon: const Icon(Icons.chrome_reader_mode_rounded),
                  ),
                  ButtonSegment<KidsDuaRepeatMode>(
                    value: KidsDuaRepeatMode.tapToRepeat,
                    label: Text(l10n.kidsDuaModeTapRepeat),
                    icon: const Icon(Icons.touch_app_rounded),
                  ),
                  ButtonSegment<KidsDuaRepeatMode>(
                    value: KidsDuaRepeatMode.gentlePractice,
                    label: Text(l10n.kidsDuaModeGentlePractice),
                    icon: const Icon(Icons.self_improvement_rounded),
                  ),
                ],
                selected: <KidsDuaRepeatMode>{_mode},
                onSelectionChanged: (selection) {
                  setState(() {
                    _mode = selection.first;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _AudioCard(
          audioAvailable: audioAvailable,
          isCurrentAudio: isCurrentAudio,
          audioState: audioState,
          repeatWhole: _repeatWhole,
          onPlayPause: () => _handlePrimaryAudioAction(
            lessonId: lesson.id,
            audioVariant: audioVariant,
          ),
          onRestart: () =>
              _handleRestart(lessonId: lesson.id, audioVariant: audioVariant),
          onRepeatWholeChanged: (value) async {
            setState(() {
              _repeatWhole = value;
            });
            await ref
                .read(kidsDuaAudioControllerProvider.notifier)
                .setRepeatWhole(value);
          },
        ),
        const SizedBox(height: 12),
        if (learningItem != null &&
            (_mode == KidsDuaRepeatMode.listen ||
                _mode == KidsDuaRepeatMode.readAlong ||
                _mode == KidsDuaRepeatMode.gentlePractice)) ...[
          _ReadAlongControls(
            mode: _readAlongMode,
            onChanged: (mode) {
              setState(() {
                _readAlongMode = mode;
              });
            },
          ),
          const SizedBox(height: 10),
          KidsDuaReadAlongView(
            item: learningItem,
            readAlongMode: _readAlongMode,
            activeSegmentId: activeSegmentId,
          ),
          const SizedBox(height: 10),
          if (_mode != KidsDuaRepeatMode.listen)
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  ref
                      .read(kidsDuaLearningProvider.notifier)
                      .recordReadAlongComplete(lesson.id, mode: _mode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.kidsDuaPracticeSavedSnack)),
                  );
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: Text(l10n.kidsDuaMarkPracticedAction),
              ),
            ),
        ],
        if (learningItem != null && _mode == KidsDuaRepeatMode.tapToRepeat) ...[
          KidsDuaTapRepeatView(
            item: learningItem,
            activeSegmentId: activeSegmentId,
            hasAudio: audioAvailable.valueOrNull ?? false,
            isSegmentFallback: audioState.isSegmentFallback,
            onTapSegment: (segment) => _handleTapSegment(
              segment: segment,
              lessonId: lesson.id,
              audioVariant: audioVariant,
            ),
          ),
        ],
        if (learningItem != null &&
            _mode == KidsDuaRepeatMode.gentlePractice) ...[
          const SizedBox(height: 12),
          _Frame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaGentlePracticeTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kidsDuaGentlePracticeSubtitle,
                  style: const TextStyle(color: Color(0xFF655A4C), height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _handlePrimaryAudioAction(
                        lessonId: lesson.id,
                        audioVariant: audioVariant,
                      ),
                      icon: const Icon(Icons.headphones_rounded),
                      label: Text(l10n.kidsDuaListenThenReadAction),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => setState(() {
                        _mode = KidsDuaRepeatMode.tapToRepeat;
                      }),
                      icon: const Icon(Icons.touch_app_rounded),
                      label: Text(l10n.kidsDuaTapRepeatAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        _ActionCard(
          lesson: lesson,
          isLearned: progress?.status == KidsDuaLessonStatus.learned,
          hasStory: stories.isNotEmpty,
          onPractice: () => context.pushNamed('kidsDuaPractice'),
          onStory: stories.isEmpty
              ? null
              : () => context.pushNamed(
                  'kidsDuaStoryPlayer',
                  pathParameters: {'storyId': stories.first.id},
                ),
          onDraw: () => context.pushNamed(
            'kidsDuaDrawing',
            pathParameters: {'lessonId': lesson.id},
          ),
          onComplete: () {
            final result = ref
                .read(kidsDuaLearningProvider.notifier)
                .completeLesson(lesson.id);
            final myDayResult = ref
                .read(kidsDuaMyDayProvider.notifier)
                .completeDuaForToday(lesson.id);
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => _CompletionSheet(
                lesson: lesson,
                nextLesson: nextLesson,
                result: result,
                myDayResult: myDayResult,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _InfoCard(title: l10n.kidsDuaMeaningSection, body: lesson.meaning),
        const SizedBox(height: 12),
        _InfoCard(
          title: l10n.kidsDuaMiniLessonSection,
          body: lesson.miniLesson,
        ),
        const SizedBox(height: 12),
        _InfoCard(title: l10n.kidsDuaWhenSection, body: lesson.whenToSay),
        const SizedBox(height: 12),
        if (learningItem?.bedtimeRelevance ?? false)
          _BedtimeIntegrationCard(
            onOpenCompanion: () => context.pushNamed('kidsBedtimeCompanion'),
          ),
        if (learningItem?.bedtimeRelevance ?? false) const SizedBox(height: 12),
        _SourceCard(lesson: lesson),
        const SizedBox(height: 12),
        if (progress != null) _ProgressCard(progress: progress),
      ],
    );
  }

  Future<void> _handlePrimaryAudioAction({
    required String lessonId,
    required KidsDuaAudioVariant? audioVariant,
  }) async {
    final controller = ref.read(kidsDuaAudioControllerProvider.notifier);
    final audioState = ref.read(kidsDuaAudioControllerProvider);
    if (audioVariant == null) {
      return;
    }
    if (audioState.currentDuaId == lessonId && audioState.isPlaying) {
      await controller.pause();
      return;
    }
    if (audioState.currentDuaId == lessonId &&
        !audioState.isPlaying &&
        audioState.isAudioAvailable) {
      await controller.resume();
      return;
    }
    final played = await controller.playVariant(audioVariant, duaId: lessonId);
    if (played) {
      ref.read(kidsDuaLearningProvider.notifier).recordAudioListen(lessonId);
    }
  }

  Future<void> _handleRestart({
    required String lessonId,
    required KidsDuaAudioVariant? audioVariant,
  }) async {
    final controller = ref.read(kidsDuaAudioControllerProvider.notifier);
    final audioState = ref.read(kidsDuaAudioControllerProvider);
    if (audioState.currentDuaId == lessonId && audioState.isAudioAvailable) {
      await controller.restart();
      return;
    }
    if (audioVariant == null) {
      return;
    }
    final played = await controller.playVariant(audioVariant, duaId: lessonId);
    if (played) {
      ref.read(kidsDuaLearningProvider.notifier).recordAudioListen(lessonId);
    }
  }

  Future<void> _handleTapSegment({
    required KidsDuaSegment segment,
    required String lessonId,
    required KidsDuaAudioVariant? audioVariant,
  }) async {
    setState(() {
      _selectedSegmentId = segment.segmentId;
    });
    ref
        .read(kidsDuaLearningProvider.notifier)
        .recordSegmentRepeat(lessonId: lessonId, segmentId: segment.segmentId);
    if (audioVariant == null) {
      return;
    }
    final played = await ref
        .read(kidsDuaAudioControllerProvider.notifier)
        .playVariant(
          audioVariant,
          duaId: lessonId,
          activeSegmentId: segment.segmentId,
          isSegmentFallback: true,
        );
    if (!played && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).kidsDuaTapRepeatNoAudioBody,
          ),
        ),
      );
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.lesson,
    required this.learnerName,
    required this.categoryTitle,
  });

  final KidsDuaLessonContent lesson;
  final String learnerName;
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7D7BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(lesson.icon, color: const Color(0xFF8A6A45)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.kidsDuaLessonHeroSubtitle(
                        learnerName.isEmpty
                            ? l10n.kidsDuaLearningBuddyLabel
                            : learnerName,
                        categoryTitle,
                      ),
                      style: const TextStyle(color: Color(0xFF675B4E)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              lesson.arabic,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 30,
                height: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lesson.transliteration,
            style: const TextStyle(fontSize: 16, color: Color(0xFF655A4C)),
          ),
        ],
      ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard({
    required this.audioAvailable,
    required this.isCurrentAudio,
    required this.audioState,
    required this.repeatWhole,
    required this.onPlayPause,
    required this.onRestart,
    required this.onRepeatWholeChanged,
  });

  final AsyncValue<bool> audioAvailable;
  final bool isCurrentAudio;
  final KidsDuaAudioState audioState;
  final bool repeatWhole;
  final VoidCallback onPlayPause;
  final VoidCallback onRestart;
  final ValueChanged<bool> onRepeatWholeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: audioAvailable.when(
        data: (hasAudio) {
          final primaryLabel = !hasAudio
              ? l10n.kidsDuaAudioUnavailableTitle
              : (isCurrentAudio && audioState.isPlaying
                    ? l10n.kidsDuaPauseAction
                    : (isCurrentAudio && audioState.isAudioAvailable
                          ? l10n.kidsDuaResumeAction
                          : l10n.kidsDuaPlayWholeAction));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsDuaAudioSectionTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasAudio
                    ? l10n.kidsDuaAudioSectionSubtitle
                    : l10n.kidsDuaAudioUnavailableSubtitle,
                style: const TextStyle(color: Color(0xFF655A4C), height: 1.4),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: hasAudio ? onPlayPause : null,
                    icon: Icon(
                      isCurrentAudio && audioState.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(primaryLabel),
                  ),
                  OutlinedButton.icon(
                    onPressed: hasAudio ? onRestart : null,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(l10n.kidsDuaRestartAction),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilterChip(
                label: Text(l10n.kidsDuaRepeatWholeAction),
                selected: repeatWhole,
                onSelected: hasAudio ? onRepeatWholeChanged : null,
              ),
              if (isCurrentAudio && hasAudio) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.kidsDuaPlaybackProgressLabel(
                    _format(audioState.currentPosition),
                    _format(audioState.totalDuration),
                  ),
                  style: const TextStyle(color: Color(0xFF6D6255)),
                ),
              ],
            ],
          );
        },
        loading: () => Text(l10n.kidsDuaAudioLoadingLabel),
        error: (error, stackTrace) =>
            Text(l10n.kidsDuaAudioUnavailableSubtitle),
      ),
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ReadAlongControls extends StatelessWidget {
  const _ReadAlongControls({required this.mode, required this.onChanged});

  final KidsDuaReadAlongMode mode;
  final ValueChanged<KidsDuaReadAlongMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaReadAlongModeTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          SegmentedButton<KidsDuaReadAlongMode>(
            segments: <ButtonSegment<KidsDuaReadAlongMode>>[
              ButtonSegment<KidsDuaReadAlongMode>(
                value: KidsDuaReadAlongMode.arabicOnly,
                label: Text(l10n.kidsDuaReadAlongArabicOnly),
              ),
              ButtonSegment<KidsDuaReadAlongMode>(
                value: KidsDuaReadAlongMode.arabicTransliteration,
                label: Text(l10n.kidsDuaReadAlongArabicTransliteration),
              ),
              ButtonSegment<KidsDuaReadAlongMode>(
                value: KidsDuaReadAlongMode.full,
                label: Text(l10n.kidsDuaReadAlongFullView),
              ),
            ],
            selected: <KidsDuaReadAlongMode>{mode},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.lesson,
    required this.isLearned,
    required this.hasStory,
    required this.onPractice,
    required this.onStory,
    required this.onDraw,
    required this.onComplete,
  });

  final KidsDuaLessonContent lesson;
  final bool isLearned;
  final bool hasStory;
  final VoidCallback onPractice;
  final VoidCallback? onStory;
  final VoidCallback onDraw;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.miniLesson,
            style: const TextStyle(color: Color(0xFF655A4C), height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPractice,
                  icon: const Icon(Icons.quiz_rounded),
                  label: Text(l10n.kidsDuaPracticeTitle),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDraw,
                  icon: const Icon(Icons.brush_rounded),
                  label: Text(l10n.kidsDuaDrawAction),
                ),
              ),
            ],
          ),
          if (hasStory) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onStory,
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.kidsDuaStoriesAction),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onComplete,
              child: Text(
                isLearned
                    ? l10n.kidsDuaCompleteAgainAction
                    : l10n.kidsDuaCompleteLessonAction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF554C42),
            ),
          ),
        ],
      ),
    );
  }
}

class _BedtimeIntegrationCard extends StatelessWidget {
  const _BedtimeIntegrationCard({required this.onOpenCompanion});

  final VoidCallback onOpenCompanion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaBedtimeLinkTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsDuaBedtimeLinkSubtitle,
            style: const TextStyle(color: Color(0xFF655A4C), height: 1.4),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onOpenCompanion,
            icon: const Icon(Icons.bedtime_rounded),
            label: Text(l10n.kidsDuaBedtimeLinkAction),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final KidsDuaLessonProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaLearningProgressTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: l10n.kidsDuaListenCountLabel,
                  value: '${progress.listenCount}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: l10n.kidsDuaPracticeTitle,
                  value: '${progress.timesPracticed}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: l10n.kidsDuaRepeatCountLabel,
                  value: '${progress.segmentRepeatCount}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: l10n.kidsDuaViewsCountLabel,
                  value: '${progress.openCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF655A4C))),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.lesson});

  final KidsDuaLessonContent lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quranRef = _quranRefForLesson(lesson.id);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaSourceSection,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.sourceType,
            style: const TextStyle(color: Color(0xFF655A4C)),
          ),
          const SizedBox(height: 8),
          if (quranRef != null)
            QuranReferenceLinkTile.forRef(
              referenceLabel: lesson.sourceReference,
              ref: quranRef,
              subtitle: l10n.kidsDuaSourceTapSubtitle,
            )
          else
            Text(
              lesson.sourceReference,
              style: const TextStyle(color: Color(0xFF655A4C)),
            ),
        ],
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: child,
    );
  }
}

QuranQuoteRef? _quranRefForLesson(String lessonId) {
  switch (lessonId) {
    case 'rabbi-zidnee-ilma':
      return const QuranQuoteRef(surah: 20, ayah: 114);
    case 'dua-for-parents':
      return const QuranQuoteRef(surah: 17, ayah: 24);
    default:
      return null;
  }
}

class _CompletionSheet extends ConsumerStatefulWidget {
  const _CompletionSheet({
    required this.lesson,
    required this.nextLesson,
    required this.result,
    required this.myDayResult,
  });

  final KidsDuaLessonContent lesson;
  final KidsDuaLessonContent? nextLesson;
  final KidsDuaCompletionResult result;
  final KidsDuaMyDayCompletionResult myDayResult;

  @override
  ConsumerState<_CompletionSheet> createState() => _CompletionSheetState();
}

class _CompletionSheetState extends ConsumerState<_CompletionSheet> {
  List<KidsDuaPracticeQuestion> _questions = const <KidsDuaPracticeQuestion>[];
  int _questionIndex = 0;
  int _correctAnswers = 0;
  int? _selectedIndex;
  bool _submitted = false;
  bool _practiceFinished = false;
  KidsDuaPracticeResult? _practiceResult;
  int _bonusXpAwarded = 0;
  int _bonusDropsAwarded = 0;

  @override
  void initState() {
    super.initState();
    final lessons = ref.read(kidsDuaLessonsProvider);
    final state = ref.read(kidsDuaLearningProvider);
    final practiceService = ref.read(kidsDuaMyDayPracticeServiceProvider);
    _questions = widget.myDayResult.dayCompletedNow
        ? practiceService.recapQuestionsForDay(
            completedDuaIds: ref.read(kidsDuaMyDayProvider).completedDuaIds,
            lessons: lessons,
            state: state,
          )
        : [
            if (practiceService.questionAfterLesson(
                  lesson: widget.lesson,
                  lessons: lessons,
                  state: state,
                ) !=
                null)
              practiceService.questionAfterLesson(
                lesson: widget.lesson,
                lessons: lessons,
                state: state,
              )!,
          ];
  }

  KidsDuaPracticeQuestion get _currentQuestion => _questions[_questionIndex];

  void _handleAnswer() {
    final isCorrect = _selectedIndex == _currentQuestion.correctIndex;
    if (!_submitted) {
      setState(() {
        _submitted = true;
        if (isCorrect) _correctAnswers += 1;
      });
      return;
    }
    if (!isCorrect) {
      setState(() {
        _submitted = false;
        _selectedIndex = null;
      });
      return;
    }
    if (_questionIndex + 1 < _questions.length) {
      setState(() {
        _questionIndex += 1;
        _selectedIndex = null;
        _submitted = false;
      });
      return;
    }
    final practiceResult = ref
        .read(kidsDuaLearningProvider.notifier)
        .recordPracticeSession(
          practicedLessonIds: _questions
              .map((question) => question.relatedDuaId)
              .toSet()
              .toList(growable: false),
          correctAnswers: _correctAnswers,
          totalQuestions: _questions.length,
        );
    var bonusXp = 0;
    var bonusDrops = 0;
    if (widget.myDayResult.dayCompletedNow) {
      final bonus = ref
          .read(kidsDuaLearningProvider.notifier)
          .awardEmbeddedPracticeBonus(
            xp: kidsDuaMyDayRecapXpBonus,
            drops: kidsDuaMyDayRecapDropsBonus,
            referenceId:
                'kids_dua_my_day_recap_${ref.read(kidsDuaMyDayProvider).date}',
          );
      bonusXp = bonus.xpAwarded;
      bonusDrops = bonus.oceanDropsAwarded;
    }
    setState(() {
      _practiceFinished = true;
      _practiceResult = practiceResult;
      _bonusXpAwarded = bonusXp;
      _bonusDropsAwarded = bonusDrops;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaCompletionCelebrateTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsDuaCompletionCelebrateBody(widget.lesson.title),
            style: const TextStyle(color: Color(0xFF655A4C)),
          ),
          const SizedBox(height: 12),
          Text(
            buildCompactRewardSummary(
              l10n,
              xp: widget.result.xpAwarded,
              drops: widget.result.oceanDropsAwarded,
            ),
            style: const TextStyle(fontSize: 12, color: Color(0xFF655A4C)),
          ),
          if (widget.result.newStickerIds.isNotEmpty ||
              widget.result.newRewardIds.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (widget.result.newStickerIds.isNotEmpty)
                  _RewardPill(
                    label: l10n.kidsDuaStickerUnlockedValue(
                      widget.result.newStickerIds.length,
                    ),
                  ),
                if (widget.result.newRewardIds.isNotEmpty)
                  _RewardPill(
                    label: l10n.kidsDuaCompletionRewardsValue(
                      widget.result.newRewardIds.length,
                    ),
                  ),
              ],
            ),
          ],
          if (widget.myDayResult.dayCompletedNow) ...[
            const SizedBox(height: 10),
            Text(
              buildCompactRewardSummary(
                l10n,
                xp: widget.myDayResult.xpAwarded,
                drops: widget.myDayResult.oceanDropsAwarded,
              ),
              style: const TextStyle(fontSize: 12, color: Color(0xFF655A4C)),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.kidsDuaMyDayCompleteBody,
              style: const TextStyle(color: Color(0xFF655A4C)),
            ),
          ],
          if (_questions.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (!_practiceFinished) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EF),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7D7BE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.myDayResult.dayCompletedNow
                          ? l10n.kidsDuaMyDayQuestionRecapTitle
                          : l10n.kidsDuaMyDayQuestionTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _questionPrompt(l10n, _currentQuestion),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._currentQuestion.options.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: _submitted
                              ? null
                              : () =>
                                    setState(() => _selectedIndex = entry.key),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color:
                                    _submitted &&
                                        entry.key ==
                                            _currentQuestion.correctIndex
                                    ? const Color(0xFF78A65A)
                                    : (_selectedIndex == entry.key
                                          ? const Color(0xFFB58B4D)
                                          : const Color(0xFFE8DDD0)),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: _selectedIndex == null ? null : _handleAnswer,
                      child: Text(
                        _submitted
                            ? (_selectedIndex == _currentQuestion.correctIndex
                                  ? l10n.kidsDuaMyDayQuestionContinueAction
                                  : l10n.kidsDuaMyDayQuestionTryAction)
                            : l10n.kidsDuaPracticeCheckAction,
                      ),
                    ),
                    if (_submitted) ...[
                      const SizedBox(height: 10),
                      Text(
                        _selectedIndex == _currentQuestion.correctIndex
                            ? l10n.kidsDuaMyDayQuestionMashaAllah
                            : l10n.kidsDuaMyDayQuestionTryAgain,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6D6255),
                        ),
                      ),
                      if (_currentQuestion.explanation != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _currentQuestion.explanation!,
                          style: const TextStyle(
                            color: Color(0xFF6D6255),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ] else ...[
              if (widget.myDayResult.dayCompletedNow) ...[
                Text(
                  l10n.kidsDuaMyDayRecapCompleteTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kidsDuaMyDayRecapCompleteBody(
                    _practiceResult?.correctAnswers ?? 0,
                    _practiceResult?.totalQuestions ?? 0,
                  ),
                  style: const TextStyle(color: Color(0xFF655A4C)),
                ),
                const SizedBox(height: 10),
                if ((_practiceResult?.correctAnswers ?? 0) > 0 ||
                    _bonusXpAwarded > 0 ||
                    _bonusDropsAwarded > 0)
                  Text(
                    buildCompactRewardSummary(
                      l10n,
                      xp: kidsDuaPracticeXp + _bonusXpAwarded,
                      drops: _bonusDropsAwarded,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF655A4C),
                    ),
                  ),
                const SizedBox(height: 14),
              ] else ...[
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed('kidsDuaMyDay');
                  },
                  child: Text(l10n.kidsDuaMyDayQuestionBackToDayAction),
                ),
              ),
              if (widget.nextLesson != null &&
                  !widget.myDayResult.dayCompletedNow) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushReplacementNamed(
                        'kidsDuaLesson',
                        pathParameters: {'lessonId': widget.nextLesson!.id},
                      );
                    },
                    child: Text(l10n.kidsDuaNextDuaAction),
                  ),
                ),
              ],
            ],
          ] else ...[
            const SizedBox(height: 16),
            if (widget.nextLesson != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pushReplacementNamed(
                      'kidsDuaLesson',
                      pathParameters: {'lessonId': widget.nextLesson!.id},
                    );
                  },
                  child: Text(l10n.kidsDuaNextDuaAction),
                ),
              ),
            if (widget.nextLesson != null) const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed('kidsDuaMyDay');
                    },
                    child: Text(l10n.kidsDuaMyDayQuestionBackToDayAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed(
                        'kidsDuaCategory',
                        pathParameters: {
                          'categoryId': widget.lesson.categoryId,
                        },
                      );
                    },
                    child: Text(l10n.kidsDuaBackToCategoryAction),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5D7BC)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

String _questionPrompt(
  AppLocalizations l10n,
  KidsDuaPracticeQuestion question,
) {
  switch (question.type) {
    case KidsDuaPracticeQuestionType.matchSituation:
      return l10n.kidsDuaMyDayMatchPrompt(question.prompt);
    case KidsDuaPracticeQuestionType.meaning:
      return l10n.kidsDuaMyDayMeaningPrompt(question.prompt);
    case KidsDuaPracticeQuestionType.behavior:
      return question.prompt;
  }
}
