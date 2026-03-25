import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/reminders/quran_live_activity_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/persistence/local_store.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../../shared/widgets/quran_text_span.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../application/quran_playback_orchestrator.dart';
import '../application/quran_audio_resilience.dart';
import '../application/quran_player_controller.dart';
import '../application/quran_reader_follow_mode_coordinator.dart';
import '../application/quran_reader_playback_controller.dart';
import '../application/quran_reader_playback_state.dart';
import '../application/quran_reader_transport.dart';
import '../application/quran_word_highlight_coordinator.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../application/quran_learning_system_service.dart';
import '../application/quran_user_intent_provider.dart';
import '../application/quran_note_enrichment.dart';
import '../application/quran_providers.dart';
import '../application/quran_reference_graph_provider.dart';
import '../application/quran_surah_insights_provider.dart';
import '../data/quran_audio_repository.dart';
import '../data/quran_word_glossary.dart';
import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_audio_resilience_models.dart';
import '../domain/quran_playback_request.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_reader_playback_presentation.dart';
import 'quran_theme_copy.dart';
import 'widgets/ayah_insights_section.dart';
import 'widgets/quran_continue_listening_card.dart';
import 'widgets/quran_playback_controls_card.dart';
import 'widgets/quran_related_reference_detail_sheet.dart';
import 'widgets/quran_reference_viewer.dart';

class QuranReaderPage extends ConsumerStatefulWidget {
  const QuranReaderPage({
    super.key,
    required this.surahNumber,
    this.initialAyah,
    this.endAyah,
    this.autoPlay = false,
    this.autoPlayFocusedSelectionLoop = false,
    this.learningJourneyId,
    this.learningJourneyStageId,
    this.highlightedTopicId,
    this.memorizationReviewMode = false,
    this.studyMode,
    this.memorizationReviewCount,
    this.memorizationLastReviewed,
  });

  final int surahNumber;
  final int? initialAyah;
  final int? endAyah;
  final bool autoPlay;
  final bool autoPlayFocusedSelectionLoop;
  final String? learningJourneyId;
  final String? learningJourneyStageId;
  final String? highlightedTopicId;
  final bool memorizationReviewMode;
  final QuranReaderStudyMode? studyMode;
  final int? memorizationReviewCount;
  final DateTime? memorizationLastReviewed;

