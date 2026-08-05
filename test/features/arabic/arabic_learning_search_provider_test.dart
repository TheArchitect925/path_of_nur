import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_search_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_search_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids search finds letters and locked beginner words safely', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final results = container.read(
      arabicLearningSearchResultsProvider(
        ArabicLearningSearchQuery(
          audience: ArabicLearningAudience.kids,
          query: 'ba',
        ),
      ),
    );

    final letter = results.firstWhere(
      (item) =>
          item.type == ArabicLearningSearchItemType.letter &&
          item.id == 'kids_letter_ba',
    );
    final word = results.firstWhere(
      (item) =>
          item.type == ArabicLearningSearchItemType.word &&
          item.id == 'kids_word_bab',
    );

    expect(letter.target.routeName, 'kidsArabicLesson');
    expect(letter.target.pathParameters['letterId'], 'ba');
    expect(word.target.routeName, 'kidsArabicWordLesson');
    expect(word.target.pathParameters['wordId'], 'bab');
    expect(word.isAvailable, isFalse);
  });

  test(
    'kids continue filter falls back to the first calm start target',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final results = container.read(
        arabicLearningSearchResultsProvider(
          ArabicLearningSearchQuery(
            audience: ArabicLearningAudience.kids,
            query: '',
            filters: const <ArabicLearningSearchFilter>{
              ArabicLearningSearchFilter.continueFlow,
            },
          ),
        ),
      );

      expect(results, isNotEmpty);
      expect(results.first.type, ArabicLearningSearchItemType.continueTarget);
      expect(results.first.target.routeName, 'kidsArabicLesson');
    },
  );

  test(
    'kids packs filter returns lesson-pack results through existing routes',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final results = container.read(
        arabicLearningSearchResultsProvider(
          ArabicLearningSearchQuery(
            audience: ArabicLearningAudience.kids,
            query: 'beginner',
            filters: const <ArabicLearningSearchFilter>{
              ArabicLearningSearchFilter.packs,
            },
          ),
        ),
      );

      expect(results, isNotEmpty);
      expect(results.first.type, ArabicLearningSearchItemType.lessonPack);
      expect(results.first.target.routeName, 'kidsArabicLesson');
    },
  );

  test(
    'adult search routes letters and words to adult-specific targets',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final letterResults = container.read(
        arabicLearningSearchResultsProvider(
          ArabicLearningSearchQuery(
            audience: ArabicLearningAudience.adult,
            query: 'ب',
            filters: const <ArabicLearningSearchFilter>{
              ArabicLearningSearchFilter.letters,
            },
          ),
        ),
      );
      final wordResults = container.read(
        arabicLearningSearchResultsProvider(
          ArabicLearningSearchQuery(
            audience: ArabicLearningAudience.adult,
            query: 'rabb',
            filters: const <ArabicLearningSearchFilter>{
              ArabicLearningSearchFilter.words,
            },
          ),
        ),
      );

      expect(letterResults, isNotEmpty);
      expect(
        letterResults.first.target.kind,
        ArabicLearningRouteTargetKind.adultLesson,
      );
      expect(letterResults.first.target.canonicalItemId, 'ba');

      final word = wordResults.firstWhere(
        (item) => item.type == ArabicLearningSearchItemType.word,
      );
      expect(
        word.target.kind,
        ArabicLearningRouteTargetKind.adultBeginnerWords,
      );
      expect(word.target.wordId, 'rabb');
    },
  );

  test('adult bridge filter returns Qur’an-readiness results only', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final results = container.read(
      arabicLearningSearchResultsProvider(
        ArabicLearningSearchQuery(
          audience: ArabicLearningAudience.adult,
          query: '',
          filters: const <ArabicLearningSearchFilter>{
            ArabicLearningSearchFilter.quranBridge,
          },
        ),
      ),
    );

    expect(results, isNotEmpty);
    expect(
      results.every(
        (item) => item.type == ArabicLearningSearchItemType.quranBridgeSnippet,
      ),
      isTrue,
    );
    expect(results.first.target.routeName, 'quranArabicReadiness');
  });

  test(
    'adult packs filter returns module-backed lesson packs safely',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final results = container.read(
        arabicLearningSearchResultsProvider(
          ArabicLearningSearchQuery(
            audience: ArabicLearningAudience.adult,
            query: 'tajweed',
            filters: const <ArabicLearningSearchFilter>{
              ArabicLearningSearchFilter.packs,
            },
          ),
        ),
      );

      expect(results, isNotEmpty);
      final pack = results.firstWhere(
        (item) => item.type == ArabicLearningSearchItemType.lessonPack,
      );
      expect(pack.target.kind, ArabicLearningRouteTargetKind.adultModule);
      expect(pack.target.moduleId, 'tajweed_basics');
    },
  );

  test('search returns no results for unmatched queries', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final results = container.read(
      arabicLearningSearchResultsProvider(
        ArabicLearningSearchQuery(
          audience: ArabicLearningAudience.adult,
          query: 'zzzz-not-found',
        ),
      ),
    );

    expect(results, isEmpty);
  });
}
