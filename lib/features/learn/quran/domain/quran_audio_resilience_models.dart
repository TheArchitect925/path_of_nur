enum QuranPlaybackSourceType { localDownload, remoteStream, unavailable }

enum QuranPlaybackSourceResolutionState {
  idle,
  preparingTransition,
  resolving,
  ready,
  buffering,
  failed,
  fallbackApplied,
}

enum QuranPlaybackFailureType {
  networkUnavailable,
  sourceMissing,
  sourceCorrupt,
  reciterUnavailable,
  bufferingTimeout,
  sessionRestoreFailed,
  unknown,
}
