import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry>
seededWorshipRemembranceAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'worship_salah_20_14',
    ref: QuranQuoteRef(surah: 20, ayah: 14),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Prayer establishes remembrance',
    summary:
        'This ayah links worship and remembrance directly, showing that salah is not only ritual form but conscious turning to Allah.',
    body:
        'The verse teaches that prayer is established to remember Allah. This gives salah a clear spiritual purpose: not empty movement, but steady presence, obedience, and recollection of the One being worshipped.',
    tags: [
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 29, ayah: 45)],
    reflectionPrompts: [
      'What would change in my prayer if I entered it more intentionally as remembrance?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 8,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_dhikr_2_152',
    ref: QuranQuoteRef(surah: 2, ayah: 152),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Remember Allah and respond with gratitude',
    summary:
        'The ayah joins remembrance and gratitude, teaching that a remembering heart is not heedless or ungrateful.',
    body:
        'This verse makes dhikr practical. Remembering Allah is not only verbal repetition, but a posture of attention, thankfulness, and refusal to live heedlessly. Dhikr should shape the heart’s direction throughout the day.',
    tags: [
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.shukr,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 62, ayah: 10)],
    reflectionPrompts: [
      'Which moment of my day could become a regular point of remembrance instead of distraction?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 11,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_dua_2_186',
    ref: QuranQuoteRef(surah: 2, ayah: 186),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Supplication begins with nearness',
    summary:
        'This ayah teaches that du’a is grounded in Allah’s nearness, response, and the servant’s sincere turning back.',
    body:
        'The verse gives du’a both comfort and responsibility. Allah is near and responsive, and the servant is called to answer that nearness with faith, receptivity, and humble asking rather than delay or despair.',
    tags: [
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.guidance,
      QuranAyahEnrichmentTag.mercy,
    ],
    relatedRefs: [QuranQuoteRef(surah: 40, ayah: 60)],
    reflectionPrompts: [
      'Do I approach du’a as a real conversation of need, or only as a last resort?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 9,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_gratitude_31_12',
    ref: QuranQuoteRef(surah: 31, ayah: 12),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Gratitude returns benefit to the worshipper',
    summary:
        'The ayah teaches that gratitude is not only praise but a form of wisdom that benefits the servant’s own heart and life.',
    body:
        'This verse makes shukr practical and personal. Gratitude is a wise response to blessing, and its benefit returns to the worshipper through humility, steadiness, and right use of what Allah has given.',
    tags: [
      QuranAyahEnrichmentTag.shukr,
      QuranAyahEnrichmentTag.guidance,
      QuranAyahEnrichmentTag.worship,
    ],
    relatedRefs: [QuranQuoteRef(surah: 14, ayah: 7)],
    reflectionPrompts: [
      'Which blessing should I thank Allah for today by using it more responsibly?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 17,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_patience_2_45',
    ref: QuranQuoteRef(surah: 2, ayah: 45),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Seek help through patience and prayer',
    summary:
        'The ayah teaches that patience and prayer are supports for worshipful endurance, especially when obedience feels heavy.',
    body:
        'This verse makes perseverance in worship concrete. When the soul feels resistance, patience and prayer are not side notes; they are the means by which the servant remains upright, dependent, and obedient.',
    tags: [
      QuranAyahEnrichmentTag.sabr,
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 2, ayah: 153)],
    reflectionPrompts: [
      'Where do I need patience so that worship does not become something I only do when it feels easy?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 13,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_repentance_11_3',
    ref: QuranQuoteRef(surah: 11, ayah: 3),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Repentance is return, not postponement',
    summary:
        'The ayah joins seeking forgiveness and repentance, showing tawbah as an active return that affects the believer’s path.',
    body:
        'This verse teaches that repentance is not abstract regret. It is a real turn toward Allah with hope in His generosity and commitment to renewed obedience. Tawbah becomes a lived correction, not only an emotion.',
    tags: [
      QuranAyahEnrichmentTag.repentance,
      QuranAyahEnrichmentTag.mercy,
      QuranAyahEnrichmentTag.guidance,
      QuranAyahEnrichmentTag.worship,
    ],
    relatedRefs: [QuranQuoteRef(surah: 66, ayah: 8)],
    reflectionPrompts: [
      'What change in action would make my repentance more sincere today?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 10,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_sincerity_98_5',
    ref: QuranQuoteRef(surah: 98, ayah: 5),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Worship is anchored by sincerity',
    summary:
        'This ayah teaches that worship is not accepted as mere outward motion; it is built on sincere devotion directed to Allah alone.',
    body:
        'The verse places ikhlas at the center of worship. A believer does not only perform acts of obedience, but purifies intention so the act is truly for Allah and not for image, habit, or approval.',
    tags: [
      QuranAyahEnrichmentTag.sincerity,
      QuranAyahEnrichmentTag.worship,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 1, ayah: 5)],
    reflectionPrompts: [
      'Which act of worship this week needs more intention and less autopilot?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 7,
  ),
  QuranAyahEnrichmentEntry(
    id: 'worship_reliance_33_3',
    ref: QuranQuoteRef(surah: 33, ayah: 3),
    domain: QuranAyahEnrichmentDomain.worshipRemembrance,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Reliance follows obedience',
    summary:
        'The ayah teaches tawakkul as a trusting dependence on Allah while remaining committed to obedience and guidance.',
    body:
        'This verse does not separate reliance from action. It teaches the servant to obey, remember Allah, and then rely upon Him without anxious self-dependence. Tawakkul steadies the heart after sincere effort.',
    tags: [
      QuranAyahEnrichmentTag.tawakkul,
      QuranAyahEnrichmentTag.guidance,
      QuranAyahEnrichmentTag.worship,
    ],
    relatedRefs: [QuranQuoteRef(surah: 3, ayah: 159)],
    reflectionPrompts: [
      'Where do I need to stop leaning on my own control and practice calmer reliance after doing my part?',
    ],
    displayType: QuranAyahDisplayItemType.worshipLesson,
    displayPriority: 12,
  ),
];
