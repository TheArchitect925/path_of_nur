import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../divine_life_lessons/data/divine_life_lessons_data.dart';
import '../../divine_life_lessons/domain/divine_life_models.dart';
import '../../world/data/world_creation_data.dart';
import '../../world/domain/world_creation_models.dart';
import '../data/seeded_akhirah_accountability_ayah_enrichment_data.dart';
import '../data/seeded_character_adab_ayah_enrichment_data.dart';
import '../data/seeded_prophets_lessons_ayah_enrichment_data.dart';
import '../data/seeded_signs_in_creation_ayah_enrichment_data.dart';
import '../data/seeded_tawhid_belief_ayah_enrichment_data.dart';
import '../data/seeded_worship_remembrance_ayah_enrichment_data.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import 'quran_learning_system_service.dart';

final quranAyahEnrichmentEntriesProvider =
    Provider<List<QuranAyahEnrichmentEntry>>((ref) {
      final learningVerses = ref.watch(quranLearningVersesProvider);
      final entries = <QuranAyahEnrichmentEntry>[];

      for (final verse in learningVerses) {
        entries.add(
          QuranAyahEnrichmentEntry(
            id: 'learning_${verse.id}',
            ref: QuranQuoteRef(surah: verse.surah, ayah: verse.ayah),
            domain: _domainForLearningVerse(verse.themeTag),
            lessonType: _lessonTypeForLearningVerse(verse.themeTag),
            linkStrength: QuranAyahLinkStrength.direct,
            title: verse.translation,
            summary: verse.explanation,
            body: verse.lessons.join(' '),
            tags: _tagsForLearningVerse(verse.themeTag),
            reflectionPrompts: verse.reflectionPrompts,
            displayType: _displayTypeForLearningVerse(verse.themeTag),
            displayPriority: 20,
          ),
        );
      }

      for (final lesson in divineLifeLessons) {
        entries.add(
          QuranAyahEnrichmentEntry(
            id: 'life_${lesson.id}',
            ref: QuranQuoteRef(
              surah: lesson.surahNumber,
              ayah: lesson.ayahStart,
              ayahEnd: lesson.ayahEnd,
            ),
            domain: _domainForDivineLifeLesson(lesson),
            lessonType: _lessonTypeForDivineLifeLesson(lesson),
            linkStrength: QuranAyahLinkStrength.direct,
            title: lesson.title,
            summary: lesson.shortSummary,
            body: lesson.practicalTakeaway,
            tags: _tagsForDivineLifeLesson(lesson),
            reflectionPrompts: lesson.reflectionPrompts,
            sourceRouteName: 'lifeLessonDetail',
            pathParameters: {'lessonId': lesson.id},
            displayType: _displayTypeForDivineLifeLesson(lesson),
            displayPriority: 10,
          ),
        );
      }

      for (final lesson in worldCreationLessons) {
        for (final verse in lesson.quranVerses) {
          entries.add(
            QuranAyahEnrichmentEntry(
              id: 'world_${lesson.id}_${verse.referenceLabel}',
              ref: QuranQuoteRef(
                surah: verse.surahNumber,
                ayah: verse.ayahStart,
                ayahEnd: verse.ayahEnd,
              ),
              domain: _domainForWorldCreationLesson(lesson),
              lessonType: QuranAyahEnrichmentLessonType.connection,
              linkStrength: QuranAyahLinkStrength.direct,
              title: lesson.title,
              summary: lesson.summary,
              body: lesson.quranObservation,
              tags: _tagsForWorldCreationLesson(lesson),
              sourceRouteName: 'worldCreationLessonDetail',
              pathParameters: {'lessonId': lesson.id},
              cautionNote: lesson.scienceLens.cautionNote,
              interpretationNote:
                  'Use this as reflective educational context, not as a claim that a verse must map one-to-one onto modern scientific terminology.',
              cautionLevel: lesson.scienceLens.cautionNote.isEmpty
                  ? QuranAyahCautionLevel.none
                  : QuranAyahCautionLevel.scientificCare,
              displayType: lesson.scienceLens.cautionNote.isEmpty
                  ? QuranAyahDisplayItemType.signsInCreation
                  : QuranAyahDisplayItemType.scientificReflection,
              displayPriority: lesson.scienceLens.cautionNote.isEmpty ? 30 : 40,
            ),
          );
        }
      }

      entries.addAll(seededSignsInCreationAyahEnrichmentEntries);
      entries.addAll(seededWorshipRemembranceAyahEnrichmentEntries);
      entries.addAll(seededCharacterAdabAyahEnrichmentEntries);
      entries.addAll(seededTawhidBeliefAyahEnrichmentEntries);
      entries.addAll(seededAkhirahAccountabilityAyahEnrichmentEntries);
      entries.addAll(seededProphetsLessonsAyahEnrichmentEntries);

      final enrichedEntries = _attachCuratedRelatedAyahs(entries);
      enrichedEntries.sort(_compareEnrichmentEntries);
      return enrichedEntries;
    });

