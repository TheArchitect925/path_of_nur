import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quran_providers.dart';
import 'quran_reader_playback_controller.dart';

class QuranReaderFollowModeState {
  const QuranReaderFollowModeState({
    required this.followModeEnabled,
    this.activeAyahNumber,
    this.pendingScrollAyahNumber,
    this.scrollRequestVersion = 0,
    this.isTemporarilySuspended = false,
    this.isProgrammaticScrollInProgress = false,
  });

  final bool followModeEnabled;
  final int? activeAyahNumber;
  final int? pendingScrollAyahNumber;
  final int scrollRequestVersion;
  final bool isTemporarilySuspended;
  final bool isProgrammaticScrollInProgress;

  bool get shouldAutoScroll => pendingScrollAyahNumber != null;
  bool get canReturnToCurrentAyah =>
      followModeEnabled && isTemporarilySuspended && activeAyahNumber != null;

  QuranReaderFollowModeState copyWith({
    bool? followModeEnabled,
    int? activeAyahNumber,
    int? pendingScrollAyahNumber,
    int? scrollRequestVersion,
    bool? isTemporarilySuspended,
    bool? isProgrammaticScrollInProgress,
    bool clearPendingScroll = false,
  }) {
    return QuranReaderFollowModeState(
      followModeEnabled: followModeEnabled ?? this.followModeEnabled,
      activeAyahNumber: activeAyahNumber ?? this.activeAyahNumber,
      pendingScrollAyahNumber: clearPendingScroll
          ? null
          : (pendingScrollAyahNumber ?? this.pendingScrollAyahNumber),
      scrollRequestVersion: scrollRequestVersion ?? this.scrollRequestVersion,
      isTemporarilySuspended:
          isTemporarilySuspended ?? this.isTemporarilySuspended,
      isProgrammaticScrollInProgress:
          isProgrammaticScrollInProgress ?? this.isProgrammaticScrollInProgress,
    );
  }
}

class QuranReaderFollowModeCoordinator
    extends StateNotifier<QuranReaderFollowModeState> {
  QuranReaderFollowModeCoordinator(this.ref, {required this.pageSurahNumber})
    : super(
        QuranReaderFollowModeState(
          followModeEnabled: ref
              .read(quranReaderSettingsProvider)
              .followPlayback,
          activeAyahNumber: ref
              .read(quranReaderPlaybackControllerProvider(pageSurahNumber))
              .activeAyahNumber,
        ),
      ) {
    _bind();
  }

  final Ref ref;
  final int pageSurahNumber;
  bool _resumeOnNextPlaybackAyahChange = false;

  void _bind() {
    ref.listen<QuranReaderPlaybackState>(
      quranReaderPlaybackControllerProvider(pageSurahNumber),
      _handlePlaybackChanged,
    );
    ref.listen<QuranReaderSettings>(
      quranReaderSettingsProvider,
      (previous, next) => _handleSettingsChanged(next.followPlayback),
    );
  }

  void _handlePlaybackChanged(
    QuranReaderPlaybackState? previous,
    QuranReaderPlaybackState next,
  ) {
    final activeAyahNumber = next.activeSurahNumber == pageSurahNumber
        ? next.activeAyahNumber
        : null;
    final previousActiveAyahNumber = state.activeAyahNumber;
    state = state.copyWith(activeAyahNumber: activeAyahNumber);

    final activeAyahChanged =
        previous?.activeAyahNumber != activeAyahNumber ||
        previousActiveAyahNumber != activeAyahNumber;

    if (state.followModeEnabled &&
        state.isTemporarilySuspended &&
        _resumeOnNextPlaybackAyahChange &&
        next.isPlaying &&
        activeAyahNumber != null &&
        activeAyahChanged) {
      _resumeOnNextPlaybackAyahChange = false;
      state = state.copyWith(isTemporarilySuspended: false);
      _queueScroll(activeAyahNumber);
      return;
    }

    if (!state.followModeEnabled ||
        state.isTemporarilySuspended ||
        state.isProgrammaticScrollInProgress ||
        activeAyahNumber == null) {
      return;
    }

    if (activeAyahChanged) {
      _queueScroll(activeAyahNumber);
    }
  }

  void _handleSettingsChanged(bool followModeEnabled) {
    if (!followModeEnabled) {
      state = state.copyWith(
        followModeEnabled: false,
        isTemporarilySuspended: false,
        isProgrammaticScrollInProgress: false,
        clearPendingScroll: true,
      );
      _resumeOnNextPlaybackAyahChange = false;
      return;
    }

    state = state.copyWith(
      followModeEnabled: true,
      isTemporarilySuspended: false,
    );
    _resumeOnNextPlaybackAyahChange = false;
    final activeAyahNumber = state.activeAyahNumber;
    if (activeAyahNumber != null) {
      _queueScroll(activeAyahNumber);
    }
  }

  void handleUserScrollInteraction() {
    if (!state.followModeEnabled ||
        state.activeAyahNumber == null ||
        state.isProgrammaticScrollInProgress ||
        state.isTemporarilySuspended) {
      return;
    }
    _resumeOnNextPlaybackAyahChange = false;
    state = state.copyWith(
      isTemporarilySuspended: true,
      clearPendingScroll: true,
    );
  }

  void handleUserScrollSettled() {
    if (!state.followModeEnabled || !state.isTemporarilySuspended) {
      return;
    }
    _resumeOnNextPlaybackAyahChange = true;
  }

  void temporarilySuspendFollowMode() {
    if (!state.followModeEnabled || state.isTemporarilySuspended) {
      return;
    }
    _resumeOnNextPlaybackAyahChange = true;
    state = state.copyWith(
      isTemporarilySuspended: true,
      clearPendingScroll: true,
    );
  }

  void handleAyahInteraction(int ayahNumber) {
    if (!state.followModeEnabled) {
      return;
    }
    _resumeOnNextPlaybackAyahChange = false;
    state = state.copyWith(isTemporarilySuspended: false);
    _queueScroll(ayahNumber);
  }

  void requestReturnToCurrentAyah() {
    final activeAyahNumber = state.activeAyahNumber;
    if (!state.followModeEnabled || activeAyahNumber == null) {
      return;
    }
    _resumeOnNextPlaybackAyahChange = false;
    state = state.copyWith(isTemporarilySuspended: false);
    _queueScroll(activeAyahNumber);
  }

  void markProgrammaticScrollStarted() {
    if (state.isProgrammaticScrollInProgress) {
      return;
    }
    state = state.copyWith(isProgrammaticScrollInProgress: true);
  }

  void markProgrammaticScrollCompleted() {
    if (!mounted) {
      return;
    }
    final activeAyahNumber = state.activeAyahNumber;
    state = state.copyWith(
      activeAyahNumber: activeAyahNumber,
      isProgrammaticScrollInProgress: false,
      clearPendingScroll: true,
    );
  }

  void _queueScroll(int ayahNumber) {
    if (state.pendingScrollAyahNumber == ayahNumber &&
        !state.isTemporarilySuspended &&
        !state.isProgrammaticScrollInProgress) {
      return;
    }
    state = state.copyWith(
      pendingScrollAyahNumber: ayahNumber,
      scrollRequestVersion: state.scrollRequestVersion + 1,
    );
  }
}

final quranReaderFollowModeCoordinatorProvider = StateNotifierProvider
    .autoDispose
    .family<QuranReaderFollowModeCoordinator, QuranReaderFollowModeState, int>((
      ref,
      surahNumber,
    ) {
      return QuranReaderFollowModeCoordinator(
        ref,
        pageSurahNumber: surahNumber,
      );
    });