  @override
  ConsumerState<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends ConsumerState<QuranReaderPage>
    with WidgetsBindingObserver {
  static const _controlsExpandedKey = 'learn.quran.readerControlsExpanded';

  bool _trackedOpen = false;
  late final AudioPlayer _audioPlayer;
  DateTime? _readingSessionStartedAt;
  Duration _pendingReadingDuration = Duration.zero;
  bool _isLoopRunning = false;
  bool _readerControlsExpanded = false;
  bool _isDownloadingSurah = false;
  int _downloadedAyahs = 0;
  int _downloadTotalAyahs = 0;
  String? _currentlyPlayingAyahKey;
  bool _isSwitchingAyahSource = false;
  bool _initialAyahAutoScrolled = false;
  int _lastSentLiveElapsedSecond = -1;
  bool _quranLiveActivitySupported = false;
  QuranAyah? _quranLiveActivityAyah;
  bool _isSurahPlaybackMode = false;
  bool _isPreparingSurahPlayback = false;
  bool _hasReachedEndOfSurahPlayback = false;
  bool _didAutoPlayFromRoute = false;
  int _playerSessionVersion = 0;
  List<QuranAyah> _surahPlaybackAyahs = const [];
  late final ScrollController _scrollController;
  final Map<int, GlobalKey> _ayahItemKeys = {};
  Timer? _userScrollSettledTimer;
  bool _isCoordinatorDrivenScroll = false;
  int _lastHandledFollowScrollRequest = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = ref.read(quranSharedAudioPlayerProvider);
    _bootstrapQuranLiveActivity();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScrollControllerChanged);
    final store = ref.read(localStoreProvider);
    _readerControlsExpanded = store.getBool(_controlsExpandedKey) ?? true;
    _resumeReadingSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pauseReadingSession();
    _flushReadingSession();
    _saveViewportReadingProgress();
    _userScrollSettledTimer?.cancel();
    _scrollController.removeListener(_handleScrollControllerChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!Platform.isIOS) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _pauseReadingSession();
      _saveViewportReadingProgress();
      final audioSettings = ref.read(quranAudioSettingsProvider);
      if (!audioSettings.backgroundPlaybackEnabled && _audioPlayer.playing) {
        unawaited(_playerController.pause());
      }
    } else if (state == AppLifecycleState.resumed) {
      _resumeReadingSession();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_trackedOpen) return;
    _trackedOpen = true;
    Future<void>.microtask(
      () => ref
          .read(quranReadingProgressProvider.notifier)
          .touchLocation(
            surahNumber: widget.surahNumber,
            ayahNumber: widget.initialAyah ?? 1,
          ),
    );
  }

  @override
  void didUpdateWidget(covariant QuranReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber ||
        oldWidget.initialAyah != widget.initialAyah) {
      _pauseReadingSession();
      _flushReadingSession();
      _resumeReadingSession();
      _ayahItemKeys.clear();
      _initialAyahAutoScrolled = false;
      _didAutoPlayFromRoute = false;
    }
  }

  void _resumeReadingSession() {
    _readingSessionStartedAt ??= DateTime.now();
  }

  void _pauseReadingSession() {
    final startedAt = _readingSessionStartedAt;
    if (startedAt == null) return;
    final elapsed = DateTime.now().difference(startedAt);
    if (!elapsed.isNegative) {
      _pendingReadingDuration += elapsed;
    }
    _readingSessionStartedAt = null;
  }

  void _flushReadingSession() {
    final duration = _pendingReadingDuration;
    if (duration < const Duration(seconds: 15)) {
      _pendingReadingDuration = Duration.zero;
      return;
    }
    ref
        .read(quranReadingStatsProvider.notifier)
        .logReadingSession(duration: duration);
    _pendingReadingDuration = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final useArabicReciterLabels = languageCode.toLowerCase().startsWith('ar');
    final surah = ref.watch(quranSurahMapProvider)[widget.surahNumber];
    final ayahsAsync = ref.watch(quranSurahAyahsProvider(widget.surahNumber));
    final ayahs = ayahsAsync.valueOrNull ?? const <QuranAyah>[];
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);
    final recitationSession = ref.watch(quranRecitationSessionProvider);
    final settings = ref.watch(quranReaderSettingsProvider);
    final quranAudioEnabled = ref.watch(quranAudioFunctionEnabledProvider);
    final settingsNotifier = ref.read(quranReaderSettingsProvider.notifier);
    final audioSettings = ref.watch(quranAudioSettingsProvider);
    final playbackState = ref.watch(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    final followModeState = ref.watch(
      quranReaderFollowModeCoordinatorProvider(widget.surahNumber),
    );
    final wordHighlightState = ref.watch(
      quranWordHighlightCoordinatorProvider(widget.surahNumber),
    );
    final audioRepository = ref.watch(quranAudioRepositoryProvider);
    final hifzSettings = ref.watch(quranHifzSettingsProvider);
    final revisionPlan = ref.watch(quranDailyRevisionPlanProvider);
    final wordFavorites = ref.watch(quranWordFavoritesProvider);
    final reading = ref.watch(quranReadingProgressProvider);
    final effectiveAyah = widget.initialAyah ?? reading.ayahNumber;
    final related = ref.watch(
      learnCrossDomainRelatedProvider(
        learnKeyFromLesson(
          domain: LearnDomainType.quran,
          lessonId: '${widget.surahNumber}:$effectiveAyah',
        ),
      ),
    );
    final verseKnowledge = ref.watch(
      quranKnowledgeForVerseProvider((widget.surahNumber, effectiveAyah)),
    );
    final currentAyahAnchorLabel = l10n.quranReferenceViewerReferenceLabel(
      '${widget.surahNumber}:$effectiveAyah',
    );
    final verseEnrichmentEntries = ref.watch(
      quranAyahEnrichmentForVerseLocalizedProvider((
        widget.surahNumber,
        effectiveAyah,
        languageCode,
      )),
    );
    final verseDisplayItems = ref.watch(
      quranAyahDisplayItemsForVerseLocalizedProvider((
        widget.surahNumber,
        effectiveAyah,
        languageCode,
      )),
    );
    final selectedReciter = audioRepository.reciterById(
      audioSettings.reciterId,
    );
    final isLiveWordSyncEnabled = settings.wordSyncHighlightBeta;
    final effectivePlaybackSpeed = _effectivePlaybackSpeed(
      configuredSpeed: audioSettings.playbackSpeed,
      lockToWordSync: isLiveWordSyncEnabled,
    );
    final activePlaybackAyahKey = quranAudioEnabled
        ? playbackState.activeAyahKey
        : null;
    ref.listen<QuranReaderPlaybackState>(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
      (previous, next) => _handlePlaybackStateChanged(previous, next, ayahs),
    );
    ref.listen<QuranReaderFollowModeState>(
      quranReaderFollowModeCoordinatorProvider(widget.surahNumber),
      _handleFollowModeStateChanged,
    );
    ref.listen<QuranPlaybackSourceState>(
      quranPlaybackSourceStateProvider,
      _handlePlaybackSourceStateChanged,
    );
    final availableAyahNumbers = ayahs.map((a) => a.ayahNumber).toSet();
    final selectedRepeatStart =
        availableAyahNumbers.contains(audioSettings.repeatStartAyah)
        ? audioSettings.repeatStartAyah
        : null;
    final selectedRepeatEnd =
        availableAyahNumbers.contains(audioSettings.repeatEndAyah)
        ? audioSettings.repeatEndAyah
        : null;
    final sessionForCurrentSurah =
        recitationSession != null &&
            recitationSession.surahNumber == widget.surahNumber
        ? recitationSession
        : null;
    final surahInsight = ref.watch(
      quranSurahInsightProvider(widget.surahNumber),
    );
    final surahThemes = ref.watch(
      quranThemesForSurahProvider(widget.surahNumber),
    );
    final learningJourney = widget.learningJourneyId == null
        ? null
        : LearningJourneyRegistry.journeyById(widget.learningJourneyId!);
    final learningStage = widget.learningJourneyStageId == null
        ? null
        : LearningJourneyRegistry.stageById(widget.learningJourneyStageId!);
    final effectiveStudyMode = _resolveStudyMode();
    final showBroaderStudyCards =
        effectiveStudyMode != QuranReaderStudyMode.reading &&
        effectiveStudyMode != QuranReaderStudyMode.memorization;
    final showRelatedOwnerLinks =
        effectiveStudyMode == QuranReaderStudyMode.study ||
        effectiveStudyMode == QuranReaderStudyMode.theme ||
        effectiveStudyMode == QuranReaderStudyMode.reflection;
    final topReferenceLimit = switch (effectiveStudyMode) {
      QuranReaderStudyMode.reading => 2,
      QuranReaderStudyMode.reflection => 3,
      QuranReaderStudyMode.study => verseKnowledge.references.length,
      QuranReaderStudyMode.memorization => 1,
      QuranReaderStudyMode.theme => 4,
    };
    final topVerseReferences = verseKnowledge.references
        .take(topReferenceLimit)
        .toList(growable: false);
    _maybeAutoScrollToInitialAyah(ayahs);
    _maybeAutoPlayFromRoute(ayahs);

    return AppPageScaffold(
      scrollController: _scrollController,
      headerIcon: Icons.menu_book_rounded,
      headerActions: [
        IconButton(
          tooltip: l10n.accessibilitySourcesAndLicensing,
          onPressed: () => _showSourcesInfoSheet(context),
          icon: const Icon(Icons.info_outline_rounded),
          color: const Color(0xFF3A3026),
        ),
      ],
      title: surah == null
          ? l10n.quranUnknownSurah
          : '${surah.transliteratedName} • ${surah.arabicName}',
      subtitle: surah == null
          ? l10n.quranReaderSubtitle
          : '${surah.englishName} • ${surah.revelationPlace} • ${surah.revelationClassification} • Revelation ${surah.revelationOrder} • ${surah.revelationPeriod} • ${surah.verseCount} ${l10n.quranAyahsLabel}',
      floatingBottom: _shouldShowFloatingPlayer(ayahs)
          ? _buildFloatingSurahPlaybackControls(ayahs, followModeState)
          : null,
      children: [
        if (widget.memorizationReviewMode && widget.initialAyah != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.repeat_rounded,
                      size: 18,
                      color: Color(0xFF7C5D3A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.quranReaderMemorizationFocusTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.quranReaderMemorizationFocusSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: QuranPresentationStyle.translucentColor(
                      context,
                      const Color(0xFF5A4A3A),
                    ),
                  ),
                ),
                if (widget.memorizationReviewCount != null ||
                    widget.memorizationLastReviewed != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.quranReaderMemorizationFocusMeta(
                      widget.memorizationReviewCount ?? 0,
                      widget.memorizationLastReviewed == null
                          ? l10n.quranNoneLabel
                          : MaterialLocalizations.of(context).formatMediumDate(
                              widget.memorizationLastReviewed!,
                            ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: QuranPresentationStyle.translucentColor(
                        context,
                        const Color(0xFF6A5A4A),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('quranMemorizationReview'),
                  icon: const Icon(Icons.list_alt_rounded),
                  label: Text(l10n.quranReaderMemorizationFocusOpenReview),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (learningJourney != null && learningStage != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alt_route_rounded,
                      size: 18,
                      color: Color(0xFF7C5D3A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.quranReaderJourneyContextTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.quranReaderJourneyContextSubtitle(
                    localizedStageTitle(context, learningStage),
                    localizedJourneyTitle(context, learningJourney),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: QuranPresentationStyle.translucentColor(
                      context,
                      const Color(0xFF5A4A3A),
                    ),
                  ),
                ),
                if (widget.highlightedTopicId?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 10),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      l10n.quranReaderJourneyContextThemeLabel(
                        localizedQuranTopicTitle(
                          l10n,
                          widget.highlightedTopicId!,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: Text(l10n.quranReaderJourneyContextOpenLesson),
                      onPressed: () => context.pushNamed(
                        'learnJourneyStage',
                        pathParameters: {
                          'journeyId': learningJourney.id,
                          'stageId': learningStage.id,
                        },
                      ),
                    ),
                    if (widget.highlightedTopicId?.trim().isNotEmpty ?? false)
                      ActionChip(
                        label: Text(l10n.quranReaderJourneyContextOpenTheme),
                        onPressed: () => context.pushNamed(
                          'quranTopicDetail',
                          pathParameters: {
                            'topicId': widget.highlightedTopicId!,
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _readerStudyModeIcon(effectiveStudyMode),
                size: 18,
                color: const Color(0xFF7C5D3A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranReaderModeCardTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: QuranPresentationStyle.translucentColor(
                          context,
                          const Color(0xFF6A5A4A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _readerStudyModeLabel(l10n, effectiveStudyMode),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _readerStudyModeSubtitle(
                        l10n,
                        effectiveStudyMode,
                        highlightedTopicId: widget.highlightedTopicId,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: QuranPresentationStyle.translucentColor(
                          context,
                          const Color(0xFF5A4A3A),
                        ),
                      ),
                    ),
                    if (widget.highlightedTopicId?.trim().isNotEmpty ??
                        false) ...[
                      const SizedBox(height: 10),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(
                          localizedQuranTopicTitle(
                            l10n,
                            widget.highlightedTopicId!,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<QuranReaderStudyMode>(
                tooltip: l10n.quranReaderModeChangeAction,
                initialValue: effectiveStudyMode,
                onSelected: _switchReaderStudyMode,
                itemBuilder: (context) => QuranReaderStudyMode.values
                    .map(
                      (mode) => PopupMenuItem<QuranReaderStudyMode>(
                        value: mode,
                        child: Text(_readerStudyModeLabel(l10n, mode)),
                      ),
                    )
                    .toList(growable: false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.quranReaderModeChangeAction,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.expand_more_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (surahInsight != null && showBroaderStudyCards) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.layers_outlined,
                      size: 18,
                      color: Color(0xFF7C5D3A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.quranSurahInsightsEntryTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.quranSurahInsightsEntrySubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: QuranPresentationStyle.translucentColor(
                      context,
                      const Color(0xFF5A4A3A),
                    ),
                  ),
                ),
                if (surahInsight.clusters.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.quranLearnMoreInsightsTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: QuranPresentationStyle.translucentColor(
                        context,
                        const Color(0xFF6A5A4A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: surahInsight.clusters
                        .map((cluster) => cluster.domain)
                        .toSet()
                        .take(3)
                        .map(
                          (domain) => Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(_quranInsightDomainLabel(l10n, domain)),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (surahThemes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.quranThemeMapRelatedThemesTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: QuranPresentationStyle.translucentColor(
                        context,
                        const Color(0xFF6A5A4A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: surahThemes
                        .take(3)
                        .map(
                          (topic) => ActionChip(
                            avatar: widget.highlightedTopicId == topic.id
                                ? const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                  )
                                : null,
                            backgroundColor:
                                widget.highlightedTopicId == topic.id
                                ? const Color(0xFFF1E1B8)
                                : null,
                            label: Text(
                              localizedQuranTopicTitle(l10n, topic.id),
                            ),
                            onPressed: () => context.pushNamed(
                              'quranTopicDetail',
                              pathParameters: {'topicId': topic.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (surahInsight.suggestedPaths.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => context.pushNamed(
                      'quranAyahInsightsPathDetail',
                      pathParameters: {
                        'pathId': surahInsight.suggestedPaths.first.id,
                      },
                    ),
                    icon: const Icon(Icons.alt_route_rounded),
                    label: Text(
                      _quranInsightPathTitle(
                        l10n,
                        surahInsight.suggestedPaths.first.id,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'quranSurahInsights',
                    pathParameters: {
                      'surahNumber': widget.surahNumber.toString(),
                    },
                  ),
                  icon: const Icon(Icons.layers_outlined),
                  label: Text(l10n.quranSurahInsightsEntryAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Column(
              children: [
                InkWell(
                  key: const ValueKey('quran-reader-settings-toggle'),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final nextValue = !_readerControlsExpanded;
                    setState(() => _readerControlsExpanded = nextValue);
                    ref
                        .read(localStoreProvider)
                        .setBool(_controlsExpandedKey, nextValue);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: Color(0xFF6A5A4A),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.quranReaderSettingsToggleTitle,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          l10n.quranReaderSettingsExpandCollapse,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A5A4A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _readerControlsExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_readerControlsExpanded) ...[
                  const SizedBox(height: 10),
                  ..._buildReaderSettingsSections(
                    context: context,
                    l10n: l10n,
                    settings: settings,
                    settingsNotifier: settingsNotifier,
                    quranAudioEnabled: quranAudioEnabled,
                    audioSettings: audioSettings,
                    audioRepository: audioRepository,
                    selectedReciter: selectedReciter,
                    useArabicReciterLabels: useArabicReciterLabels,
                    isLiveWordSyncEnabled: isLiveWordSyncEnabled,
                    effectivePlaybackSpeed: effectivePlaybackSpeed,
                    ayahs: ayahs,
                    selectedRepeatStart: selectedRepeatStart,
                    selectedRepeatEnd: selectedRepeatEnd,
                    hifzSettings: hifzSettings,
                    revisionPlan: revisionPlan,
                    wordFavorites: wordFavorites,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (quranAudioEnabled &&
            sessionForCurrentSurah != null &&
            !_audioPlayer.playing) ...[
          const SizedBox(height: 12),
          QuranContinueListeningCard(
            session: sessionForCurrentSurah,
            formatPosition: _formatPosition,
            onResume: ayahs.isEmpty
                ? null
                : () => _resumeRecitationSession(sessionForCurrentSurah),
            onRestartSurah: ayahs.isEmpty
                ? null
                : () => _restartRecitationSession(sessionForCurrentSurah),
          ),
        ],
        if (related.isNotEmpty && showRelatedOwnerLinks) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnContentReferencesTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: related
                      .map(
                        (item) => ActionChip(
                          label: Text(item.title),
                          onPressed: () => context.pushNamed(
                            item.routeName,
                            pathParameters: item.pathParameters,
                            queryParameters: item.queryParameters,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.lifeAddReflectionTitle),
                  subtitle: Text(l10n.lifeAddReflectionSubtitle),
                  onTap: () => context.pushNamed('journalCreate'),
                ),
              ],
            ),
          ),
        ],
        if (settings.showLearnMore &&
            topVerseReferences.isNotEmpty &&
            effectiveStudyMode != QuranReaderStudyMode.memorization) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranLearnMoreSectionTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topVerseReferences
                      .map(
                        (reference) => QuranReferenceChip(
                          referenceId: reference.id,
                          anchorLabel: currentAyahAnchorLabel,
                          relationReason: reference.contextSummary,
                          leading: const Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                if (verseDisplayItems.isNotEmpty &&
                    effectiveStudyMode != QuranReaderStudyMode.reading) ...[
                  const SizedBox(height: 10),
                  AyahInsightsSection(
                    title: l10n.quranLearnMoreInsightsTitle,
                    entries: verseEnrichmentEntries,
                    items: verseDisplayItems,
                  ),
                ],
                if (verseKnowledge.lifeLessons.isNotEmpty &&
                    showRelatedOwnerLinks) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: l10n.quranReferenceViewerRelatedLifeLessons,
                    items: verseKnowledge.lifeLessons,
                    anchorLabel: currentAyahAnchorLabel,
                    itemLimit: effectiveStudyMode == QuranReaderStudyMode.theme
                        ? 4
                        : 3,
                  ),
                ],
                if (verseKnowledge.hadithEntries.isNotEmpty &&
                    showRelatedOwnerLinks) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: l10n.quranReferenceViewerRelatedHadith,
                    items: verseKnowledge.hadithEntries,
                    anchorLabel: currentAyahAnchorLabel,
                    itemLimit: effectiveStudyMode == QuranReaderStudyMode.study
                        ? 4
                        : 3,
                  ),
                ],
                if (verseKnowledge.prophets.isNotEmpty &&
                    effectiveStudyMode == QuranReaderStudyMode.study) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: l10n.quranReferenceViewerRelatedProphets,
                    items: verseKnowledge.prophets,
                    anchorLabel: currentAyahAnchorLabel,
                    itemLimit: 3,
                  ),
                ],
                if (verseKnowledge.journeys.isNotEmpty &&
                    showRelatedOwnerLinks) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: l10n.quranReferenceViewerRelatedJourneys,
                    items: verseKnowledge.journeys,
                    anchorLabel: currentAyahAnchorLabel,
                    itemLimit: effectiveStudyMode == QuranReaderStudyMode.study
                        ? 4
                        : 2,
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (ayahsAsync.isLoading && ayahs.isEmpty)
          const PremiumCard(child: LinearProgressIndicator())
        else if (ayahsAsync.hasError && ayahs.isEmpty)
          PremiumCard(
            child: Text(
              l10n.quranReaderTransliterationLoadError,
            ),
          )
        else if (ayahs.isEmpty)
          PremiumCard(child: Text(l10n.quranSearchNoResults))
        else
          ...ayahs.map(
            (ayah) => Padding(
              key: _ayahKeyFor(ayah.ayahNumber),
              padding: const EdgeInsets.only(bottom: 12),
              child: QuranAyahCard(
                ayah: ayah,
                isHighlighted: _isAyahHighlighted(ayah.ayahNumber),
                isNowPlaying:
                    activePlaybackAyahKey ==
                    '${ayah.surahNumber}:${ayah.ayahNumber}',
                activeWordIndex:
                    activePlaybackAyahKey ==
                            '${ayah.surahNumber}:${ayah.ayahNumber}' &&
                        wordHighlightState.activeAyahKey ==
                            '${ayah.surahNumber}:${ayah.ayahNumber}'
                    ? wordHighlightState.activeWordIndex
                    : null,
                isBookmarked: bookmarks.any(
                  (bookmark) =>
                      bookmark.surahNumber == ayah.surahNumber &&
                      bookmark.ayahNumber == ayah.ayahNumber,
                ),
                isMarkedForMemorization:
                    ref.watch(
                      quranMemorizationEntryForAyahProvider((
                        ayah.surahNumber,
                        ayah.ayahNumber,
                      )),
                    ) !=
                    null,
                notesCount: notes
                    .where(
                      (note) =>
                          note.surahNumber == ayah.surahNumber &&
                          note.ayahNumber == ayah.ayahNumber,
                    )
                    .length,
                onBookmark: () {
                  ref
                      .read(quranBookmarksProvider.notifier)
                      .toggleBookmark(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                },
                onAddNote: () => _showAddNoteDialog(context, ref, ayah),
                showArabic: settings.showArabic,
                showTranslation: settings.showTranslation,
                showTransliteration: settings.showTransliteration,
                showWordByWord: settings.showArabic && settings.showWordByWord,
                showActions: !settings.cleanReadingMode,
                hifzRevealMode: hifzSettings.enabled
                    ? hifzSettings.revealMode
                    : HifzRevealMode.full,
                arabicFontSize: 24 * (settings.arabicScalePercent / 100.0),
                translationFontSize:
                    14 * (settings.translationScalePercent / 100.0),
                transliterationFontSize:
                    15 * (settings.transliterationScalePercent / 100.0),
                harakatColor: settings.redDiacriticsEnabled
                    ? const Color(0xFFC22A2A)
                    : null,
                contextualLinks: ref.watch(
                  quranContextualKnowledgeLinksForVerseProvider((
                    ayah.surahNumber,
                    ayah.ayahNumber,
                  )),
                ),
                themeTopics: ref.watch(
                  quranThemesForVerseProvider((
                    ayah.surahNumber,
                    ayah.ayahNumber,
                  )),
                ),
                studyMode: effectiveStudyMode,
                activeTopicId: widget.highlightedTopicId,
                onPlayAyah: quranAudioEnabled ? () => _handleAyahPlay(ayah) : null,
                onToggleMemorization: () => ref
                    .read(quranMemorizationProgressProvider.notifier)
                    .toggleVerse(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    ),
                onTap: quranAudioEnabled
                    ? () => _handleAyahPlay(ayah)
                    : null,
                onPlayWord: (word) => _onWordTap(context, ref, word),
                onMistakeCheckpoint: () {
                  ref
                      .read(quranHifzSettingsProvider.notifier)
                      .markMistakeCheckpoint(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                },
              ),
            ),
          ),
        if (ayahs.isNotEmpty) const SizedBox(height: 96),
      ],
    );
  }

  bool _isAyahHighlighted(int ayahNumber) {
    final start = widget.initialAyah;
    if (start == null) return false;
    final end = widget.endAyah;
    if (end == null || end < start) {
      return ayahNumber == start;
    }
    return ayahNumber >= start && ayahNumber <= end;
  }

  QuranReaderStudyMode _resolveStudyMode() {
    if (widget.studyMode != null) return widget.studyMode!;
    if (widget.memorizationReviewMode) {
      return QuranReaderStudyMode.memorization;
    }
    final hasThemeFocus = widget.highlightedTopicId?.trim().isNotEmpty ?? false;
    if (hasThemeFocus) return QuranReaderStudyMode.theme;
    if (widget.learningJourneyId != null &&
        widget.learningJourneyStageId != null) {
      return QuranReaderStudyMode.study;
    }
    final userIntent = ref.read(quranSelectedUserIntentProvider);
    if (userIntent != null) {
      return quranPreferredReaderModeForIntent(
        userIntent,
        hasHighlightedTopic: hasThemeFocus,
      );
    }
    return QuranReaderStudyMode.reading;
  }

  void _switchReaderStudyMode(QuranReaderStudyMode mode) {
    context.pushReplacementNamed(
      'quranReader',
      pathParameters: {'surahNumber': widget.surahNumber.toString()},
      queryParameters: <String, String>{
        if (widget.initialAyah != null) 'ayah': widget.initialAyah.toString(),
        if (widget.endAyah != null) 'endAyah': widget.endAyah.toString(),
        if (widget.learningJourneyId?.trim().isNotEmpty ?? false)
          'journeyId': widget.learningJourneyId!,
        if (widget.learningJourneyStageId?.trim().isNotEmpty ?? false)
          'stageId': widget.learningJourneyStageId!,
        if (widget.highlightedTopicId?.trim().isNotEmpty ?? false)
          'topicId': widget.highlightedTopicId!,
        if (widget.memorizationReviewMode) 'review': 'memorization',
        'mode': mode.wireName,
      },
    );
  }

  bool _shouldShowFloatingPlayer(List<QuranAyah> ayahs) {
    if (!ref.read(quranAudioFunctionEnabledProvider)) return false;
    if (ayahs.isEmpty) return false;
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    final activeAyahKey = _resolvedCurrentPlaybackAyahKey();
    return _isPreparingSurahPlayback ||
        playbackState.isSurahPlaybackMode ||
        _isLoopRunning ||
        activeAyahKey != null ||
        playbackState.isPlaying;
  }

  Widget _buildFloatingSurahPlaybackControls(
    List<QuranAyah> ayahs,
    QuranReaderFollowModeState followModeState,
  ) {
    final l10n = AppLocalizations.of(context);
    final playbackState = ref.watch(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    final hasPlayback = playbackState.hasPlayback;
    final isPlaying = playbackState.isPlaying;
    final nowRecitingLabel = buildQuranReaderNowPlayingLabel(
      l10n: l10n,
      playbackState: playbackState,
      surahMap: ref.read(quranSurahMapProvider),
    );
    final totalDuration = _surahPlaybackTotalDuration();
    final computedPosition = _surahPlaybackAbsolutePosition();
    final absolutePosition = computedPosition < Duration.zero
        ? Duration.zero
        : (computedPosition > totalDuration ? totalDuration : computedPosition);
    final maxMillis = totalDuration.inMilliseconds.toDouble();
    final currentMillis = absolutePosition.inMilliseconds
        .clamp(0, totalDuration.inMilliseconds)
        .toDouble();
    final isPreparingPlayback =
        _isPreparingSurahPlayback ||
        playbackState.sourceResolutionState ==
            QuranPlaybackSourceResolutionState.preparingTransition;
    final canGoPreviousAyah =
        playbackState.canGoPreviousAyah && !isPreparingPlayback;
    final canGoNextAyah = playbackState.canGoNextAyah && !isPreparingPlayback;
    final canRestartAyah =
        playbackState.canRestartAyah && !isPreparingPlayback;
    final canGoPreviousSurah =
        playbackState.canGoPreviousSurah &&
        playbackState.isSurahPlaybackMode &&
        !isPreparingPlayback;
    final canGoNextSurah =
        playbackState.canGoNextSurah &&
        playbackState.isSurahPlaybackMode &&
        !isPreparingPlayback;
    final repeatSummaryLabel = buildQuranPlaybackRepeatSummaryLabel(
      l10n,
      playbackState,
    );
    final sourceStatusLabel = buildQuranPlaybackSourceStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (followModeState.canReturnToCurrentAyah) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: const Color(0xFFF3E8DA),
                elevation: 4,
                borderRadius: BorderRadius.circular(999),
                child: IconButton(
                  key: const ValueKey('quran-reader-return-to-current-ayah-pill'),
                  tooltip: l10n.quranReaderReturnToCurrentAyahAction,
                  onPressed: () => ref
                      .read(
                        quranReaderFollowModeCoordinatorProvider(
                          widget.surahNumber,
                        ).notifier,
                      )
                      .requestReturnToCurrentAyah(),
                  icon: const Icon(Icons.my_location_rounded, size: 20),
                  color: const Color(0xFF6A5A4A),
                ),
              ),
            ),
          ),
        ],
        QuranPlaybackControlsCard(
          isPreparing: isPreparingPlayback,
          hasPlayback: hasPlayback,
          isPlaying: isPlaying,
          currentPosition: absolutePosition,
          totalDuration: totalDuration,
          nowRecitingLabel: nowRecitingLabel,
          hasReachedEnd: _hasReachedEndOfSurahPlayback,
          previousSurahNumber: playbackState.previousSurahNumber,
          nextSurahNumber: playbackState.nextSurahNumber,
          onClose: _closeSurahPlaybackPlayer,
          onBack15: () => _seekRelative(const Duration(seconds: -15)),
          onTogglePlayback: playbackState.hasRecoverableFailure
              ? _retryCurrentPlayback
              : () => _toggleCurrentPlayback(ayahs),
          onForward15: () => _seekRelative(const Duration(seconds: 15)),
          canGoPreviousAyah: canGoPreviousAyah,
          canRestartAyah: canRestartAyah,
          canGoNextAyah: canGoNextAyah,
          onPreviousAyah: canGoPreviousAyah
              ? () => _handleTransportAction(
                  ayahs,
                  QuranReaderTransportAction.previousAyah,
                )
              : null,
          onRestartAyah: canRestartAyah
              ? () => _handleTransportAction(
                  ayahs,
                  QuranReaderTransportAction.restartAyah,
                )
              : null,
          onNextAyah: canGoNextAyah
              ? () => _handleTransportAction(
                  ayahs,
                  QuranReaderTransportAction.nextAyah,
                )
              : null,
          canGoPreviousSurah: canGoPreviousSurah,
          canGoNextSurah: canGoNextSurah,
          onPreviousSurah: canGoPreviousSurah
              ? () => _handleAdjacentSurahTransition(-1)
              : null,
          onNextSurah: canGoNextSurah
              ? () => _handleAdjacentSurahTransition(1)
              : null,
          followModeEnabled: followModeState.followModeEnabled,
          isFollowSuspended: followModeState.isTemporarilySuspended,
          showFollowSuspendedHint: false,
          onToggleFollowMode: () => ref
              .read(quranReaderSettingsProvider.notifier)
              .setFollowPlayback(!followModeState.followModeEnabled),
          onReturnToCurrentAyah: followModeState.canReturnToCurrentAyah
              ? () => ref
                    .read(
                      quranReaderFollowModeCoordinatorProvider(
                        widget.surahNumber,
                      ).notifier,
                    )
                    .requestReturnToCurrentAyah()
              : null,
          onSeek: maxMillis > 0
              ? (value) =>
                    _seekSurahAbsolute(Duration(milliseconds: value.round()))
              : null,
          sliderMax: maxMillis > 0 ? maxMillis : 1,
          sliderValue: maxMillis > 0 ? currentMillis : 0,
          onOpenExpandedPlayer: hasPlayback
              ? () => context.pushNamed(
                    'quranFocusRecitation',
                    queryParameters: <String, String>{
                      'surah': widget.surahNumber.toString(),
                      if (playbackState.activeAyahNumber != null ||
                          playbackState.storedSession?.ayahNumber != null)
                        'ayah': (playbackState.activeAyahNumber ??
                                playbackState.storedSession!.ayahNumber)
                            .toString(),
                    },
                  )
              : null,
          repeatSummaryLabel: repeatSummaryLabel,
          sourceStatusLabel: sourceStatusLabel,
          showRetryAction: playbackState.hasRecoverableFailure,
        ),
      ],
    );
  }

  String? _resolvedCurrentPlaybackAyahKey() {
    return ref
        .read(quranReaderPlaybackControllerProvider(widget.surahNumber))
        .activeAyahKey;
  }

  QuranAyah? _resolvedCurrentPlaybackAyah(List<QuranAyah> ayahs) {
    return resolveQuranReaderPlaybackAyah(
      ayahs: ayahs,
      ayahKey: _resolvedCurrentPlaybackAyahKey(),
    );
  }

  void _syncCurrentPlaybackAyahKey() {
    if (!mounted) return;
    final nextKey = _resolvedCurrentPlaybackAyahKey();
    if (nextKey == _currentlyPlayingAyahKey) return;
    setState(() => _currentlyPlayingAyahKey = nextKey);
  }

  void _handleFollowModeStateChanged(
    QuranReaderFollowModeState? previous,
    QuranReaderFollowModeState next,
  ) {
    if (!mounted || !next.shouldAutoScroll) {
      return;
    }
    if (next.scrollRequestVersion == _lastHandledFollowScrollRequest) {
      return;
    }
    final targetAyahNumber = next.pendingScrollAyahNumber;
    if (targetAyahNumber == null) {
      return;
    }
    _lastHandledFollowScrollRequest = next.scrollRequestVersion;
    unawaited(_executeFollowModeScroll(targetAyahNumber));
  }

  void _handlePlaybackStateChanged(
    QuranReaderPlaybackState? previous,
    QuranReaderPlaybackState next,
    List<QuranAyah> ayahs,
  ) {
    if (!mounted) return;
    _currentlyPlayingAyahKey = next.activeAyahKey;
    _isSurahPlaybackMode = next.isSurahPlaybackMode;

    if (previous?.isPlaying == true && !next.isPlaying) {
      _saveCurrentRecitationSession();
    }

    if (next.hasReachedEnd && previous?.hasReachedEnd != true) {
      _saveCurrentRecitationSession(preferTrackEnd: true);
      _quranLiveActivityAyah = null;
      unawaited(_endQuranLiveActivityIfEnabled());
      unawaited(_playerController.stop());
      if (mounted) {
        setState(() {
          _isSurahPlaybackMode = false;
          _currentlyPlayingAyahKey = null;
          _hasReachedEndOfSurahPlayback = true;
        });
      }
      return;
    }

    if (!_isLoopRunning &&
        !_isSwitchingAyahSource &&
        !next.isSurahPlaybackMode &&
        !next.isPlaying &&
        (next.status == QuranReaderPlaybackStatus.completed ||
            next.status == QuranReaderPlaybackStatus.idle) &&
        next.activeAyahKey == null) {
      _quranLiveActivityAyah = null;
      unawaited(_endQuranLiveActivityIfEnabled());
    }

    final activeAyahChanged = previous?.activeAyahKey != next.activeAyahKey;
    if (activeAyahChanged) {
      final ayah = next.activeAyahKey == null
          ? null
          : resolveQuranReaderPlaybackAyah(
              ayahs: ayahs,
              ayahKey: next.activeAyahKey,
            );
      if (ayah == null) {
        return;
      }
      _quranLiveActivityAyah = ayah;
      unawaited(
        _updateQuranLiveActivity(
          ayah: ayah,
          force: true,
          isPlayingOverride: next.isPlaying,
        ),
      );
      return;
    }

    if (next.activeAyahKey != null) {
      if (_quranLiveActivityAyah != null) {
        final elapsedSeconds = _audioPlayer.position.inSeconds;
        if (elapsedSeconds == _lastSentLiveElapsedSecond &&
            next.duration == previous?.duration &&
            next.isPlaying == previous?.isPlaying &&
            previous?.activeAyahKey == next.activeAyahKey) {
          return;
        }
        _lastSentLiveElapsedSecond = elapsedSeconds;
        unawaited(
          _updateQuranLiveActivity(
            ayah: _quranLiveActivityAyah!,
            force: next.isBuffering || next.duration != previous?.duration,
            isPlayingOverride: next.isPlaying,
          ),
        );
      }
    }
  }

  void _handlePlaybackSourceStateChanged(
    QuranPlaybackSourceState? previous,
    QuranPlaybackSourceState next,
  ) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (next.didApplyFallback &&
        previous?.didApplyFallback != true &&
        next.resolutionState ==
            QuranPlaybackSourceResolutionState.fallbackApplied) {
      final message = next.activeSourceType == QuranPlaybackSourceType.localDownload
          ? l10n.quranPlaybackFallbackUsingDownloaded
          : l10n.quranPlaybackFallbackUsingStream;
      messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    if (next.hasFailure &&
        (previous?.failureType != next.failureType ||
            previous?.ayahNumber != next.ayahNumber ||
            previous?.surahNumber != next.surahNumber)) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            buildQuranPlaybackStatusLabel(
              l10n: l10n,
              playbackState: ref.read(
                quranReaderPlaybackControllerProvider(widget.surahNumber),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _maybeAutoPlayFromRoute(List<QuranAyah> ayahs) {
    if (!widget.autoPlay || _didAutoPlayFromRoute || ayahs.isEmpty) return;
    _didAutoPlayFromRoute = true;
    final targetAyahNumber = widget.initialAyah;
    final targetAyah = targetAyahNumber == null
        ? null
        : ayahs
              .where((ayah) => ayah.ayahNumber == targetAyahNumber)
              .firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (targetAyah != null) {
        final selectedAyahs = _routePlaybackSelectionAyahs(ayahs);
        unawaited(() async {
          if (widget.autoPlayFocusedSelectionLoop && selectedAyahs.isNotEmpty) {
            await _startFocusedSelectionLoopPlayback(
              selectionAyahs: selectedAyahs,
              initialAyah: targetAyah,
              scrollBeforePlay: true,
            );
            return;
          }
          await _runProgrammaticScrollToAyah(targetAyah.ayahNumber, retries: 30);
          if (!mounted) return;
          await _startSurahPlaybackFromAyah(
            ayahs,
            targetAyah,
            scrollBeforePlay: true,
          );
        }());
        return;
      }
      unawaited(_startSurahPlayback(ayahs: ayahs, initialIndex: 0));
    });
  }

  List<QuranAyah> _routePlaybackSelectionAyahs(List<QuranAyah> ayahs) {
    final startAyah = widget.initialAyah;
    if (startAyah == null) {
      return const <QuranAyah>[];
    }
    final endAyah = widget.endAyah ?? startAyah;
    return ayahs
        .where(
          (ayah) =>
              ayah.ayahNumber >= startAyah && ayah.ayahNumber <= endAyah,
        )
        .toList(growable: false);
  }

  void _maybeAutoScrollToInitialAyah(List<QuranAyah> ayahs) {
    final targetAyah = widget.initialAyah;
    if (_initialAyahAutoScrolled || targetAyah == null) return;
    if (!ayahs.any((ayah) => ayah.ayahNumber == targetAyah)) return;
    _initialAyahAutoScrolled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_runProgrammaticScrollToAyah(targetAyah, retries: 30));
    });
  }

  QuranPlaybackOrchestrator get _playbackOrchestrator =>
      ref.read(quranPlaybackOrchestratorProvider);

  QuranPlayerController get _playerController =>
      ref.read(quranPlayerControllerProvider);

  Future<QuranPreparedPlayback> _preparePlayback({
    required QuranPlaybackRequest request,
    required List<QuranAyah> ayahs,
    required String reciterId,
    BismillahPlaybackMode? mode,
  }) {
    return _playbackOrchestrator.preparePlayback(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahs.map((item) => item.ayahNumber).toList(growable: false),
      mode: mode ?? ref.read(quranDefaultBismillahPlaybackModeProvider),
    );
  }

  void _rememberPlaybackSession({
    required List<QuranAyah> ayahs,
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
    required bool isSurahMode,
  }) {
    _playerController.rememberSession(
      QuranActivePlaybackSession(
        surahNumber: widget.surahNumber,
        ayahNumbers: ayahs
            .map((item) => item.ayahNumber)
            .toList(growable: false),
        reciterId: reciterId,
        playbackSpeed: playbackSpeed,
        includeMediaTags: includeMediaTags,
        isSurahMode: isSurahMode,
        bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
      ),
    );
  }

  Future<void> _applyPreparedPlayback({
    required QuranPreparedPlayback prepared,
    required List<QuranAyah> ayahs,
    required String reciterId,
    required double playbackSpeed,
    required int sessionVersion,
    required bool isSurahMode,
    required String? currentAyahKey,
    LoopMode loopMode = LoopMode.off,
  }) async {
    final audioSettings = ref.read(quranAudioSettingsProvider);

    _isSwitchingAyahSource = true;
    try {
      final started = await _playerController.startPreparedPlayback(
        prepared,
        reciterId: reciterId,
        playbackSpeed: playbackSpeed,
        includeMediaTags: audioSettings.backgroundPlaybackEnabled,
        loopMode: loopMode,
      );
      if (!started) {
        return;
      }
      if (sessionVersion != _playerSessionVersion) return;
      _rememberPlaybackSession(
        ayahs: ayahs,
        reciterId: reciterId,
        playbackSpeed: playbackSpeed,
        includeMediaTags: audioSettings.backgroundPlaybackEnabled,
        isSurahMode: isSurahMode,
      );
      if (mounted) {
        setState(() {
          _isSurahPlaybackMode = isSurahMode;
          _surahPlaybackAyahs = isSurahMode ? ayahs : const [];
          _currentlyPlayingAyahKey = currentAyahKey;
          _hasReachedEndOfSurahPlayback = false;
        });
      }
      final targetAyah = ayahs[prepared.initialLogicalIndex];
      _quranLiveActivityAyah = targetAyah;
      await _updateQuranLiveActivity(ayah: targetAyah, force: true);
    } finally {
      _isSwitchingAyahSource = false;
    }
  }

  Future<void> _handleAyahPlay(QuranAyah ayah) async {
    if (!mounted) return;
    final ayahKey = quranPlaybackAyahKey(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );
    final followPlayback = ref.read(quranReaderSettingsProvider).followPlayback;
    if (_resolvedCurrentPlaybackAyahKey() == ayahKey &&
        _audioPlayer.audioSource != null &&
        !_isSurahPlaybackMode) {
      if (_audioPlayer.playing) {
        await _playerController.pause();
      } else {
        final resumed = await _resumeLoadedPlaybackIfPossible();
        if (!resumed) {
          await _playAyahAudio(
            ayah,
            request: QuranPlaybackRequest(
              surahNumber: ayah.surahNumber,
              ayahNumber: ayah.ayahNumber,
              resumePosition: _audioPlayer.position,
              playbackReason: QuranPlaybackReason.resume,
            ),
          );
        } else if (followPlayback) {
          await _reengageFollowModeForAyah(ayah.ayahNumber);
        }
      }
      return;
    }
    setState(() {
      _isSurahPlaybackMode = false;
      _surahPlaybackAyahs = const [];
      _currentlyPlayingAyahKey = ayahKey;
      _hasReachedEndOfSurahPlayback = false;
    });
    final started = await _playerController.playAyah(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      playbackReason: QuranPlaybackReason.jump,
    );
    if (started && followPlayback) {
      await _reengageFollowModeForAyah(ayah.ayahNumber);
    }
    if (!started && mounted) {
      setState(() {
        _currentlyPlayingAyahKey = _resolvedCurrentPlaybackAyahKey();
      });
    }
  }

  Future<void> _reengageFollowModeForAyah(int ayahNumber) async {
    ref
        .read(quranReaderFollowModeCoordinatorProvider(widget.surahNumber).notifier)
        .handleAyahInteraction(ayahNumber);
    await _runProgrammaticScrollToAyah(ayahNumber, retries: 20);
  }

  Future<void> _toggleCurrentPlayback(List<QuranAyah> ayahs) async {
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    if (_isSurahPlaybackMode) {
      await _toggleSurahPlayback(ayahs);
      return;
    }
    if (!playbackState.hasPlayback) {
      await _toggleSurahPlayback(ayahs);
      return;
    }
    if (playbackState.isPlaying) {
      await _playerController.pause();
      return;
    }
    final resumed = await _resumeLoadedPlaybackIfPossible();
    if (resumed) return;
    final currentAyah =
        _resolvedCurrentPlaybackAyah(ayahs) ?? _currentAyahFromPlaybackKey(ayahs);
    if (currentAyah != null) {
      await _playAyahAudio(
        currentAyah,
        request: QuranPlaybackRequest(
          surahNumber: currentAyah.surahNumber,
          ayahNumber: currentAyah.ayahNumber,
          resumePosition: _audioPlayer.position,
          playbackReason: QuranPlaybackReason.resume,
        ),
      );
      return;
    }
    await _playerController.resumeCurrentPlayback();
  }

  Future<void> _bootstrapQuranLiveActivity() async {
    final service = QuranLiveActivityService();
    _quranLiveActivitySupported = await service.isSupported();
  }

  List<Widget> _buildReaderSettingsSections({
    required BuildContext context,
    required AppLocalizations l10n,
    required QuranReaderSettings settings,
    required QuranReaderSettingsNotifier settingsNotifier,
    required bool quranAudioEnabled,
    required QuranAudioSettings audioSettings,
    required QuranAudioRepository audioRepository,
    required QuranReciter selectedReciter,
    required bool useArabicReciterLabels,
    required bool isLiveWordSyncEnabled,
    required double effectivePlaybackSpeed,
    required List<QuranAyah> ayahs,
    required int? selectedRepeatStart,
    required int? selectedRepeatEnd,
    required QuranHifzSettings hifzSettings,
    required List<QuranRevisionItem> revisionPlan,
    required List<QuranWordFavorite> wordFavorites,
  }) {
    final widgets = <Widget>[
      _SettingsGroupCard(
        title: l10n.quranReaderReadingDisplaySectionTitle,
        subtitle: l10n.quranReaderReadingDisplaySectionSubtitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScaleControl(
              label: l10n.quranArabicTextSize,
              percent: settings.arabicScalePercent,
              onChanged: settingsNotifier.setArabicScalePercent,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ScaleControl(
                    label: l10n.quranTranslationTextSize,
                    percent: settings.translationScalePercent,
                    onChanged: settingsNotifier.setTranslationScalePercent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ScaleControl(
                    label: l10n.quranTransliterationTextSize,
                    percent: settings.transliterationScalePercent,
                    onChanged:
                        settingsNotifier.setTransliterationScalePercent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: settings.translationCode,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: l10n.quranReaderTranslationSourceLabel,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              items: quranTranslationCodes
                  .map(
                    (code) => DropdownMenuItem(
                      value: code,
                      child: Text(
                        _translationLabelForCode(l10n, code),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                settingsNotifier.setTranslationCode(value);
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-show-arabic'),
              contentPadding: EdgeInsets.zero,
              value: settings.showArabic,
              title: Text(l10n.quranShowArabic),
              onChanged: settingsNotifier.setShowArabic,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-show-translation'),
              contentPadding: EdgeInsets.zero,
              value: settings.showTranslation,
              title: Text(l10n.quranShowTranslation),
              onChanged: settingsNotifier.setShowTranslation,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey(
                'quran-reader-setting-show-transliteration',
              ),
              contentPadding: EdgeInsets.zero,
              value: settings.showTransliteration,
              title: Text(l10n.quranShowTransliteration),
              onChanged: settingsNotifier.setShowTransliteration,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-clean-reading-mode'),
              contentPadding: EdgeInsets.zero,
              value: settings.cleanReadingMode,
              title: Text(l10n.quranCleanReadingMode),
              onChanged: settingsNotifier.setCleanReadingMode,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-red-diacritics'),
              contentPadding: EdgeInsets.zero,
              value: settings.redDiacriticsEnabled,
              title: Text(l10n.quranReaderRedDiacriticsTitle),
              subtitle: Text(l10n.quranReaderRedDiacriticsSubtitle),
              onChanged: settingsNotifier.setRedDiacriticsEnabled,
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      _SettingsGroupCard(
        title: l10n.quranReaderStudyToolsSectionTitle,
        subtitle: l10n.quranReaderStudyToolsSectionSubtitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-show-learn-more'),
              contentPadding: EdgeInsets.zero,
              value: settings.showLearnMore,
              title: Text(l10n.quranShowLearnMore),
              subtitle: Text(l10n.quranShowLearnMoreSubtitle),
              onChanged: settingsNotifier.setShowLearnMore,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-word-by-word'),
              contentPadding: EdgeInsets.zero,
              value: settings.showWordByWord,
              title: Text(l10n.quranWordTranslationBetaTitle),
              subtitle: Text(l10n.quranWordTranslationBetaSubtitle),
              onChanged: settingsNotifier.setShowWordByWord,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('quran-reader-setting-live-word-sync'),
              contentPadding: EdgeInsets.zero,
              value: settings.wordSyncHighlightBeta,
              title: Text(l10n.quranReaderLiveWordSyncTitle),
              subtitle: Text(l10n.quranReaderLiveWordSyncSubtitle),
              onChanged: _setWordSyncHighlightBeta,
            ),
          ],
        ),
      ),
    ];

    if (quranAudioEnabled) {
      widgets.addAll([
        const SizedBox(height: 10),
        _SettingsGroupCard(
          title: l10n.quranReaderAudioPlaybackSectionTitle,
          subtitle: l10n.quranReaderAudioPlaybackSectionSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile.adaptive(
                key: const ValueKey(
                  'quran-reader-setting-background-playback',
                ),
                contentPadding: EdgeInsets.zero,
                value: audioSettings.backgroundPlaybackEnabled,
                title: Text(l10n.quranReaderBackgroundPlaybackTitle),
                subtitle: Text(l10n.quranReaderBackgroundPlaybackSubtitle),
                onChanged: _setBackgroundPlaybackEnabled,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedReciter.id,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l10n.quranReaderReciterLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: QuranAudioRepository.reciters
                          .map(
                            (reciter) => DropdownMenuItem<String>(
                              value: reciter.id,
                              child: Text(
                                useArabicReciterLabels
                                    ? reciter.arabicName
                                    : reciter.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        unawaited(_handleReciterChanged(context, value));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.tonalIcon(
                    onPressed: () => _playReciterSample(
                      context: context,
                      reciterId: audioSettings.reciterId,
                    ),
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: Text(l10n.quranReaderReciterSampleAction),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SettingsSubsectionLabel(
                l10n.quranReaderPlaybackSpeedTitle,
              ),
              Row(
                children: [
                  Text(
                    l10n.quranReaderPlaybackSpeedTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '${effectivePlaybackSpeed.toStringAsFixed(2)}x',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A5A4A),
                    ),
                  ),
                ],
              ),
              Slider(
                min: 0.6,
                max: 1.2,
                divisions: 6,
                value: effectivePlaybackSpeed,
                onChanged: isLiveWordSyncEnabled
                    ? null
                    : (value) {
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setPlaybackSpeed(value);
                      },
              ),
              if (isLiveWordSyncEnabled)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.quranReaderPlaybackSpeedLockedHint,
                    style: const TextStyle(
                      color: Color(0xFF6A5A4A),
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              _SettingsSubsectionLabel(l10n.quranReaderRepeatPracticeTitle),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: selectedRepeatStart,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l10n.quranRepeatFromLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.quranNoneLabel),
                        ),
                        ...ayahs.map(
                          (a) => DropdownMenuItem<int?>(
                            value: a.ayahNumber,
                            child: Text(
                              l10n.quranAyahNumberLabel(a.ayahNumber),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setRepeatRange(
                              startAyah: value,
                              endAyah: selectedRepeatEnd,
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: selectedRepeatEnd,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l10n.quranRepeatToLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.quranNoneLabel),
                        ),
                        ...ayahs.map(
                          (a) => DropdownMenuItem<int?>(
                            value: a.ayahNumber,
                            child: Text(
                              l10n.quranAyahNumberLabel(a.ayahNumber),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setRepeatRange(
                              startAyah: selectedRepeatStart,
                              endAyah: value,
                            );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: audioSettings.ayahLoopCount,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l10n.quranLoopCountLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}x'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setAyahLoopCount(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _isLoopRunning ? null : () => _playConfiguredLoop(ayahs),
                      icon: const Icon(Icons.repeat_rounded),
                      label: Text(l10n.quranPlayLoopLabel),
                    ),
                  ),
                ],
              ),
              if (selectedRepeatStart == null || selectedRepeatEnd == null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.quranLoopRangeHint,
                  style: const TextStyle(
                    color: Color(0xFF6A5A4A),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        _SettingsGroupCard(
          title: l10n.quranReaderDownloadsOfflineSectionTitle,
          subtitle: l10n.quranReaderDownloadsOfflineSectionSubtitle,
          child: FutureBuilder<bool>(
            future: audioRepository.isSurahDownloaded(
              reciterId: audioSettings.reciterId,
              surahNumber: widget.surahNumber,
            ),
            builder: (context, snapshot) {
              final fullyDownloaded = snapshot.data ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _isDownloadingSurah
                              ? null
                              : () => _downloadCurrentSurah(
                                  context: context,
                                  repository: audioRepository,
                                  reciterId: audioSettings.reciterId,
                                ),
                          icon: const Icon(Icons.download_rounded),
                          label: Text(
                            _isDownloadingSurah
                                ? l10n.quranReaderDownloadInProgressLabel(
                                    _downloadedAyahs,
                                    _downloadTotalAyahs,
                                  )
                                : l10n.quranReaderDownloadSurahAction,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: fullyDownloaded
                              ? () => _clearCurrentSurahDownload(
                                  context: context,
                                  repository: audioRepository,
                                  reciterId: audioSettings.reciterId,
                                )
                              : null,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: Text(l10n.quranReaderRemoveDownloadAction),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.quranReaderAudioDownloadNote,
                    style: const TextStyle(
                      color: Color(0xFF6A5A4A),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ]);
    }

    widgets.addAll([
      const SizedBox(height: 10),
      _SettingsGroupCard(
        title: l10n.quranReaderMemorizationReviewSectionTitle,
        subtitle: l10n.quranReaderMemorizationReviewSectionSubtitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.quranMemorizationTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: hifzSettings.enabled,
                  onChanged: (value) {
                    ref
                        .read(quranHifzSettingsProvider.notifier)
                        .setEnabled(value);
                  },
                ),
              ],
            ),
            if (hifzSettings.enabled) ...[
              const SizedBox(height: 6),
              SegmentedButton<HifzRevealMode>(
                segments: [
                  ButtonSegment(
                    value: HifzRevealMode.full,
                    label: Text(l10n.quranHifzRevealModeFull),
                  ),
                  ButtonSegment(
                    value: HifzRevealMode.firstWordOnly,
                    label: Text(l10n.quranHifzRevealModeFirstWord),
                  ),
                  ButtonSegment(
                    value: HifzRevealMode.hidden,
                    label: Text(l10n.quranHifzRevealModeHidden),
                  ),
                ],
                selected: {hifzSettings.revealMode},
                onSelectionChanged: (selection) {
                  ref
                      .read(quranHifzSettingsProvider.notifier)
                      .setRevealMode(selection.first);
                },
              ),
              const SizedBox(height: 8),
              Text(
                l10n.quranDailyRevisionPlanLabel(revisionPlan.length),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A5A4A),
                ),
              ),
              const SizedBox(height: 6),
              if (revisionPlan.isEmpty)
                Text(
                  l10n.quranDailyRevisionEmpty,
                  style: const TextStyle(color: Color(0xFF6A5A4A)),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: revisionPlan
                      .map(
                        (item) => ActionChip(
                          label: Text('${item.surahNumber}:${item.ayahNumber}'),
                          onPressed: () {
                            context.pushNamed(
                              'quranReader',
                              pathParameters: {
                                'surahNumber': item.surahNumber.toString(),
                              },
                              queryParameters: {
                                'ayah': item.ayahNumber.toString(),
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
            ],
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => context.pushNamed('quranWordReview'),
              icon: const Icon(Icons.style_outlined),
              label: Text(l10n.quranOpenReviewDeckLabel(wordFavorites.length)),
            ),
          ],
        ),
      ),
    ]);

    return widgets;
  }

  Future<void> _updateQuranLiveActivity({
    required QuranAyah ayah,
    bool force = false,
    bool? isPlayingOverride,
  }) async {
    if (!_quranLiveActivitySupported) return;
    final audioSettings = ref.read(quranAudioSettingsProvider);
    if (!audioSettings.backgroundPlaybackEnabled) return;
    if (!_audioPlayer.playing && isPlayingOverride != true && !force) return;
    final surah = ref.read(quranSurahMapProvider)[ayah.surahNumber];
    final reciter = ref
        .read(quranAudioRepositoryProvider)
        .reciterById(audioSettings.reciterId);
    final elapsed = _audioPlayer.position.inSeconds.clamp(0, 24 * 60 * 60);
    final total = (_audioPlayer.duration?.inSeconds ?? 0).clamp(
      0,
      24 * 60 * 60,
    );
    await QuranLiveActivityService().updatePlaybackCard(
      surahNumber: ayah.surahNumber,
      surahName: surah?.transliteratedName ?? 'Surah ${ayah.surahNumber}',
      surahArabicName: surah?.arabicName ?? '',
      ayahNumber: ayah.ayahNumber,
      reciterName: reciter.name,
      isPlaying: isPlayingOverride ?? _audioPlayer.playing,
      elapsedSeconds: elapsed,
      totalSeconds: total,
    );
  }

  Future<void> _endQuranLiveActivityIfEnabled() async {
    if (!_quranLiveActivitySupported) return;
    _quranLiveActivityAyah = null;
    await QuranLiveActivityService().endPlaybackCard();
  }

  GlobalKey _ayahKeyFor(int ayahNumber) {
    return _ayahItemKeys.putIfAbsent(ayahNumber, () => GlobalKey());
  }

  void _saveViewportReadingProgress() {
    final ayahNumber = _visibleAyahFromViewport();
    if (ayahNumber == null) return;
    ref
        .read(quranReadingProgressProvider.notifier)
        .touchLocation(surahNumber: widget.surahNumber, ayahNumber: ayahNumber);
  }

  int? _visibleAyahFromViewport() {
    if (_ayahItemKeys.isEmpty) return null;
    const targetY = 160.0;
    int? bestAyah;
    var bestDistance = double.infinity;

    for (final entry in _ayahItemKeys.entries) {
      final ayahNumber = entry.key;
      final context = entry.value.currentContext;
      if (context == null) continue;
      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      if (bottom < 0) continue;
      if (top <= targetY && bottom >= targetY) {
        return ayahNumber;
      }
      final distance = (top - targetY).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestAyah = ayahNumber;
      }
    }
    return bestAyah;
  }

  Future<void> _scrollToAyah(int ayahNumber, {int retries = 0}) async {
    final key = _ayahItemKeys[ayahNumber];
    final targetContext = key?.currentContext;
    if (targetContext == null) {
      if (retries > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        await _scrollToAyah(ayahNumber, retries: retries - 1);
      }
      return;
    }
    final renderObject = targetContext.findRenderObject();
    if (renderObject == null ||
        renderObject is! RenderBox ||
        !renderObject.attached) {
      if (retries > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        await _scrollToAyah(ayahNumber, retries: retries - 1);
      }
      return;
    }

    if (!_scrollController.hasClients) {
      if (retries > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        await _scrollToAyah(ayahNumber, retries: retries - 1);
      }
      return;
    }

    final listRenderObject = _scrollController.position.context.storageContext
        .findRenderObject();
    final previousOffset = _scrollController.offset;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final currentTop = renderObject.localToGlobal(Offset.zero).dy;
    final currentBottom = currentTop + renderObject.size.height;
    final comfortableTop = 116.0;
    final comfortableBottom = viewportHeight - 190.0;
    if (currentTop >= comfortableTop && currentBottom <= comfortableBottom) {
      return;
    }

    var didFallback = false;
    if (listRenderObject != null) {
      try {
        final targetOffset =
            (_scrollController.offset +
                    renderObject
                        .localToGlobal(Offset.zero, ancestor: listRenderObject)
                        .dy -
                    120)
                .clamp(
                  _scrollController.position.minScrollExtent,
                  _scrollController.position.maxScrollExtent,
                );
        if ((targetOffset - previousOffset).abs() > 28) {
          didFallback = true;
          await _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 340),
            curve: Curves.easeOutCubic,
          );
        }
      } catch (_) {
        didFallback = false;
      }
    }

    if (!didFallback) {
      if (!targetContext.mounted) return;
      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeOutCubic,
        alignment: 0.1,
      );
    }

    if (retries > 0) {
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      final visible = bottom >= 0 && top <= viewportHeight;
      if (!visible && (_scrollController.offset - previousOffset).abs() < 0.5) {
        await Future<void>.delayed(const Duration(milliseconds: 70));
        if (!mounted) return;
        await _scrollToAyah(ayahNumber, retries: retries - 1);
      }
    }
  }

  Future<void> _runProgrammaticScrollToAyah(
    int ayahNumber, {
    int retries = 0,
  }) async {
    final coordinator = ref.read(
      quranReaderFollowModeCoordinatorProvider(widget.surahNumber).notifier,
    );
    coordinator.markProgrammaticScrollStarted();
    _isCoordinatorDrivenScroll = true;
    try {
      await _scrollToAyah(ayahNumber, retries: retries);
    } finally {
      _isCoordinatorDrivenScroll = false;
      coordinator.markProgrammaticScrollCompleted();
    }
  }

  Future<void> _executeFollowModeScroll(int ayahNumber) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_runProgrammaticScrollToAyah(ayahNumber, retries: 20));
    });
  }

  void _handleScrollControllerChanged() {
    if (!_scrollController.hasClients || _isCoordinatorDrivenScroll) {
      return;
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.idle) {
      return;
    }
    final coordinator = ref.read(
      quranReaderFollowModeCoordinatorProvider(widget.surahNumber).notifier,
    );
    coordinator.handleUserScrollInteraction();
    _userScrollSettledTimer?.cancel();
    _userScrollSettledTimer = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) {
        return;
      }
      coordinator.handleUserScrollSettled();
      _saveViewportReadingProgress();
    });
  }

  Future<void> _toggleSurahPlayback(List<QuranAyah> ayahs) async {
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    if (_hasReachedEndOfSurahPlayback) {
      setState(() => _hasReachedEndOfSurahPlayback = false);
      await _startSurahPlayback(ayahs: ayahs, initialIndex: 0);
      return;
    }
    if (_isSurahPlaybackMode) {
      if (playbackState.isPlaying) {
        await _playerController.pause();
      } else {
        final resumed = await _resumeLoadedPlaybackIfPossible();
        if (!resumed) {
          if (ayahs.isEmpty) return;
          final index = (playbackState.currentIndex ?? 0).clamp(
            0,
            ayahs.length - 1,
          );
          await _startSurahPlayback(
            ayahs: ayahs,
            initialIndex: index,
            initialPosition: _audioPlayer.position,
          );
        }
      }
      return;
    }
    if (ayahs.isEmpty) return;
    await _startSurahPlayback(ayahs: ayahs, initialIndex: 0);
  }

  Future<void> _handleTransportAction(
    List<QuranAyah> ayahs,
    QuranReaderTransportAction action,
  ) async {
    if (ayahs.isEmpty || _isPreparingSurahPlayback) return;
    final currentIndex = resolveQuranReaderActiveAyahIndex(
      ayahs: ayahs,
      isSurahPlaybackMode: _isSurahPlaybackMode,
      playerIndex: _audioPlayer.currentIndex,
      currentAyahKey: _resolvedCurrentPlaybackAyahKey(),
    );
    final targetIndex = resolveQuranReaderTransportIndex(
      ayahCount: ayahs.length,
      currentIndex: currentIndex,
      action: action,
    );
    if (targetIndex == null) return;
    await _transportToAyahIndex(
      ayahs: ayahs,
      targetIndex: targetIndex,
      restartCurrentAyah: action == QuranReaderTransportAction.restartAyah,
    );
  }

  Future<void> _transportToAyahIndex({
    required List<QuranAyah> ayahs,
    required int targetIndex,
    bool restartCurrentAyah = false,
  }) async {
    if (ayahs.isEmpty) return;
    final safeIndex = targetIndex.clamp(0, ayahs.length - 1);
    final targetAyah = ayahs[safeIndex];
    final followPlayback = ref.read(quranReaderSettingsProvider).followPlayback;
    if (_isSurahPlaybackMode) {
      await _startSurahPlayback(
        ayahs: ayahs,
        initialIndex: safeIndex,
        initialPosition: Duration.zero,
        scrollBeforePlay: followPlayback,
      );
      return;
    }
    setState(() {
      _isSurahPlaybackMode = false;
      _surahPlaybackAyahs = const [];
      _currentlyPlayingAyahKey =
          '${targetAyah.surahNumber}:${targetAyah.ayahNumber}';
      _hasReachedEndOfSurahPlayback = false;
    });
    await _playAyahAudio(
      targetAyah,
      request: QuranPlaybackRequest(
        surahNumber: targetAyah.surahNumber,
        ayahNumber: targetAyah.ayahNumber,
        playbackReason: restartCurrentAyah
            ? QuranPlaybackReason.freshPlay
            : QuranPlaybackReason.jump,
      ),
    );
    if (followPlayback) {
      ref
          .read(quranReaderFollowModeCoordinatorProvider(widget.surahNumber).notifier)
          .handleAyahInteraction(targetAyah.ayahNumber);
      await _runProgrammaticScrollToAyah(targetAyah.ayahNumber, retries: 20);
    }
  }

  Future<void> _startSurahPlaybackFromAyah(
    List<QuranAyah> ayahs,
    QuranAyah startAyah, {
    bool scrollBeforePlay = false,
  }) async {
    if (ayahs.isEmpty || _isPreparingSurahPlayback) return;
    final targetIndex = ayahs.indexWhere(
      (item) =>
          item.surahNumber == startAyah.surahNumber &&
          item.ayahNumber == startAyah.ayahNumber,
    );
    if (targetIndex < 0) return;

    if (_isSurahPlaybackMode &&
        _surahPlaybackAyahs.length == ayahs.length &&
        _surahPlaybackAyahs.isNotEmpty &&
        _surahPlaybackAyahs.first.surahNumber == ayahs.first.surahNumber &&
        _audioPlayer.sequence.length == ayahs.length) {
      await _startSurahPlayback(
        ayahs: ayahs,
        initialIndex: targetIndex,
        scrollBeforePlay: scrollBeforePlay,
      );
      return;
    }

    await _startSurahPlayback(
      ayahs: ayahs,
      initialIndex: targetIndex,
      scrollBeforePlay: scrollBeforePlay,
    );
  }

  QuranAyah? _currentAyahFromPlaybackKey(List<QuranAyah> ayahs) {
    return resolveQuranReaderPlaybackAyah(
      ayahs: ayahs,
      ayahKey: _currentlyPlayingAyahKey,
    );
  }

  Future<void> _startSurahPlayback({
    required List<QuranAyah> ayahs,
    required int initialIndex,
    Duration initialPosition = Duration.zero,
    bool scrollBeforePlay = false,
  }) async {
    if (ayahs.isEmpty) return;
    final sessionVersion = ++_playerSessionVersion;
    final safeInitialIndex = initialIndex.clamp(0, ayahs.length - 1);
    setState(() => _isPreparingSurahPlayback = true);
    try {
      final audioSettings = ref.read(quranAudioSettingsProvider);
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: audioSettings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      final request = QuranPlaybackRequest(
        surahNumber: widget.surahNumber,
        ayahNumber: ayahs[safeInitialIndex].ayahNumber,
        resumePosition: initialPosition > Duration.zero
            ? initialPosition
            : null,
        playbackReason: initialPosition > Duration.zero
            ? QuranPlaybackReason.resume
            : safeInitialIndex == 0
            ? QuranPlaybackReason.freshPlay
            : QuranPlaybackReason.jump,
        isSurahEntry: safeInitialIndex == 0,
      );
      final prepared = await _preparePlayback(
        request: request,
        ayahs: ayahs,
        reciterId: audioSettings.reciterId,
      );
      if (sessionVersion != _playerSessionVersion) return;
      final first = ayahs[safeInitialIndex];
      await _applyPreparedPlayback(
        prepared: prepared,
        ayahs: ayahs,
        reciterId: audioSettings.reciterId,
        playbackSpeed: playbackSpeed,
        sessionVersion: sessionVersion,
        isSurahMode: true,
        currentAyahKey: '${first.surahNumber}:${first.ayahNumber}',
      );
      if (sessionVersion != _playerSessionVersion) return;
      if (scrollBeforePlay) {
        await _runProgrammaticScrollToAyah(first.ayahNumber, retries: 30);
      }
    } finally {
      if (mounted) {
        setState(() => _isPreparingSurahPlayback = false);
      }
    }
  }

  void _closeSurahPlaybackPlayer() {
    _playerSessionVersion += 1;
    _playerController.clearSession();
    unawaited(_playerController.stop());
    unawaited(_endQuranLiveActivityIfEnabled());
    if (!mounted) return;
    setState(() {
      _isSurahPlaybackMode = false;
      _isPreparingSurahPlayback = false;
      _isLoopRunning = false;
      _hasReachedEndOfSurahPlayback = false;
      _currentlyPlayingAyahKey = null;
      _surahPlaybackAyahs = const [];
      _quranLiveActivityAyah = null;
    });
  }

  void _saveCurrentRecitationSession({bool preferTrackEnd = false}) {
    if (!_isSurahPlaybackMode || _surahPlaybackAyahs.isEmpty) return;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    if (currentIndex < 0 || currentIndex >= _surahPlaybackAyahs.length) return;
    final ayah = _surahPlaybackAyahs[currentIndex];
    final sourcePosition = preferTrackEnd
        ? (_audioPlayer.duration ?? _audioPlayer.position)
        : _audioPlayer.position;
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          positionSeconds: sourcePosition.inSeconds,
        );
  }

  Future<void> _resumeRecitationSession(QuranRecitationSession session) async {
    if (_isPreparingSurahPlayback || session.surahNumber != widget.surahNumber) {
      return;
    }
    await _playerController.resumeStoredRecitationSession();
  }

  Future<void> _restartRecitationSession(QuranRecitationSession session) async {
    if (_isPreparingSurahPlayback || session.surahNumber != widget.surahNumber) {
      return;
    }
    await _playerController.resumeStoredRecitationSession(
      restartFromSurah: true,
    );
  }

  Future<void> _seekRelative(Duration delta) async {
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    final trackDuration = _audioPlayer.duration ?? Duration.zero;
    final currentPosition = _audioPlayer.position;
    var target = currentPosition + delta;

    if (!_isSurahPlaybackMode) {
      if (target < Duration.zero) target = Duration.zero;
      if (trackDuration > Duration.zero && target > trackDuration) {
        target = trackDuration;
      }
      await _playerController.seek(target);
      _syncCurrentPlaybackAyahKey();
      return;
    }

    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < _surahPlaybackAyahs.length - 1;

    if (target < Duration.zero && hasPrev) {
      final previousIndex = currentIndex - 1;
      await _playerController.seek(Duration.zero, index: previousIndex);
      _syncCurrentPlaybackAyahKey();
      return;
    }

    if (trackDuration > Duration.zero && target > trackDuration && hasNext) {
      final nextIndex = currentIndex + 1;
      await _playerController.seek(Duration.zero, index: nextIndex);
      _syncCurrentPlaybackAyahKey();
      return;
    }

    if (target < Duration.zero) target = Duration.zero;
    if (trackDuration > Duration.zero && target > trackDuration) {
      target = trackDuration;
    }
    await _playerController.seek(target, index: currentIndex);
    _syncCurrentPlaybackAyahKey();
  }

  Duration _surahPlaybackTotalDuration() {
    if (!_isSurahPlaybackMode) {
      return _audioPlayer.duration ?? Duration.zero;
    }
    final sequence = _audioPlayer.sequence;
    if (sequence.isEmpty) return Duration.zero;
    var totalMs = 0;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    for (var i = 0; i < sequence.length; i += 1) {
      final duration =
          sequence[i].duration ??
          (i == currentIndex ? _audioPlayer.duration : null) ??
          Duration.zero;
      totalMs += duration.inMilliseconds;
    }
    return Duration(milliseconds: totalMs);
  }

  Duration _surahPlaybackAbsolutePosition() {
    if (!_isSurahPlaybackMode) {
      return _audioPlayer.position;
    }
    final sequence = _audioPlayer.sequence;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    if (sequence.isEmpty) return _audioPlayer.position;
    var elapsedMs = 0;
    for (var i = 0; i < currentIndex && i < sequence.length; i += 1) {
      elapsedMs += (sequence[i].duration ?? Duration.zero).inMilliseconds;
    }
    elapsedMs += _audioPlayer.position.inMilliseconds;
    return Duration(milliseconds: elapsedMs);
  }

  Future<void> _seekSurahAbsolute(Duration target) async {
    if (!_isSurahPlaybackMode) {
      await _playerController.seek(target);
      _syncCurrentPlaybackAyahKey();
      return;
    }
    final sequence = _audioPlayer.sequence;
    if (sequence.isEmpty) return;
    var remainingMs = target.inMilliseconds;
    for (var i = 0; i < sequence.length; i += 1) {
      final itemDuration =
          sequence[i].duration ??
          (i == (_audioPlayer.currentIndex ?? 0)
              ? _audioPlayer.duration
              : null) ??
          Duration.zero;
      final itemMs = itemDuration.inMilliseconds;
      if (remainingMs <= itemMs || i == sequence.length - 1) {
        final positionMs = remainingMs.clamp(0, itemMs);
        await _playerController.seek(Duration(milliseconds: positionMs), index: i);
        _syncCurrentPlaybackAyahKey();
        return;
      }
      remainingMs -= itemMs;
    }
  }

  String _formatPosition(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = value.inHours;
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _playAyahAudio(
    QuranAyah ayah, {
    required QuranPlaybackRequest request,
    BismillahPlaybackMode? bismillahMode,
    LoopMode loopMode = LoopMode.off,
  }) async {
    final sessionVersion = ++_playerSessionVersion;
    final settings = ref.read(quranAudioSettingsProvider);
    final readerSettings = ref.read(quranReaderSettingsProvider);
    final effectiveBismillahMode =
        bismillahMode ?? ref.read(quranDefaultBismillahPlaybackModeProvider);
    final playbackSpeed = _effectivePlaybackSpeed(
      configuredSpeed: settings.playbackSpeed,
      lockToWordSync: readerSettings.wordSyncHighlightBeta,
    );
    final prepared = await _preparePlayback(
      request: request,
      ayahs: <QuranAyah>[ayah],
      reciterId: settings.reciterId,
      mode: effectiveBismillahMode,
    );
    await _applyPreparedPlayback(
      prepared: prepared,
      ayahs: <QuranAyah>[ayah],
      reciterId: settings.reciterId,
      playbackSpeed: playbackSpeed,
      sessionVersion: sessionVersion,
      isSurahMode: false,
      currentAyahKey: '${ayah.surahNumber}:${ayah.ayahNumber}',
      loopMode: loopMode,
    );
  }

  Future<void> _startFocusedSelectionLoopPlayback({
    required List<QuranAyah> selectionAyahs,
    required QuranAyah initialAyah,
    bool scrollBeforePlay = false,
  }) async {
    if (selectionAyahs.isEmpty || _isPreparingSurahPlayback) {
      return;
    }
    final initialIndex = selectionAyahs.indexWhere(
      (ayah) =>
          ayah.surahNumber == initialAyah.surahNumber &&
          ayah.ayahNumber == initialAyah.ayahNumber,
    );
    if (initialIndex < 0) {
      return;
    }
    final sessionVersion = ++_playerSessionVersion;
    setState(() => _isPreparingSurahPlayback = true);
    try {
      final audioSettings = ref.read(quranAudioSettingsProvider);
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: audioSettings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      final request = QuranPlaybackRequest(
        surahNumber: widget.surahNumber,
        ayahNumber: initialAyah.ayahNumber,
        playbackReason: QuranPlaybackReason.freshPlay,
        isSurahEntry: initialAyah.ayahNumber == 1,
      );
      final prepared = await _preparePlayback(
        request: request,
        ayahs: selectionAyahs,
        reciterId: audioSettings.reciterId,
      );
      if (sessionVersion != _playerSessionVersion) {
        return;
      }
      await _applyPreparedPlayback(
        prepared: prepared,
        ayahs: selectionAyahs,
        reciterId: audioSettings.reciterId,
        playbackSpeed: playbackSpeed,
        sessionVersion: sessionVersion,
        isSurahMode: selectionAyahs.length > 1,
        currentAyahKey: '${initialAyah.surahNumber}:${initialAyah.ayahNumber}',
        loopMode: selectionAyahs.length == 1 ? LoopMode.one : LoopMode.all,
      );
      if (sessionVersion != _playerSessionVersion) {
        return;
      }
      if (scrollBeforePlay) {
        await _runProgrammaticScrollToAyah(initialAyah.ayahNumber, retries: 30);
      }
    } finally {
      if (mounted) {
        setState(() => _isPreparingSurahPlayback = false);
      }
    }
  }

  Future<void> _playReciterSample({
    required BuildContext context,
    required String reciterId,
  }) async {
    try {
      final settings = ref.read(quranAudioSettingsProvider);
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final repository = ref.read(quranAudioRepositoryProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: settings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      final sample = repository.sampleUri(reciterId).toString();
      final reciter = repository.reciterById(reciterId);
      await _audioPlayer.stop();
      if (mounted) {
        setState(() {
          _currentlyPlayingAyahKey = null;
        });
      }
      _quranLiveActivityAyah = null;
      await _endQuranLiveActivityIfEnabled();
      await _audioPlayer.setSpeed(playbackSpeed);
      await _audioPlayer.setUrl(
        sample,
        tag: settings.backgroundPlaybackEnabled
            ? MediaItem(
                id: 'quran:sample:$reciterId',
                album: 'Path of Nur • Quran sample',
                title: 'Reciter sample',
                artist: reciter.name,
              )
            : null,
      );
      await _audioPlayer.play();
    } catch (error) {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.quranReaderReciterSampleError(error.toString())),
        ),
      );
    }
  }

  Future<void> _handleReciterChanged(
    BuildContext context,
    String reciterId,
  ) async {
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    if (!playbackState.hasPlayback) {
      ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciterId);
      return;
    }

    final switched = await _playerController.switchReciter(reciterId);
    if (switched) {
      return;
    }

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.quranReciterSwitchFailed)),
    );
  }

  Future<void> _handleAdjacentSurahTransition(int offset) async {
    if (offset == 0) return;
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    final activeSurah = playbackState.activeSurahNumber;
    if (activeSurah == null) return;
    final targetSurah = (activeSurah + offset).clamp(1, 114);
    if (targetSurah == activeSurah) return;
    final started = await _playerController.playAdjacentSurah(offset);
    if (!mounted) return;
    if (!started) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranReaderAdjacentSurahUnavailable)),
      );
      return;
    }
    context.pushReplacementNamed(
      'quranReader',
      pathParameters: {'surahNumber': targetSurah.toString()},
      queryParameters: const {'ayah': '1'},
    );
  }

  Future<void> _retryCurrentPlayback() async {
    await _playerController.retryCurrentPlayback();
  }

  double _effectivePlaybackSpeed({
    required double configuredSpeed,
    required bool lockToWordSync,
  }) {
    return lockToWordSync ? 1.0 : configuredSpeed;
  }

  void _setWordSyncHighlightBeta(bool value) {
    ref
        .read(quranReaderSettingsProvider.notifier)
        .setWordSyncHighlightBeta(value);
    if (value) {
      ref.read(quranAudioSettingsProvider.notifier).setPlaybackSpeed(1.0);
    }
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final playbackSpeed = _effectivePlaybackSpeed(
      configuredSpeed: audioSettings.playbackSpeed,
      lockToWordSync: value,
    );
    unawaited(_playerController.setPlaybackSpeed(playbackSpeed));
  }

  void _setBackgroundPlaybackEnabled(bool value) {
    ref
        .read(quranAudioSettingsProvider.notifier)
        .setBackgroundPlaybackEnabled(value);
    if (!value) {
      unawaited(_endQuranLiveActivityIfEnabled());
    } else if (_quranLiveActivityAyah != null) {
      unawaited(
        _updateQuranLiveActivity(ayah: _quranLiveActivityAyah!, force: true),
      );
    }
    if (value) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final isForeground =
        lifecycle == null || lifecycle == AppLifecycleState.resumed;
    if (!isForeground && _audioPlayer.playing) {
      unawaited(_playerController.pause());
    }
  }

  void _showSourcesInfoSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sources & Licensing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  _SourceLine(
                    title: 'Qur’an Arabic text (reader/search):',
                    value:
                        'package:quran (Flutter package), based on Quran data bundled in package.',
                  ),
                  _SourceLine(
                    title: 'Translations:',
                    value:
                        'package:quran translation set (e.g., Saheeh International, Clear Quran, Urdu, Bengali, Indonesian, Turkish, Dari).',
                  ),
                  _SourceLine(
                    title: 'Transliteration:',
                    value:
                        'AlQuran.cloud API (edition: en.transliteration) cached locally on device.',
                  ),
                  _SourceLine(
                    title: 'Audio recitations:',
                    value: 'EveryAyah CDN (Husary, Alafasy, Abdul Basit).',
                  ),
                  _SourceLine(
                    title: 'Word timing segments (live sync beta):',
                    value:
                        'Quran.com API v4 (api.quran.com), recitations by ayah with segments.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Attribution links',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  SelectableText('https://pub.dev/packages/quran'),
                  SelectableText('https://github.com/aqeelshamz/quran'),
                  SelectableText('https://alquran.cloud/api'),
                  SelectableText('https://everyayah.com/data/'),
                  SelectableText('https://api-docs.quran.com/'),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushNamed('attributionsLicenses');
                      },
                      icon: Icon(Icons.open_in_new_rounded),
                      label: Text('Open full Attributions & Licenses page'),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Note: verify production usage terms with each provider before public launch, especially audio redistribution rights.',
                    style: TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadCurrentSurah({
    required BuildContext context,
    required QuranAudioRepository repository,
    required String reciterId,
  }) async {
    setState(() {
      _isDownloadingSurah = true;
      _downloadedAyahs = 0;
      _downloadTotalAyahs = 0;
    });
    try {
      await repository.downloadSurah(
        reciterId: reciterId,
        surahNumber: widget.surahNumber,
        onProgress: (downloaded, total) {
          if (!mounted) return;
          setState(() {
            _downloadedAyahs = downloaded;
            _downloadTotalAyahs = total;
          });
        },
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).quranReaderDownloadSuccess)),
      );
    } catch (error) {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranReaderDownloadFailed(error.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingSurah = false;
        });
      }
    }
  }

  Future<void> _clearCurrentSurahDownload({
    required BuildContext context,
    required QuranAudioRepository repository,
    required String reciterId,
  }) async {
    await repository.clearSurahDownloads(
      reciterId: reciterId,
      surahNumber: widget.surahNumber,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).quranReaderDownloadRemoved)),
    );
    setState(() {});
  }

  Future<void> _onWordTap(
    BuildContext context,
    WidgetRef ref,
    QuranWordGloss word,
  ) async {
    final l10n = AppLocalizations.of(context);
    final pinned = ref
        .read(quranWordFavoritesProvider.notifier)
        .isPinned(word.arabic);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.arabic,
                  style: QuranPresentationStyle.translucentTextStyle(
                    context,
                    AppTextStyles.quranVerse(size: 36, weight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.transliteration,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(word.gloss),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () {
                    ref
                        .read(quranWordFavoritesProvider.notifier)
                        .togglePin(
                          arabic: word.arabic,
                          gloss: word.gloss,
                          transliteration: word.transliteration,
                        );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  ),
                  label: Text(
                    pinned
                        ? l10n.quranUnpinWordLabel
                        : l10n.quranPinForReviewLabel,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _playConfiguredLoop(List<QuranAyah> ayahs) async {
    final audio = ref.read(quranAudioSettingsProvider);
    final start = audio.repeatStartAyah;
    final end = audio.repeatEndAyah;
    if (start == null || end == null || end < start) {
      return;
    }
    final range = ayahs
        .where((ayah) => ayah.ayahNumber >= start && ayah.ayahNumber <= end)
        .toList();
    if (range.isEmpty) return;
    final sessionVersion = ++_playerSessionVersion;
    setState(() => _isLoopRunning = true);
    try {
      for (var loop = 0; loop < audio.ayahLoopCount; loop += 1) {
        if (sessionVersion != _playerSessionVersion) return;
        for (final ayah in range) {
          if (sessionVersion != _playerSessionVersion) return;
          if (!mounted) return;
          await _playAyahAudio(
            ayah,
            request: QuranPlaybackRequest(
              surahNumber: ayah.surahNumber,
              ayahNumber: ayah.ayahNumber,
              playbackReason: loop == 0 && ayah == range.first
                  ? QuranPlaybackReason.freshPlay
                  : QuranPlaybackReason.jump,
            ),
            bismillahMode: loop == 0 && ayah == range.first
                ? ref.read(quranDefaultBismillahPlaybackModeProvider)
                : BismillahPlaybackMode.disabled,
          );
          await Future<void>.delayed(const Duration(milliseconds: 350));
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoopRunning = false;
          _currentlyPlayingAyahKey = null;
        });
      }
    }
  }

  Future<bool> _resumeLoadedPlaybackIfPossible() async {
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(widget.surahNumber),
    );
    if (!playbackState.hasPlayback) return false;
    final processingState = _audioPlayer.processingState;
    if (_audioPlayer.audioSource != null &&
        processingState != ProcessingState.idle &&
        processingState != ProcessingState.completed) {
      await _audioPlayer.play();
      _syncCurrentPlaybackAyahKey();
      return true;
    }
    return _playerController.resumeCurrentPlayback();
  }

  Future<void> _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    QuranAyah ayah,
  ) async {
    final l10n = AppLocalizations.of(context);
    final surahName =
        ref.read(quranSurahMapProvider)[ayah.surahNumber]?.transliteratedName ??
        'Surah ${ayah.surahNumber}';
    final defaultTags = buildQuranNoteTags(
      surahName: surahName,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );
    final controller = TextEditingController();
    final tagsController = TextEditingController(text: defaultTags.join(', '));
    final folderController = TextEditingController(
      text: quranNotesDefaultFolder,
    );
    bool isHighlight = false;
    final highlightLabelController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(l10n.quranAddNote),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: l10n.quranNoteHint),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: folderController,
                    decoration: InputDecoration(
                      labelText: l10n.quranNotesFolderLabel,
                      hintText: l10n.quranNotesFolderHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      labelText: l10n.quranNotesTagsLabel,
                      hintText: l10n.quranNotesTagsHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: isHighlight,
                    title: Text(l10n.quranSaveAsHighlightLabel),
                    onChanged: (value) => setState(() => isHighlight = value),
                  ),
                  if (isHighlight)
                    TextField(
                      controller: highlightLabelController,
                      decoration: InputDecoration(
                        labelText: l10n.quranHighlightLabelInput,
                        hintText: l10n.quranHighlightHint,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.quranCancel),
              ),
              FilledButton(
                onPressed: () {
                  final tags =
                      <String>[
                            ...defaultTags,
                            ...tagsController.text.split(','),
                          ]
                          .map((item) => item.trim())
                          .where((item) => item.isNotEmpty)
                          .toList();
                  ref
                      .read(quranNotesProvider.notifier)
                      .addNote(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                        text: controller.text,
                        tags: tags,
                        folder: folderController.text,
                        isHighlight: isHighlight,
                        highlightLabel: highlightLabelController.text,
                      );
                  Navigator.of(context).pop();
                },
                child: Text(l10n.quranSave),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4F4032),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Color(0xFF6A5A4A),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SettingsSubsectionLabel extends StatelessWidget {
  const _SettingsSubsectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6A5A4A),
        ),
      ),
    );
  }
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF4A4036), height: 1.35),
          ),
        ],
      ),
    );
  }
}

