import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_surah_insight_models.dart';

const List<QuranSurahInsightDefinition> seededQuranSurahInsights =
    <QuranSurahInsightDefinition>[
      QuranSurahInsightDefinition(
        surahNumber: 2,
        descriptionId: 'al_baqarah',
        significanceId: 'al_baqarah',
        themeIds: [
          'guidance_and_devotion',
          'patience_and_reliance',
          'supplication_and_response',
        ],
        lessonIds: [
          'steadfast_worship_needs_help',
          'remembering_allah_reshapes_the_heart',
          'dua_is_part_of_lived_faith',
        ],
        studyPromptIds: [
          'al_baqarah_worship_and_help',
          'al_baqarah_dua_and_response',
        ],
        clusters: [
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.worshipRemembrance,
            refs: [
              QuranQuoteRef(surah: 2, ayah: 45),
              QuranQuoteRef(surah: 2, ayah: 152),
              QuranQuoteRef(surah: 2, ayah: 186),
            ],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.guidanceDailyLife,
            refs: [QuranQuoteRef(surah: 2, ayah: 153)],
          ),
        ],
        relatedRoutes: [
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'prayer'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.characterCompanion,
            routeName: 'learnCharacterCompanion',
            queryParameters: {'focus': 'sabr'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.hadith,
            routeName: 'learnHadithLanding',
          ),
        ],
        relatedTopicIds: ['prayer', 'remembrance', 'patience'],
        suggestedPathIds: ['worship-remembrance-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 3,
        descriptionId: 'ali_imran',
        significanceId: 'ali_imran',
        themeIds: [
          'steadfast_belief',
          'character_under_pressure',
          'reflecting_on_signs',
        ],
        lessonIds: [
          'taqwa_and_reflection_belong_together',
          'mercy_and_restraint_are_strengths',
          'steadfastness_is_built_through_belief_and_character',
        ],
        studyPromptIds: [
          'ali_imran_pressure_and_character',
          'ali_imran_signs_and_belief',
        ],
        clusters: [
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.tawhidBelief,
            refs: [
              QuranQuoteRef(surah: 3, ayah: 102),
              QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191),
            ],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.characterAdab,
            refs: [
              QuranQuoteRef(surah: 3, ayah: 134),
              QuranQuoteRef(surah: 3, ayah: 159),
              QuranQuoteRef(surah: 3, ayah: 200),
            ],
          ),
        ],
        relatedRoutes: [
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'signs-in-creation'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.characterCompanion,
            routeName: 'learnCharacterCompanion',
            queryParameters: {'focus': 'kindness'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.hadith,
            routeName: 'learnHadithLanding',
          ),
        ],
        relatedTopicIds: ['justice', 'mercy', 'signs-in-creation'],
        suggestedPathIds: ['tawhid-belief-starter', 'character-adab-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 20,
        descriptionId: 'ta_ha',
        significanceId: 'ta_ha',
        themeIds: [
          'revelation_and_remembrance',
          'seeking_knowledge',
          'worship_with_presence',
        ],
        lessonIds: [
          'prayer_keeps_revelation_connected_to_life',
          'sincere_learning_begins_with_humility',
          'remembrance_is_meant_to_shape_action',
        ],
        studyPromptIds: [
          'ta_ha_revelation_and_presence',
          'ta_ha_knowledge_and_humility',
        ],
        clusters: [
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.worshipRemembrance,
            refs: [QuranQuoteRef(surah: 20, ayah: 14)],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.guidanceDailyLife,
            refs: [QuranQuoteRef(surah: 20, ayah: 114)],
          ),
        ],
        relatedRoutes: [
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'remembrance'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'prayer'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.dailyWisdomCompanion,
            routeName: 'learnDailyWisdomCompanion',
            queryParameters: {'focus': 'remembrance'},
          ),
        ],
        relatedTopicIds: ['remembrance', 'prayer', 'humility'],
        suggestedPathIds: ['worship-remembrance-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 25,
        descriptionId: 'al_furqan',
        significanceId: 'al_furqan',
        themeIds: [
          'discernment_and_reflection',
          'humble_servanthood',
          'signs_in_time_and_creation',
        ],
        lessonIds: [
          'the_servants_of_the_merciful_are_known_by_conduct',
          'signs_in_creation_should_lead_to_remembrance',
          'guidance_becomes_visible_in_how_one_walks_and_responds',
        ],
        studyPromptIds: [
          'al_furqan_conduct_and_discernment',
          'al_furqan_time_and_signs',
        ],
        clusters: [
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.signsInCreation,
            refs: [QuranQuoteRef(surah: 25, ayah: 62)],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.characterAdab,
            refs: [QuranQuoteRef(surah: 25, ayah: 63)],
          ),
        ],
        relatedRoutes: [
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.characterCompanion,
            routeName: 'learnCharacterCompanion',
            queryParameters: {'focus': 'humility'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.world,
            routeName: 'learnWorldLanding',
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'mercy'},
          ),
        ],
        relatedTopicIds: ['humility', 'mercy', 'signs-in-creation'],
        suggestedPathIds: [
          'signs-in-creation-starter',
          'character-adab-starter',
        ],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 31,
        descriptionId: 'luqman',
        significanceId: 'luqman',
        themeIds: [
          'gratitude_and_wisdom',
          'tawhid_in_family_guidance',
          'humility_and_good_conduct',
        ],
        lessonIds: [
          'gratitude_is_a_form_of_worship',
          'belief_and_character_are_taught_together',
          'wisdom_shows_in_humility_before_allah_and_people',
        ],
        studyPromptIds: [
          'luqman_family_and_tawhid',
          'luqman_gratitude_and_humility',
        ],
        clusters: [
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.worshipRemembrance,
            refs: [QuranQuoteRef(surah: 31, ayah: 12)],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.tawhidBelief,
            refs: [QuranQuoteRef(surah: 31, ayah: 13)],
          ),
          QuranSurahInsightClusterDefinition(
            domain: QuranAyahEnrichmentDomain.characterAdab,
            refs: [QuranQuoteRef(surah: 31, ayah: 18)],
          ),
        ],
        relatedRoutes: [
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'family'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.quranTheme,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': 'gratitude'},
          ),
          QuranTopicRouteTarget(
            kind: QuranTopicRouteKind.life,
            routeName: 'learnLifeLanding',
          ),
        ],
        relatedTopicIds: ['family', 'gratitude', 'humility'],
        suggestedPathIds: ['tawhid-belief-starter', 'character-adab-starter'],
      ),
    ];
