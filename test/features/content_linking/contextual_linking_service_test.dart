import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/content_linking/application/contextual_linking_service.dart';
import 'package:path_of_nur/features/content_linking/domain/contextual_linking_models.dart';

void main() {
  const service = ContextualLinkingService();

  ContextualLinkNode node({
    required String id,
    required ContextualContentType type,
    String title = 'Title',
    List<String> tags = const <String>[],
    List<String> categories = const <String>[],
    List<String> entities = const <String>[],
    String routeName = 'route',
    Map<String, String> pathParameters = const <String, String>{},
  }) {
    return ContextualLinkNode(
      id: id,
      uniqueKey: '$routeName|$pathParameters',
      type: type,
      title: title,
      subtitle: '',
      summary: '',
      tags: tags,
      categories: categories,
      entities: entities,
      routeName: routeName,
      pathParameters: pathParameters,
    );
  }

  test('shared tags outrank category-only matches', () {
    final current = node(
      id: 'event:badr',
      type: ContextualContentType.historicalEvent,
      tags: const ['badr', 'ramadan'],
      categories: const ['seerah', 'battles'],
      entities: const ['prophet muhammad ﷺ'],
    );
    final tagMatch = node(
      id: 'hadith:patience',
      type: ContextualContentType.hadith,
      tags: const ['ramadan'],
      categories: const ['hadith'],
      routeName: 'hadithLessonDetail',
      pathParameters: const {'lessonId': 'hadith:patience'},
    );
    final categoryOnly = node(
      id: 'event:uhud',
      type: ContextualContentType.historicalEvent,
      tags: const ['uhud'],
      categories: const ['battles'],
      routeName: 'learnHistoricalEventDetail',
      pathParameters: const {'slug': 'uhud'},
    );

    final results = service.findRelated(
      current: current,
      candidates: [categoryOnly, tagMatch],
    );

    expect(results.map((item) => item.node.id).toList(), [
      'hadith:patience',
      'event:uhud',
    ]);
  });

  test('manual overrides are always included', () {
    final current = node(
      id: 'event:hijrah',
      type: ContextualContentType.historicalEvent,
      tags: const ['migration'],
      categories: const ['seerah'],
    );
    final manual = node(
      id: 'learn:madinah-charter',
      type: ContextualContentType.learnContent,
      routeName: 'lifeLessonDetail',
      pathParameters: const {'lessonId': 'madinah-charter'},
    );

    final results = service.findRelated(
      current: current,
      candidates: [manual],
      manualIncludeIds: const ['learn:madinah-charter'],
    );

    expect(results, hasLength(1));
    expect(results.single.node.id, 'learn:madinah-charter');
    expect(results.single.isManualOverride, isTrue);
  });

  test('journey nodes can be linked as related content', () {
    final current = node(
      id: 'event:first-revelation',
      type: ContextualContentType.historicalEvent,
      tags: const ['revelation', 'quran', 'hira'],
      categories: const ['revelation', 'seerah'],
    );
    final journey = node(
      id: 'journey-quran',
      type: ContextualContentType.journey,
      tags: const ['quran', 'guidance', 'revelation'],
      categories: const ['core-knowledge', 'journey'],
      routeName: 'learnJourneyDetail',
      pathParameters: const {'journeyId': 'journey-quran'},
    );

    final results = service.findRelated(
      current: current,
      candidates: [journey],
      manualIncludeIds: const ['journey-quran'],
    );

    expect(results, hasLength(1));
    expect(results.single.node.type, ContextualContentType.journey);
    expect(results.single.node.routeName, 'learnJourneyDetail');
  });

  test('same route is deduplicated and the stronger node wins', () {
    final current = node(
      id: 'event:first-revelation',
      type: ContextualContentType.historicalEvent,
      tags: const ['revelation'],
      categories: const ['revelation'],
    );
    final genericLearn = node(
      id: 'learn:hadith-1',
      type: ContextualContentType.learnContent,
      tags: const ['revelation'],
      routeName: 'hadithLessonDetail',
      pathParameters: const {'lessonId': 'hadith-1'},
    );
    final directHadith = node(
      id: 'hadith-1',
      type: ContextualContentType.hadith,
      tags: const ['revelation'],
      routeName: 'hadithLessonDetail',
      pathParameters: const {'lessonId': 'hadith-1'},
    );

    final results = service.findRelated(
      current: current,
      candidates: [genericLearn, directHadith],
    );

    expect(results, hasLength(1));
    expect(results.single.node.id, 'hadith-1');
    expect(results.single.node.type, ContextualContentType.hadith);
  });

  test('current item is excluded from results', () {
    final current = node(
      id: 'event:badr',
      type: ContextualContentType.historicalEvent,
      tags: const ['badr'],
      routeName: 'learnHistoricalEventDetail',
      pathParameters: const {'slug': 'battle-of-badr'},
    );

    final results = service.findRelated(
      current: current,
      candidates: [current],
    );

    expect(results, isEmpty);
  });
}
