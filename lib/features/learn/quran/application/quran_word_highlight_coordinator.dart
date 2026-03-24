import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quran_word_timing_repository.dart';
import '../domain/quran_ayah.dart';
import 'quran_providers.dart';
import 'quran_reader_playback_controller.dart';
import 'quran_reader_playback_state.dart';
import 'quran_word_highlight_sync.dart';

enum QuranWordHighlightMode {
  inactive,
  ayahOnlyHighlight,
  loadingTiming,
  noTimingAvailable,
  wordHighlightReady,
}

class QuranWordHighlightState {
  const QuranWordHighlightState({
    this.activeAyahKey,
    this.activeWordIndex,
    this.mode = QuranWordHighlightMode.inactive,
  });

  final String? activeAyahKey;
  final int? activeWordIndex;
  final QuranWordHighlightMode mode;

  bool get hasWordHighlight =>
      mode == QuranWordHighlightMode.wordHighlightReady &&
      activeWordIndex != null;
}

class QuranWordHighlightCoordinator extends StateNotifier<QuranWordHighlightState> {
  QuranWordHighlightCoordinator(this.ref, {required this.pageSurahNumber})
    : super(const QuranWordHighlightState()) {
    _bind();
    _refreshFromInputs();
  }

  final Ref ref;
  final int pageSurahNumber;

  int _requestId = 0;
  String? _timedAyahKey;
  String? _timedReciterId;
  String _timedArabicText = '';
  List<QuranWordTimingSegment> _timingSegments = const [];
  bool _isLoadingTiming = false;

  void _bind() {
    ref.listen<QuranReaderPlaybackState>(
      quranReaderPlaybackControllerProvider(pageSurahNumber),
      (previous, next) => _refreshFromInputs(),
    );
    ref.listen<QuranReaderSettings>(
      quranReaderSettingsProvider,
      (previous, next) => _refreshFromInputs(),
    );
    ref.listen<QuranAudioSettings>(
      quranAudioSettingsProvider,
      (previous, next) => _refreshFromInputs(),
    );
    ref.listen<AsyncValue<List<QuranAyah>>>(
      quranSurahAyahsProvider(pageSurahNumber),
      (previous, next) => _refreshFromInputs(),
    );
  }

  void _refreshFromInputs() {
    final playbackState = ref.read(
      quranReaderPlaybackControllerProvider(pageSurahNumber),
    );
    final readerSettings = ref.read(quranReaderSettingsProvider);
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final ayahs =
        ref.read(quranSurahAyahsProvider(pageSurahNumber)).valueOrNull ??
        const <QuranAyah>[];

    final activeAyahKey = playbackState.activeAyahKey;
    if (activeAyahKey == null || activeAyahKey.isEmpty) {
      _reset();
      return;
    }

    if (!readerSettings.wordSyncHighlightBeta) {
      _timedAyahKey = activeAyahKey;
      state = QuranWordHighlightState(
        activeAyahKey: activeAyahKey,
        mode: QuranWordHighlightMode.ayahOnlyHighlight,
      );
      return;
    }

    final ayah = resolveQuranReaderPlaybackAyah(
      ayahs: ayahs,
      ayahKey: activeAyahKey,
    );
    if (ayah == null) {
      state = QuranWordHighlightState(
        activeAyahKey: activeAyahKey,
        mode: QuranWordHighlightMode.ayahOnlyHighlight,
      );
      return;
    }

    final needsTimingReload =
        _timedAyahKey != activeAyahKey ||
        _timedReciterId != audioSettings.reciterId ||
        _timedArabicText != ayah.arabic;

    if (needsTimingReload) {
      _timedAyahKey = activeAyahKey;
      _timedReciterId = audioSettings.reciterId;
      _timedArabicText = ayah.arabic;
      _timingSegments = const [];
      _isLoadingTiming = true;
      state = QuranWordHighlightState(
        activeAyahKey: activeAyahKey,
        mode: QuranWordHighlightMode.loadingTiming,
      );
      unawaited(
        _loadTimingSegments(
          reciterId: audioSettings.reciterId,
          ayah: ayah,
          ayahKey: activeAyahKey,
        ),
      );
      return;
    }

    _updateResolvedWordHighlight(playbackState);
  }

  Future<void> _loadTimingSegments({
    required String reciterId,
    required QuranAyah ayah,
    required String ayahKey,
  }) async {
    final requestId = ++_requestId;
    final repository = ref.read(quranWordTimingRepositoryProvider);

    try {
      final segments = await repository.getAyahWordTimings(
        reciterId: reciterId,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
      if (!_matchesCurrentRequest(
        requestId: requestId,
        ayahKey: ayahKey,
        reciterId: reciterId,
      )) {
        return;
      }
      _timingSegments = segments;
    } catch (_) {
      if (!_matchesCurrentRequest(
        requestId: requestId,
        ayahKey: ayahKey,
        reciterId: reciterId,
      )) {
        return;
      }
      _timingSegments = const [];
    }

    _isLoadingTiming = false;
    _updateResolvedWordHighlight(
      ref.read(quranReaderPlaybackControllerProvider(pageSurahNumber)),
    );
  }

  bool _matchesCurrentRequest({
    required int requestId,
    required String ayahKey,
    required String reciterId,
  }) {
    return requestId == _requestId &&
        _timedAyahKey == ayahKey &&
        _timedReciterId == reciterId;
  }

  void _updateResolvedWordHighlight(QuranReaderPlaybackState playbackState) {
    final activeAyahKey = playbackState.activeAyahKey;
    if (activeAyahKey == null || activeAyahKey != _timedAyahKey) {
      state = const QuranWordHighlightState();
      return;
    }

    if (_isLoadingTiming) {
      state = QuranWordHighlightState(
        activeAyahKey: activeAyahKey,
        mode: QuranWordHighlightMode.loadingTiming,
      );
      return;
    }

    if (_timingSegments.isEmpty) {
      state = QuranWordHighlightState(
        activeAyahKey: activeAyahKey,
        mode: QuranWordHighlightMode.noTimingAvailable,
      );
      return;
    }

    final nextIndex = resolveQuranWordHighlightIndex(
      arabicText: _timedArabicText,
      position: playbackState.position,
      totalDuration: playbackState.duration,
      preciseSegments: _timingSegments,
    );
    state = QuranWordHighlightState(
      activeAyahKey: activeAyahKey,
      activeWordIndex: nextIndex,
      mode: QuranWordHighlightMode.wordHighlightReady,
    );
  }

  void _reset() {
    _requestId += 1;
    _timedAyahKey = null;
    _timedReciterId = null;
    _timedArabicText = '';
    _timingSegments = const [];
    _isLoadingTiming = false;
    state = const QuranWordHighlightState();
  }
}

final quranWordHighlightCoordinatorProvider = StateNotifierProvider.autoDispose
    .family<QuranWordHighlightCoordinator, QuranWordHighlightState, int>((
      ref,
      surahNumber,
    ) {
      return QuranWordHighlightCoordinator(ref, pageSurahNumber: surahNumber);
    });
