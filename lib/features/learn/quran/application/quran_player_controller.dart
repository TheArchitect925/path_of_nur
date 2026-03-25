import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../data/quran_audio_repository.dart';
import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_audio_resilience_models.dart';
import '../domain/quran_playback_request.dart';
import 'quran_audio_resilience.dart';
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
  QuranPlayerController(this.ref, this._player) {
    _errorSubscription = _player.errorStream.listen(_handlePlayerError);
    _playerStateSubscription = _player.playerStateStream.listen(
      _handlePlayerState,
    );
    _currentIndexSubscription = _player.currentIndexStream.listen(
      (_) => _syncSourceStateFromCurrentPlayback(),
    );
    ref.onDispose(() {
      _bufferingTimeoutTimer?.cancel();
      _errorSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _currentIndexSubscription?.cancel();
    });
  }

  final Ref ref;
  final AudioPlayer _player;
  StreamSubscription<PlayerException>? _errorSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  Timer? _bufferingTimeoutTimer;
  QuranPreparedPlayback? _activePreparedPlayback;
  String? _activeReciterId;
  double _activePlaybackSpeed = 1.0;
  bool _activeIncludeMediaTags = true;
  bool _isRecoveringFromSourceFailure = false;
  static const _bufferingTimeout = Duration(seconds: 18);

  AudioPlayer get player => _player;

  Future<void> pause() => _player.pause();

  Future<void> setRepeatCurrentAyahEnabled(bool enabled) {
    return _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  Future<void> stop({bool preserveSession = true}) async {
    if (preserveSession) {
      _persistCurrentSessionPosition();
    }
    await _player.setLoopMode(LoopMode.off);
    await _player.stop();
    _activePreparedPlayback = null;
    _activeReciterId = null;
    _bufferingTimeoutTimer?.cancel();
    _bufferingTimeoutTimer = null;
    clearSession();
  }

  Future<void> seek(Duration position, {int? index}) {
    return _player.seek(position, index: index);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _activePlaybackSpeed = speed;
    await _player.setSpeed(speed);
  }

  Future<bool> playAyah({
    required int surahNumber,
    required int ayahNumber,
    Duration resumePosition = Duration.zero,
    QuranPlaybackReason playbackReason = QuranPlaybackReason.freshPlay,
    List<int>? ayahNumbers,
    bool pauseAfterStart = false,
  }) async {
    try {
      final activeSession = ref.read(quranActivePlaybackSessionProvider);
      final resolvedAyahs =
          ayahNumbers ??
          (activeSession?.surahNumber == surahNumber
              ? activeSession?.ayahNumbers
              : null) ??
          await _loadSurahAyahNumbers(surahNumber);
      if (resolvedAyahs.isEmpty || !resolvedAyahs.contains(ayahNumber)) {
        return false;
      }

      final session = activeSession != null &&
              activeSession.surahNumber == surahNumber &&
              _matchesAyahSequence(activeSession.ayahNumbers, resolvedAyahs)
          ? activeSession
          : QuranActivePlaybackSession(
              surahNumber: surahNumber,
              ayahNumbers: resolvedAyahs,
              reciterId: ref.read(quranAudioSettingsProvider).reciterId,
              playbackSpeed: _resolvedPlaybackSpeed(),
              includeMediaTags:
                  ref.read(quranAudioSettingsProvider).backgroundPlaybackEnabled,
              isSurahMode: resolvedAyahs.length > 1,
              bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
            );
      _markPreparingTransition(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        reciterId: session.reciterId,
      );
      final started = await _playSessionAyahAtIndex(
        session: session,
        targetIndex: resolvedAyahs.indexOf(ayahNumber),
        playbackReason: playbackReason,
        resumePosition: resumePosition,
      );
      if (!started) {
        return false;
      }
      if (pauseAfterStart) {
        await _player.pause();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resumeStoredRecitationSession({
    bool restartFromSurah = false,
    bool pauseAfterStart = false,
  }) async {
    final stored = ref.read(quranRecitationSessionProvider);
    if (stored == null) {
      return false;
    }
    final targetAyah = restartFromSurah ? 1 : stored.ayahNumber;
    _markPreparingTransition(
      surahNumber: stored.surahNumber,
      ayahNumber: targetAyah,
      reciterId: ref.read(quranAudioSettingsProvider).reciterId,
    );
    final started = await _startSessionPlayback(
      surahNumber: stored.surahNumber,
      ayahNumber: targetAyah,
      resumePosition: restartFromSurah
          ? Duration.zero
          : Duration(seconds: stored.positionSeconds),
      playbackReason: restartFromSurah
          ? QuranPlaybackReason.freshPlay
          : QuranPlaybackReason.resume,
      isSurahEntry: targetAyah == 1,
      isSurahTransition: false,
      preferredMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
    );
    if (!started) {
      return false;
    }
    if (pauseAfterStart) {
      await _player.pause();
    }
    return true;
  }

  Future<bool> switchReciter(String reciterId) async {
    final exists = QuranAudioRepository.reciters.any((item) => item.id == reciterId);
    if (!exists) {
      return false;
    }

    final currentSettings = ref.read(quranAudioSettingsProvider);
    if (currentSettings.reciterId == reciterId) {
      return true;
    }

    final activeSession = ref.read(quranActivePlaybackSessionProvider);
    final storedSession = ref.read(quranRecitationSessionProvider);
    final hasRestorablePlayback =
        activeSession != null &&
        activeSession.ayahNumbers.isNotEmpty &&
        (_player.audioSource != null ||
            (storedSession?.surahNumber == activeSession.surahNumber));

    if (!hasRestorablePlayback) {
      ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciterId);
      return true;
    }

    final session = activeSession;
    final wasPlaying = _player.playing;
    final currentIndex = (_player.currentIndex ?? 0).clamp(
      0,
      session.ayahNumbers.length - 1,
    );
    final targetAyah = session.ayahNumbers[currentIndex];
    final resumePosition = _player.position;
    final request = QuranPlaybackRequest(
      surahNumber: session.surahNumber,
      ayahNumber: targetAyah,
      resumePosition: resumePosition > Duration.zero ? resumePosition : null,
      playbackReason: QuranPlaybackReason.resume,
      isSurahEntry: targetAyah == 1,
    );

    try {
      _markPreparingTransition(
        surahNumber: session.surahNumber,
        ayahNumber: targetAyah,
        reciterId: reciterId,
      );
      final prepared = await ref
          .read(quranPlaybackOrchestratorProvider)
          .preparePlayback(
            request: request,
            reciterId: reciterId,
            ayahNumbers: session.ayahNumbers,
            mode: session.bismillahMode,
          );
      final started = await _executePreparedPlayback(
        prepared,
        reciterId: reciterId,
        playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
        includeMediaTags: session.includeMediaTags,
      );
      if (!started) {
        await _restorePreviousReciterSession(
          session: session,
          reciterId: currentSettings.reciterId,
          targetAyah: targetAyah,
          resumePosition: resumePosition,
          wasPlaying: wasPlaying,
        );
        return false;
      }
      rememberSession(
        QuranActivePlaybackSession(
          surahNumber: session.surahNumber,
          ayahNumbers: session.ayahNumbers,
          reciterId: reciterId,
          playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
          includeMediaTags: session.includeMediaTags,
          isSurahMode: session.isSurahMode,
          bismillahMode: session.bismillahMode,
        ),
      );
      ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciterId);
      ref
          .read(quranRecitationSessionProvider.notifier)
          .save(
            surahNumber: session.surahNumber,
            ayahNumber: targetAyah,
            positionSeconds: _player.position.inSeconds,
          );
      if (!wasPlaying) {
        await _player.pause();
      }
      return true;
    } catch (_) {
      await _restorePreviousReciterSession(
        session: session,
        reciterId: currentSettings.reciterId,
        targetAyah: targetAyah,
        resumePosition: resumePosition,
        wasPlaying: wasPlaying,
      );
      return false;
    }
  }

  void rememberSession(QuranActivePlaybackSession session) {
    ref.read(quranActivePlaybackSessionProvider.notifier).state = session;
  }

  void clearSession() {
    ref.read(quranActivePlaybackSessionProvider.notifier).state = null;
    if (_player.audioSource == null) {
      ref.read(quranPlaybackSourceStateProvider.notifier).reset();
    }
  }

  Future<bool> resumeCurrentPlayback() async {
    try {
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
          (_player.audioSource == null &&
              stored?.surahNumber == session.surahNumber)
          ? stored!.ayahNumber
          : session.ayahNumbers[currentIndex];
      final request = QuranPlaybackRequest(
        surahNumber: session.surahNumber,
        ayahNumber: targetAyah,
        resumePosition:
            _player.audioSource == null &&
                stored?.surahNumber == session.surahNumber
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
      final started = await _executePreparedPlayback(
        prepared,
        reciterId: session.reciterId,
        playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
        includeMediaTags: session.includeMediaTags,
      );
      if (!started) {
        ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
          failureType: QuranPlaybackFailureType.sessionRestoreFailed,
          activeSourceType: QuranPlaybackSourceType.unavailable,
          canRetry: true,
          canUseFallback: false,
          requiresUserAction: true,
          surahNumber: session.surahNumber,
          ayahNumber: targetAyah,
          reciterId: session.reciterId,
        );
        return false;
      }
      rememberSession(
        QuranActivePlaybackSession(
          surahNumber: session.surahNumber,
          ayahNumbers: session.ayahNumbers,
          reciterId: session.reciterId,
          playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
          includeMediaTags: session.includeMediaTags,
          isSurahMode: session.isSurahMode,
          bismillahMode: session.bismillahMode,
        ),
      );
      return true;
    } catch (error) {
      final stored = ref.read(quranRecitationSessionProvider);
      ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
        failureType: QuranPlaybackFailureType.sessionRestoreFailed,
        activeSourceType: QuranPlaybackSourceType.unavailable,
        canRetry: true,
        canUseFallback: false,
        requiresUserAction: true,
        surahNumber: stored?.surahNumber,
        ayahNumber: stored?.ayahNumber,
        reciterId: ref.read(quranAudioSettingsProvider).reciterId,
        failureDetail: error.toString(),
      );
      return false;
    }
  }

  Future<bool> retryCurrentPlayback() async {
    ref.read(quranPlaybackSourceStateProvider.notifier).reset();
    return resumeCurrentPlayback();
  }

  Future<bool> replayCurrentAyah() async {
    try {
      final session =
          ref.read(quranActivePlaybackSessionProvider) ??
          await _restoreSessionFromStoredProgress();
      if (session == null || session.ayahNumbers.isEmpty) {
        return false;
      }
      final currentIndex = (_player.currentIndex ?? 0).clamp(
        0,
        session.ayahNumbers.length - 1,
      );
      return _playSessionAyahAtIndex(
        session: session,
        targetIndex: currentIndex,
        playbackReason: QuranPlaybackReason.jump,
        resumePosition: Duration.zero,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> playRelativeAyah(int offset) async {
    try {
      final session =
          ref.read(quranActivePlaybackSessionProvider) ??
          await _restoreSessionFromStoredProgress();
      if (session == null || session.ayahNumbers.isEmpty) {
        return false;
      }
      final currentIndex = (_player.currentIndex ?? 0).clamp(
        0,
        session.ayahNumbers.length - 1,
      );
      final targetIndex = (currentIndex + offset).clamp(
        0,
        session.ayahNumbers.length - 1,
      );
      return _playSessionAyahAtIndex(
        session: session,
        targetIndex: targetIndex,
        playbackReason: offset == 0
            ? QuranPlaybackReason.resume
            : QuranPlaybackReason.jump,
        resumePosition: Duration.zero,
      );
    } catch (_) {
      return false;
    }
  }

  @Deprecated('Auto-Bismillah is temporarily disabled. Use resumeCurrentPlayback.')
  Future<bool> resumeCurrentPlaybackWithBismillah() {
    return resumeCurrentPlayback();
  }

  Future<bool> playAdjacentSurah(int offset) async {
    final activeSession = ref.read(quranActivePlaybackSessionProvider);
    final persistedSession = ref.read(quranRecitationSessionProvider);
    final wasPlaying = _player.playing;
    final currentSurah =
        activeSession?.surahNumber ?? persistedSession?.surahNumber;
    if (currentSurah == null) {
      return false;
    }
    final targetSurah = (currentSurah + offset).clamp(1, 114);
    if (targetSurah == currentSurah) {
      return false;
    }
    try {
      final started = await _startSessionPlayback(
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
      if (started && !wasPlaying) {
        await _player.pause();
      }
      return started;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startPreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
    LoopMode loopMode = LoopMode.off,
  }) {
    return _executePreparedPlayback(
      prepared,
      reciterId: reciterId,
      playbackSpeed: playbackSpeed,
      includeMediaTags: includeMediaTags,
      loopMode: loopMode,
    );
  }

  Future<bool> _executePreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
    LoopMode loopMode = LoopMode.off,
  }) async {
    _activePreparedPlayback = prepared;
    _activeReciterId = reciterId;
    _activePlaybackSpeed = playbackSpeed;
    _activeIncludeMediaTags = includeMediaTags;
    final targetEntry = prepared.entries[prepared.initialLogicalIndex];
    ref.read(quranPlaybackSourceStateProvider.notifier).markResolving(
      activeSourceType: targetEntry.metadata.sourceType,
      surahNumber: targetEntry.metadata.surahNumber,
      ayahNumber: targetEntry.metadata.ayahNumber,
      reciterId: reciterId,
      canUseFallback: targetEntry.metadata.hasFallbackSource,
      fallbackSourceType: targetEntry.metadata.fallbackSourceType,
    );

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

    return _activatePreparedPlayback(
      prepared,
      initialIndex: prepared.initialLogicalIndex,
      initialPosition: prepared.initialPosition,
      reciterId: reciterId,
      playbackSpeed: playbackSpeed,
      includeMediaTags: includeMediaTags,
      loopMode: loopMode,
    );
  }

  Future<bool> _activatePreparedPlayback(
    QuranPreparedPlayback prepared, {
    required int initialIndex,
    required Duration initialPosition,
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
    required LoopMode loopMode,
    QuranPlaybackSourceType? fallbackFrom,
    bool hasAlreadyAttemptedFallback = false,
  }) async {
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    final reciterName = audioRepository.reciterById(reciterId).name;
    final surahMap = ref.read(quranSurahMapProvider);
    final sources = _buildAudioSources(
      prepared: prepared,
      includeMediaTags: includeMediaTags,
      reciterName: reciterName,
      surahMap: surahMap,
    );

    try {
      await _player.stop();
      await _player.setSpeed(playbackSpeed);
      await _player.setAudioSources(sources, initialIndex: initialIndex);
      await _player.setLoopMode(loopMode);
      if (initialPosition > Duration.zero) {
        await _player.seek(initialPosition, index: initialIndex);
      }
      await _player.play();
      _activePreparedPlayback = prepared;
      _activeReciterId = reciterId;
      _activePlaybackSpeed = playbackSpeed;
      _activeIncludeMediaTags = includeMediaTags;
      final entry = prepared.entries[initialIndex];
      if (fallbackFrom != null) {
        ref.read(quranPlaybackSourceStateProvider.notifier).markFallbackApplied(
          fromSourceType: fallbackFrom,
          toSourceType: entry.metadata.sourceType,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: reciterId,
        );
      } else {
        ref.read(quranPlaybackSourceStateProvider.notifier).markReady(
          activeSourceType: entry.metadata.sourceType,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: reciterId,
        );
      }
      _scheduleBufferingTimeoutIfNeeded(_player.playerState);
      final activeSession = ref.read(quranActivePlaybackSessionProvider);
      if (activeSession != null) {
        _scheduleLikelyPreloads(
          session: activeSession,
          currentIndex: initialIndex,
        );
      }
      return true;
    } on PlayerException catch (error) {
      if (!hasAlreadyAttemptedFallback) {
        final fallbackPrepared = _preparedPlaybackWithFallbackForIndex(
          prepared,
          initialIndex,
        );
        if (fallbackPrepared != null) {
          return _activatePreparedPlayback(
            fallbackPrepared,
            initialIndex: initialIndex,
            initialPosition: initialPosition,
            reciterId: reciterId,
            playbackSpeed: playbackSpeed,
            includeMediaTags: includeMediaTags,
            loopMode: loopMode,
            fallbackFrom: prepared.entries[initialIndex].metadata.sourceType,
            hasAlreadyAttemptedFallback: true,
          );
        }
      }
      _saveFailureSessionContext(
        prepared: prepared,
        failedIndex: initialIndex,
        failurePosition: initialPosition,
      );
      ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
        failureType: classifyQuranPlaybackFailure(
          error: error,
          sourceType: prepared.entries[initialIndex].metadata.sourceType,
        ),
        activeSourceType: prepared.entries[initialIndex].metadata.sourceType,
        canRetry: true,
        canUseFallback: prepared.entries[initialIndex].metadata.hasFallbackSource,
        requiresUserAction: true,
        surahNumber: prepared.entries[initialIndex].metadata.surahNumber,
        ayahNumber: prepared.entries[initialIndex].metadata.ayahNumber,
        reciterId: reciterId,
        failureDetail: error.message,
      );
      await _player.stop();
      return false;
    } on PlayerInterruptedException {
      return false;
    }
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
      playbackSpeed: _resolvedPlaybackSpeed(
        preferred: audioSettings.playbackSpeed,
      ),
      includeMediaTags: audioSettings.backgroundPlaybackEnabled,
      isSurahMode: true,
      bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
    );
    rememberSession(session);
    return session;
  }

  Future<bool> _playSessionAyahAtIndex({
    required QuranActivePlaybackSession session,
    required int targetIndex,
    required QuranPlaybackReason playbackReason,
    required Duration resumePosition,
  }) async {
    if (session.ayahNumbers.isEmpty) {
      return false;
    }
    final safeIndex = targetIndex.clamp(0, session.ayahNumbers.length - 1);
    final targetAyah = session.ayahNumbers[safeIndex];
    final wasPlaying = _player.playing;
    _markPreparingTransition(
      surahNumber: session.surahNumber,
      ayahNumber: targetAyah,
      reciterId: session.reciterId,
    );
    final prepared = await ref
        .read(quranPlaybackOrchestratorProvider)
        .preparePlayback(
          request: QuranPlaybackRequest(
            surahNumber: session.surahNumber,
            ayahNumber: targetAyah,
            resumePosition: resumePosition > Duration.zero ? resumePosition : null,
            playbackReason: playbackReason,
            isSurahEntry: targetAyah == 1,
          ),
          reciterId: session.reciterId,
          ayahNumbers: session.ayahNumbers,
          mode: session.bismillahMode,
        );
    final started = await _executePreparedPlayback(
      prepared,
      reciterId: session.reciterId,
      playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
      includeMediaTags: session.includeMediaTags,
    );
    if (!started) {
      return false;
    }
    rememberSession(
      QuranActivePlaybackSession(
        surahNumber: session.surahNumber,
        ayahNumbers: session.ayahNumbers,
        reciterId: session.reciterId,
        playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
        includeMediaTags: session.includeMediaTags,
        isSurahMode: session.isSurahMode,
        bismillahMode: session.bismillahMode,
      ),
    );
    _scheduleLikelyPreloads(session: session, currentIndex: safeIndex);
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: session.surahNumber,
          ayahNumber: targetAyah,
          positionSeconds: 0,
        );
    if (!wasPlaying) {
      await _player.pause();
    }
    return true;
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
    final playbackSpeed = _resolvedPlaybackSpeed(
      preferred: audioSettings.playbackSpeed,
    );
    _markPreparingTransition(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: audioSettings.reciterId,
    );
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
    final started = await _executePreparedPlayback(
      prepared,
      reciterId: audioSettings.reciterId,
      playbackSpeed: playbackSpeed,
      includeMediaTags: audioSettings.backgroundPlaybackEnabled,
    );
    if (!started) {
      return false;
    }
    rememberSession(
      QuranActivePlaybackSession(
        surahNumber: surahNumber,
        ayahNumbers: ayahNumbers,
        reciterId: audioSettings.reciterId,
        playbackSpeed: playbackSpeed,
        includeMediaTags: audioSettings.backgroundPlaybackEnabled,
        isSurahMode: true,
        bismillahMode: preferredMode,
      ),
    );
    _scheduleLikelyPreloads(
      session: QuranActivePlaybackSession(
        surahNumber: surahNumber,
        ayahNumbers: ayahNumbers,
        reciterId: audioSettings.reciterId,
        playbackSpeed: playbackSpeed,
        includeMediaTags: audioSettings.backgroundPlaybackEnabled,
        isSurahMode: true,
        bismillahMode: preferredMode,
      ),
      currentIndex: ayahNumbers.indexOf(ayahNumber).clamp(0, ayahNumbers.length - 1),
    );
    return true;
  }

  @Deprecated('Auto-Bismillah is temporarily disabled. Use playAdjacentSurah.')
  Future<bool> playAdjacentSurahWithBismillah(int offset) {
    return playAdjacentSurah(offset);
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

  List<AudioSource> _buildAudioSources({
    required QuranPreparedPlayback prepared,
    required bool includeMediaTags,
    required String reciterName,
    required Map<int, dynamic> surahMap,
  }) {
    return <AudioSource>[
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
  }

  QuranPreparedPlayback? _preparedPlaybackWithFallbackForIndex(
    QuranPreparedPlayback prepared,
    int index,
  ) {
    if (index < 0 || index >= prepared.entries.length) {
      return null;
    }
    final entry = prepared.entries[index];
    final metadata = entry.metadata;
    if (!metadata.hasFallbackSource) {
      return null;
    }
    final fallbackMetadata = metadata.copyWith(
      source: metadata.fallbackSource,
      sourceType: metadata.fallbackSourceType,
      fallbackSource: metadata.source,
      fallbackSourceType: metadata.sourceType,
    );
    final nextEntries = prepared.entries.toList(growable: true);
    nextEntries[index] = entry.copyWith(
      source: fallbackMetadata.source,
      metadata: fallbackMetadata,
    );
    return prepared.copyWith(entries: nextEntries);
  }

  void _handlePlayerState(PlayerState playerState) {
    _scheduleBufferingTimeoutIfNeeded(playerState);
    _syncSourceStateFromCurrentPlayback(playerState: playerState);
  }

  void _scheduleBufferingTimeoutIfNeeded(PlayerState playerState) {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      _bufferingTimeoutTimer ??= Timer(_bufferingTimeout, () async {
        final activePrepared = _activePreparedPlayback;
        if (activePrepared == null) {
          return;
        }
        final index = (_player.currentIndex ?? activePrepared.initialLogicalIndex)
            .clamp(0, activePrepared.entries.length - 1);
        final entry = activePrepared.entries[index];
        _saveFailureSessionContext(
          prepared: activePrepared,
          failedIndex: index,
          failurePosition: _player.position,
        );
        ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
          failureType: QuranPlaybackFailureType.bufferingTimeout,
          activeSourceType: entry.metadata.sourceType,
          canRetry: true,
          canUseFallback: entry.metadata.hasFallbackSource,
          requiresUserAction: true,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: _activeReciterId,
        );
        await _player.stop();
      });
      return;
    }
    _bufferingTimeoutTimer?.cancel();
    _bufferingTimeoutTimer = null;
  }

  void _syncSourceStateFromCurrentPlayback({PlayerState? playerState}) {
    final prepared = _activePreparedPlayback;
    if (prepared == null || prepared.entries.isEmpty) {
      if (_player.audioSource == null &&
          !ref.read(quranPlaybackSourceStateProvider).hasFailure) {
        ref.read(quranPlaybackSourceStateProvider.notifier).reset();
      }
      return;
    }
    final index = (_player.currentIndex ?? prepared.initialLogicalIndex).clamp(
      0,
      prepared.entries.length - 1,
    );
    final entry = prepared.entries[index];
    final state = playerState ?? _player.playerState;
    final notifier = ref.read(quranPlaybackSourceStateProvider.notifier);
    switch (state.processingState) {
      case ProcessingState.loading:
        notifier.markResolving(
          activeSourceType: entry.metadata.sourceType,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: _activeReciterId ?? entry.metadata.reciterId,
          canUseFallback: entry.metadata.hasFallbackSource,
          fallbackSourceType: entry.metadata.fallbackSourceType,
        );
      case ProcessingState.buffering:
        notifier.markBuffering(
          activeSourceType: entry.metadata.sourceType,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: _activeReciterId ?? entry.metadata.reciterId,
          didApplyFallback:
              ref.read(quranPlaybackSourceStateProvider).didApplyFallback,
        );
      case ProcessingState.ready:
        final current = ref.read(quranPlaybackSourceStateProvider);
        if (current.didApplyFallback &&
            current.ayahNumber == entry.metadata.ayahNumber &&
            current.surahNumber == entry.metadata.surahNumber) {
          return;
        }
        notifier.markReady(
          activeSourceType: entry.metadata.sourceType,
          surahNumber: entry.metadata.surahNumber,
          ayahNumber: entry.metadata.ayahNumber,
          reciterId: _activeReciterId ?? entry.metadata.reciterId,
        );
      case ProcessingState.completed:
      case ProcessingState.idle:
        if (!ref.read(quranPlaybackSourceStateProvider).hasFailure &&
            _player.audioSource == null) {
          notifier.reset();
        }
    }
  }

  Future<void> _handlePlayerError(PlayerException error) async {
    if (_isRecoveringFromSourceFailure) {
      return;
    }
    final prepared = _activePreparedPlayback;
    if (prepared == null || prepared.entries.isEmpty) {
      ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
        failureType: QuranPlaybackFailureType.unknown,
        activeSourceType: QuranPlaybackSourceType.unavailable,
        canRetry: true,
        canUseFallback: false,
        requiresUserAction: true,
        surahNumber: null,
        ayahNumber: null,
        reciterId: _activeReciterId,
        failureDetail: error.message,
      );
      return;
    }

    _isRecoveringFromSourceFailure = true;
    try {
      final failedIndex = (error.index ?? _player.currentIndex ?? prepared.initialLogicalIndex)
          .clamp(0, prepared.entries.length - 1);
      final failedEntry = prepared.entries[failedIndex];
      final currentPosition =
          failedIndex == (_player.currentIndex ?? failedIndex)
          ? _player.position
          : Duration.zero;

      final fallbackPrepared = _preparedPlaybackWithFallbackForIndex(
        prepared,
        failedIndex,
      );
      if (fallbackPrepared != null) {
        final recovered = await _activatePreparedPlayback(
          fallbackPrepared,
          initialIndex: failedIndex,
          initialPosition: currentPosition,
          reciterId: _activeReciterId ?? failedEntry.metadata.reciterId,
          playbackSpeed: _activePlaybackSpeed,
          includeMediaTags: _activeIncludeMediaTags,
          loopMode: _player.loopMode,
          fallbackFrom: failedEntry.metadata.sourceType,
          hasAlreadyAttemptedFallback: true,
        );
        if (recovered) {
          return;
        }
      }

      _saveFailureSessionContext(
        prepared: prepared,
        failedIndex: failedIndex,
        failurePosition: currentPosition,
      );
      ref.read(quranPlaybackSourceStateProvider.notifier).markFailure(
        failureType: classifyQuranPlaybackFailure(
          error: error,
          sourceType: failedEntry.metadata.sourceType,
        ),
        activeSourceType: failedEntry.metadata.sourceType,
        canRetry: true,
        canUseFallback: failedEntry.metadata.hasFallbackSource,
        requiresUserAction: true,
        surahNumber: failedEntry.metadata.surahNumber,
        ayahNumber: failedEntry.metadata.ayahNumber,
        reciterId: _activeReciterId ?? failedEntry.metadata.reciterId,
        failureDetail: error.message,
      );
      await _player.stop();
    } finally {
      _isRecoveringFromSourceFailure = false;
    }
  }

  void _saveFailureSessionContext({
    required QuranPreparedPlayback prepared,
    required int failedIndex,
    required Duration failurePosition,
  }) {
    if (failedIndex < 0 || failedIndex >= prepared.entries.length) {
      return;
    }
    final failedEntry = prepared.entries[failedIndex];
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: failedEntry.metadata.surahNumber,
          ayahNumber: failedEntry.metadata.ayahNumber,
        positionSeconds: failurePosition.inSeconds,
        );
  }

  void _persistCurrentSessionPosition() {
    final session = ref.read(quranActivePlaybackSessionProvider);
    if (session == null || session.ayahNumbers.isEmpty) {
      return;
    }
    final currentIndex = (_player.currentIndex ?? 0).clamp(
      0,
      session.ayahNumbers.length - 1,
    );
    final currentAyah = session.ayahNumbers[currentIndex];
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: session.surahNumber,
          ayahNumber: currentAyah,
          positionSeconds: _player.position.inSeconds,
        );
  }

  Future<void> _restorePreviousReciterSession({
    required QuranActivePlaybackSession session,
    required String reciterId,
    required int targetAyah,
    required Duration resumePosition,
    required bool wasPlaying,
  }) async {
    try {
      final prepared = await ref
          .read(quranPlaybackOrchestratorProvider)
          .preparePlayback(
            request: QuranPlaybackRequest(
              surahNumber: session.surahNumber,
              ayahNumber: targetAyah,
              resumePosition: resumePosition > Duration.zero
                  ? resumePosition
                  : null,
              playbackReason: QuranPlaybackReason.resume,
              isSurahEntry: targetAyah == 1,
            ),
            reciterId: reciterId,
            ayahNumbers: session.ayahNumbers,
            mode: session.bismillahMode,
          );
      final restored = await _activatePreparedPlayback(
        prepared,
        initialIndex: prepared.initialLogicalIndex,
        initialPosition: prepared.initialPosition,
        reciterId: reciterId,
        playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
        includeMediaTags: session.includeMediaTags,
        loopMode: _player.loopMode,
      );
      if (restored) {
        rememberSession(
          QuranActivePlaybackSession(
            surahNumber: session.surahNumber,
            ayahNumbers: session.ayahNumbers,
            reciterId: reciterId,
            playbackSpeed: _resolvedPlaybackSpeed(preferred: session.playbackSpeed),
            includeMediaTags: session.includeMediaTags,
            isSurahMode: session.isSurahMode,
            bismillahMode: session.bismillahMode,
          ),
        );
        ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciterId);
        if (!wasPlaying) {
          await _player.pause();
        }
      }
    } catch (_) {
      // If the restore path also fails, keep the failure state already surfaced.
    }
  }

  Future<List<int>> _loadSurahAyahNumbers(int surahNumber) async {
    final ayahs = await ref.read(quranSurahAyahsProvider(surahNumber).future);
    return ayahs.map((item) => item.ayahNumber).toList(growable: false);
  }

  void _markPreparingTransition({
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
  }) {
    final current = ref.read(quranPlaybackSourceStateProvider);
    ref.read(quranPlaybackSourceStateProvider.notifier).markPreparingTransition(
      activeSourceType: current.activeSourceType,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
      canUseFallback: current.canUseFallback,
      fallbackSourceType: current.fallbackSourceType,
      didApplyFallback: current.didApplyFallback,
    );
  }

  void _scheduleLikelyPreloads({
    required QuranActivePlaybackSession session,
    required int currentIndex,
  }) {
    if (session.ayahNumbers.isEmpty) {
      return;
    }
    final safeIndex = currentIndex.clamp(0, session.ayahNumbers.length - 1);
    final nextAyah = safeIndex < session.ayahNumbers.length - 1
        ? session.ayahNumbers[safeIndex + 1]
        : null;
    if (nextAyah != null) {
      unawaited(
        ref.read(quranPlaybackOrchestratorProvider).preloadPlayback(
          request: QuranPlaybackRequest(
            surahNumber: session.surahNumber,
            ayahNumber: nextAyah,
            playbackReason: QuranPlaybackReason.jump,
            isSurahEntry: nextAyah == 1,
          ),
          reciterId: session.reciterId,
          ayahNumbers: session.ayahNumbers,
          mode: session.bismillahMode,
        ),
      );
      return;
    }
    if (session.surahNumber >= 114) {
      return;
    }
    unawaited(
      _preloadAdjacentSurahStart(
        currentSurahNumber: session.surahNumber,
        targetSurahNumber: session.surahNumber + 1,
        reciterId: session.reciterId,
        preferredMode: session.bismillahMode,
      ),
    );
  }

  Future<void> _preloadAdjacentSurahStart({
    required int currentSurahNumber,
    required int targetSurahNumber,
    required String reciterId,
    required BismillahPlaybackMode preferredMode,
  }) async {
    final ayahNumbers = await _loadSurahAyahNumbers(targetSurahNumber);
    if (ayahNumbers.isEmpty) {
      return;
    }
    await ref.read(quranPlaybackOrchestratorProvider).preloadPlayback(
      request: QuranPlaybackRequest(
        surahNumber: targetSurahNumber,
        ayahNumber: ayahNumbers.first,
        playbackReason: QuranPlaybackReason.jump,
        isSurahEntry: true,
        isSurahTransition: true,
        originatingSurahNumber: currentSurahNumber,
      ),
      reciterId: reciterId,
      ayahNumbers: ayahNumbers,
      mode: preferredMode,
    );
  }

  double _resolvedPlaybackSpeed({double? preferred}) {
    final readerSettings = ref.read(quranReaderSettingsProvider);
    if (readerSettings.wordSyncHighlightBeta) {
      return 1.0;
    }
    return preferred ?? ref.read(quranAudioSettingsProvider).playbackSpeed;
  }

  bool _matchesAyahSequence(List<int> left, List<int> right) {
    if (identical(left, right)) {
      return true;
    }
    if (left.length != right.length) {
      return false;
    }
    for (var i = 0; i < left.length; i += 1) {
      if (left[i] != right[i]) {
        return false;
      }
    }
    return true;
  }
}

final quranPlayerControllerProvider = Provider<QuranPlayerController>((ref) {
  return QuranPlayerController(ref, ref.watch(quranSharedAudioPlayerProvider));
});
