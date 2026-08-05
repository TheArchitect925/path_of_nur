import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/quran_ayah.dart';
import '../domain/quran_audio_resilience_models.dart';
import 'quran_audio_resilience.dart';
import 'quran_player_controller.dart';
import 'quran_providers.dart';
import 'quran_reader_playback_state.dart';

enum QuranReaderPlaybackStatus {
  idle,
  loading,
  buffering,
  playing,
  paused,
  completed,
}

class QuranReaderPlaybackState {
  const QuranReaderPlaybackState({
    required this.pageSurahNumber,
    required this.reciterId,
    required this.reciterName,
    this.activeSurahNumber,
    this.activeAyahKey,
    this.activeAyahNumber,
    this.currentIndex,
    this.position = Duration.zero,
    this.duration,
    this.isSurahPlaybackMode = false,
    this.hasPlayback = false,
    this.isPlaying = false,
    this.hasReachedEnd = false,
    this.status = QuranReaderPlaybackStatus.idle,
    this.activeSession,
    this.storedSession,
    this.canPlay = false,
    this.canPause = false,
    this.canSeek = false,
    this.canGoPreviousAyah = false,
    this.canRestartAyah = false,
    this.canGoNextAyah = false,
    this.canGoPreviousSurah = false,
    this.canGoNextSurah = false,
    this.previousAyahNumber,
    this.nextAyahNumber,
    this.previousSurahNumber,
    this.nextSurahNumber,
    this.repeatStartAyah,
    this.repeatEndAyah,
    this.ayahLoopCount = 1,
    this.activeSourceType = QuranPlaybackSourceType.unavailable,
    this.sourceResolutionState = QuranPlaybackSourceResolutionState.idle,
    this.failureType,
    this.canRetryFromFailure = false,
    this.didApplyFallback = false,
    this.fallbackSourceType,
  });

  final int pageSurahNumber;
  final int? activeSurahNumber;
  final String? activeAyahKey;
  final int? activeAyahNumber;
  final int? currentIndex;
  final Duration position;
  final Duration? duration;
  final bool isSurahPlaybackMode;
  final bool hasPlayback;
  final bool isPlaying;
  final bool hasReachedEnd;
  final QuranReaderPlaybackStatus status;
  final String reciterId;
  final String reciterName;
  final QuranActivePlaybackSession? activeSession;
  final QuranRecitationSession? storedSession;
  final bool canPlay;
  final bool canPause;
  final bool canSeek;
  final bool canGoPreviousAyah;
  final bool canRestartAyah;
  final bool canGoNextAyah;
  final bool canGoPreviousSurah;
  final bool canGoNextSurah;
  final int? previousAyahNumber;
  final int? nextAyahNumber;
  final int? previousSurahNumber;
  final int? nextSurahNumber;
  final int? repeatStartAyah;
  final int? repeatEndAyah;
  final int ayahLoopCount;
  final QuranPlaybackSourceType activeSourceType;
  final QuranPlaybackSourceResolutionState sourceResolutionState;
  final QuranPlaybackFailureType? failureType;
  final bool canRetryFromFailure;
  final bool didApplyFallback;
  final QuranPlaybackSourceType? fallbackSourceType;

  bool get isBuffering => status == QuranReaderPlaybackStatus.buffering;
  bool get isLoading => status == QuranReaderPlaybackStatus.loading;
  bool get hasRepeatRange => repeatStartAyah != null && repeatEndAyah != null;
  bool get hasRepeatLoop => ayahLoopCount > 1;
  bool get hasRepeatConfigured => hasRepeatRange || hasRepeatLoop;
  bool get hasRecoverableFailure => failureType != null && canRetryFromFailure;
}

abstract class QuranPlaybackFeed {
  bool get playing;
  bool get hasPlaybackSource;
  int? get currentIndex;
  Duration get position;
  Duration? get duration;
  ProcessingState get processingState;
  Stream<PlayerState> get playerStateStream;
  Stream<int?> get currentIndexStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
}

class JustAudioQuranPlaybackFeed implements QuranPlaybackFeed {
  const JustAudioQuranPlaybackFeed(this.player);

  final AudioPlayer player;

  @override
  bool get playing => player.playing;

  @override
  bool get hasPlaybackSource => player.audioSource != null;

  @override
  int? get currentIndex => player.currentIndex;

  @override
  Duration get position => player.position;