String _quranInsightDomainLabel(
  AppLocalizations l10n,
  QuranAyahEnrichmentDomain domain,
) {
  return switch (domain) {
    QuranAyahEnrichmentDomain.signsInCreation ||
    QuranAyahEnrichmentDomain.worldNature =>
      l10n.quranAyahInsightsDomainSignsInCreation,
    QuranAyahEnrichmentDomain.worshipRemembrance =>
      l10n.quranAyahInsightsDomainWorshipRemembrance,
    QuranAyahEnrichmentDomain.characterAdab =>
      l10n.quranAyahInsightsDomainCharacterAdab,
    QuranAyahEnrichmentDomain.tawhidBelief =>
      l10n.quranAyahInsightsDomainTawhidBelief,
    QuranAyahEnrichmentDomain.akhirahAccountability =>
      l10n.quranAyahInsightsDomainAkhirahAccountability,
    QuranAyahEnrichmentDomain.prophetsLessons =>
      l10n.quranAyahInsightsDomainProphetsLessons,
    QuranAyahEnrichmentDomain.guidanceDailyLife =>
      l10n.quranAyahInsightsDomainGuidanceDailyLife,
  };
}

String _quranInsightPathTitle(AppLocalizations l10n, String pathId) {
  return switch (pathId) {
    'signs-in-creation-starter' =>
      l10n.quranAyahInsightPathTitleSignsInCreationStarter,
    'worship-remembrance-starter' =>
      l10n.quranAyahInsightPathTitleWorshipRemembranceStarter,
    'character-adab-starter' =>
      l10n.quranAyahInsightPathTitleCharacterAdabStarter,
    'tawhid-belief-starter' =>
      l10n.quranAyahInsightPathTitleTawhidBeliefStarter,
    'akhirah-accountability-starter' =>
      l10n.quranAyahInsightPathTitleAkhirahAccountabilityStarter,
    'prophets-lessons-starter' =>
      l10n.quranAyahInsightPathTitleProphetsLessonsStarter,
    _ => l10n.quranAyahInsightPathsTitle,
  };
}

