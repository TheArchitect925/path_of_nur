import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry> seededTawhidBeliefAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'belief_tawhid_112_1_4',
    ref: QuranQuoteRef(surah: 112, ayah: 1, ayahEnd: 4),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Allah is One and unlike His creation',
    summary:
        'These ayahs give a clear foundation of Tawhid by affirming Allah’s oneness, self-sufficiency, and uniqueness.',
    body:
        'This short surah teaches that Allah alone is truly one, absolutely needed by all creation, and not comparable to anything. It protects belief from turning Allah into something imagined, dependent, or like created beings.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 2, ayah: 255)],
    reflectionPrompts: [
      'How does remembering that Allah is unlike all creation change the way I rely on Him and worship Him?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 5,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_signs_3_190_191',
    ref: QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'The signs of creation should lead the heart to belief',
    summary:
        'These ayahs connect reflection on the heavens and the earth with remembrance, worship, and recognition of Allah’s wisdom.',
    body:
        'The passage teaches that signs in creation are not only for curiosity. They are meant to awaken remembrance, humility, and recognition that Allah created with truth and purpose. Reflection should draw the servant closer to belief and obedience.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.guidance,
      QuranAyahEnrichmentTag.worship,
    ],
    relatedRefs: [QuranQuoteRef(surah: 51, ayah: 20, ayahEnd: 21)],
    reflectionPrompts: [
      'When I observe the world around me, does it deepen my remembrance and belief or stay only as passing information?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 16,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_reliance_65_3',
    ref: QuranQuoteRef(surah: 65, ayah: 3),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Reliance on Allah brings steadiness in uncertainty',
    summary:
        'This ayah teaches that whoever places trust in Allah will find Him sufficient.',
    body:
        'The verse makes belief practical. Tawakkul is not abandoning effort, but placing the heart’s dependence on Allah instead of on control, calculation, or fear. It teaches that sufficiency ultimately comes from Allah, not from our own planning alone.',
    tags: [QuranAyahEnrichmentTag.tawakkul, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 3, ayah: 159)],
    reflectionPrompts: [
      'Where am I acting as though my security depends only on my own control instead of on Allah?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 12,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_sincerity_39_11',
    ref: QuranQuoteRef(surah: 39, ayah: 11),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Belief demands sincere devotion to Allah alone',
    summary:
        'This ayah links worship directly to sincerity, teaching that devotion belongs to Allah without divided intention.',
    body:
        'The verse teaches that sincerity is not an optional refinement. It belongs to the foundation of belief itself. A servant is called to direct worship, obedience, and inward devotion to Allah alone rather than mixing them with image, status, or created approval.',
    tags: [
      QuranAyahEnrichmentTag.sincerity,
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 98, ayah: 5)],
    reflectionPrompts: [
      'Which act in my life needs cleaner intention so that it is more clearly for Allah alone?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 10,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_reject_shirk_31_13',
    ref: QuranQuoteRef(surah: 31, ayah: 13),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Shirk is the greatest wrong because it misdirects worship',
    summary:
        'This ayah clearly warns against associating partners with Allah and names it as a tremendous ظلم.',
    body:
        'The verse teaches that shirk is not a small mistake in religious language. It is a deep injustice because it gives to creation what belongs only to Allah. The ayah protects the heart from misplaced devotion, fear, and dependence.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 4, ayah: 48)],
    reflectionPrompts: [
      'Do I guard my heart from giving created things the fear, hope, or dependence that belong to Allah alone?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 6,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_taqwa_3_102',
    ref: QuranQuoteRef(surah: 3, ayah: 102),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Taqwa is living with awareness of Allah',
    summary:
        'This ayah calls believers to fear Allah as He should be feared and to remain in submission until death.',
    body:
        'The verse teaches that taqwa is not a passing emotion. It is sustained awareness that shapes decisions, obedience, and the direction of life. Belief becomes visible when a person lives with concern for how they stand before Allah.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 59, ayah: 18)],
    reflectionPrompts: [
      'What choice in my life right now would look different if I acted with stronger awareness of Allah?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 11,
  ),
  QuranAyahEnrichmentEntry(
    id: 'belief_attributes_57_3',
    ref: QuranQuoteRef(surah: 57, ayah: 3),
    domain: QuranAyahEnrichmentDomain.tawhidBelief,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Allah’s knowledge and lordship surround all times',
    summary:
        'This ayah teaches, in simple terms, that Allah is before and after, manifest and hidden, and fully knowing of all things.',
    body:
        'The verse introduces core belief in a simple and reverent way. Allah is not limited like creation, and His knowledge encompasses all things. The ayah helps the believer grow in trust, awe, and humility without turning belief into abstract speculation.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 59, ayah: 22)],
    reflectionPrompts: [
      'How does remembering Allah’s complete knowledge change the way I act when no one else sees me?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 15,
  ),
];
