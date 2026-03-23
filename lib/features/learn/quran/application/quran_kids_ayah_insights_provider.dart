import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/quran_ayah_enrichment_models.dart';
import 'quran_ayah_enrichment_provider.dart';

enum KidsQuranAyahInsightCategory {
  signsInCreation,
  prayerAndRemembrance,
  gratitudeAndTrust,
  kindnessAndGoodManners,
  prophetLessons,
}

class KidsQuranAyahInsightItem {
  const KidsQuranAyahInsightItem({
    required this.id,
    required this.category,
    required this.entry,
  });

  final String id;
  final KidsQuranAyahInsightCategory category;
  final QuranAyahEnrichmentEntry entry;
}

class KidsQuranAyahInsightCategorySection {
  const KidsQuranAyahInsightCategorySection({
    required this.category,
    required this.items,
  });

  final KidsQuranAyahInsightCategory category;
  final List<KidsQuranAyahInsightItem> items;
}

final quranKidsAyahInsightsProvider = Provider<List<KidsQuranAyahInsightItem>>((
  ref,
) {
  final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
  final entryById = <String, QuranAyahEnrichmentEntry>{
    for (final entry in entries) entry.id: entry,
  };

  final items = <KidsQuranAyahInsightItem>[];
  for (final config in _kidsInsightConfigs) {
    final entry = entryById[config.entryId];
    if (entry == null) continue;
    if (!_isSafeForKids(entry)) continue;
    items.add(
      KidsQuranAyahInsightItem(
        id: config.entryId,
        category: config.category,
        entry: entry,
      ),
    );
  }
  return items;
});

final quranKidsAyahInsightSectionsProvider =
    Provider<List<KidsQuranAyahInsightCategorySection>>((ref) {
      final items = ref.watch(quranKidsAyahInsightsProvider);
      return KidsQuranAyahInsightCategory.values
          .map(
            (category) => KidsQuranAyahInsightCategorySection(
              category: category,
              items: items
                  .where((item) => item.category == category)
                  .toList(growable: false),
            ),
          )
          .where((section) => section.items.isNotEmpty)
          .toList(growable: false);
    });

bool _isSafeForKids(QuranAyahEnrichmentEntry entry) {
  if (entry.cautionLevel != QuranAyahCautionLevel.none) return false;
  if (entry.lessonType == QuranAyahEnrichmentLessonType.warning) return false;
  if (entry.domain == QuranAyahEnrichmentDomain.akhirahAccountability) {
    return false;
  }
  if (entry.displayType == QuranAyahDisplayItemType.scientificReflection) {
    return false;
  }
  return true;
}

class _KidsInsightConfig {
  const _KidsInsightConfig({required this.entryId, required this.category});

  final String entryId;
  final KidsQuranAyahInsightCategory category;
}

const _kidsInsightConfigs = <_KidsInsightConfig>[
  _KidsInsightConfig(
    entryId: 'signs_sun_moon_10_5',
    category: KidsQuranAyahInsightCategory.signsInCreation,
  ),
  _KidsInsightConfig(
    entryId: 'signs_animals_24_45',
    category: KidsQuranAyahInsightCategory.signsInCreation,
  ),
  _KidsInsightConfig(
    entryId: 'worship_salah_20_14',
    category: KidsQuranAyahInsightCategory.prayerAndRemembrance,
  ),
  _KidsInsightConfig(
    entryId: 'worship_dhikr_2_152',
    category: KidsQuranAyahInsightCategory.prayerAndRemembrance,
  ),
  _KidsInsightConfig(
    entryId: 'worship_gratitude_31_12',
    category: KidsQuranAyahInsightCategory.gratitudeAndTrust,
  ),
  _KidsInsightConfig(
    entryId: 'worship_reliance_33_3',
    category: KidsQuranAyahInsightCategory.gratitudeAndTrust,
  ),
  _KidsInsightConfig(
    entryId: 'character_parents_17_23_24',
    category: KidsQuranAyahInsightCategory.kindnessAndGoodManners,
  ),
  _KidsInsightConfig(
    entryId: 'character_good_conduct_41_34',
    category: KidsQuranAyahInsightCategory.kindnessAndGoodManners,
  ),
  _KidsInsightConfig(
    entryId: 'prophets_reliance_26_62',
    category: KidsQuranAyahInsightCategory.prophetLessons,
  ),
  _KidsInsightConfig(
    entryId: 'prophets_trials_21_83_84',
    category: KidsQuranAyahInsightCategory.prophetLessons,
  ),
];
