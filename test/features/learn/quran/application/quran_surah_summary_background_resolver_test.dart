import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_surah_summary_background_resolver.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_surah_summary_background_registry.dart';

void main() {
  group('quran surah summary background resolver', () {
    test('returns structured specs for the Top 10 rollout', () {
      final fatiha = resolveQuranSurahSummaryBackgroundSpec(1);
      final yunus = resolveQuranSurahSummaryBackgroundSpec(10);

      expect(fatiha, isNotNull);
      expect(fatiha!.assetPath, endsWith('001.webp'));
      expect(fatiha.themeTitle, 'Opening Light');

      expect(yunus, isNotNull);
      expect(yunus!.assetPath, endsWith('010.webp'));
      expect(yunus.themeTitle, 'Calm Return');
    });

    test('returns null specs for surahs outside the current rollout', () {
      expect(resolveQuranSurahSummaryBackgroundSpec(11), isNull);
    });

    test('returns null assets until binaries are added to the ready set', () {
      expect(kQuranSurahSummaryBackgroundReadyNumbers, isEmpty);
      expect(resolveQuranSurahSummaryBackgroundAsset(1), isNull);
      expect(resolveQuranSurahSummaryBackgroundAsset(11), isNull);
      expect(hasQuranSurahSummaryBackgroundAsset(1), isFalse);
    });
  });
}