final quranAyahEnrichmentForVerseProvider =
    Provider.family<List<QuranAyahEnrichmentEntry>, (int surah, int ayah)>((
      ref,
      input,
    ) {
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      return entries
          .where((entry) => entry.containsVerse(input.$1, input.$2))
          .where(
            (entry) => entry.linkStrength != QuranAyahLinkStrength.contextual,
          )
          .toList(growable: false)
        ..sort(_compareEnrichmentEntries);
    });

final quranAyahEnrichmentForRangeProvider =
    Provider.family<List<QuranAyahEnrichmentEntry>, QuranQuoteRef>((
      ref,
      range,
    ) {
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final rangeEnd = range.ayahEnd ?? range.ayah;
      return entries
          .where((entry) {
            if (entry.ref.surah != range.surah) return false;
            final entryEnd = entry.ref.ayahEnd ?? entry.ref.ayah;
            return entry.ref.ayah <= rangeEnd && entryEnd >= range.ayah;
          })
          .toList(growable: false)
        ..sort(_compareEnrichmentEntries);
    });

final quranAyahDisplayItemsForVerseProvider =
    Provider.family<List<QuranAyahDisplayItem>, (int surah, int ayah)>((
      ref,
      input,
    ) {
      final entries = ref.watch(quranAyahEnrichmentForVerseProvider(input));
      return _buildDisplayItems(entries);
    });

final quranAyahDisplayItemsForRangeProvider =
    Provider.family<List<QuranAyahDisplayItem>, QuranQuoteRef>((ref, range) {
      final entries = ref.watch(quranAyahEnrichmentForRangeProvider(range));
      return _buildDisplayItems(entries);
    });

final quranAyahEnrichmentBrowseCategoriesProvider =
    Provider<List<QuranAyahEnrichmentBrowseCategory>>((ref) {
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      return _buildBrowseCategories(entries);
    });

final quranAyahEnrichmentBrowseCategoryProvider =
    Provider.family<QuranAyahEnrichmentBrowseCategory?, String>((ref, id) {
      final categories = ref.watch(quranAyahEnrichmentBrowseCategoriesProvider);
      for (final category in categories) {
        if (category.id == id) return category;
      }
      return null;
    });

final quranAyahEnrichmentBrowseTagsProvider =
    Provider<List<QuranAyahEnrichmentTag>>((ref) {
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final tags = <QuranAyahEnrichmentTag>{};
      for (final entry in entries) {
        tags.addAll(entry.tags);
      }
      final output = tags.toList(growable: false)
        ..sort((a, b) => a.name.compareTo(b.name));
      return output;
    });

