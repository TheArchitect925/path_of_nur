import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/quran_audio_resilience_models.dart';

class QuranPlaybackSourceState {
  const QuranPlaybackSourceState({
    this.activeSourceType = QuranPlaybackSourceType.unavailable,
    this.resolutionState = QuranPlaybackSourceResolutionState.idle,
    this.failureType,
    this.canRetry = false,
    this.canUseFallback = false,
    this.requiresUserAction = false,
    this.didApplyFallback = false,
    this.fallbackSourceType,
    this.surahNumber,
    this.ayahNumber,
    this.reciterId,
    this.failureDetail,
  });

  final QuranPlaybackSourceType activeSourceType;
  final QuranPlaybackSourceResolutionState resolutionState;
  final QuranPlaybackFailureType? failureType;
  final bool canRetry;
  final bool canUseFallback;
  final bool requiresUserAction;
  final bool didApplyFallback;
  final QuranPlaybackSourceType? fallbackSourceType;
  final int? surahNumber;
  final int? ayahNumber;
  final String? reciterId;
  final String? failureDetail;

  bool get hasFailure =>
      resolutionState == QuranPlaybackSourceResolutionState.failed &&
      failureType != null;

  QuranPlaybackSourceState copyWith({
    QuranPlaybackSourceType? activeSourceType,
    QuranPlaybackSourceResolutionState? resolutionState,
    QuranPlaybackFailureType? failureType,
    bool clearFailureType = false,
    bool? canRetry,
    bool? canUseFallback,
    bool? requiresUserAction,
    bool? didApplyFallback,
    QuranPlaybackSourceType? fallbackSourceType,
    bool clearFallbackSourceType = false,
    int? surahNumber,
    bool clearSurahNumber = false,
    int? ayahNumber,
    bool clearAyahNumber = false,
    String? reciterId,
    bool clearReciterId = false,
    String? failureDetail,
    bool clearFailureDetail = false,
  }) {
    return QuranPlaybackSourceState(
      activeSourceType: activeSourceType ?? this.activeSourceType,
      resolutionState: resolutionState ?? this.resolutionState,
      failureType: clearFailureType ? null : (failureType ?? this.failureType),
      canRetry: canRetry ?? this.canRetry,
      canUseFallback: canUseFallback ?? this.canUseFallback,
      requiresUserAction: requiresUserAction ?? this.requiresUserAction,
      didApplyFallback: didApplyFallback ?? this.didApplyFallback,
      fallbackSourceType: clearFallbackSourceType
          ? null
          : (fallbackSourceType ?? this.fallbackSourceType),
      surahNumber: clearSurahNumber ? null : (surahNumber ?? this.surahNumber),
      ayahNumber: clearAyahNumber ? null : (ayahNumber ?? this.ayahNumber),
      reciterId: clearReciterId ? null : (reciterId ?? this.reciterId),
      failureDetail: clearFailureDetail
          ? null
          : (failureDetail ?? this.failureDetail),
    );
  }
}

class QuranPlaybackSourceStateNotifier
    extends StateNotifier<QuranPlaybackSourceState> {
  QuranPlaybackSourceStateNotifier() : super(const QuranPlaybackSourceState());

  void reset() {
    state = const QuranPlaybackSourceState();
  }

  void markResolving({
    required QuranPlaybackSourceType activeSourceType,
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
    bool canUseFallback = false,
    QuranPlaybackSourceType? fallbackSourceType,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: activeSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.resolving,
      canRetry: false,
      canUseFallback: canUseFallback,
      requiresUserAction: false,
      didApplyFallback: false,
      fallbackSourceType: fallbackSourceType,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
    );
  }

  void markPreparingTransition({
    required QuranPlaybackSourceType activeSourceType,
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
    bool canUseFallback = false,
    QuranPlaybackSourceType? fallbackSourceType,
    bool didApplyFallback = false,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: activeSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.preparingTransition,
      canRetry: false,
      canUseFallback: canUseFallback,
      requiresUserAction: false,
      didApplyFallback: didApplyFallback,
      fallbackSourceType: fallbackSourceType,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
    );
  }

  void markReady({
    required QuranPlaybackSourceType activeSourceType,
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: activeSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.ready,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
    );
  }

  void markBuffering({
    required QuranPlaybackSourceType activeSourceType,
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
    bool didApplyFallback = false,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: activeSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.buffering,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
      didApplyFallback: didApplyFallback,
    );
  }

  void markFallbackApplied({
    required QuranPlaybackSourceType fromSourceType,
    required QuranPlaybackSourceType toSourceType,
    required int surahNumber,
    required int ayahNumber,
    required String reciterId,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: toSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.fallbackApplied,
      canRetry: true,
      canUseFallback: false,
      requiresUserAction: false,
      didApplyFallback: true,
      fallbackSourceType: fromSourceType,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
    );
  }

  void markFailure({
    required QuranPlaybackFailureType failureType,
    required QuranPlaybackSourceType activeSourceType,
    required bool canRetry,
    required bool canUseFallback,
    required bool requiresUserAction,
    required int? surahNumber,
    required int? ayahNumber,
    required String? reciterId,
    String? failureDetail,
  }) {
    state = QuranPlaybackSourceState(
      activeSourceType: activeSourceType,
      resolutionState: QuranPlaybackSourceResolutionState.failed,
      failureType: failureType,
      canRetry: canRetry,
      canUseFallback: canUseFallback,
      requiresUserAction: requiresUserAction,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
      failureDetail: failureDetail,
    );
  }
}

QuranPlaybackFailureType classifyQuranPlaybackFailure({
  required Object error,
  required QuranPlaybackSourceType sourceType,
  bool duringReciterSwitch = false,
  bool duringSessionRestore = false,
}) {
  if (duringReciterSwitch) {
    return QuranPlaybackFailureType.reciterUnavailable;
  }
  if (duringSessionRestore) {
    return QuranPlaybackFailureType.sessionRestoreFailed;
  }
  if (error is PlayerInterruptedException) {
    return QuranPlaybackFailureType.unknown;
  }

  final message = error.toString().toLowerCase();
  if (message.contains('timed out') || message.contains('timeout')) {
    return QuranPlaybackFailureType.bufferingTimeout;
  }
  if (sourceType == QuranPlaybackSourceType.localDownload) {
    if (message.contains('404') ||
        message.contains('not found') ||
        message.contains('no such file')) {
      return QuranPlaybackFailureType.sourceMissing;
    }
    if (message.contains('format') ||
        message.contains('decoder') ||
        message.contains('decode') ||
        message.contains('corrupt')) {
      return QuranPlaybackFailureType.sourceCorrupt;
    }
  }
  if (message.contains('network') ||
      message.contains('socket') ||
      message.contains('host') ||
      message.contains('dns') ||
      message.contains('connection') ||
      message.contains('offline') ||
      message.contains('unreachable') ||
      message.contains('timed out')) {
    return QuranPlaybackFailureType.networkUnavailable;
  }
  if (message.contains('404') ||
      message.contains('not found') ||
      message.contains('403') ||
      message.contains('source')) {
    return QuranPlaybackFailureType.sourceMissing;
  }
  return QuranPlaybackFailureType.unknown;
}

final quranPlaybackSourceStateProvider = StateNotifierProvider<
  QuranPlaybackSourceStateNotifier,
  QuranPlaybackSourceState
>((ref) {
  return QuranPlaybackSourceStateNotifier();
});
