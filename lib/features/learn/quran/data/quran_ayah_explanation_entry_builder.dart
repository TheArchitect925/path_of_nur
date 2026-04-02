import '../domain/quran_ayah_explanation_models.dart';

const List<QuranAyahExplanationSourceRef>
trustedTafsirSources = <QuranAyahExplanationSourceRef>[
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir al-Tabari',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir Ibn Kathir',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir al-Sa‘di',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.simplifiedSummary,
    title: 'Path of Nur editorial simplification',
    note:
        'Paraphrased beginner-friendly summary grounded in reviewed tafsir meaning.',
    group: 'path_of_nur_editorial',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.kidsSimplification,
    title: 'Path of Nur kids simplification',
    note:
        'Child-friendly wording derived from the same reviewed tafsir meaning.',
    group: 'path_of_nur_editorial',
  ),
];

QuranAyahExplanationEntry buildQuranAyahExplanationEntry({
  required int surahNumber,
  required int ayahNumber,
  required String simpleSummary,
  required String standardExplanation,
  String? deepExplanation,
  String? kidsExplanation,
  List<String> keyLessons = const <String>[],
  String? reflectionPrompt,
  List<QuranAyahExplanationSourceRef> sourceRefs = trustedTafsirSources,
  QuranAyahExplanationRolloutPack rolloutPack =
      QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
  QuranAyahExplanationReviewStatus reviewStatus =
      QuranAyahExplanationReviewStatus.reviewed,
  QuranAyahExplanationLocalizedContent localizedContent =
      const QuranAyahExplanationLocalizedContent(),
}) {
  return QuranAyahExplanationEntry(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    simpleSummary: simpleSummary,
    standardExplanation: standardExplanation,
    deepExplanation: deepExplanation,
    kidsExplanation: kidsExplanation,
    keyLessons: keyLessons,
    reflectionPrompt: reflectionPrompt,
    sourceRefs: sourceRefs,
    rolloutPack: rolloutPack,
    reviewStatus: reviewStatus,
    localizedContent: localizedContent,
  );
}
