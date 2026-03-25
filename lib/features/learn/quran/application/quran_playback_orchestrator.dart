import '../data/quran_audio_repository.dart';
import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_audio_source_metadata.dart';
import '../domain/quran_playback_request.dart';
import 'quran_playback_policy.dart';

class QuranPreparedPlaybackEntry {
  const QuranPreparedPlaybackEntry({
    required this.source,
    required this.metadata,
    required this.ayahNumber,
  });

  final String source;
  final QuranAudioSourceMetadata metadata;
  final int ayahNumber;

  QuranPreparedPlaybackEntry copyWith({
    String? source,
    QuranAudioSourceMetadata? metadata,
    int? ayahNumber,
  }) {
    return QuranPreparedPlaybackEntry(
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
      ayahNumber: ayahNumber ?? this.ayahNumber,
    );
  }
}

class QuranPreparedPlayback {
  const QuranPreparedPlayback({
    required this.request,
    required this.entries,
    required this.initialLogicalIndex,
    required this.initialPosition,
    required this.didPrependBismillah,
    this.preRollSource,
    this.preRollMetadata,
  });

  final QuranPlaybackRequest request;
  final List<QuranPreparedPlaybackEntry> entries;
  final int initialLogicalIndex;
  final Duration initialPosition;
  final bool didPrependBismillah;
  final String? preRollSource;
  final QuranAudioSourceMetadata? preRollMetadata;

  QuranPreparedPlayback copyWith({
    QuranPlaybackRequest? request,
    List<QuranPreparedPlaybackEntry>? entries,
    int? initialLogicalIndex,
    Duration? initialPosition,
    bool? didPrependBismillah,
    String? preRollSource,
    bool clearPreRollSource = false,
    QuranAudioSourceMetadata? preRollMetadata,
    bool clearPreRollMetadata = false,
  }) {
    return QuranPreparedPlayback(
      request: request ?? this.request,
      entries: entries ?? this.entries,
      initialLogicalIndex: initialLogicalIndex ?? this.initialLogicalIndex,
      initialPosition: initialPosition ?? this.initialPosition,
      didPrependBismillah: didPrependBismillah ?? this.didPrependBismillah,
      preRollSource: clearPreRollSource
          ? null
          : (preRollSource ?? this.preRollSource),
      preRollMetadata: clearPreRollMetadata
          ? null
          : (preRollMetadata ?? this.preRollMetadata),
    );
  }
}

class QuranPlaybackOrchestrator {
  QuranPlaybackOrchestrator({
    required QuranAudioRepository audioRepository,
    required QuranPlaybackPolicy policy,
  }) : _audioRepository = audioRepository,
       _policy = policy;

  final QuranAudioRepository _audioRepository;
  final QuranPlaybackPolicy _policy;
  final Map<String, QuranPreparedPlayback> _preparedPlaybackCache =
      <String, QuranPreparedPlayback>{};
  final Map<String, Future<QuranPreparedPlayback>> _inflightPreparationCache =
      <String, Future<QuranPreparedPlayback>>{};

  // Product rule: all Qur'an playback entry points should resolve here first so
  // Bismillah pre-roll remains centralized instead of being reimplemented in UI.
  Future<QuranPreparedPlayback> startPlayback({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) {
    return preparePlayback(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
      mode: mode,
    );
  }

  Future<QuranPreparedPlayback> preparePlayback({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) async {
    final cacheKey = _cacheKey(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
      mode: mode,
    );
    final cached = _preparedPlaybackCache[cacheKey];
    if (cached != null) {
      return _rebindPreparedPlayback(
        cached,
        request: request,
        ayahNumbers: ayahNumbers,
      );
    }
    final inflight = _inflightPreparationCache[cacheKey];
    if (inflight != null) {
      final prepared = await inflight;
      return _rebindPreparedPlayback(
        prepared,
        request: request,
        ayahNumbers: ayahNumbers,
      );
    }

    final future = _preparePlaybackUncached(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
      mode: mode,
    );
    _inflightPreparationCache[cacheKey] = future;
    try {
      final prepared = await future;
      _preparedPlaybackCache[cacheKey] = prepared;
      return _rebindPreparedPlayback(
        prepared,
        request: request,
        ayahNumbers: ayahNumbers,
      );
    } finally {
      _inflightPreparationCache.remove(cacheKey);
    }
  }

  Future<void> preloadPlayback({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) async {
    await preparePlayback(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
      mode: mode,
    );
  }

  Future<QuranPreparedPlayback> _preparePlaybackUncached({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    required BismillahPlaybackMode mode,
  }) async {
    assert(ayahNumbers.isNotEmpty);

    final entries = await buildPlaybackQueue(
      request: request,
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
    );

    final leading = entries.first;
    final shouldPrepend = _policy.shouldPlayBismillahBefore(
      request,
      leading.metadata,
      mode: mode,
    );

    final preRollMetadata = await resolveBismillahClip(
      reciterId: reciterId,
      shouldPrepend: shouldPrepend,
    );

    final initialLogicalIndex = resolveTargetClipOrPosition(
      request: request,
      ayahNumbers: ayahNumbers,
    );

    return QuranPreparedPlayback(
      request: request,
      entries: entries,
      initialLogicalIndex: initialLogicalIndex,
      initialPosition: request.resumePosition ?? Duration.zero,
      didPrependBismillah: shouldPrepend,
      preRollSource: preRollMetadata?.source,
      preRollMetadata: preRollMetadata,
    );
  }

  QuranPreparedPlayback _rebindPreparedPlayback(
    QuranPreparedPlayback prepared, {
    required QuranPlaybackRequest request,
    required List<int> ayahNumbers,
  }) {
    return prepared.copyWith(
      request: request,
      initialLogicalIndex: resolveTargetClipOrPosition(
        request: request,
        ayahNumbers: ayahNumbers,
      ),
      initialPosition: request.resumePosition ?? Duration.zero,
    );
  }

  String _cacheKey({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    required BismillahPlaybackMode mode,
  }) {
    final ayahSequence = ayahNumbers.join(',');
    return [
      reciterId,
      request.surahNumber,
      request.ayahNumber ?? -1,
      request.playbackReason.name,
      request.isSurahEntry,
      request.isSurahTransition,
      request.originatingSurahNumber ?? -1,
      mode.name,
      ayahSequence,
    ].join('|');
  }

  Future<List<QuranPreparedPlaybackEntry>> buildPlaybackQueue({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
  }) async {
    final entries = <QuranPreparedPlaybackEntry>[];
    for (final ayahNumber in ayahNumbers) {
      final metadata = await _audioRepository.resolveAyahSourceMetadata(
        reciterId: reciterId,
        surahNumber: request.surahNumber,
        ayahNumber: ayahNumber,
      );
      entries.add(
        QuranPreparedPlaybackEntry(
          source: metadata.source,
          metadata: metadata,
          ayahNumber: ayahNumber,
        ),
      );
    }
    return entries;
  }

  Future<QuranAudioSourceMetadata?> resolveBismillahClip({
    required String reciterId,
    required bool shouldPrepend,
  }) async {
    if (!shouldPrepend) {
      return null;
    }
    return _audioRepository.resolveCanonicalBismillahMetadata(
      reciterId: reciterId,
    );
  }

  int resolveTargetClipOrPosition({
    required QuranPlaybackRequest request,
    required List<int> ayahNumbers,
  }) {
    final targetAyah = request.ayahNumber ?? ayahNumbers.first;
    return ayahNumbers.contains(targetAyah) ? ayahNumbers.indexOf(targetAyah) : 0;
  }
}