final quranAyahInsightPathsProvider = Provider<List<QuranAyahInsightPath>>((
  ref,
) {
  return const <QuranAyahInsightPath>[
    QuranAyahInsightPath(
      id: 'signs-in-creation-starter',
      titleKey: 'signs_in_creation_starter',
      descriptionKey: 'signs_in_creation_starter',
      reflectionFocusKey: 'signs_in_creation_starter',
      domain: QuranAyahEnrichmentDomain.signsInCreation,
      entryIds: [
        'signs_heavens_51_47',
        'signs_sun_moon_10_5',
        'signs_night_day_25_62',
        'signs_rain_water_39_21',
        'signs_plants_6_99',
      ],
    ),
    QuranAyahInsightPath(
      id: 'worship-remembrance-starter',
      titleKey: 'worship_remembrance_starter',
      descriptionKey: 'worship_remembrance_starter',
      reflectionFocusKey: 'worship_remembrance_starter',
      domain: QuranAyahEnrichmentDomain.worshipRemembrance,
      entryIds: [
        'worship_salah_20_14',
        'worship_dhikr_2_152',
        'worship_dua_2_186',
        'worship_sincerity_98_5',
        'worship_reliance_33_3',
      ],
    ),
    QuranAyahInsightPath(
      id: 'character-adab-starter',
      titleKey: 'character_adab_starter',
      descriptionKey: 'character_adab_starter',
      reflectionFocusKey: 'character_adab_starter',
      domain: QuranAyahEnrichmentDomain.characterAdab,
      entryIds: [
        'character_patience_3_200',
        'character_mercy_3_159',
        'character_justice_5_8',
        'character_forgiveness_24_22',
        'character_good_conduct_41_34',
      ],
    ),
    QuranAyahInsightPath(
      id: 'tawhid-belief-starter',
      titleKey: 'tawhid_belief_starter',
      descriptionKey: 'tawhid_belief_starter',
      reflectionFocusKey: 'tawhid_belief_starter',
      domain: QuranAyahEnrichmentDomain.tawhidBelief,
      entryIds: [
        'belief_tawhid_112_1_4',
        'belief_signs_3_190_191',
        'belief_reliance_65_3',
        'belief_reject_shirk_31_13',
        'belief_taqwa_3_102',
      ],
    ),
    QuranAyahInsightPath(
      id: 'akhirah-accountability-starter',
      titleKey: 'akhirah_accountability_starter',
      descriptionKey: 'akhirah_accountability_starter',
      reflectionFocusKey: 'akhirah_accountability_starter',
      domain: QuranAyahEnrichmentDomain.akhirahAccountability,
      entryIds: [
        'akhirah_judgment_99_6_8',
        'akhirah_deeds_17_13_14',
        'akhirah_resurrection_22_5_7',
        'akhirah_urgency_59_18',
        'akhirah_jannah_13_22_24',
      ],
    ),
    QuranAyahInsightPath(
      id: 'prophets-lessons-starter',
      titleKey: 'prophets_lessons_starter',
      descriptionKey: 'prophets_lessons_starter',
      reflectionFocusKey: 'prophets_lessons_starter',
      domain: QuranAyahEnrichmentDomain.prophetsLessons,
      entryIds: [
        'prophets_patience_46_35',
        'prophets_reliance_26_62',
        'prophets_submission_2_131',
        'prophets_dawah_71_5_6',
        'prophets_leadership_38_26',
      ],
    ),
  ];
});

final quranAyahInsightPathProvider =
    Provider.family<QuranAyahInsightResolvedPath?, String>((ref, id) {
      final paths = ref.watch(quranAyahInsightPathsProvider);
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      QuranAyahInsightPath? path;
      for (final candidate in paths) {
        if (candidate.id == id) {
          path = candidate;
          break;
        }
      }
      if (path == null) return null;

      final entriesById = {for (final entry in entries) entry.id: entry};
      final resolvedEntries = path.entryIds
          .map((entryId) => entriesById[entryId])
          .whereType<QuranAyahEnrichmentEntry>()
          .toList(growable: false);

      if (resolvedEntries.isEmpty) return null;
      return QuranAyahInsightResolvedPath(path: path, entries: resolvedEntries);
    });

final quranAyahInsightResolvedPathsProvider =
    Provider<List<QuranAyahInsightResolvedPath>>((ref) {
      final paths = ref.watch(quranAyahInsightPathsProvider);
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final entriesById = {for (final entry in entries) entry.id: entry};
      final resolved = <QuranAyahInsightResolvedPath>[];

      for (final path in paths) {
        final resolvedEntries = path.entryIds
            .map((entryId) => entriesById[entryId])
            .whereType<QuranAyahEnrichmentEntry>()
            .toList(growable: false);
        if (resolvedEntries.isEmpty) continue;
        resolved.add(
          QuranAyahInsightResolvedPath(path: path, entries: resolvedEntries),
        );
      }

      return resolved;
    });

