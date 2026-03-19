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
}

class QuranPlaybackOrchestrator {
  const QuranPlaybackOrchestrator({
    required QuranAudioRepository audioRepository,
    required QuranPlaybackPolicy policy,
  }) : _audioRepository = audioRepository,
       _policy = policy;

  final QuranAudioRepository _audioRepository;
  final QuranPlaybackPolicy _policy;

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
