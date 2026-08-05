import 'quran_surah.dart';

enum QuranSurahSummaryFilter { all, makki, madani }

enum QuranSurahSummaryRevelationType { makki, madani, mixed }

enum QuranSurahContentEvidenceLevel {
  quranExplicit,
  broadlyAcceptedClassicalUnderstanding,
  widelyTaughtThematicSummary,
  devotionalRecitationAssociation,
  editorialSynthesis,
  requiresSourceReview,
}

enum QuranSurahThemeTag {
  tawhid,
  revelation,
  guidance,
  mercy,
  judgment,
  patience,
  repentance,
  prophethood,
  resurrection,
  worship,
  law,
  community,
  gratitude,
  justice,
  signsOfCreation,
  hypocrisy,
  charity,
  family,
  struggle,
  paradiseAndHell,
}

extension QuranSurahThemeTagSearchAliases on QuranSurahThemeTag {
  List<String> get searchAliases {
    return switch (this) {
      QuranSurahThemeTag.tawhid => const ['tawhid', 'oneness', 'belief'],
      QuranSurahThemeTag.revelation => const ['revelation', 'quran', 'wahy'],
      QuranSurahThemeTag.guidance => const [
        'guidance',
        'hidayah',
        'straight path',
      ],
      QuranSurahThemeTag.mercy => const ['mercy', 'rahmah', 'compassion'],
      QuranSurahThemeTag.judgment => const [
        'judgment',
        'accountability',
        'reckoning',
      ],
      QuranSurahThemeTag.patience => const [
        'patience',
        'sabr',
        'steadfastness',
      ],
      QuranSurahThemeTag.repentance => const [
        'repentance',
        'tawbah',
        'returning to Allah',
      ],
      QuranSurahThemeTag.prophethood => const [
        'prophets',
        'messengers',
        'nubuwwah',
      ],
      QuranSurahThemeTag.resurrection => const [
        'resurrection',
        'afterlife',
        'rising again',
      ],
      QuranSurahThemeTag.worship => const ['worship', 'ibadah', 'remembrance'],
      QuranSurahThemeTag.law => const ['law', 'halal', 'haram', 'rulings'],
      QuranSurahThemeTag.community => const [
        'community',
        'ummah',
        'social order',
      ],
      QuranSurahThemeTag.gratitude => const [
        'gratitude',
        'shukr',
        'thankfulness',
      ],
      QuranSurahThemeTag.justice => const ['justice', 'fairness', 'trusts'],
      QuranSurahThemeTag.signsOfCreation => const [
        'signs of creation',
        'creation',
        'nature',
      ],
      QuranSurahThemeTag.hypocrisy => const [
        'hypocrisy',
        'nifaq',
        'double-heartedness',
      ],
      QuranSurahThemeTag.charity => const ['charity', 'spending', 'giving'],
      QuranSurahThemeTag.family => const ['family', 'parents', 'marriage'],
      QuranSurahThemeTag.struggle => const [
        'struggle',
        'steadfast struggle',
        'sacrifice',
      ],
      QuranSurahThemeTag.paradiseAndHell => const [
        'paradise',
        'hell',
        'heaven',
      ],
    };
  }
}

class QuranSurahNotableAyah {
  const QuranSurahNotableAyah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.label,
    this.endAyahNumber,
    this.whyItMatters,
    this.evidenceLevel = QuranSurahContentEvidenceLevel.editorialSynthesis,
  });

  final int surahNumber;
  final int ayahNumber;
  final int? endAyahNumber;
  final String label;
  final String? whyItMatters;
  final QuranSurahContentEvidenceLevel evidenceLevel;
}

class QuranSurahNamedReference {
  const QuranSurahNamedReference({
    required this.id,
    required this.label,
    this.evidenceLevel = QuranSurahContentEvidenceLevel.editorialSynthesis,
  });

  final String id;
  final String label;
  final QuranSurahContentEvidenceLevel evidenceLevel;
}

class QuranSurahVirtueNote {
  const QuranSurahVirtueNote({
    required this.title,
    required this.description,
    this.isRecitationNote = false,
    this.evidenceLevel =
        QuranSurahContentEvidenceLevel.devotionalRecitationAssociation,
  });

  final String title;
  final String description;
  final bool isRecitationNote;
  final QuranSurahContentEvidenceLevel evidenceLevel;
}

