import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry>
seededSignsInCreationAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'signs_heavens_51_47',
    ref: QuranQuoteRef(surah: 51, ayah: 47),
    domain: QuranAyahEnrichmentDomain.signsInCreation,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'The heavens point to power and measure',
    summary:
        'This ayah directs the heart toward the vastness of the heavens as a sign of Allah’s power and sustaining order.',
    body:
        'The verse invites reflection on the heavens as a created reality held by Allah’s power. It supports humility and wonder, and it encourages observation without turning the Qur’an into a technical manual.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 3, ayah: 190)],
    reflectionPrompts: [
      'How does looking at the sky change the way I think about my own limits?',
    ],
    interpretationNote:
        'Use this ayah as a sign of divine power and order first. Modern cosmology comparisons should stay secondary and careful.',
    cautionNote:
        'Avoid treating this verse as a one-to-one scientific formula. Its primary role is guidance and reflection.',
    cautionLevel: QuranAyahCautionLevel.scientificCare,
    displayType: QuranAyahDisplayItemType.scientificReflection,
    displayPriority: 16,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_sun_moon_10_5',
    ref: QuranQuoteRef(surah: 10, ayah: 5),
    domain: QuranAyahEnrichmentDomain.signsInCreation,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Sun and moon mark order, light, and time',
    summary:
        'The ayah points to the sun and moon as ordered signs that help people reckon time and notice divine wisdom.',
    body:
        'This verse links celestial order with practical human life. It teaches that created patterns are not random; they help people recognize measure, gratitude, and responsibility.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 36, ayah: 39, ayahEnd: 40)],
    reflectionPrompts: [
      'What regular pattern in creation helps me remember that Allah’s order is not chaotic?',
    ],
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 14,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_night_day_25_62',
    ref: QuranQuoteRef(surah: 25, ayah: 62),
    domain: QuranAyahEnrichmentDomain.signsInCreation,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Night and day are signs for remembrance',
    summary:
        'The alternation of night and day is presented as a sign for those who want to reflect, remember, and give thanks.',
    body:
        'This ayah does more than point to a natural cycle. It connects time itself to worship, gratitude, and conscious living. The passing of day and night becomes a repeated reminder rather than a background routine.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.shukr,
    ],
    relatedRefs: [QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191)],
    reflectionPrompts: [
      'How can I let one part of my day become more intentional in remembrance and gratitude?',
    ],
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 12,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_rain_water_39_21',
    ref: QuranQuoteRef(surah: 39, ayah: 21),
    domain: QuranAyahEnrichmentDomain.worldNature,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Rain revives the earth by Allah’s leave',
    summary:
        'The ayah connects rainfall, the earth, and plant growth as a visible cycle of provision and renewal.',
    body:
        'This verse teaches people to see water not only as a physical resource but as a sign of mercy, dependence, and renewal. The movement from rain to growth invites gratitude and reflection on resurrection imagery as well.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 30, ayah: 48)],
    reflectionPrompts: [
      'When I see rain or flowing water, do I think about dependence and mercy or only utility?',
    ],
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 15,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_oceans_rivers_25_53',
    ref: QuranQuoteRef(surah: 25, ayah: 53),
    domain: QuranAyahEnrichmentDomain.worldNature,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Seas and rivers invite reflection on distinction and balance',
    summary:
        'The verse points to distinct bodies of water as signs of Allah’s wisdom in creation.',
    body:
        'This ayah draws attention to difference within creation and the limits Allah places within the world. It should be approached as a sign of divine ordering and reflection, not as a claim that every modern oceanographic detail is directly stated here.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    reflectionPrompts: [
      'What created boundaries in life remind me that not everything is meant to be without measure?',
    ],
    interpretationNote:
        'The core lesson is divine ordering in creation. Specific scientific readings should remain modest and evidence-aware.',
    cautionNote:
        'Do not overstate this ayah as a settled scientific proof text. Keep the emphasis on reflection and created balance.',
    cautionLevel: QuranAyahCautionLevel.interpretationSensitive,
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 22,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_mountains_16_15',
    ref: QuranQuoteRef(surah: 16, ayah: 15),
    domain: QuranAyahEnrichmentDomain.worldNature,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Mountains are signs of stability and placement',
    summary:
        'The ayah directs attention to mountains as part of Allah’s wise placing of the earth for human life.',
    body:
        'The verse highlights mountains within a broader pattern of created stability, pathways, and guidance. The main teaching is that the earth is arranged purposefully by Allah and is not self-sustaining.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 78, ayah: 6, ayahEnd: 7)],
    reflectionPrompts: [
      'What in creation makes me slow down enough to notice steadiness instead of only motion?',
    ],
    interpretationNote:
        'The ayah supports reflection on stability and purposeful placement. It should not be turned into an over-precise geology claim.',
    cautionNote:
        'Keep the meaning rooted in Qur’anic guidance and visible reflection before importing technical geological claims.',
    cautionLevel: QuranAyahCautionLevel.interpretationSensitive,
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 24,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_plants_6_99',
    ref: QuranQuoteRef(surah: 6, ayah: 99),
    domain: QuranAyahEnrichmentDomain.worldNature,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Plants and harvests show layered provision',
    summary:
        'The ayah calls attention to rain, greenery, grain, fruit, and variety as signs for people who reflect.',
    body:
        'This verse teaches observation of growth, diversity, and provision. It trains the eye to move from ordinary agriculture and vegetation to gratitude, dependence, and awareness of divine care.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.shukr,
    ],
    relatedRefs: [QuranQuoteRef(surah: 50, ayah: 9, ayahEnd: 11)],
    reflectionPrompts: [
      'What blessing of food or growth have I stopped seeing as a sign of care?',
    ],
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 18,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_animals_24_45',
    ref: QuranQuoteRef(surah: 24, ayah: 45),
    domain: QuranAyahEnrichmentDomain.worldNature,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Animal life reflects diversity in creation',
    summary:
        'The ayah highlights different living forms and movements as signs of Allah’s creative will.',
    body:
        'This verse teaches humility before the diversity of living creatures. It encourages reflection on variety, dependence, and the fact that life unfolds by Allah’s creating and sustaining command.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 6, ayah: 38)],
    reflectionPrompts: [
      'How can observing animals make me more humble before the breadth of Allah’s creation?',
    ],
    displayType: QuranAyahDisplayItemType.signsInCreation,
    displayPriority: 20,
  ),
  QuranAyahEnrichmentEntry(
    id: 'signs_human_creation_23_12_14',
    ref: QuranQuoteRef(surah: 23, ayah: 12, ayahEnd: 14),
    domain: QuranAyahEnrichmentDomain.signsInCreation,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Human creation calls to humility and gratitude',
    summary:
        'These ayahs direct attention to stages of human creation as signs of Allah’s power and wisdom.',
    body:
        'The passage reminds people that human life begins in dependence and unfolds by Allah’s decree. Its primary effect is humility, gratitude, and awareness of being created rather than self-made.',
    tags: [
      QuranAyahEnrichmentTag.signs,
      QuranAyahEnrichmentTag.creation,
      QuranAyahEnrichmentTag.guidance,
    ],
    reflectionPrompts: [
      'How should remembering my created origin affect my pride, gratitude, and sense of responsibility?',
    ],
    interpretationNote:
        'The passage is first a spiritual reminder of dependence, creation, and divine power. Comparisons with modern embryology should stay cautious and secondary.',
    cautionNote:
        'Do not treat these verses as requiring a one-to-one scientific reading. Keep the primary lesson in humility, gratitude, and divine creation.',
    cautionLevel: QuranAyahCautionLevel.scientificCare,
    displayType: QuranAyahDisplayItemType.scientificReflection,
    displayPriority: 26,
  ),
];
