import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/quran_ayah.dart';
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

  bool get isBuffering => status == QuranReaderPlaybackStatus.buffering;
  bool get isLoading => status == QuranReaderPlaybackStatus.loading;
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
      super(_buildState(ref, pageSurahNumber: pageSurahNumber)) {
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
    _playerStateSubscription = _feed.playerStateStream.listen((_) => _refresh());
    _currentIndexSubscription = _feed.currentIndexStream.listen((_) => _refresh());
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
    ref.listen<AsyncValue<List<QuranAyah>>>(
      quranSurahAyahsProvider(pageSurahNumber),
      (_, next) => _refreshFromEvent(next),
    );
  }

  void _refresh() {
    state = _buildState(ref, pageSurahNumber: pageSurahNumber);
  }

  void _refreshFromEvent(Object? _) {
    _refresh();
  }

  static QuranReaderPlaybackState _buildState(
    Ref ref, {
    required int pageSurahNumber,
  }) {
    final feed = ref.read(quranPlaybackFeedProvider);
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    final activeSession = ref.read(quranActivePlaybackSessionProvider);
    final storedSession = ref.read(quranRecitationSessionProvider);
    final surahAyahs = ref.read(quranSurahAyahsProvider(pageSurahNumber)).valueOrNull;
    final isSurahPlaybackMode =
        activeSession?.isSurahMode == true &&
        activeSession?.surahNumber == pageSurahNumber;
    final activeAyahKey = resolveQuranReaderPlaybackAyahKey(
      currentSurahNumber: pageSurahNumber,
      isSurahPlaybackMode: isSurahPlaybackMode,
      surahPlaybackAyahs: surahAyahs ?? const [],
      playerIndex: feed.currentIndex,
      fallbackAyahKey: null,
      activeSession: activeSession,
    );
    final activeAyahNumber = _parseAyahNumber(activeAyahKey);
    final activeSurahNumber = _parseSurahNumber(activeAyahKey);
    final status = _resolveStatus(feed);
    final hasReachedEnd =
        status == QuranReaderPlaybackStatus.completed && isSurahPlaybackMode;
    final hasPlayback = feed.hasPlaybackSource || activeAyahKey != null;
    final reciter = audioRepository.reciterById(audioSettings.reciterId);

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
      storedSession: storedSession?.surahNumber == pageSurahNumber ? storedSession : null,
    );
  }

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

final quranReaderPlaybackControllerProvider = StateNotifierProvider.autoDispose
    .family<QuranReaderPlaybackController, QuranReaderPlaybackState, int>((
      ref,
      surahNumber,
    ) {
      return QuranReaderPlaybackController(ref, pageSurahNumber: surahNumber);
    });
