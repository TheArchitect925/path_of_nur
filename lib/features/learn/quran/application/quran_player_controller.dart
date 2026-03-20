import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_playback_request.dart';
import 'quran_playback_orchestrator.dart';
import 'quran_providers.dart';

class QuranActivePlaybackSession {
  const QuranActivePlaybackSession({
    required this.surahNumber,
    required this.ayahNumbers,
    required this.reciterId,
    required this.playbackSpeed,
    required this.includeMediaTags,
    required this.isSurahMode,
    this.bismillahMode = defaultBismillahPlaybackMode,
  });

  final int surahNumber;
  final List<int> ayahNumbers;
  final String reciterId;
  final double playbackSpeed;
  final bool includeMediaTags;
  final bool isSurahMode;
  final BismillahPlaybackMode bismillahMode;
}

final quranActivePlaybackSessionProvider =
    StateProvider<QuranActivePlaybackSession?>((ref) => null);

class QuranPlayerController {
  QuranPlayerController(this.ref, this._player);

  final Ref ref;
  final AudioPlayer _player;

  AudioPlayer get player => _player;

  Future<void> pause() => _player.pause();

  void rememberSession(QuranActivePlaybackSession session) {
    ref.read(quranActivePlaybackSessionProvider.notifier).state = session;
  }

  void clearSession() {
    ref.read(quranActivePlaybackSessionProvider.notifier).state = null;
  }

  Future<bool> resumeCurrentPlaybackWithBismillah() async {
    final session =
        ref.read(quranActivePlaybackSessionProvider) ??
        await _restoreSessionFromStoredProgress();
    if (session == null || session.ayahNumbers.isEmpty) {
      return false;
    }

    final stored = ref.read(quranRecitationSessionProvider);
    final currentIndex = (_player.currentIndex ?? 0).clamp(
      0,
      session.ayahNumbers.length - 1,
    );
    final targetAyah =
        (_player.audioSource == null && stored?.surahNumber == session.surahNumber)
        ? stored!.ayahNumber
        : session.ayahNumbers[currentIndex];
    final request = QuranPlaybackRequest(
      surahNumber: session.surahNumber,
      ayahNumber: targetAyah,
      resumePosition:
          _player.audioSource == null && stored?.surahNumber == session.surahNumber
          ? Duration(seconds: stored!.positionSeconds)
          : _player.position,
      playbackReason: QuranPlaybackReason.resume,
      isSurahEntry: targetAyah == 1,
    );
    final prepared = await ref
        .read(quranPlaybackOrchestratorProvider)
        .preparePlayback(
          request: request,
          reciterId: session.reciterId,
          ayahNumbers: session.ayahNumbers,
          mode: session.bismillahMode,
        );
    await _executePreparedPlayback(
      prepared,
      reciterId: session.reciterId,
      playbackSpeed: session.playbackSpeed,
      includeMediaTags: session.includeMediaTags,
    );
    rememberSession(
      QuranActivePlaybackSession(
        surahNumber: session.surahNumber,
        ayahNumbers: session.ayahNumbers,
        reciterId: session.reciterId,
        playbackSpeed: session.playbackSpeed,
        includeMediaTags: session.includeMediaTags,
        isSurahMode: session.isSurahMode,
        bismillahMode: session.bismillahMode,
      ),
    );
    return true;
  }

  Future<bool> playAdjacentSurahWithBismillah(int offset) async {
    final activeSession = ref.read(quranActivePlaybackSessionProvider);
    final persistedSession = ref.read(quranRecitationSessionProvider);
    final currentSurah =
        activeSession?.surahNumber ?? persistedSession?.surahNumber;
    if (currentSurah == null) {
      return false;
    }
    final targetSurah = (currentSurah + offset).clamp(1, 114);
    if (targetSurah == currentSurah) {
      return false;
    }
    return _startSessionPlayback(
      surahNumber: targetSurah,
      ayahNumber: 1,
      resumePosition: Duration.zero,
      playbackReason: QuranPlaybackReason.jump,
      isSurahEntry: true,
      isSurahTransition: true,
      originatingSurahNumber: currentSurah,
      preferredMode:
          activeSession?.bismillahMode ??
          ref.read(quranDefaultBismillahPlaybackModeProvider),
    );
  }

