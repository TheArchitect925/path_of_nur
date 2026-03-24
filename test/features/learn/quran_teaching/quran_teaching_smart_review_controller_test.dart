import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_smart_review_controller.dart';
import 'package:path_of_nur/features/learn/quran_teaching/domain/quran_teaching_review_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('practice recommendations stay typed and data-driven', () async {
    final state = QuranTeachingSmartReviewState(
      records: <String, QuranTeachingReviewRecord>{
        'word_due': QuranTeachingReviewRecord(
          id: 'word_due',
          lessonId: 'alphabet_letters_1',
          moduleId: 'foundations',
          contentType: QuranTeachingReviewContentType.shortWord,
          prompt: 'Review word',
          tags: const <String>['word_recognition'],
          memoryState: QuranTeachingMemoryState.practicing,
          nextDueAt: DateTime(2026, 3, 20),
        ),
        'phrase_due': QuranTeachingReviewRecord(
          id: 'phrase_due',
          lessonId: 'phrase_reading_1',
          moduleId: 'phrase_reading',
          contentType: QuranTeachingReviewContentType.phrase,
          prompt: 'Review phrase',
          tags: const <String>['phrase_reading'],
          memoryState: QuranTeachingMemoryState.practicing,
          nextDueAt: DateTime(2026, 3, 20),
        ),
      },
      weakAreas: <String, QuranTeachingWeakArea>{
        'harakat': QuranTeachingWeakArea(
          tag: 'harakat',
          failureCount: 3,
          successCount: 1,
          reviewCount: 4,
          lastSeenAt: DateTime(2026, 3, 23),
        ),
      },
    );

    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.quran.teaching.smart_review.v1': jsonEncode(state.toJson()),
      },
    );
    addTearDown(container.dispose);

    final recommendations = container.read(
      quranTeachingPracticeRecommendationsProvider,
    );

    expect(recommendations, hasLength(3));
    expect(
      recommendations.first.type,
      QuranTeachingPracticeRecommendationType.weakArea,
    );
    expect(recommendations.first.tag, 'harakat');
    expect(
      recommendations[1].type,
      QuranTeachingPracticeRecommendationType.dueWords,
    );
    expect(recommendations[1].count, 1);
    expect(
      recommendations[2].type,
      QuranTeachingPracticeRecommendationType.duePhrases,
    );
    expect(recommendations[2].count, 1);
  });
}