List<QuranAyahDisplayItem> _buildDisplayItems(
  List<QuranAyahEnrichmentEntry> entries,
) {
  final items = <QuranAyahDisplayItem>[];
  final seenIds = <String>{};

  for (final entry in entries) {
    final primaryType =
        entry.displayType ?? QuranAyahDisplayItemType.ayahInsight;
    if (seenIds.add('primary_${entry.id}')) {
      items.add(
        QuranAyahDisplayItem(
          id: 'primary_${entry.id}',
          type: primaryType,
          title: entry.title,
          summary: entry.summary,
          linkStrength: entry.linkStrength,
          displayPriority: entry.displayPriority,
          sourceRouteName: entry.sourceRouteName,
          pathParameters: entry.pathParameters,
          queryParameters: entry.queryParameters,
          cautionLevel: entry.cautionLevel,
          sourceEnrichmentId: entry.id,
        ),
      );
    }

    if (entry.interpretationNote != null &&
        seenIds.add('interpretation_${entry.id}')) {
      items.add(
        QuranAyahDisplayItem(
          id: 'interpretation_${entry.id}',
          type: QuranAyahDisplayItemType.interpretationNote,
          title: entry.title,
          summary: entry.interpretationNote!,
          linkStrength: entry.linkStrength,
          displayPriority: entry.displayPriority + 30,
          cautionLevel: entry.cautionLevel,
          sourceEnrichmentId: entry.id,
        ),
      );
    }

    for (var index = 0; index < entry.reflectionPrompts.length; index += 1) {
      final prompt = entry.reflectionPrompts[index].trim();
      if (prompt.isEmpty) continue;
      final promptId = 'prompt_${entry.id}_$index';
      if (!seenIds.add(promptId)) continue;
      items.add(
        QuranAyahDisplayItem(
          id: promptId,
          type: QuranAyahDisplayItemType.reflectionPrompt,
          title: entry.title,
          summary: prompt,
          linkStrength: entry.linkStrength,
          displayPriority: entry.displayPriority + 40,
          sourceEnrichmentId: entry.id,
        ),
      );
    }

    for (var index = 0; index < entry.relatedRefs.length; index += 1) {
      final relatedRef = entry.relatedRefs[index];
      final relatedId =
          'related_${entry.id}_${relatedRef.locationLabel}_$index';
      if (!seenIds.add(relatedId)) continue;
      items.add(
        QuranAyahDisplayItem(
          id: relatedId,
          type: QuranAyahDisplayItemType.relatedAyah,
          title: relatedRef.locationLabel,
          summary: relatedRef.locationLabel,
          linkStrength: QuranAyahLinkStrength.strongThematic,
          displayPriority: entry.displayPriority + 50,
          relatedRef: relatedRef,
          relatedAyahType: QuranRelatedAyahLinkType.sameTheme,
          sourceEnrichmentId: entry.id,
        ),
      );
    }

    for (var index = 0; index < entry.relatedAyahs.length; index += 1) {
      final related = entry.relatedAyahs[index];
      final relatedId =
          'typed_related_${entry.id}_${related.ref.locationLabel}_$index';
      if (!seenIds.add(relatedId)) continue;
      items.add(
        QuranAyahDisplayItem(
          id: relatedId,
          type: QuranAyahDisplayItemType.relatedAyah,
          title: related.ref.locationLabel,
          summary: related.reason ?? related.ref.locationLabel,
          linkStrength: related.linkStrength,
          displayPriority: entry.displayPriority + 45 + index,
          relatedRef: related.ref,
          relatedAyahType: related.type,
          relatedReason: related.reason,
          sourceEnrichmentId: entry.id,
        ),
      );
    }
  }

  items.sort(_compareDisplayItems);
  final nonRelatedItems = items
      .where((item) => item.type != QuranAyahDisplayItemType.relatedAyah)
      .take(6);
  final relatedItems = items
      .where((item) => item.type == QuranAyahDisplayItemType.relatedAyah)
      .take(3);
  return [...nonRelatedItems, ...relatedItems];
}

