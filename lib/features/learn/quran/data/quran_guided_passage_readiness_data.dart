import '../domain/quran_content_refs.dart';
import '../domain/quran_guided_passage_readiness_models.dart';

const quranGuidedPassageReadinessSeeds = <QuranGuidedPassageReadinessSeed>[
  QuranGuidedPassageReadinessSeed(
    id: 'fatihah_opening_passage',
    order: 1,
    stage: QuranGuidedPassageReadinessStage.familiarOpening,
    ref: QuranQuoteRef(surah: 1, ayah: 1, ayahEnd: 4),
  ),
  QuranGuidedPassageReadinessSeed(
    id: 'fatihah_response_passage',
    order: 2,
    stage: QuranGuidedPassageReadinessStage.completingFatihah,
    ref: QuranQuoteRef(surah: 1, ayah: 5, ayahEnd: 7),
  ),
  QuranGuidedPassageReadinessSeed(
    id: 'fatihah_full_passage',
    order: 3,
    stage: QuranGuidedPassageReadinessStage.fullSurahConfidence,
    ref: QuranQuoteRef(surah: 1, ayah: 1, ayahEnd: 7),
  ),
];
