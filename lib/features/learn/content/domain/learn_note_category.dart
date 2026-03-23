enum LearnNoteCategory {
  quran,
  hadith,
  learning,
  reflection,
  journal,
  dua,
  worship,
  general,
}

extension LearnNoteCategoryX on LearnNoteCategory {
  String get id => name;

  static LearnNoteCategory fromId(String? raw) {
    for (final value in LearnNoteCategory.values) {
      if (value.id == raw) return value;
    }
    return LearnNoteCategory.general;
  }
}
