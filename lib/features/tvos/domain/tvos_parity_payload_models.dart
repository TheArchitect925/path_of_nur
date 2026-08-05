import '../../learn/quran/application/quran_providers.dart';
import '../../learn/quran/domain/quran_daily_verse.dart';
import '../../learn/quran/domain/quran_surah.dart';
import '../../../shared/application/app_summary_providers.dart';

enum TVOSMirroredSectionId {
  homePrayerSummary,
  homeContinueReading,
  homeDailyVerse,
  quranContinueReading,
  quranDailyVerse,
  quranBrowse,
  quranPlayback,
}

class TVOSMirroredSectionManifest {
  const TVOSMirroredSectionManifest({
    required this.id,
    required this.routePath,
    required this.contentKey,
    required this.phaseSummary,
  });

  final TVOSMirroredSectionId id;
  final String routePath;
  final String contentKey;
  final String phaseSummary;
}

class TVOSPrayerSummaryParityPayload {
  const TVOSPrayerSummaryParityPayload({
    required this.completed,
    required this.total,
    required this.progress,
  });

  factory TVOSPrayerSummaryParityPayload.fromWorshipSummary(
    WorshipSummary summary,
  ) {
    return TVOSPrayerSummaryParityPayload(
      completed: summary.prayerCompleted,
      total: summary.prayerTotal,
      progress: summary.prayerProgress,
    );
  }

  final int completed;
  final int total;
  final double progress;

  Map<String, Object> toJson() => {
    'completed': completed,
    'total': total,
    'progress': progress,
  };
}

class TVOSContinueReadingParityPayload {
  const TVOSContinueReadingParityPayload({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.locationLabel,
  });

  factory TVOSContinueReadingParityPayload.fromSummary(
    QuranContinueReadingSummary summary,
  ) {
    return TVOSContinueReadingParityPayload(
      surahNumber: summary.surahNumber,
      surahName: summary.surahName,
      ayahNumber: summary.ayahNumber,
      locationLabel: summary.locationLabel,
    );
  }

  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String locationLabel;

  Map<String, Object> toJson() => {
    'surahNumber': surahNumber,
    'surahName': surahName,
    'ayahNumber': ayahNumber,
    'locationLabel': locationLabel,
  };
}

class TVOSDailyVerseParityPayload {
  const TVOSDailyVerseParityPayload({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.locationLabel,
  });

  factory TVOSDailyVerseParityPayload.fromDailyVerse(QuranDailyVerse verse) {
    return TVOSDailyVerseParityPayload(
      surahNumber: verse.surahNumber,
      ayahNumber: verse.ayahNumber,
      arabic: verse.arabic,
      translation: verse.translation,
      transliteration: verse.transliteration,
      locationLabel: verse.locationLabel,
    );
  }

  final int surahNumber;
  final int ayahNumber;
  final String arabic;
  final String translation;
  final String transliteration;
  final String locationLabel;

  Map<String, Object> toJson() => {
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'arabic': arabic,
    'translation': translation,
    'transliteration': transliteration,
    'locationLabel': locationLabel,
  };
}

class TVOSBrowseSurahParityPayload {
  const TVOSBrowseSurahParityPayload({
    required this.number,
    required this.arabicName,
    required this.transliteratedName,
    required this.englishName,
    required this.verseCount,
    required this.revelationPlace,
  });

  factory TVOSBrowseSurahParityPayload.fromSurah(QuranSurah surah) {
    return TVOSBrowseSurahParityPayload(
      number: surah.number,
      arabicName: surah.arabicName,
      transliteratedName: surah.transliteratedName,
      englishName: surah.englishName,
      verseCount: surah.verseCount,
      revelationPlace: surah.revelationPlace,
    );
  }

  final int number;
  final String arabicName;
  final String transliteratedName;
  final String englishName;
  final int verseCount;
  final String revelationPlace;

  Map<String, Object> toJson() => {
    'number': number,
    'arabicName': arabicName,
    'transliteratedName': transliteratedName,
    'englishName': englishName,
    'verseCount': verseCount,
    'revelationPlace': revelationPlace,
  };
}

class TVOSPlaybackParityPayload {
  const TVOSPlaybackParityPayload({
    required this.audioEnabled,
    required this.hasActiveSession,
    required this.resumeSurahNumber,
    required this.resumeAyahNumber,
    required this.resumeSurahName,
    required this.positionSeconds,
  });

  final bool audioEnabled;
  final bool hasActiveSession;
  final int resumeSurahNumber;
  final int resumeAyahNumber;
  final String resumeSurahName;
  final int positionSeconds;

  Map<String, Object> toJson() => {
    'audioEnabled': audioEnabled,
    'hasActiveSession': hasActiveSession,
    'resumeSurahNumber': resumeSurahNumber,
    'resumeAyahNumber': resumeAyahNumber,
    'resumeSurahName': resumeSurahName,
    'positionSeconds': positionSeconds,
  };
}

class TVOSHomeParityPayload {
  const TVOSHomeParityPayload({
    required this.routePath,
    required this.prayerSummary,
    required this.continueReading,
    required this.dailyVerse,
    required this.mirroredSections,
  });

  final String routePath;
  final TVOSPrayerSummaryParityPayload prayerSummary;
  final TVOSContinueReadingParityPayload continueReading;
  final TVOSDailyVerseParityPayload dailyVerse;
  final List<TVOSMirroredSectionId> mirroredSections;

  Map<String, Object> toJson() => {
    'routePath': routePath,
    'prayerSummary': prayerSummary.toJson(),
    'continueReading': continueReading.toJson(),
    'dailyVerse': dailyVerse.toJson(),
    'mirroredSections': mirroredSections
        .map((section) => section.name)
        .toList(growable: false),
  };
}

class TVOSQuranParityPayload {
  const TVOSQuranParityPayload({
    required this.routePath,
    required this.continueReading,
    required this.dailyVerse,
    required this.browseSurahs,
    required this.playback,
    required this.mirroredSections,
  });

  final String routePath;
  final TVOSContinueReadingParityPayload continueReading;
  final TVOSDailyVerseParityPayload dailyVerse;
  final List<TVOSBrowseSurahParityPayload> browseSurahs;
  final TVOSPlaybackParityPayload playback;
  final List<TVOSMirroredSectionId> mirroredSections;

  Map<String, Object> toJson() => {
    'routePath': routePath,
    'continueReading': continueReading.toJson(),
    'dailyVerse': dailyVerse.toJson(),
    'browseSurahs': browseSurahs.map((surah) => surah.toJson()).toList(),
    'playback': playback.toJson(),
    'mirroredSections': mirroredSections
        .map((section) => section.name)
        .toList(growable: false),
  };
}

class TVOSParityPayloadBundle {
  const TVOSParityPayloadBundle({
    required this.generatedAtIso,
    required this.home,
    required this.quran,
  });

  final String generatedAtIso;
  final TVOSHomeParityPayload home;
  final TVOSQuranParityPayload quran;

  Map<String, Object> toJson() => {
    'generatedAtIso': generatedAtIso,
    'home': home.toJson(),
    'quran': quran.toJson(),
  };
}