List<QuranAyahEnrichmentBrowseCategory> _buildBrowseCategories(
  List<QuranAyahEnrichmentEntry> entries,
) {
  const categoryConfigs = <(String, List<QuranAyahEnrichmentDomain>)>[
    (
      'signs-in-creation',
      [
        QuranAyahEnrichmentDomain.signsInCreation,
        QuranAyahEnrichmentDomain.worldNature,
      ],
    ),
    ('worship-remembrance', [QuranAyahEnrichmentDomain.worshipRemembrance]),
    ('character-adab', [QuranAyahEnrichmentDomain.characterAdab]),
    ('tawhid-belief', [QuranAyahEnrichmentDomain.tawhidBelief]),
    (
      'akhirah-accountability',
      [QuranAyahEnrichmentDomain.akhirahAccountability],
    ),
    ('prophets-lessons', [QuranAyahEnrichmentDomain.prophetsLessons]),
    ('guidance-daily-life', [QuranAyahEnrichmentDomain.guidanceDailyLife]),
  ];

  final output = <QuranAyahEnrichmentBrowseCategory>[];
  for (final config in categoryConfigs) {
    final categoryEntries =
        entries
            .where((entry) => config.$2.contains(entry.domain))
            .toList(growable: false)
          ..sort(_compareEnrichmentEntries);
    if (categoryEntries.isEmpty) continue;
    output.add(
      QuranAyahEnrichmentBrowseCategory(
        id: config.$1,
        domains: config.$2,
        entries: categoryEntries,
      ),
    );
  }
  return output;
}

List<QuranAyahEnrichmentEntry> _attachCuratedRelatedAyahs(
  List<QuranAyahEnrichmentEntry> entries,
) {
  const relatedMap = <String, List<QuranRelatedAyahLink>>{
    'signs_heavens_51_47': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191),
        type: QuranRelatedAyahLinkType.supportingInsight,
        reason: 'Creation is tied to reflective belief and remembrance.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 25, ayah: 62),
        type: QuranRelatedAyahLinkType.creationConnection,
        reason: 'Night and day deepen the pattern of created signs.',
      ),
    ],
    'worship_salah_20_14': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 2, ayah: 152),
        type: QuranRelatedAyahLinkType.worshipConnection,
        reason: 'Prayer is strengthened by living remembrance of Allah.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 98, ayah: 5),
        type: QuranRelatedAyahLinkType.supportingInsight,
        reason: 'Salah is tied to sincere worship and devotion.',
      ),
    ],
    'character_justice_5_8': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 41, ayah: 34),
        type: QuranRelatedAyahLinkType.characterConnection,
        reason:
            'Justice is deepened by choosing the better response to people.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 3, ayah: 134),
        type: QuranRelatedAyahLinkType.supportingInsight,
        reason: 'Self-restraint helps justice stay principled under pressure.',
      ),
    ],
    'belief_tawhid_112_1_4': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 39, ayah: 11),
        type: QuranRelatedAyahLinkType.worshipConnection,
        reason: 'Tawhid leads naturally to sincere worship for Allah alone.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 31, ayah: 13),
        type: QuranRelatedAyahLinkType.contrast,
        reason: 'The rejection of shirk protects the clarity of Tawhid.',
      ),
    ],
    'akhirah_deeds_99_6_8': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 59, ayah: 18),
        type: QuranRelatedAyahLinkType.continuation,
        reason:
            'Knowing that deeds are shown should lead to daily preparation.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 17, ayah: 13, ayahEnd: 14),
        type: QuranRelatedAyahLinkType.supportingInsight,
        reason:
            'The personal record of deeds reinforces individual accountability.',
      ),
    ],
    'prophets_patience_46_35': [
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 21, ayah: 83, ayahEnd: 84),
        type: QuranRelatedAyahLinkType.prophetConnection,
        reason:
            'Ayyub عليه السلام shows patient turning to Allah through trial.',
      ),
      QuranRelatedAyahLink(
        ref: QuranQuoteRef(surah: 71, ayah: 5, ayahEnd: 6),
        type: QuranRelatedAyahLinkType.supportingInsight,
        reason:
            'Nuh عليه السلام reflects perseverance over a long call to truth.',
      ),
    ],
  };

  return entries
      .map((entry) {
        final curatedRelated = relatedMap[entry.id];
        if (curatedRelated == null || curatedRelated.isEmpty) {
          return entry;
        }
        return QuranAyahEnrichmentEntry(
          id: entry.id,
          ref: entry.ref,
          domain: entry.domain,
          lessonType: entry.lessonType,
          linkStrength: entry.linkStrength,
          title: entry.title,
          summary: entry.summary,
          body: entry.body,
          tags: entry.tags,
          relatedRefs: entry.relatedRefs,
          relatedAyahs: curatedRelated,
          reflectionPrompts: entry.reflectionPrompts,
          sourceRouteName: entry.sourceRouteName,
          pathParameters: entry.pathParameters,
          queryParameters: entry.queryParameters,
          interpretationNote: entry.interpretationNote,
          cautionNote: entry.cautionNote,
          cautionLevel: entry.cautionLevel,
          displayType: entry.displayType,
          displayPriority: entry.displayPriority,
        );
      })
      .toList(growable: false);
}

