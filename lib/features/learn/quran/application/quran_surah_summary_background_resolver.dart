import '../data/quran_surah_summary_background_registry.dart';
import '../domain/quran_surah_summary_background_spec.dart';

QuranSurahSummaryBackgroundSpec? resolveQuranSurahSummaryBackgroundSpec(
  int surahNumber,
) => kQuranSurahSummaryBackgroundSpecs[surahNumber];

String? resolveQuranSurahSummaryBackgroundAsset(int surahNumber) {
  final spec = resolveQuranSurahSummaryBackgroundSpec(surahNumber);
  if (spec == null) {
    return null;
  }
  if (!kQuranSurahSummaryBackgroundReadyNumbers.contains(surahNumber)) {
    return null;
  }
  return spec.assetPath;
}

bool hasQuranSurahSummaryBackgroundAsset(int surahNumber) =>
    resolveQuranSurahSummaryBackgroundAsset(surahNumber) != null;