  Future<void> startPreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
  }) {
    return _executePreparedPlayback(
      prepared,
      reciterId: reciterId,
      playbackSpeed: playbackSpeed,
      includeMediaTags: includeMediaTags,
    );
  }

  Future<void> _executePreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
  }) async {
    if (prepared.didPrependBismillah && prepared.preRollSource != null) {
      try {
        await _playSourceOnce(
          prepared.preRollSource!,
          playbackSpeed: playbackSpeed,
        );
      } catch (_) {
        // Bismillah pre-roll should never block the requested Qur'an recitation
        // target from starting.
      }
    }

    final audioRepository = ref.read(quranAudioRepositoryProvider);
    final reciterName = audioRepository.reciterById(reciterId).name;
    final surahMap = ref.read(quranSurahMapProvider);
    final sources = <AudioSource>[
      for (final entry in prepared.entries)
        if (entry.source.startsWith('/'))
          AudioSource.file(
            entry.source,
            tag: includeMediaTags
                ? _mediaItemForAyah(
                    surahNumber: prepared.request.surahNumber,
                    ayahNumber: entry.ayahNumber,
                    reciterName: reciterName,
                    surahMap: surahMap,
                  )
                : null,
          )
        else
          AudioSource.uri(
            Uri.parse(entry.source),
            tag: includeMediaTags
                ? _mediaItemForAyah(
                    surahNumber: prepared.request.surahNumber,
                    ayahNumber: entry.ayahNumber,
                    reciterName: reciterName,
                    surahMap: surahMap,
                  )
                : null,
          ),
    ];

    await _player.stop();
    await _player.setSpeed(playbackSpeed);
    await _player.setAudioSources(
      sources,
      initialIndex: prepared.initialLogicalIndex,
    );
    if (prepared.initialPosition > Duration.zero) {
      await _player.seek(
        prepared.initialPosition,
        index: prepared.initialLogicalIndex,
      );
    }
    await _player.play();
  }

  Future<QuranActivePlaybackSession?> _restoreSessionFromStoredProgress() async {
    final stored = ref.read(quranRecitationSessionProvider);
    if (stored == null) {
      return null;
    }
    final ayahs = await ref.read(
      quranSurahAyahsProvider(stored.surahNumber).future,
    );
    if (ayahs.isEmpty) {
      return null;
    }
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final session = QuranActivePlaybackSession(
      surahNumber: stored.surahNumber,
      ayahNumbers: ayahs
          .map((item) => item.ayahNumber)
          .toList(growable: false),
      reciterId: audioSettings.reciterId,
      playbackSpeed: audioSettings.playbackSpeed,
      includeMediaTags: audioSettings.backgroundPlaybackEnabled,
      isSurahMode: true,
      bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
    );
    rememberSession(session);
    return session;
  }

  Future<bool> _startSessionPlayback({
    required int surahNumber,
    required int ayahNumber,
    required Duration resumePosition,
    required QuranPlaybackReason playbackReason,
    required bool isSurahEntry,
    required bool isSurahTransition,
    int? originatingSurahNumber,
    required BismillahPlaybackMode preferredMode,
  }) async {
    final ayahs = await ref.read(quranSurahAyahsProvider(surahNumber).future);
    if (ayahs.isEmpty) {
      return false;
    }
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final ayahNumbers = ayahs
        .map((item) => item.ayahNumber)
        .toList(growable: false);
    final prepared = await ref
        .read(quranPlaybackOrchestratorProvider)
        .startPlayback(
          request: QuranPlaybackRequest(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            resumePosition: resumePosition > Duration.zero ? resumePosition : null,
            playbackReason: playbackReason,
            isSurahEntry: isSurahEntry,
            isSurahTransition: isSurahTransition,
            originatingSurahNumber: originatingSurahNumber,
          ),
          reciterId: audioSettings.reciterId,
          ayahNumbers: ayahNumbers,
          mode: preferredMode,
        );
    await _executePreparedPlayback(
      prepared,
      reciterId: audioSettings.reciterId,
      playbackSpeed: audioSettings.playbackSpeed,
      includeMediaTags: audioSettings.backgroundPlaybackEnabled,
    );
    rememberSession(
      QuranActivePlaybackSession(
        surahNumber: surahNumber,
        ayahNumbers: ayahNumbers,
        reciterId: audioSettings.reciterId,
        playbackSpeed: audioSettings.playbackSpeed,
        includeMediaTags: audioSettings.backgroundPlaybackEnabled,
        isSurahMode: true,
        bismillahMode: preferredMode,
      ),
    );
    return true;
  }

  Future<void> _playSourceOnce(
    String source, {
    required double playbackSpeed,
  }) async {
    await _player.stop();
    await _player.setSpeed(playbackSpeed);
    if (source.startsWith('/')) {
      await _player.setFilePath(source);
    } else {
      await _player.setUrl(source);
    }
    await _player.play();
    await _player.processingStateStream.firstWhere(
      (state) =>
          state == ProcessingState.completed || state == ProcessingState.idle,
    );
  }

  MediaItem _mediaItemForAyah({
    required int surahNumber,
    required int ayahNumber,
    required String reciterName,
    required Map<int, dynamic> surahMap,
  }) {
    final surah = surahMap[surahNumber];
    final surahLabel = surah?.transliteratedName ?? 'Surah $surahNumber';
    return MediaItem(
      id: 'quran:$surahNumber:$ayahNumber:$reciterName',
      album: 'Path of Nur • $surahLabel',
      title: '$surahLabel $surahNumber:$ayahNumber',
      artist: reciterName,
    );
  }
}

final quranPlayerControllerProvider = Provider<QuranPlayerController>((ref) {
  return QuranPlayerController(ref, ref.watch(quranSharedAudioPlayerProvider));
});