class QuranSurahReflectionPrompt {
  const QuranSurahReflectionPrompt({
    required this.prompt,
    this.evidenceLevel = QuranSurahContentEvidenceLevel.editorialSynthesis,
  });

  final String prompt;
  final QuranSurahContentEvidenceLevel evidenceLevel;
}

class QuranSurahSummarySeed {
  const QuranSurahSummarySeed({
    required this.surahNumber,
    required this.summary,
    this.keywords = const <String>[],
    this.revelationTypeOverride,
  });

  final int surahNumber;
  final String summary;
  final List<String> keywords;
  final QuranSurahSummaryRevelationType? revelationTypeOverride;
}

class QuranSurahEnrichmentSeed {
  const QuranSurahEnrichmentSeed({
    required this.surahNumber,
    this.themeTags = const <QuranSurahThemeTag>[],
    this.notableAyat = const <QuranSurahNotableAyah>[],
    this.relatedProphets = const <QuranSurahNamedReference>[],
    this.relatedEvents = const <QuranSurahNamedReference>[],
    this.virtues = const <QuranSurahVirtueNote>[],
    this.reflections = const <QuranSurahReflectionPrompt>[],
    this.searchAliases = const <String>[],
    this.detailIntro,
    this.editorialNotes = const <String>[],
    this.summaryEvidenceLevel =
        QuranSurahContentEvidenceLevel.editorialSynthesis,
  });

  final int surahNumber;
  final List<QuranSurahThemeTag> themeTags;
  final List<QuranSurahNotableAyah> notableAyat;
  final List<QuranSurahNamedReference> relatedProphets;
  final List<QuranSurahNamedReference> relatedEvents;
  final List<QuranSurahVirtueNote> virtues;
  final List<QuranSurahReflectionPrompt> reflections;
  final List<String> searchAliases;
  final String? detailIntro;
  final List<String> editorialNotes;
  final QuranSurahContentEvidenceLevel summaryEvidenceLevel;
}

class QuranSurahSummaryEntry {
  const QuranSurahSummaryEntry({
    required this.surah,
    required this.meaning,
    required this.revelationType,
    required this.summary,
    this.keywords = const <String>[],
    this.themeTags = const <QuranSurahThemeTag>[],
    this.notableAyat = const <QuranSurahNotableAyah>[],
    this.relatedProphets = const <QuranSurahNamedReference>[],
    this.relatedEvents = const <QuranSurahNamedReference>[],
    this.virtues = const <QuranSurahVirtueNote>[],
    this.reflections = const <QuranSurahReflectionPrompt>[],
    this.searchAliases = const <String>[],
    this.detailIntro,
    this.editorialNotes = const <String>[],
    this.summaryEvidenceLevel =
        QuranSurahContentEvidenceLevel.editorialSynthesis,
    this.sortIndex = 0,
  });

  final QuranSurah surah;
  final String meaning;
  final QuranSurahSummaryRevelationType revelationType;
  final String summary;
  final List<String> keywords;
  final List<QuranSurahThemeTag> themeTags;
  final List<QuranSurahNotableAyah> notableAyat;
  final List<QuranSurahNamedReference> relatedProphets;
  final List<QuranSurahNamedReference> relatedEvents;
  final List<QuranSurahVirtueNote> virtues;
  final List<QuranSurahReflectionPrompt> reflections;
  final List<String> searchAliases;
  final String? detailIntro;
  final List<String> editorialNotes;
  final QuranSurahContentEvidenceLevel summaryEvidenceLevel;
  final int sortIndex;

  int get surahNumber => surah.number;
  String get arabicName => surah.arabicName;
  String get transliteratedName => surah.transliteratedName;
  String get englishName => surah.englishName;
  int get verseCount => surah.verseCount;

  bool get hasEnrichment =>
      themeTags.isNotEmpty ||
      notableAyat.isNotEmpty ||
      relatedProphets.isNotEmpty ||
      relatedEvents.isNotEmpty ||
      virtues.isNotEmpty ||
      reflections.isNotEmpty ||
      (detailIntro?.trim().isNotEmpty ?? false);

  bool matchesFilter(QuranSurahSummaryFilter filter) {
    switch (filter) {
      case QuranSurahSummaryFilter.all:
        return true;
      case QuranSurahSummaryFilter.makki:
        return revelationType == QuranSurahSummaryRevelationType.makki;
      case QuranSurahSummaryFilter.madani:
        return revelationType == QuranSurahSummaryRevelationType.madani;
    }
  }
}
