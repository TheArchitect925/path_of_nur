import '../domain/quran_surah_summary_models.dart';
import 'quran_surah_enrichment_seed_data_1_38.dart';
import 'quran_surah_enrichment_seed_data_39_76.dart';
import 'quran_surah_enrichment_seed_data_77_114.dart';

const List<QuranSurahEnrichmentSeed> seededQuranSurahEnrichments =
    <QuranSurahEnrichmentSeed>[
      ...seededQuranSurahEnrichments1To38,
      ...seededQuranSurahEnrichments39To76,
      ...seededQuranSurahEnrichments77To114,
    ];