  @override
  Duration? get duration => player.duration;

  @override
  ProcessingState get processingState => player.processingState;

  @override
  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  @override
  Stream<int?> get currentIndexStream => player.currentIndexStream;

  @override
  Stream<Duration> get positionStream => player.positionStream;

  @override
  Stream<Duration?> get durationStream => player.durationStream;
}

final quranPlaybackFeedProvider = Provider<QuranPlaybackFeed>((ref) {
  return JustAudioQuranPlaybackFeed(ref.watch(quranSharedAudioPlayerProvider));
});

class QuranReaderPlaybackController
    extends StateNotifier<QuranReaderPlaybackState> {
  QuranReaderPlaybackController(this.ref, {required this.pageSurahNumber})
    : _feed = ref.read(quranPlaybackFeedProvider),
      super(
        _buildState(
          ref,
          pageSurahNumber: pageSurahNumber,
          rememberedActiveAyahKey: null,
        ),
      ) {
    _bind();
  }

  final Ref ref;
  final int pageSurahNumber;
  final QuranPlaybackFeed _feed;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  void _bind() {
    _playerStateSubscription = _feed.playerStateStream.listen(
      (_) => _refresh(),
    );
    _currentIndexSubscription = _feed.currentIndexStream.listen(
      (_) => _refresh(),
    );
    _positionSubscription = _feed.positionStream.listen((_) => _refresh());
    _durationSubscription = _feed.durationStream.listen((_) => _refresh());

    ref.listen<QuranActivePlaybackSession?>(
      quranActivePlaybackSessionProvider,
      (_, next) => _refreshFromEvent(next),
    );
    ref.listen<QuranRecitationSession?>(
      quranRecitationSessionProvider,
      (_, next) => _refreshFromEvent(next),
    );
    ref.listen<QuranAudioSettings>(
      quranAudioSettingsProvider,
      (_, next) => _refreshFromEvent(next),
    );
    ref.listen<QuranPlaybackSourceState>(
      quranPlaybackSourceStateProvider,
      (_, next) => _refreshFromEvent(next),
    );
    ref.listen<AsyncValue<List<QuranAyah>>>(
      quranSurahAyahsProvider(pageSurahNumber),
      (_, next) => _refreshFromEvent(next),
    );
  }

  void _refresh() {
    state = _buildState(
      ref,
      pageSurahNumber: pageSurahNumber,
      rememberedActiveAyahKey: state.activeAyahKey,
    );
  }

  void _refreshFromEvent(Object? _) {
    _refresh();
  }

  static QuranReaderPlaybackState _buildState(
    Ref ref, {
    required int pageSurahNumber,
    required String? rememberedActiveAyahKey,
  }) => buildQuranReaderPlaybackState(
    ref,
    pageSurahNumber: pageSurahNumber,
    rememberedActiveAyahKey: rememberedActiveAyahKey,
  );

  static QuranReaderPlaybackStatus _resolveStatus(QuranPlaybackFeed feed) {
    switch (feed.processingState) {
      case ProcessingState.loading:
        return QuranReaderPlaybackStatus.loading;
      case ProcessingState.buffering:
        return QuranReaderPlaybackStatus.buffering;
      case ProcessingState.completed:
        return QuranReaderPlaybackStatus.completed;
      case ProcessingState.idle:
        return QuranReaderPlaybackStatus.idle;
      case ProcessingState.ready:
        return feed.playing
            ? QuranReaderPlaybackStatus.playing
            : (feed.hasPlaybackSource
                  ? QuranReaderPlaybackStatus.paused
                  : QuranReaderPlaybackStatus.idle);
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  static int? _parseSurahNumber(String? ayahKey) {
    if (ayahKey == null || ayahKey.isEmpty) {
      return null;
    }
    final parts = ayahKey.split(':');
    return parts.length == 2 ? int.tryParse(parts.first) : null;
  }

  static int? _parseAyahNumber(String? ayahKey) {
    if (ayahKey == null || ayahKey.isEmpty) {
      return null;
    }
    final parts = ayahKey.split(':');
    return parts.length == 2 ? int.tryParse(parts.last) : null;
  }
}

QuranReaderPlaybackState buildQuranReaderPlaybackState(
  Ref ref, {
  required int pageSurahNumber,
  String? rememberedActiveAyahKey,
}) {
  final feed = ref.read(quranPlaybackFeedProvider);
  final audioSettings = ref.read(quranAudioSettingsProvider);
  final audioRepository = ref.read(quranAudioRepositoryProvider);
  final activeSession = ref.read(quranActivePlaybackSessionProvider);
  final storedSession = ref.read(quranRecitationSessionProvider);
  final surahAyahs = ref
      .read(quranSurahAyahsProvider(pageSurahNumber))
      .valueOrNull;
  final sourceState = ref.read(quranPlaybackSourceStateProvider);
  final isSurahPlaybackMode =
      activeSession?.isSurahMode == true &&
      activeSession?.surahNumber == pageSurahNumber;
  final activeSessionForResolution = sourceState.hasFailure
      ? null
      : activeSession;
  final resolvedPlayerIndex = feed.hasPlaybackSource ? feed.currentIndex : null;
  final isPlaybackFullyStopped =
      !feed.hasPlaybackSource &&
      activeSession == null &&
      sourceState.resolutionState == QuranPlaybackSourceResolutionState.idle &&
      !sourceState.hasFailure;
  final resolvedFallbackAyahKey = isPlaybackFullyStopped
      ? null
      : _resolveReaderPlaybackFallbackAyahKey(
          pageSurahNumber: pageSurahNumber,
          sourceState: sourceState,
          rememberedActiveAyahKey: rememberedActiveAyahKey,
        );
  final resolvedActiveAyahKey = resolveQuranReaderPlaybackAyahKey(
    currentSurahNumber: pageSurahNumber,
    isSurahPlaybackMode: isSurahPlaybackMode,
    surahPlaybackAyahs: surahAyahs ?? const [],
    playerIndex: resolvedPlayerIndex,
    fallbackAyahKey: resolvedFallbackAyahKey,
    activeSession: activeSessionForResolution,
  );
  final activeAyahKey = resolvedActiveAyahKey;
  final activeAyahNumber = QuranReaderPlaybackController._parseAyahNumber(
    activeAyahKey,
  );
  final activeSurahNumber = QuranReaderPlaybackController._parseSurahNumber(
    activeAyahKey,
  );
  final status = QuranReaderPlaybackController._resolveStatus(feed);
  final hasReachedEnd =
      status == QuranReaderPlaybackStatus.completed && isSurahPlaybackMode;
  final isPreparingTransition =
      sourceState.resolutionState ==
      QuranPlaybackSourceResolutionState.preparingTransition;
  final hasPlayback =
      feed.hasPlaybackSource ||
      activeAyahKey != null ||
      sourceState.hasFailure ||
      (activeSession?.surahNumber == pageSurahNumber);
  final reciter = audioRepository.reciterById(audioSettings.reciterId);
  final sessionAyahs = activeSession?.surahNumber == activeSurahNumber
      ? activeSession?.ayahNumbers ?? const <int>[]
      : const <int>[];
  final sessionIndex = activeAyahNumber == null
      ? null
      : sessionAyahs.indexOf(activeAyahNumber);
  final hasSessionIndex = sessionIndex != null && sessionIndex >= 0;
  final resolvedSessionIndex = hasSessionIndex ? sessionIndex : null;
  final previousAyahNumber =
      resolvedSessionIndex != null && resolvedSessionIndex > 0
      ? sessionAyahs[resolvedSessionIndex - 1]
      : null;
  final nextAyahNumber =
      resolvedSessionIndex != null &&
          resolvedSessionIndex < _sessionAyahsLastIndex(sessionAyahs)
      ? sessionAyahs[resolvedSessionIndex + 1]
      : null;
  final previousSurahNumber = activeSurahNumber != null && activeSurahNumber > 1
      ? activeSurahNumber - 1
      : null;
  final nextSurahNumber = activeSurahNumber != null && activeSurahNumber < 114
      ? activeSurahNumber + 1
      : null;

  return QuranReaderPlaybackState(
    pageSurahNumber: pageSurahNumber,
    activeSurahNumber: activeSurahNumber,
    activeAyahKey: activeAyahKey,
    activeAyahNumber: activeAyahNumber,
    currentIndex: feed.currentIndex,
    position: feed.position,
    duration: feed.duration,
    isSurahPlaybackMode: isSurahPlaybackMode,
    hasPlayback: hasPlayback,
    isPlaying: feed.playing,
    hasReachedEnd: hasReachedEnd,
    status: status,
    reciterId: reciter.id,
    reciterName: reciter.name,
    activeSession: activeSession,
    storedSession: storedSession?.surahNumber == pageSurahNumber
        ? storedSession
        : null,
    canPlay:
        hasPlayback &&
        !feed.playing &&
        status != QuranReaderPlaybackStatus.loading &&
        !isPreparingTransition,
    canPause: hasPlayback && feed.playing,
    canSeek: hasPlayback && (feed.duration?.inMilliseconds ?? 0) > 0,
    canGoPreviousAyah: previousAyahNumber != null,
    canRestartAyah: activeAyahNumber != null,
    canGoNextAyah: nextAyahNumber != null,
    canGoPreviousSurah: previousSurahNumber != null,
    canGoNextSurah: nextSurahNumber != null,
    previousAyahNumber: previousAyahNumber,
    nextAyahNumber: nextAyahNumber,
    previousSurahNumber: previousSurahNumber,
    nextSurahNumber: nextSurahNumber,
    repeatStartAyah: audioSettings.repeatStartAyah,
    repeatEndAyah: audioSettings.repeatEndAyah,
    ayahLoopCount: audioSettings.ayahLoopCount,
    activeSourceType: sourceState.activeSourceType,
    sourceResolutionState: sourceState.resolutionState,
    failureType: sourceState.failureType,
    canRetryFromFailure: sourceState.canRetry,
    didApplyFallback: sourceState.didApplyFallback,
    fallbackSourceType: sourceState.fallbackSourceType,
  );
}

String? _resolveReaderPlaybackFallbackAyahKey({
  required int pageSurahNumber,
  required QuranPlaybackSourceState sourceState,
  required String? rememberedActiveAyahKey,
}) {
  final transitionTargetAyahKey = _buildPlaybackSourceAyahKey(
    pageSurahNumber: pageSurahNumber,
    sourceState: sourceState,
  );

  switch (sourceState.resolutionState) {
    case QuranPlaybackSourceResolutionState.preparingTransition:
    case QuranPlaybackSourceResolutionState.resolving:
    case QuranPlaybackSourceResolutionState.buffering:
      return transitionTargetAyahKey ?? rememberedActiveAyahKey;
    case QuranPlaybackSourceResolutionState.ready:
    case QuranPlaybackSourceResolutionState.fallbackApplied:
      return rememberedActiveAyahKey ?? transitionTargetAyahKey;
    case QuranPlaybackSourceResolutionState.failed:
    case QuranPlaybackSourceResolutionState.idle:
      return rememberedActiveAyahKey;
  }
}

String? _buildPlaybackSourceAyahKey({
  required int pageSurahNumber,
  required QuranPlaybackSourceState sourceState,
}) {
  final sourceSurahNumber = sourceState.surahNumber;
  final sourceAyahNumber = sourceState.ayahNumber;
  if (sourceSurahNumber == null ||
      sourceSurahNumber != pageSurahNumber ||
      sourceAyahNumber == null) {
    return null;
  }
  return quranPlaybackAyahKey(
    surahNumber: sourceSurahNumber,
    ayahNumber: sourceAyahNumber,
  );
}

int _sessionAyahsLastIndex(List<int> ayahNumbers) => ayahNumbers.length - 1;

final quranGlobalPlaybackStateProvider = Provider<QuranReaderPlaybackState>((
  ref,
) {
  final activeSession = ref.watch(quranActivePlaybackSessionProvider);
  final storedSession = ref.watch(quranRecitationSessionProvider);
  final currentSurah =
      activeSession?.surahNumber ?? storedSession?.surahNumber ?? 1;
  ref.watch(quranPlaybackFeedProvider);
  ref.watch(quranAudioSettingsProvider);
  ref.watch(quranPlaybackSourceStateProvider);
  ref.watch(quranSurahAyahsProvider(currentSurah));
  return buildQuranReaderPlaybackState(
    ref,
    pageSurahNumber: currentSurah,
    rememberedActiveAyahKey: null,
  );
});

final quranReaderPlaybackControllerProvider = StateNotifierProvider.autoDispose
    .family<QuranReaderPlaybackController, QuranReaderPlaybackState, int>((
      ref,
      surahNumber,
    ) {
      return QuranReaderPlaybackController(ref, pageSurahNumber: surahNumber);
    });
