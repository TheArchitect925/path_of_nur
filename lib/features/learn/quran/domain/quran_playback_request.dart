class QuranPlaybackRequest {
  const QuranPlaybackRequest({
    required this.surahNumber,
    required this.playbackReason,
    this.ayahNumber,
    this.sectionId,
    this.resumePosition,
    this.isSurahEntry,
    this.isSurahTransition = false,
    this.originatingSurahNumber,
  }) : assert(surahNumber > 0),
       assert(ayahNumber == null || ayahNumber > 0);

  final int surahNumber;
  final int? ayahNumber;
  final String? sectionId;
  final Duration? resumePosition;
  final QuranPlaybackReason playbackReason;
  final bool? isSurahEntry;
  final bool isSurahTransition;
  final int? originatingSurahNumber;

  int get targetSurahNumber => surahNumber;

  int? get targetAyahNumber => ayahNumber;

  bool get resolvesToSurahEntry =>
      isSurahEntry ?? targetAyahNumber == null || targetAyahNumber == 1;
}

enum QuranPlaybackReason {
  freshPlay,
  resume,
  jump,
  bookmark,
  restore,
  lesson,
  deepLink,
}
