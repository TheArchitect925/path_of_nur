enum HadithSourceBrowseChapterKind { canonical, general, uncategorized }

class HadithSourceBrowseCollection {
  const HadithSourceBrowseCollection({
    required this.id,
    required this.title,
    required this.entryCount,
    required this.chapterCount,
  });

  final String id;
  final String title;
  final int entryCount;
  final int chapterCount;

  bool get hasChapters => chapterCount > 0;
}

class HadithSourceBrowseChapter {
  const HadithSourceBrowseChapter({
    required this.id,
    required this.title,
    required this.number,
    required this.entryCount,
    required this.kind,
  });

  final String id;
  final String title;
  final int? number;
  final int entryCount;
  final HadithSourceBrowseChapterKind kind;

  bool get isFallback =>
      kind == HadithSourceBrowseChapterKind.general ||
      kind == HadithSourceBrowseChapterKind.uncategorized;
}
