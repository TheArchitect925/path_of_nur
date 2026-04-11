import 'package:quran/quran.dart' as q;

import 'quran_transliteration_local_data.dart';

class QuranTransliterationRepository {
  QuranTransliterationRepository();

  final Map<int, List<String>> _memoryCache = {};

  Future<List<String>> getSurahTransliteration(int surahNumber) async {
    final expectedCount = q.getVerseCount(surahNumber);
    final memory = _memoryCache[surahNumber];
    if (memory != null && memory.length == expectedCount) {
      return memory;
    }
    final bundledRows = quranTransliterationLocalData[surahNumber];
    if (bundledRows != null && bundledRows.length == expectedCount) {
      _memoryCache[surahNumber] = bundledRows;
      return bundledRows;
    }
    return List<String>.filled(expectedCount, '', growable: false);
  }
}
