enum ArabicLearningPlaybackSpeed { normal, slow }

class ArabicLearningAudioState {
  const ArabicLearningAudioState({
    this.activePlaybackId,
    this.isPlaying = false,
    this.playbackSpeed = ArabicLearningPlaybackSpeed.normal,
  });

  final String? activePlaybackId;
  final bool isPlaying;
  final ArabicLearningPlaybackSpeed playbackSpeed;

  ArabicLearningAudioState copyWith({
    String? activePlaybackId,
    bool? isPlaying,
    ArabicLearningPlaybackSpeed? playbackSpeed,
    bool clearActivePlaybackId = false,
  }) {
    return ArabicLearningAudioState(
      activePlaybackId: clearActivePlaybackId
          ? null
          : (activePlaybackId ?? this.activePlaybackId),
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }
}