int _compareEnrichmentEntries(
  QuranAyahEnrichmentEntry a,
  QuranAyahEnrichmentEntry b,
) {
  final byPriority = a.displayPriority.compareTo(b.displayPriority);
  if (byPriority != 0) return byPriority;
  final byStrength = a.linkStrength.priorityValue.compareTo(
    b.linkStrength.priorityValue,
  );
  if (byStrength != 0) return byStrength;
  final bySurah = a.ref.surah.compareTo(b.ref.surah);
  if (bySurah != 0) return bySurah;
  final byAyah = a.ref.ayah.compareTo(b.ref.ayah);
  if (byAyah != 0) return byAyah;
  return a.id.compareTo(b.id);
}

int _compareDisplayItems(QuranAyahDisplayItem a, QuranAyahDisplayItem b) {
  final byPriority = a.displayPriority.compareTo(b.displayPriority);
  if (byPriority != 0) return byPriority;
  final byStrength = a.linkStrength.priorityValue.compareTo(
    b.linkStrength.priorityValue,
  );
  if (byStrength != 0) return byStrength;
  return a.id.compareTo(b.id);
}

QuranAyahEnrichmentDomain _domainForLearningVerse(String? themeTag) {
  switch (themeTag) {
    case 'faith':
      return QuranAyahEnrichmentDomain.tawhidBelief;
    case 'prayer':
      return QuranAyahEnrichmentDomain.worshipRemembrance;
    case 'justice':
      return QuranAyahEnrichmentDomain.characterAdab;
    case 'repentance':
      return QuranAyahEnrichmentDomain.guidanceDailyLife;
    case 'purpose':
      return QuranAyahEnrichmentDomain.akhirahAccountability;
    case 'patience':
      return QuranAyahEnrichmentDomain.guidanceDailyLife;
    default:
      return QuranAyahEnrichmentDomain.guidanceDailyLife;
  }
}

QuranAyahEnrichmentLessonType _lessonTypeForLearningVerse(String? themeTag) {
  switch (themeTag) {
    case 'prayer':
      return QuranAyahEnrichmentLessonType.connection;
    case 'justice':
      return QuranAyahEnrichmentLessonType.practicalTakeaway;
    case 'repentance':
      return QuranAyahEnrichmentLessonType.reminder;
    case 'patience':
      return QuranAyahEnrichmentLessonType.reflection;
    case 'purpose':
      return QuranAyahEnrichmentLessonType.warning;
    default:
      return QuranAyahEnrichmentLessonType.coreLesson;
  }
}

QuranAyahDisplayItemType _displayTypeForLearningVerse(String? themeTag) {
  switch (themeTag) {
    case 'prayer':
      return QuranAyahDisplayItemType.worshipLesson;
    case 'justice':
      return QuranAyahDisplayItemType.characterLesson;
    default:
      return QuranAyahDisplayItemType.ayahInsight;
  }
}