class QuranAyahCard extends StatefulWidget {
  const QuranAyahCard({
    super.key,
    required this.ayah,
    required this.isHighlighted,
    required this.isNowPlaying,
    required this.activeWordIndex,
    required this.isBookmarked,
    required this.isMarkedForMemorization,
    required this.notesCount,
    required this.onBookmark,
    required this.onAddNote,
    required this.showArabic,
    required this.showTranslation,
    required this.showTransliteration,
    required this.showWordByWord,
    required this.showActions,
    required this.hifzRevealMode,
    required this.arabicFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    required this.harakatColor,
    required this.contextualLinks,
    required this.themeTopics,
    required this.studyMode,
    this.activeTopicId,
    this.onTap,
    this.onPlayAyah,
    required this.onToggleMemorization,
    required this.onPlayWord,
    required this.onMistakeCheckpoint,
  });

  final QuranAyah ayah;
  final bool isHighlighted;
  final bool isNowPlaying;
  final int? activeWordIndex;
  final bool isBookmarked;
  final bool isMarkedForMemorization;
  final int notesCount;
  final VoidCallback onBookmark;
  final VoidCallback onAddNote;
  final bool showArabic;
  final bool showTranslation;
  final bool showTransliteration;
  final bool showWordByWord;
  final bool showActions;
  final HifzRevealMode hifzRevealMode;
  final double arabicFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final Color? harakatColor;
  final List<QuranRelatedKnowledgeLink> contextualLinks;
  final List<QuranTopic> themeTopics;
  final QuranReaderStudyMode studyMode;
  final String? activeTopicId;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAyah;
  final VoidCallback onToggleMemorization;
  final Future<void> Function(QuranWordGloss word) onPlayWord;
  final VoidCallback onMistakeCheckpoint;

