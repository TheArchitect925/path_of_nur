import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reference_graph_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';

void main() {
  test(
    'ayah contextual knowledge links do not invent weak keyword matches',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((2, 8)),
      );

      expect(links, isEmpty);
    },
  );

  test('ayah contextual knowledge links use canonical path detail routes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final links = container.read(
      quranContextualKnowledgeLinksForVerseProvider((3, 159)),
    );

    expect(
      links.any(
        (link) =>
            link.routeName == 'quranAyahInsightsPathDetail' &&
            link.pathParameters['pathId']?.isNotEmpty == true,
      ),
      isTrue,
    );
  });

  test(
    'broad default journey fallback is suppressed for non-curated verses',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bundle = container.read(quranKnowledgeForVerseProvider((2, 83)));

      expect(bundle.journeys, isEmpty);
    },
  );

  test('broad prophet fallback is suppressed for non-prophetic themes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final bundle = container.read(quranKnowledgeForVerseProvider((67, 2)));

    expect(bundle.prophets, isEmpty);
  });

  test('ayah contextual knowledge links remain capped for reader calmness', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final links = container.read(
      quranContextualKnowledgeLinksForVerseProvider((3, 159)),
    );

    expect(links.length, lessThanOrEqualTo(4));
  });

  test(
    'ayah contextual knowledge links can surface strong learning journey handoffs',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((13, 28)),
      );

      expect(
        links.any(
          (link) =>
              link.category == QuranRelatedKnowledgeCategory.learningJourney &&
              link.routeName == 'learnJourneyStage' &&
              link.pathParameters['stageId'] == 'dhikr-what-is',
        ),
        isTrue,
      );
    },
  );

  test(
    'ayah contextual knowledge links can hand patience ayahs into the character journey',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((2, 153)),
      );

      expect(
        links.any(
          (link) =>
              link.category == QuranRelatedKnowledgeCategory.learningJourney &&
              link.pathParameters['stageId'] == 'character-sabr',
        ),
        isTrue,
      );
    },
  );

  test(
    'learning journey handoffs expose journey knowledge type with strong credibility when curated',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((13, 28)),
      );
      final journeyLink = links.firstWhere(
        (link) =>
            link.category == QuranRelatedKnowledgeCategory.learningJourney,
      );

      expect(journeyLink.knowledgeType, QuranKnowledgeType.journey);
      expect(journeyLink.connectionStrength, QuranConnectionStrength.strong);
    },
  );

  test('surfaced contextual links always carry credibility classification', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final links = container.read(
      quranContextualKnowledgeLinksForVerseProvider((3, 159)),
    );

    expect(links, isNotEmpty);
    for (final link in links) {
      expect(link.knowledgeType, isA<QuranKnowledgeType>());
      expect(link.connectionStrength, isA<QuranConnectionStrength>());
    }
  });

  test('curated quran themes expose meaningful starter mappings', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final topics = container.read(quranTopicsProvider);
    final patience = topics.firstWhere((topic) => topic.id == 'patience');
    final sincerity = topics.firstWhere((topic) => topic.id == 'sincerity');

    expect(patience.verseReferences.length, greaterThanOrEqualTo(5));
    expect(patience.relatedRoutes, isNotEmpty);
    expect(patience.searchKeywords, contains('sabr'));
    expect(patience.suggestedPathId, 'memorization-support');
    expect(sincerity.verseReferences.length, greaterThanOrEqualTo(3));
    expect(sincerity.relatedRoutes, isNotEmpty);
  });

  test('verse themes only surface curated thematic matches', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final patienceThemes = container.read(
      quranThemesForVerseProvider((2, 153)),
    );
    final noThemes = container.read(quranThemesForVerseProvider((2, 8)));

    expect(patienceThemes.any((topic) => topic.id == 'patience'), isTrue);
    expect(noThemes, isEmpty);
  });

  test('surah themes expose curated thematic discovery for related surahs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final topics = container.read(quranThemesForSurahProvider(31));

    expect(topics, isNotEmpty);
    expect(
      topics.any((topic) => topic.id == 'gratitude' || topic.id == 'family'),
      isTrue,
    );
  });

  test('expanded remembrance theme keeps memorization and path handoffs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final remembrance = container
        .read(quranTopicsProvider)
        .firstWhere((topic) => topic.id == 'remembrance');

    expect(remembrance.verseReferences.length, greaterThanOrEqualTo(4));
    expect(remembrance.suggestedPathId, 'reflection-journey');
    expect(
      remembrance.relatedRoutes.any(
        (route) => route.routeName == 'quranMemorizationReview',
      ),
      isTrue,
    );
  });
}