List<QuranAyahEnrichmentTag> _tagsForLearningVerse(String? themeTag) {
  switch (themeTag) {
    case 'faith':
      return const [QuranAyahEnrichmentTag.guidance];
    case 'patience':
      return const [
        QuranAyahEnrichmentTag.sabr,
        QuranAyahEnrichmentTag.guidance,
      ];
    case 'justice':
      return const [
        QuranAyahEnrichmentTag.justice,
        QuranAyahEnrichmentTag.guidance,
      ];
    case 'prayer':
      return const [
        QuranAyahEnrichmentTag.worship,
        QuranAyahEnrichmentTag.guidance,
      ];
    case 'repentance':
      return const [
        QuranAyahEnrichmentTag.repentance,
        QuranAyahEnrichmentTag.mercy,
      ];
    case 'purpose':
      return const [
        QuranAyahEnrichmentTag.signs,
        QuranAyahEnrichmentTag.guidance,
      ];
    default:
      return const [QuranAyahEnrichmentTag.guidance];
  }
}

QuranAyahEnrichmentDomain _domainForDivineLifeLesson(DivineLifeLesson lesson) {
  final themeId = lesson.themeId;
  if (themeId.contains('trust') || themeId.contains('prayer')) {
    return QuranAyahEnrichmentDomain.worshipRemembrance;
  }
  if (themeId.contains('repentance') || themeId.contains('hope')) {
    return QuranAyahEnrichmentDomain.guidanceDailyLife;
  }
  if (themeId.contains('gratitude') || themeId.contains('patience')) {
    return QuranAyahEnrichmentDomain.guidanceDailyLife;
  }
  return QuranAyahEnrichmentDomain.characterAdab;
}

QuranAyahEnrichmentLessonType _lessonTypeForDivineLifeLesson(
  DivineLifeLesson lesson,
) {
  final themeId = lesson.themeId;
  if (themeId.contains('trust') || themeId.contains('prayer')) {
    return QuranAyahEnrichmentLessonType.connection;
  }
  if (themeId.contains('repentance') || themeId.contains('hope')) {
    return QuranAyahEnrichmentLessonType.reminder;
  }
  if (themeId.contains('gratitude') || themeId.contains('patience')) {
    return QuranAyahEnrichmentLessonType.reflection;
  }
  return QuranAyahEnrichmentLessonType.practicalTakeaway;
}

QuranAyahDisplayItemType _displayTypeForDivineLifeLesson(
  DivineLifeLesson lesson,
) {
  final domain = _domainForDivineLifeLesson(lesson);
  switch (domain) {
    case QuranAyahEnrichmentDomain.worshipRemembrance:
      return QuranAyahDisplayItemType.worshipLesson;
    case QuranAyahEnrichmentDomain.characterAdab:
      return QuranAyahDisplayItemType.characterLesson;
    default:
      return QuranAyahDisplayItemType.ayahInsight;
  }
}

List<QuranAyahEnrichmentTag> _tagsForDivineLifeLesson(DivineLifeLesson lesson) {
  final output = <QuranAyahEnrichmentTag>{QuranAyahEnrichmentTag.guidance};
  for (final tag in lesson.tags) {
    switch (tag) {
      case 'patience':
      case 'sabr':
        output.add(QuranAyahEnrichmentTag.sabr);
      case 'gratitude':
      case 'shukr':
        output.add(QuranAyahEnrichmentTag.shukr);
      case 'tawakkul':
      case 'trust':
      case 'reliance':
        output.add(QuranAyahEnrichmentTag.tawakkul);
      case 'mercy':
      case 'hope':
      case 'forgiveness':
        output.add(QuranAyahEnrichmentTag.mercy);
      case 'repentance':
        output.add(QuranAyahEnrichmentTag.repentance);
      case 'justice':
        output.add(QuranAyahEnrichmentTag.justice);
      case 'sincerity':
        output.add(QuranAyahEnrichmentTag.sincerity);
      case 'prayer':
      case 'dhikr':
        output.add(QuranAyahEnrichmentTag.worship);
    }
  }
  return output.toList(growable: false);
}

QuranAyahEnrichmentDomain _domainForWorldCreationLesson(
  WorldCreationLesson lesson,
) {
  switch (lesson.category.name) {
    case 'universeSpace':
    case 'reflectionSigns':
      return QuranAyahEnrichmentDomain.signsInCreation;
    default:
      return QuranAyahEnrichmentDomain.worldNature;
  }
}

List<QuranAyahEnrichmentTag> _tagsForWorldCreationLesson(
  WorldCreationLesson lesson,
) {
  return const [QuranAyahEnrichmentTag.signs, QuranAyahEnrichmentTag.creation];
}