  @override
  State<QuranAyahCard> createState() => _QuranAyahCardState();
}

class _QuranAyahCardState extends State<QuranAyahCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final arabicWordCount = widget.ayah.arabic
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    final visibleContextualLinks = _visibleContextualLinks(
      widget.contextualLinks,
      widget.studyMode,
    );
    final groupedContextualLinks = _groupKnowledgeLinksByCategory(
      visibleContextualLinks,
    );
    final visibleThemes = _visibleThemeTopics(
      widget.themeTopics,
      widget.studyMode,
      widget.activeTopicId,
    );
    final showThemesFirst =
        widget.studyMode == QuranReaderStudyMode.theme &&
        visibleThemes.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: AnimatedContainer(
          key: ValueKey(
            'quran-ayah-card-${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
          ),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: widget.isNowPlaying
                ? Border.all(
                    color: const Color(0xFF3E9C68).withValues(alpha: 0.90),
                    width: 1.6,
                  )
                : null,
            boxShadow: widget.isNowPlaying
                ? [
                    BoxShadow(
                      color: const Color(0xFFE0C37A).withValues(alpha: 0.30),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: PremiumCard(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.ayah.ayahNumber.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                    if (widget.isHighlighted || widget.isNowPlaying)
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF7C5D3A),
                        size: 20,
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranBookmark,
                        onPressed: widget.onBookmark,
                        icon: Icon(
                          widget.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_outline_rounded,
                        ),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: widget.isMarkedForMemorization
                            ? l10n.quranMemorizationRemoveAction
                            : l10n.quranMemorizationMarkAction,
                        onPressed: widget.onToggleMemorization,
                        icon: Icon(
                          widget.isMarkedForMemorization
                              ? Icons.school_rounded
                              : Icons.school_outlined,
                        ),
                      ),
                    if (widget.showActions && widget.onPlayAyah != null)
                      IconButton(
                        key: ValueKey(
                          'quran-reader-play-ayah-${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
                        ),
                        tooltip: l10n.quranPlayAyahTooltip,
                        onPressed: widget.onPlayAyah,
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranHifzCheckpointTooltip,
                        onPressed: widget.onMistakeCheckpoint,
                        icon: const Icon(Icons.flag_outlined),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranAddNote,
                        onPressed: widget.onAddNote,
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.sticky_note_2_outlined),
                            if (widget.notesCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C5D3A),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.notesCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (widget.showArabic) ...[
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final visibleArabic = _displayArabicForHifz(
                        widget.ayah.arabic,
                        widget.hifzRevealMode,
                      );
                      final style = QuranPresentationStyle.translucentTextStyle(
                        context,
                        AppTextStyles.quranVerse(
                          size: widget.arabicFontSize + 4,
                          color: const Color(0xFF1F1B17),
                        ).copyWith(
                          height: 1.9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      );
                      final canWordHighlight =
                          widget.hifzRevealMode == HifzRevealMode.full &&
                          widget.activeWordIndex != null;

                      return Text.rich(
                        canWordHighlight
                            ? _buildWordSyncedArabicSpan(
                                context,
                                visibleArabic,
                                style,
                                widget.activeWordIndex!,
                                widget.harakatColor,
                              )
                            : buildQuranTextWithColoredHarakat(
                                visibleArabic,
                                style,
                                harakatColor:
                                    widget.harakatColor ??
                                    QuranPresentationStyle.translucentHarakatColor(
                                      context,
                                    ),
                              ),
                        textAlign: textAlignForContent(visibleArabic),
                        textDirection: textDirectionForContent(visibleArabic),
                        strutStyle: StrutStyle(
                          fontFamily: style.fontFamily,
                          fontSize: style.fontSize,
                          height: style.height,
                          forceStrutHeight: true,
                        ),
                      );
                    },
                  ),
                ],
                if (widget.showWordByWord) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: buildWordGlosses(widget.ayah.arabic)
                        .map(
                          (word) => InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => widget.onPlayWord(word),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF1E7D8),
                                border: Border.all(
                                  color: const Color(0xFFD9C4A2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.arabic,
                                    textAlign: textAlignForContent(word.arabic),
                                    textDirection: textDirectionForContent(
                                      word.arabic,
                                    ),
                                    style: AppTextStyles.arabicLearning(
                                      size: 16,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    word.transliteration,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: QuranPresentationStyle
                                          .quranSupportTextColor(context),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    l10n.quranReaderWordTranslationPrefix(
                                      word.gloss,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: QuranPresentationStyle
                                          .quranSupportTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (widget.showTransliteration) ...[
                  SizedBox(height: widget.showWordByWord ? 12 : 16),
                  Text.rich(
                    _buildFollowTextSpan(
                      text: (widget.ayah.transliteration ?? '').isNotEmpty
                          ? widget.ayah.transliteration!
                          : l10n.quranReaderTransliterationUnavailable,
                      baseStyle: QuranPresentationStyle.quranSupportTextStyle(
                        context,
                        TextStyle(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          fontSize: widget.transliterationFontSize,
                        ),
                        italic: true,
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                    ),
                  ),
                ],
                if (widget.showTranslation) ...[
                  const SizedBox(height: 8),
                  Text.rich(
                    _buildFollowTextSpan(
                      text: widget.ayah.translation,
                      baseStyle: TextStyle(
                        height:
                            widget.studyMode == QuranReaderStudyMode.reflection
                            ? 1.65
                            : 1.5,
                        fontSize: widget.translationFontSize,
                        fontWeight:
                            widget.studyMode == QuranReaderStudyMode.reflection
                            ? FontWeight.w500
                            : null,
                        color: QuranPresentationStyle.quranSupportTextColor(
                          context,
                        ),
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                    ),
                  ),
                ],
                if (showThemesFirst) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.quranThemeMapRelatedThemesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleThemes
                        .map(
                          (topic) => ActionChip(
                            avatar: widget.activeTopicId == topic.id
                                ? const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                  )
                                : null,
                            label: Text(
                              localizedQuranTopicTitle(l10n, topic.id),
                            ),
                            backgroundColor: widget.activeTopicId == topic.id
                                ? const Color(0xFFF1E1B8)
                                : null,
                            onPressed: () => context.pushNamed(
                              'quranTopicDetail',
                              pathParameters: {'topicId': topic.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (groupedContextualLinks.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.quranLearnMoreSectionTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...groupedContextualLinks.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quranRelatedKnowledgeCategoryLabel(l10n, entry.key),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      QuranPresentationStyle.translucentColor(
                                        context,
                                        const Color(0xFF6A5A4A),
                                      ),
                                ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: entry.value
                                .map(
                                  (link) => ActionChip(
                                    label: Text(link.title),
                                    onPressed: () =>
                                        showQuranRelatedKnowledgeDetailSheet(
                                          context,
                                          link: link,
                                          anchorLabel: l10n
                                              .quranReferenceViewerReferenceLabel(
                                                '${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
                                              ),
                                        ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (!showThemesFirst && visibleThemes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.quranThemeMapRelatedThemesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleThemes
                        .map(
                          (topic) => ActionChip(
                            avatar: widget.activeTopicId == topic.id
                                ? const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                  )
                                : null,
                            label: Text(
                              localizedQuranTopicTitle(l10n, topic.id),
                            ),
                            backgroundColor: widget.activeTopicId == topic.id
                                ? const Color(0xFFF1E1B8)
                                : null,
                            onPressed: () => context.pushNamed(
                              'quranTopicDetail',
                              pathParameters: {'topicId': topic.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Map<QuranRelatedKnowledgeCategory, List<QuranRelatedKnowledgeLink>>
_groupKnowledgeLinksByCategory(List<QuranRelatedKnowledgeLink> links) {
  final grouped =
      <QuranRelatedKnowledgeCategory, List<QuranRelatedKnowledgeLink>>{};
  for (final link in links) {
    grouped
        .putIfAbsent(link.category, () => <QuranRelatedKnowledgeLink>[])
        .add(link);
  }
  for (final entry in grouped.entries) {
    entry.value.sort((a, b) {
      final byStrength = a.connectionStrength.priorityValue.compareTo(
        b.connectionStrength.priorityValue,
      );
      if (byStrength != 0) return byStrength;
      return a.title.compareTo(b.title);
    });
  }
  return grouped;
}

String _displayArabicForHifz(String text, HifzRevealMode mode) {
  switch (mode) {
    case HifzRevealMode.full:
      return text;
    case HifzRevealMode.firstWordOnly:
      final words = text.split(RegExp(r'\s+'));
      if (words.isEmpty) return text;
      if (words.length == 1) return '${words.first} ...';
      return '${words.first} ${'•' * (words.length * 2)}';
    case HifzRevealMode.hidden:
      return '•' * text.length.clamp(20, 180).toInt();
  }
}

TextSpan _buildWordSyncedArabicSpan(
  BuildContext context,
  String arabic,
  TextStyle baseStyle,
  int activeWordIndex,
  Color? harakatColor,
) {
  final words = arabic
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return buildQuranTextWithColoredHarakat(
      arabic,
      baseStyle,
      harakatColor:
          harakatColor ??
          QuranPresentationStyle.translucentHarakatColor(context),
    );
  }

  final children = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == activeWordIndex;
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B).withValues(
              alpha:
                  (const Color(0xFF2F8F5B).a *
                          QuranPresentationStyle.translucencyFactor(context))
                      .clamp(0.0, 1.0),
            ),
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.80),
            shadows: [
              Shadow(
                color: const Color(0xFFC8A85A).withValues(alpha: 0.40),
                blurRadius: 7,
                offset: const Offset(0, 0.6),
              ),
            ],
          )
        : baseStyle;
    children.add(
      buildQuranTextWithColoredHarakat(
        words[i],
        style,
        harakatColor:
            harakatColor ??
            QuranPresentationStyle.translucentHarakatColor(context),
      ),
    );
    if (i != words.length - 1) {
      children.add(TextSpan(text: ' ', style: baseStyle));
    }
  }

  return TextSpan(style: baseStyle, children: children);
}

TextSpan _buildFollowTextSpan({
  required String text,
  required TextStyle baseStyle,
  required int sourceWordCount,
  required int? activeSourceIndex,
}) {
  final words = text
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty ||
      activeSourceIndex == null ||
      sourceWordCount <= 0 ||
      words.length <= 1) {
    return TextSpan(text: text, style: baseStyle);
  }

  final mappedIndex = _mapActiveIndex(
    sourceIndex: activeSourceIndex,
    sourceCount: sourceWordCount,
    targetCount: words.length,
  );

  final spans = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == mappedIndex;
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B),
            fontWeight: FontWeight.w700,
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.35),
          )
        : baseStyle.copyWith(
            color: (baseStyle.color ?? const Color(0xFF4A4036)).withValues(
              alpha: 0.42,
            ),
          );
    spans.add(TextSpan(text: words[i], style: style));
    if (i != words.length - 1) {
      spans.add(TextSpan(text: ' ', style: baseStyle));
    }
  }
  return TextSpan(style: baseStyle, children: spans);
}

int _mapActiveIndex({
  required int sourceIndex,
  required int sourceCount,
  required int targetCount,
}) {
  if (targetCount <= 1 || sourceCount <= 1) return 0;
  final normalized = sourceIndex.clamp(0, sourceCount - 1) / (sourceCount - 1);
  return (normalized * (targetCount - 1)).round().clamp(0, targetCount - 1);
}

class _KnowledgeLinkWrap extends StatelessWidget {
  const _KnowledgeLinkWrap({
    required this.title,
    required this.items,
    required this.anchorLabel,
    this.itemLimit = 5,
  });

  final String title;
  final List<QuranRelatedKnowledgeLink> items;
  final String anchorLabel;
  final int itemLimit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .take(itemLimit)
              .map(
                (item) => ActionChip(
                  label: Text(item.title),
                  onPressed: () => showQuranRelatedKnowledgeDetailSheet(
                    context,
                    link: item,
                    anchorLabel: anchorLabel,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

IconData _readerStudyModeIcon(QuranReaderStudyMode mode) {
  return switch (mode) {
    QuranReaderStudyMode.reading => Icons.chrome_reader_mode_rounded,
    QuranReaderStudyMode.reflection => Icons.self_improvement_rounded,
    QuranReaderStudyMode.study => Icons.school_rounded,
    QuranReaderStudyMode.memorization => Icons.repeat_rounded,
    QuranReaderStudyMode.theme => Icons.auto_awesome_rounded,
  };
}

String _readerStudyModeLabel(AppLocalizations l10n, QuranReaderStudyMode mode) {
  return switch (mode) {
    QuranReaderStudyMode.reading => l10n.quranReaderModeReadingLabel,
    QuranReaderStudyMode.reflection => l10n.quranReaderModeReflectionLabel,
    QuranReaderStudyMode.study => l10n.quranReaderModeStudyLabel,
    QuranReaderStudyMode.memorization => l10n.quranReaderModeMemorizationLabel,
    QuranReaderStudyMode.theme => l10n.quranReaderModeThemeLabel,
  };
}

String _readerStudyModeSubtitle(
  AppLocalizations l10n,
  QuranReaderStudyMode mode, {
  String? highlightedTopicId,
}) {
  return switch (mode) {
    QuranReaderStudyMode.reading => l10n.quranReaderModeReadingSubtitle,
    QuranReaderStudyMode.reflection => l10n.quranReaderModeReflectionSubtitle,
    QuranReaderStudyMode.study => l10n.quranReaderModeStudySubtitle,
    QuranReaderStudyMode.memorization =>
      l10n.quranReaderModeMemorizationSubtitle,
    QuranReaderStudyMode.theme => l10n.quranReaderModeThemeSubtitle(
      highlightedTopicId == null || highlightedTopicId.trim().isEmpty
          ? l10n.quranThemeMapRelatedThemesTitle
          : localizedQuranTopicTitle(l10n, highlightedTopicId),
    ),
  };
}

List<QuranRelatedKnowledgeLink> _visibleContextualLinks(
  List<QuranRelatedKnowledgeLink> links,
  QuranReaderStudyMode mode,
) {
  if (links.isEmpty) return const <QuranRelatedKnowledgeLink>[];
  return switch (mode) {
    QuranReaderStudyMode.reading => links.take(2).toList(growable: false),
    QuranReaderStudyMode.reflection => links.take(3).toList(growable: false),
    QuranReaderStudyMode.study => links,
    QuranReaderStudyMode.memorization => links.take(1).toList(growable: false),
    QuranReaderStudyMode.theme => links.take(4).toList(growable: false),
  };
}

List<QuranTopic> _visibleThemeTopics(
  List<QuranTopic> topics,
  QuranReaderStudyMode mode,
  String? activeTopicId,
) {
  if (topics.isEmpty) return const <QuranTopic>[];
  final prioritized = [...topics]
    ..sort((a, b) {
      final aIsActive = a.id == activeTopicId;
      final bIsActive = b.id == activeTopicId;
      if (aIsActive == bIsActive) return 0;
      return aIsActive ? -1 : 1;
    });
  return switch (mode) {
    QuranReaderStudyMode.reading => prioritized.take(1).toList(growable: false),
    QuranReaderStudyMode.reflection =>
      prioritized.take(2).toList(growable: false),
    QuranReaderStudyMode.study => prioritized.take(3).toList(growable: false),
    QuranReaderStudyMode.memorization =>
      prioritized
          .where((topic) => topic.id == activeTopicId)
          .take(1)
          .toList(growable: false),
    QuranReaderStudyMode.theme => prioritized.take(4).toList(growable: false),
  };
}

class _ScaleControl extends StatelessWidget {
  const _ScaleControl({
    required this.label,
    required this.percent,
    required this.onChanged,
  });

  final String label;
  final int percent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ($percent%)',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A5A4A),
          ),
        ),
        Slider(
          min: 85,
          max: 140,
          divisions: 11,
          value: percent.toDouble(),
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

String _translationLabelForCode(AppLocalizations l10n, String code) {
  switch (code) {
    case 'en.sahih':
      return l10n.quranTranslationSahih;
    case 'en.clear':
      return l10n.quranTranslationClearQuran;
    case 'ur.urdu':
      return l10n.quranTranslationUrdu;
    case 'bn.bengali':
      return l10n.quranTranslationBengali;
    case 'id.indonesian':
      return l10n.quranTranslationIndonesian;
    case 'tr.saheeh':
      return l10n.quranTranslationTurkish;
    case 'fa.dari':
      return l10n.quranTranslationDari;
    default:
      return code;
  }
}
