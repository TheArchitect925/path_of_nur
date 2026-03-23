import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_transliteration_repository.dart';
import 'package:quran/quran.dart' as q;

import '../../../test_helpers/app_test_harness.dart';

class _FakeQuranTransliterationRepository
    extends QuranTransliterationRepository {
  _FakeQuranTransliterationRepository(this._rowsBySurah);

  final Map<int, List<String>> _rowsBySurah;

  @override
  Future<List<String>> getSurahTransliteration(int surahNumber) async {
    final expectedCount = q.getVerseCount(surahNumber);
    final rows = _rowsBySurah[surahNumber];
    if (rows == null) {
      return List<String>.filled(expectedCount, '', growable: false);
    }
    if (rows.length >= expectedCount) {
      return rows.take(expectedCount).toList(growable: false);
    }
    return <String>[
      ...rows,
      ...List<String>.filled(expectedCount - rows.length, '', growable: false),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> makeContainer({
    QuranTransliterationRepository? transliterationRepository,
  }) {
    return makeTestContainer(
      overrides: <Override>[
        quranTransliterationRepositoryProvider.overrideWithValue(
          transliterationRepository ??
              _FakeQuranTransliterationRepository(const <int, List<String>>{}),
        ),
      ],
    );
  }

  test('quran search matches surah names and ayah translation text', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    container.read(quranSearchQueryProvider.notifier).state = 'opening';
    var results = await container.read(quranSearchResultsProvider.future);
    expect(
      results.any((result) => result.ayah == null && result.surah.number == 1),
      isTrue,
    );

    container.read(quranSearchQueryProvider.notifier).state = 'recompense';
    container.invalidate(quranSearchResultsProvider);
    results = await container.read(quranSearchResultsProvider.future);
    expect(
      results.any(
        (result) =>
            result.ayah?.surahNumber == 1 && result.ayah?.ayahNumber == 4,
      ),
      isTrue,
    );
  });

  test('quran search matches ayah arabic text', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    container.read(quranSearchQueryProvider.notifier).state = 'الحمد';
    final results = await container.read(quranSearchResultsProvider.future);

    expect(
      results.any(
        (result) =>
            result.ayah?.surahNumber == 1 && result.ayah?.ayahNumber == 2,
      ),
      isTrue,
    );
  });

  test(
    'quran search matches transliteration text through repository data',
    () async {
      final transliterationRepository = _FakeQuranTransliterationRepository({
        1: const <String>[
          'bismillahi ar-rahmani ar-rahim',
          'alhamdu lillahi rabbil alamin',
          'ar-rahmani ar-rahim',
          'maliki yawmi ad-din',
          'iyyaka naabudu wa iyyaka nastaeen',
          'ihdinas-siratal-mustaqeem',
          'siratal-ladhina anamta alayhim ghayril-maghdubi alayhim walad-dalleen',
        ],
      });
      final container = await makeContainer(
        transliterationRepository: transliterationRepository,
      );
      addTearDown(container.dispose);

      container.read(quranSearchQueryProvider.notifier).state = 'naabudu';
      final results = await container.read(quranSearchResultsProvider.future);

      expect(
        results.any(
          (result) =>
              result.ayah?.surahNumber == 1 &&
              result.ayah?.ayahNumber == 5 &&
              result.ayah?.transliteration?.contains('naabudu') == true,
        ),
        isTrue,
      );
    },
  );
}
