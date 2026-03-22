import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';

const List<QuranAyahEnrichmentEntry>
seededCharacterAdabAyahEnrichmentEntries = [
  QuranAyahEnrichmentEntry(
    id: 'character_patience_3_200',
    ref: QuranQuoteRef(surah: 3, ayah: 200),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Patience is steady endurance with purpose',
    summary:
        'This ayah calls believers to remain patient, resilient, and God-conscious instead of giving up when difficulty stretches them.',
    body:
        'The verse presents patience as active endurance. It is not passivity, but disciplined steadiness in faith, obedience, and struggle. Sabr shapes conduct by helping a person stay upright when emotions or hardship pull them off course.',
    tags: [QuranAyahEnrichmentTag.sabr, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 2, ayah: 153)],
    reflectionPrompts: [
      'Where do I need more steady patience instead of reacting only to the pressure of the moment?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 14,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_mercy_3_159',
    ref: QuranQuoteRef(surah: 3, ayah: 159),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Mercy appears as gentleness with people',
    summary:
        'This ayah connects mercy with softness, pardon, and gracious dealing rather than harshness and hardness of heart.',
    body:
        'The verse teaches that mercy is visible in how a person treats others. Gentleness, pardon, and sincere concern draw hearts closer, while harshness often pushes people away. Mercy in conduct is therefore a disciplined strength, not weakness.',
    tags: [QuranAyahEnrichmentTag.mercy, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 21, ayah: 107)],
    reflectionPrompts: [
      'Does my way of correcting or advising people show mercy, or mainly irritation and force?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 9,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_justice_5_8',
    ref: QuranQuoteRef(surah: 5, ayah: 8),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Justice must remain firm even with dislike',
    summary:
        'The ayah teaches that justice is not selective. Personal dislike must not push a believer into unfairness.',
    body:
        'This verse makes justice a moral discipline. A believer is not allowed to let hostility, frustration, or tribal instinct distort what is fair. The ayah trains character to be principled even when emotion would prefer retaliation or bias.',
    tags: [QuranAyahEnrichmentTag.justice, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 4, ayah: 135)],
    reflectionPrompts: [
      'Where might personal dislike be making me less fair than I should be?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 8,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_truthfulness_9_119',
    ref: QuranQuoteRef(surah: 9, ayah: 119),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.reminder,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Truthfulness shapes both speech and company',
    summary:
        'This ayah commands God-consciousness alongside keeping company with the truthful, showing honesty as a lived moral environment.',
    body:
        'The verse teaches that truthfulness is more than avoiding direct lies. It is a posture of sincerity, honest speech, and choosing companionship that strengthens integrity instead of hypocrisy or double speech.',
    tags: [QuranAyahEnrichmentTag.sincerity, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 33, ayah: 70)],
    reflectionPrompts: [
      'Do my words become less truthful when I want approval, protection, or advantage?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 11,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_humility_25_63',
    ref: QuranQuoteRef(surah: 25, ayah: 63),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Humility walks calmly and answers with peace',
    summary:
        'This ayah describes humility through calm conduct, dignified walking, and restrained responses when provoked by ignorance.',
    body:
        'The verse teaches that humility is seen in bearing and response. A humble believer is not frantic, arrogant, or eager to escalate. Even when faced with foolishness, the response remains dignified and peaceful rather than loud or contemptuous.',
    tags: [QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 31, ayah: 18)],
    reflectionPrompts: [
      'When I feel slighted, do I respond with calm dignity or with a need to assert myself?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 10,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_forgiveness_24_22',
    ref: QuranQuoteRef(surah: 24, ayah: 22),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Forgiveness is chosen with hope in Allah’s pardon',
    summary:
        'This ayah calls believers to pardon and overlook, tying forgiveness of others to hope in Allah’s forgiveness.',
    body:
        'The verse teaches that forgiveness is not denial of hurt, but a deliberate moral response. By asking whether one loves Allah’s forgiveness, it shifts the heart away from holding tightly to grievance and toward release, pardon, and spiritual maturity.',
    tags: [QuranAyahEnrichmentTag.mercy, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 42, ayah: 43)],
    reflectionPrompts: [
      'What grievance am I carrying that could be softened by remembering my own need for Allah’s pardon?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 12,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_parents_17_23_24',
    ref: QuranQuoteRef(surah: 17, ayah: 23, ayahEnd: 24),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.coreLesson,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Kindness to parents begins with restraint and honor',
    summary:
        'These ayahs make dutiful excellence to parents concrete through respectful speech, humility, care, and prayer for them.',
    body:
        'The passage teaches that family adab is not vague affection. It includes refusing even small words of irritation, speaking nobly, lowering oneself in mercy, and making du’a for one’s parents. Character begins at home in daily treatment.',
    tags: [QuranAyahEnrichmentTag.mercy, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 31, ayah: 14)],
    reflectionPrompts: [
      'Does the way I speak to my parents show honor, or only convenience and impatience?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 7,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_self_restraint_79_40_41',
    ref: QuranQuoteRef(surah: 79, ayah: 40, ayahEnd: 41),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.warning,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Self-restraint protects the soul from unchecked desire',
    summary:
        'These ayahs link fear of standing before Allah with restraining the soul from destructive impulses.',
    body:
        'The passage teaches that self-restraint is an act of faith. A believer remembers accountability and learns to refuse every impulse that demands immediate satisfaction. Moral discipline grows when desire is governed instead of obeyed blindly.',
    tags: [QuranAyahEnrichmentTag.sabr, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 12, ayah: 53)],
    reflectionPrompts: [
      'Which desire most often tries to lead me instead of being guided and restrained?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 13,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_anger_control_3_134',
    ref: QuranQuoteRef(surah: 3, ayah: 134),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.practicalTakeaway,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Controlling anger opens the door to pardon',
    summary:
        'This ayah praises those who restrain anger and pardon people, showing emotional control as part of excellence.',
    body:
        'The verse teaches that anger itself is not the measure of character; what matters is whether it is governed. Restraining anger keeps harm from spreading, and pardon turns an inflamed moment into an opportunity for ihsan and maturity.',
    tags: [
      QuranAyahEnrichmentTag.sabr,
      QuranAyahEnrichmentTag.mercy,
      QuranAyahEnrichmentTag.guidance,
    ],
    relatedRefs: [QuranQuoteRef(surah: 42, ayah: 37)],
    reflectionPrompts: [
      'When I become angry, do I try to control my response before it harms someone else?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 6,
  ),
  QuranAyahEnrichmentEntry(
    id: 'character_good_conduct_41_34',
    ref: QuranQuoteRef(surah: 41, ayah: 34),
    domain: QuranAyahEnrichmentDomain.characterAdab,
    lessonType: QuranAyahEnrichmentLessonType.connection,
    linkStrength: QuranAyahLinkStrength.direct,
    title: 'Good conduct repels harm with what is better',
    summary:
        'This ayah teaches that noble conduct is not reactive imitation; it answers wrong with what is better and more healing.',
    body:
        'The verse gives a demanding standard for dealing with people. Good conduct means rising above the instinct to mirror harm. By responding with what is better, a believer opens the possibility of softened hearts and repaired relationships.',
    tags: [QuranAyahEnrichmentTag.mercy, QuranAyahEnrichmentTag.guidance],
    relatedRefs: [QuranQuoteRef(surah: 23, ayah: 96)],
    reflectionPrompts: [
      'What would it look like to respond to one difficult person this week with what is better instead of what is easier?',
    ],
    displayType: QuranAyahDisplayItemType.characterLesson,
    displayPriority: 15,
  ),
];
