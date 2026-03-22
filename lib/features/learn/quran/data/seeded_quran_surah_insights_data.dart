import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_surah_insight_models.dart';

const List<QuranSurahInsightDefinition> seededQuranSurahInsights =
    <QuranSurahInsightDefinition>[
      QuranSurahInsightDefinition(
        surahNumber: 2,
        descriptionId: 'al_baqarah',
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
        suggestedPathIds: ['worship-remembrance-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 3,
        descriptionId: 'ali_imran',
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
        suggestedPathIds: ['tawhid-belief-starter', 'character-adab-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 20,
        descriptionId: 'ta_ha',
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
        suggestedPathIds: ['worship-remembrance-starter'],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 25,
        descriptionId: 'al_furqan',
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
        suggestedPathIds: [
          'signs-in-creation-starter',
          'character-adab-starter',
        ],
      ),
      QuranSurahInsightDefinition(
        surahNumber: 31,
        descriptionId: 'luqman',
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
        suggestedPathIds: ['tawhid-belief-starter', 'character-adab-starter'],
      ),
    ];
