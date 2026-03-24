import '../domain/quran_short_surah_readiness_models.dart';

const quranShortSurahReadinessSeeds = <QuranShortSurahReadinessSeed>[
  QuranShortSurahReadinessSeed(
    id: 'short_surah_ikhlas',
    order: 1,
    stage: QuranShortSurahReadinessStage.firstCompleteSurah,
    surahNumber: 112,
  ),
  QuranShortSurahReadinessSeed(
    id: 'short_surah_kawthar',
    order: 2,
    stage: QuranShortSurahReadinessStage.gentleExpansion,
    surahNumber: 108,
  ),
  QuranShortSurahReadinessSeed(
    id: 'short_surah_falaq',
    order: 3,
    stage: QuranShortSurahReadinessStage.protectionPair,
    surahNumber: 113,
  ),
  QuranShortSurahReadinessSeed(
    id: 'short_surah_nas',
    order: 4,
    stage: QuranShortSurahReadinessStage.protectionPair,
    surahNumber: 114,
  ),
];
