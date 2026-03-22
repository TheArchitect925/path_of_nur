import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry>
seededAkhirahAccountabilityAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'akhirah_judgment_99_6_8',
    ref: QuranQuoteRef(surah: 99, ayah: 6, ayahEnd: 8),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'On the Day of Judgment, deeds will be fully shown',
    summary:
        'These ayahs teach that every person will see the outcome of even the smallest good and the smallest evil.',
    body:
        'The passage makes accountability personal and exact. Nothing meaningful is lost before Allah, whether it is a small act of goodness or a small act of wrongdoing. The believer is taught to take daily choices seriously because they are not forgotten.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 18, ayah: 49)],
    reflectionPrompts: [
      'What small action in my daily life would look more serious if I remembered I will see it again before Allah?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 8,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_deeds_17_13_14',
    ref: QuranQuoteRef(surah: 17, ayah: 13, ayahEnd: 14),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Every person will face their own record',
    summary:
        'These ayahs teach that a person’s deeds are bound to them and will be read openly on the Day of Reckoning.',
    body:
        'The verses teach personal responsibility. A believer cannot finally escape their own record or rely on excuses when the truth of their actions is made clear. This encourages honesty, repentance, and careful living before that day arrives.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 36, ayah: 12)],
    reflectionPrompts: [
      'If I had to read my record today, what habit would I most want to correct first?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 10,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_jannah_13_22_24',
    ref: QuranQuoteRef(surah: 13, ayah: 22, ayahEnd: 24),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Jannah is tied to patient faith and righteous response',
    summary:
        'These ayahs connect the promise of the good end with patience, prayer, generosity, and repelling evil with good.',
    body:
        'The passage presents Paradise not as a vague reward but as the fruit of lived obedience. It gives hope while teaching that preparation for Jannah happens through real conduct, worship, patience, and moral discipline in this life.',
    tags: [QuranAyahEnrichmentTag.sabr, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 41, ayah: 30, ayahEnd: 32)],
    reflectionPrompts: [
      'Which quality named in these ayahs needs more attention in my life if I truly want the good end they describe?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 14,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_jahannam_3_131',
    ref: QuranQuoteRef(surah: 3, ayah: 131),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Warnings about the Fire call the heart to obedience',
    summary:
        'This ayah warns believers to guard themselves from the Fire prepared for the disbelievers.',
    body:
        'The verse is serious without exaggeration. It teaches that the warning of punishment is meant to awaken caution, repentance, and obedience before a person becomes hardened. Fear here is a protection that should move the believer toward Allah, not toward despair.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 66, ayah: 6)],
    reflectionPrompts: [
      'Does hearing a warning from Allah make me correct myself, or do I quickly push it away and continue unchanged?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 11,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_resurrection_22_5_7',
    ref: QuranQuoteRef(surah: 22, ayah: 5, ayahEnd: 7),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Resurrection is taught through created life and return',
    summary:
        'These ayahs connect human origin, growth, death, and revival of the earth to the certainty of resurrection.',
    body:
        'The passage teaches that resurrection should not be treated as remote or impossible. Allah who creates, develops, causes death, and revives the earth is fully able to bring people back. The ayahs connect observable realities to certainty about the Hereafter.',
    tags: [QuranAyahEnrichmentTag.signs, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 36, ayah: 78, ayahEnd: 79)],
    reflectionPrompts: [
      'What in creation reminds me that returning to Allah is certain, not merely symbolic?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 16,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_urgency_59_18',
    ref: QuranQuoteRef(surah: 59, ayah: 18),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Righteousness requires preparation before tomorrow',
    summary:
        'This ayah calls believers to fear Allah and examine what they are sending ahead for the next life.',
    body:
        'The verse teaches urgency without panic. A believer is asked to review their direction now, while change is still possible, rather than delaying righteousness until opportunity narrows. Accountability becomes a reason for honest self-review and timely action.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 82, ayah: 4, ayahEnd: 5)],
    reflectionPrompts: [
      'What am I sending ahead through my habits right now, and what needs to change before more time passes?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 9,
  ),
  QuranAyahEnrichmentEntry(
    id: 'akhirah_dunya_57_20',
    ref: QuranQuoteRef(surah: 57, ayah: 20),
    domain: QuranAyahEnrichmentDomain.akhirahAccountability,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'The dunya can deceive when it becomes the main goal',
    summary:
        'This ayah teaches that worldly life can appear impressive yet pass quickly, while the Hereafter is the lasting reality.',
    body:
        'The verse does not deny the existence of worldly life, but it corrects its place. When dunya becomes the final aim, it deceives. The believer is taught to use this life responsibly while keeping the lasting life with Allah in view.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 87, ayah: 16, ayahEnd: 17)],
    reflectionPrompts: [
      'Where might worldly goals be taking more of my heart than the life I am preparing for?',
    ],
    displayType: QuranAyahDisplayItemType.ayahInsight,
    displayPriority: 13,
  ),
];
