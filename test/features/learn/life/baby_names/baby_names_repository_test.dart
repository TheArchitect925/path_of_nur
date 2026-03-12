import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/life/baby_names/application/baby_names_controller.dart';
import 'package:path_of_nur/features/learn/life/baby_names/data/baby_names_repository.dart';
import 'package:path_of_nur/features/learn/life/baby_names/domain/baby_name_models.dart';

BabyNameEntry _entry({
  required String id,
  required String name,
  required String arabic,
  required String meaning,
  List<String> themes = const <String>['faith'],
  List<String> origin = const <String>['Arabic'],
  List<String> categories = const <String>['classic'],
  List<String> variants = const <String>[],
  bool quranic = false,
}) {
  return BabyNameEntry(
    id: id,
    name: name,
    arabic: arabic,
    transliteration: name,
    pronunciation: name,
    gender: BabyNameGender.male,
    meaning: meaning,
    description: null,
    meaningThemes: themes,
    origin: origin,
    isQuranic: quranic,
    quranReferences: const <String>[],
    associatedFigures: const <String>[],
    associatedCategories: categories,
    popularityRegions: const <String>['Global'],
    variants: variants,
    similarNames: const <String>[],
    startsWith: name.substring(0, 1),
    syllables: 2,
    isPopular: false,
    styleTags: const <String>['classic'],
    audioPronunciation: null,
  );
}

void main() {
  group('BabyNamesRepository search scoring', () {
    final repository = BabyNamesRepository();

    test('exact name outranks meaning-only match', () {
      final exact = _entry(
        id: 'yusuf_1',
        name: 'Yusuf',
        arabic: 'يوسف',
        meaning: 'Allah increases',
      );
      final meaningOnly = _entry(
        id: 'other_1',
        name: 'Harith',
        arabic: 'حارث',
        meaning: 'Related to Yusuf in meaning notes',
      );

      final scoreExact = repository.searchScore(exact, 'yusuf');
      final scoreMeaning = repository.searchScore(meaningOnly, 'yusuf');

      expect(scoreExact, greaterThan(scoreMeaning));
    });

    test('variant match contributes score', () {
      final entry = _entry(
        id: 'mariam_1',
        name: 'Maryam',
        arabic: 'مريم',
        meaning: 'Devoted',
        variants: const <String>['Mariam'],
      );

      final score = repository.searchScore(entry, 'mariam');
      expect(score, greaterThan(0));
    });
  });

  group('BabyNamesIndex and related names', () {
    test('related names excludes the current entry', () {
      final a = _entry(
        id: 'noor_1',
        name: 'Noor',
        arabic: 'نور',
        meaning: 'Light',
        themes: const <String>['light', 'guidance'],
      );
      final b = _entry(
        id: 'ziya_1',
        name: 'Ziya',
        arabic: 'ضياء',
        meaning: 'Radiance',
        themes: const <String>['light'],
      );
      final c = _entry(
        id: 'huda_1',
        name: 'Huda',
        arabic: 'هدى',
        meaning: 'Guidance',
        themes: const <String>['guidance'],
      );

      final index = BabyNamesIndex.fromEntries([a, b, c]);
      final repository = BabyNamesRepository();
      final related = repository.relatedNames(a, index);

      expect(related.any((entry) => entry.id == a.id), isFalse);
      expect(related, isNotEmpty);
    });
  });

  group('BabyNamesState serialization', () {
    test('recent searches and favorites round-trip', () {
      const state = BabyNamesState(
        searchQuery: 'noor',
        filters: BabyNameFilters(quranicOnly: true),
        sort: BabyNameSort.alphabeticalAz,
        favorites: <String>{'noor_u_001'},
        recentSearches: <String>['noor'],
        recentlyViewed: <String>['noor_u_001'],
        finderInput: BabyNameFinderInput(
          fatherName: 'Shahab',
          motherName: 'Sadia',
          preferredGender: null,
          meaningThemes: <String>{'light'},
          quranicOnly: false,
          originPreference: null,
        ),
      );

      final restored = BabyNamesState.fromJson(state.toJson());
      expect(restored.searchQuery, 'noor');
      expect(restored.favorites.contains('noor_u_001'), isTrue);
      expect(restored.recentSearches, contains('noor'));
    });
  });
}
