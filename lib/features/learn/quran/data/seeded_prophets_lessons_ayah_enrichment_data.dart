import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry>
seededProphetsLessonsAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'prophets_patience_46_35',
    ref: QuranQuoteRef(surah: 46, ayah: 35),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Prophetic patience is steady, not hurried',
    summary:
        'This ayah calls the Prophet ﷺ to the patient endurance shown by the resolute messengers before him.',
    body:
        'The verse teaches that the prophetic path includes patience under resistance, delay, and hardship. The lesson is not passive waiting, but disciplined steadiness without becoming rash when truth is slow to be accepted.',
    tags: [
      QuranAyahEnrichmentTag.sabr,
      QuranAyahEnrichmentTag.prophets,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 3, ayah: 200)],
    reflectionPrompts: [
      'Where do I need more patient steadiness instead of wanting immediate results?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 12,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_reliance_26_62',
    ref: QuranQuoteRef(surah: 26, ayah: 62),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Trust in Allah remains firm when fear closes in',
    summary:
        'Through Musa عليه السلام, this ayah shows reliance on Allah at a moment when outward escape seemed blocked.',
    body:
        'The lesson here is not denial of danger, but confidence in Allah’s guidance even when the situation appears closed. Reliance becomes clearest when the heart refuses despair and continues to expect Allah’s way forward.',
    tags: [
      QuranAyahEnrichmentTag.tawakkul,
      QuranAyahEnrichmentTag.prophets,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 65, ayah: 3)],
    reflectionPrompts: [
      'When I feel trapped by circumstances, do I still leave room in my heart for Allah’s guidance and opening?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 9,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_submission_2_131',
    ref: QuranQuoteRef(surah: 2, ayah: 131),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Prophetic obedience begins with willing submission',
    summary:
        'This ayah shows Ibrahim عليه السلام answering Allah’s command with immediate submission.',
    body:
        'The lesson is that obedience is not only external compliance. It begins with a heart that yields to Allah willingly and recognizes His lordship without argument or self-centered delay.',
    tags: [QuranAyahEnrichmentTag.prophets, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 6, ayah: 162, ayahEnd: 163)],
    reflectionPrompts: [
      'Where do I still delay obedience instead of responding with the readiness of submission?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 7,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_dawah_71_5_6',
    ref: QuranQuoteRef(surah: 71, ayah: 5, ayahEnd: 6),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Da’wah continues with perseverance even when response is slow',
    summary:
        'Through Nuh عليه السلام, these ayahs show sustained calling despite long resistance from his people.',
    body:
        'The lesson is that truthful calling is measured by faithfulness, not only by immediate response. Perseverance in calling others to truth does not mean changing the message to gain acceptance, but continuing sincerely through disappointment.',
    tags: [QuranAyahEnrichmentTag.prophets, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 16, ayah: 125)],
    reflectionPrompts: [
      'When good advice is not accepted quickly, do I abandon it too fast or continue with patience and sincerity?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 13,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_trials_21_83_84',
    ref: QuranQuoteRef(surah: 21, ayah: 83, ayahEnd: 84),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Trials are met with humble turning to Allah',
    summary:
        'Through Ayyub عليه السلام, these ayahs show suffering met with supplication, humility, and hope in Allah’s mercy.',
    body:
        'The lesson is that hardship does not have to harden the heart. A prophetic response to trial is to turn to Allah honestly, without arrogance or despair, while remaining hopeful in His mercy and wisdom.',
    tags: [
      QuranAyahEnrichmentTag.mercy,
      QuranAyahEnrichmentTag.prophets,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 39, ayah: 53)],
    reflectionPrompts: [
      'When I am tested, do I move closer to Allah in humility or only become more consumed by the hardship itself?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 10,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_leadership_38_26',
    ref: QuranQuoteRef(surah: 38, ayah: 26),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Leadership is a trust that must be ruled by justice',
    summary:
        'Addressing Dawud عليه السلام, this ayah ties leadership to judging with truth and resisting personal desire.',
    body:
        'The lesson is that authority is not permission for self-serving rule. Leadership becomes sound when truth governs decisions and desire is restrained, especially when judging between people.',
    tags: [
      QuranAyahEnrichmentTag.justice,
      QuranAyahEnrichmentTag.prophets,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 5, ayah: 8)],
    reflectionPrompts: [
      'Where I have responsibility over others, am I letting truth lead me or only preference and convenience?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 8,
  ),
  QuranAyahEnrichmentEntry(
    id: 'prophets_rejection_11_89',
    ref: QuranQuoteRef(surah: 11, ayah: 89),
    domain: QuranAyahEnrichmentDomain.prophetsLessons,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Rejecting prophetic guidance carries consequences',
    summary:
        'In the words of Shu’ayb عليه السلام, this ayah warns that stubborn rejection of truth does not end without consequence.',
    body:
        'The lesson is balanced but serious: prophetic warnings are given out of concern, not vengeance. When people persist in rejecting truth after clear calling, they should not assume there will be no consequence before Allah.',
    tags: [QuranAyahEnrichmentTag.prophets, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 7, ayah: 96)],
    reflectionPrompts: [
      'Do I treat clear reminders as mercy and correction, or do I keep resisting until my heart grows harder?',
    ],
    displayType: QuranAyahDisplayItemType.prophetConnection,
    displayPriority: 14,
  ),
];
