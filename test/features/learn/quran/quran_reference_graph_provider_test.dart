import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_foundation_repository.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reference_graph_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _createContainer() async {
  SharedPreferences.setMockInitialValues(const <String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  test(
    'ayah contextual knowledge links do not invent weak keyword matches',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((2, 8)),
      );

      expect(links, isEmpty);
    },
  );

  test(
    'ayah contextual knowledge links use canonical path detail routes',
    () async {
      final container = await _createContainer();
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
    },
  );

  test(
    'broad default journey fallback is suppressed for non-curated verses',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final bundle = container.read(quranKnowledgeForVerseProvider((2, 83)));

      expect(bundle.journeys, isEmpty);
    },
  );

  test(
    'broad prophet fallback is suppressed for non-prophetic themes',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final bundle = container.read(quranKnowledgeForVerseProvider((67, 2)));

      expect(bundle.prophets, isEmpty);
    },
  );

  test(
    'ayah contextual knowledge links remain capped for reader calmness',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((3, 159)),
      );

      expect(links.length, lessThanOrEqualTo(4));
    },
  );

  test(
    'ayah contextual knowledge links can surface strong learning journey handoffs',
    () async {
      final container = await _createContainer();
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
    () async {
      final container = await _createContainer();
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
    () async {
      final container = await _createContainer();
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

  test(
    'surfaced contextual links always carry credibility classification',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final links = container.read(
        quranContextualKnowledgeLinksForVerseProvider((3, 159)),
      );

      expect(links, isNotEmpty);
      for (final link in links) {
        expect(link.knowledgeType, isA<QuranKnowledgeType>());
        expect(link.connectionStrength, isA<QuranConnectionStrength>());
      }
    },
  );

  test('curated quran themes expose meaningful starter mappings', () async {
    final container = await _createContainer();
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

  test('verse themes only surface curated thematic matches', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    final patienceThemes = container.read(
      quranThemesForVerseProvider((2, 153)),
    );
    final noThemes = container.read(quranThemesForVerseProvider((2, 8)));

    expect(patienceThemes.any((topic) => topic.id == 'patience'), isTrue);
    expect(noThemes, isEmpty);
  });

  test(
    'surah themes expose curated thematic discovery for related surahs',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final topics = container.read(quranThemesForSurahProvider(31));

      expect(topics, isNotEmpty);
      expect(
        topics.any((topic) => topic.id == 'gratitude' || topic.id == 'family'),
        isTrue,
      );
    },
  );

  test(
    'expanded remembrance theme keeps memorization and path handoffs',
    () async {
      final container = await _createContainer();
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
    },
  );

  test(
    'quran graph hadith links resolve through canonical public hadith ids',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final graph = container.read(quranReferenceGraphProvider);
      final publicHadithIds = {
        for (final entry in container.read(hadithEntriesProvider)) entry.id,
      };
      final graphHadithIds = graph.references
          .expand((item) => item.relatedHadithIds)
          .toSet();

      expect(graphHadithIds, isNotEmpty);
      expect(graphHadithIds.difference(publicHadithIds), isEmpty);
    },
  );

  test('quran graph no longer emits legacy hadith curriculum ids', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    const legacyHadithIds = {
      'hardship-sabr-with-purpose',
      'hardship-grief-with-hope',
      'gratitude-seeing-blessings-daily',
      'worship-dhikr-heart-anchor',
      'hardship-tawakkul-with-effort',
      'worship-hidden-deeds',
      'community-reconciling-hearts',
      'speech-say-good-or-silent',
      'char-adab-correction',
      'speech-avoid-backbiting-harm',
      'humility-lowering-ego',
      'community-justice-with-mercy',
      'family-honoring-parents',
      'mercy-care-for-poor',
      'hardship-managing-anger',
      'humility-daily-self-accounting',
      'worship-consistency-small-deeds',
      'worship-intentions-weigh-actions',
      'life-value-of-time',
      'life-remembering-death-balance',
    };

    final graph = container.read(quranReferenceGraphProvider);
    final graphHadithIds = graph.references
        .expand((item) => item.relatedHadithIds)
        .toSet();

    expect(graphHadithIds.intersection(legacyHadithIds), isEmpty);
  });

  test(
    'quran hadith knowledge links keep canonical hadith detail handoff',
    () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final bundle = container.read(quranKnowledgeForVerseProvider((13, 28)));

      expect(bundle.hadithEntries, isNotEmpty);
      for (final link in bundle.hadithEntries) {
        expect(link.routeName, 'hadithLessonDetail');
        expect(link.pathParameters['lessonId'], link.id);
        expect(link.pathParameters['lessonId'], isNotEmpty);
      }
    },
  );
}
