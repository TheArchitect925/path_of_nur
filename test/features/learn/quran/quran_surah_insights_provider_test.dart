import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_surah_insights_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah_enrichment_models.dart';

void main() {
  test('surah insights browse exposes curated starter surahs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final insights = container.read(quranSurahInsightsBrowseProvider);

    expect(insights.length, 5);
    expect(insights.any((insight) => insight.surah.number == 2), isTrue);
    expect(insights.any((insight) => insight.surah.number == 3), isTrue);
    expect(insights.any((insight) => insight.surah.number == 20), isTrue);
    expect(insights.any((insight) => insight.surah.number == 25), isTrue);
    expect(insights.any((insight) => insight.surah.number == 31), isTrue);
  });

  test('al imran surah insight resolves multiple strong clusters', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final insight = container.read(quranSurahInsightProvider(3));

    expect(insight, isNotNull);
    expect(insight!.clusters.length, greaterThanOrEqualTo(2));
    expect(
      insight.clusters.any(
        (cluster) =>
            cluster.domain == QuranAyahEnrichmentDomain.tawhidBelief &&
            cluster.entries.any(
              (entry) => entry.id == 'belief_signs_3_190_191',
            ),
      ),
      isTrue,
    );
    expect(
      insight.clusters.any(
        (cluster) =>
            cluster.domain == QuranAyahEnrichmentDomain.characterAdab &&
            cluster.entries.any((entry) => entry.id == 'character_mercy_3_159'),
      ),
      isTrue,
    );
  });

  test(
    'surah insight metadata carries study structure and related learning',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final insight = container.read(quranSurahInsightProvider(2));

      expect(insight, isNotNull);
      expect(insight!.definition.significanceId, 'al_baqarah');
      expect(
        insight.definition.studyPromptIds,
        containsAll(<String>[
          'al_baqarah_worship_and_help',
          'al_baqarah_dua_and_response',
        ]),
      );
      expect(insight.definition.relatedTopicIds, contains('prayer'));
      expect(insight.definition.relatedRoutes, isNotEmpty);
      expect(
        insight.definition.relatedRoutes.any(
          (route) => route.routeName == 'quranTopicDetail',
        ),
        isTrue,
      );
    },
  );
}
