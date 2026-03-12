import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_quiz_models.dart';

const List<HadithChapterQuiz> seededHadithChapterQuizzes = [
  HadithChapterQuiz(
    id: 'quiz_essential_ch1',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch1_foundations_faith',
    title: 'Chapter Quiz: Foundations of Faith',
    description:
        'Review intention, sincerity, moral clarity, and believing concern for others.',
    quranReflection: QuranConnection(
      surahName: 'Al-Bayyinah',
      surahNumber: 98,
      verseRange: '5',
      label: 'Sincere devotion to Allah',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c1_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which hadith teaches that deeds are judged by intention?',
        options: [
          'Actions are by intentions',
          'The covenant between us and them is prayer',
          'Visit graves for reflection',
          'The strong believer is better than the weak believer',
        ],
        correctAnswer: 'Actions are by intentions',
        explanation:
            'The first essential hadith centers sincerity: every deed is valued by intention before Allah.',
        lessonId: 'intentions_core',
      ),
      HadithQuizQuestion(
        id: 'c1_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'A person gives charity publicly for praise. Which principle is most relevant?',
        options: [
          'Religion is sincerity',
          'The lawful is clear and the unlawful is clear',
          'Love for your brother what you love for yourself',
          'Whoever remains patient, Allah will make him patient',
        ],
        correctAnswer: 'Religion is sincerity',
        explanation:
            'Sincerity is the core of religion. Outward action without sincerity loses spiritual value.',
        lessonId: 'religion_sincerity',
      ),
      HadithQuizQuestion(
        id: 'c1_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text:
            'Complete the phrase: "The lawful is clear and the ____ is clear."',
        options: ['Merciful', 'Unlawful', 'Easy', 'Reward'],
        correctAnswer: 'Unlawful',
        explanation:
            'This hadith teaches clear moral boundaries and warns against doubtful matters.',
        lessonId: 'lawful_unlawful_clear',
      ),
      HadithQuizQuestion(
        id: 'c1_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which Qur\'anic anchor aligns with sincerity of worship in this chapter?',
        options: [
          'Qur\'an 98:5',
          'Qur\'an 87:14-15',
          'Qur\'an 3:185',
          'Qur\'an 4:103',
        ],
        correctAnswer: 'Qur\'an 98:5',
        explanation:
            'Qur\'an 98:5 highlights worship with pure devotion, matching the chapter\'s emphasis on sincere intention.',
        lessonId: 'religion_sincerity',
      ),
      HadithQuizQuestion(
        id: 'c1_q5',
        type: HadithQuizQuestionType.reflection,
        text:
            'Which response best reflects "love for your brother what you love for yourself"?',
        options: [
          'Competing for personal gain without concern',
          'Praying for others and wishing them sincere good',
          'Ignoring people unless they benefit you',
          'Limiting kindness to close friends only',
        ],
        correctAnswer: 'Praying for others and wishing them sincere good',
        explanation:
            'This hadith turns faith into social ethics through sincere goodwill toward others.',
        lessonId: 'love_for_brother',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch2',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch2_worship_practice',
    title: 'Chapter Quiz: Worship & Practice',
    description:
        'Strengthen core prayer foundations, wudu, and reverent practice.',
    quranReflection: QuranConnection(
      surahName: 'Al-Mu\'minun',
      surahNumber: 23,
      verseRange: '1-2',
      label: 'Successful believers are humble in prayer',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c2_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which pillar-hadith includes establishing salah?',
        options: [
          'Islam is built on five',
          'Visit graves for reflection',
          'The scholars are inheritors of prophets',
          'The strong person controls anger',
        ],
        correctAnswer: 'Islam is built on five',
        explanation:
            'Prayer is one of the central pillars in the hadith describing Islam\'s foundation.',
        lessonId: 'islam_built_on_five_prayer',
      ),
      HadithQuizQuestion(
        id: 'c2_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'Someone says prayer is optional as long as their heart is good. Which hadith addresses this most directly?',
        options: [
          'The covenant between us and them is prayer',
          'Part of excellent Islam is leaving what does not concern him',
          'Truthfulness leads to righteousness',
          'Be in this world as a traveler',
        ],
        correctAnswer: 'The covenant between us and them is prayer',
        explanation:
            'This hadith highlights prayer as a defining sign of commitment to faith.',
        lessonId: 'covenant_is_prayer',
      ),
      HadithQuizQuestion(
        id: 'c2_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text: 'Complete: "Pray as you have seen me ____."',
        options: ['Teach', 'Remember', 'Pray', 'Repent'],
        correctAnswer: 'Pray',
        explanation:
            'The Sunnah gives practical form to salah, making the Prophet\'s example central.',
        lessonId: 'pray_as_you_have_seen_me',
      ),
      HadithQuizQuestion(
        id: 'c2_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which verse anchor aligns most with regular prayer at set times?',
        options: [
          'Qur\'an 4:103',
          'Qur\'an 57:20',
          'Qur\'an 99:7-8',
          'Qur\'an 16:90',
        ],
        correctAnswer: 'Qur\'an 4:103',
        explanation:
            'Qur\'an 4:103 stresses prayer as prescribed at appointed times.',
        lessonId: 'first_account_prayer',
      ),
      HadithQuizQuestion(
        id: 'c2_q5',
        type: HadithQuizQuestionType.reflection,
        text:
            'What is the most balanced reading of "whoever makes wudu well, then prays"?',
        options: [
          'Outer form is enough with no heart',
          'Purification and prayer together shape devotion',
          'Only voluntary prayers matter',
          'Wudu is symbolic but unnecessary',
        ],
        correctAnswer: 'Purification and prayer together shape devotion',
        explanation:
            'Careful purification prepares body and heart for attentive worship.',
        lessonId: 'wudu_then_prayer',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch3',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch3_heart_intention',
    title: 'Chapter Quiz: Heart & Intention',
    description: 'Reinforce repentance, focus, and internal reform.',
    quranReflection: QuranConnection(
      surahName: 'Az-Zumar',
      surahNumber: 39,
      verseRange: '53',
      label: 'Do not despair of Allah\'s mercy',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c3_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text:
            'Which hadith teaches spiritual maturity through avoiding the unnecessary?',
        options: [
          'Part of excellent Islam is leaving what does not concern him',
          'The just will be on pulpits of light',
          'Smiling is charity',
          'The merciful are shown mercy',
        ],
        correctAnswer:
            'Part of excellent Islam is leaving what does not concern him',
        explanation:
            'Leaving distractions protects sincerity and preserves spiritual focus.',
        lessonId: 'leave_what_not_concern',
      ),
      HadithQuizQuestion(
        id: 'c3_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'A believer sins, regrets sincerely, and returns to Allah. Which hadith best frames this?',
        options: [
          'Allah rejoices at the repentance of His servant',
          'The best of you are those best to family',
          'Prayer in congregation is superior',
          'The scholars are inheritors of prophets',
        ],
        correctAnswer: 'Allah rejoices at the repentance of His servant',
        explanation:
            'This hadith gives hope and motivates sincere tawbah rather than despair.',
        lessonId: 'repentance_joy',
      ),
      HadithQuizQuestion(
        id: 'c3_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text: 'Complete: "Every son of Adam ____."',
        options: ['forgets', 'sins', 'travels', 'disagrees'],
        correctAnswer: 'sins',
        explanation:
            'Human imperfection is acknowledged, while the door of repentance remains open.',
        lessonId: 'every_son_of_adam_sins',
      ),
      HadithQuizQuestion(
        id: 'c3_q4',
        type: HadithQuizQuestionType.quranConnection,
        text: 'Which verse anchor best matches daily repentance and return?',
        options: [
          'Qur\'an 66:8',
          'Qur\'an 31:14',
          'Qur\'an 49:10',
          'Qur\'an 20:114',
        ],
        correctAnswer: 'Qur\'an 66:8',
        explanation:
            'Qur\'an 66:8 calls believers to sincere repentance, matching this chapter closely.',
        lessonId: 'allah_accepts_repentance_night_day',
      ),
      HadithQuizQuestion(
        id: 'c3_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'What is the best practical takeaway from frequent istighfar?',
        options: [
          'Only seek forgiveness after major sins',
          'Regular repentance keeps the heart soft and alert',
          'Repentance is mainly symbolic speech',
          'Forgiveness is unnecessary if intentions are good',
        ],
        correctAnswer: 'Regular repentance keeps the heart soft and alert',
        explanation:
            'The Prophet\'s frequent istighfar teaches humility and continuous return to Allah.',
        lessonId: 'prophet_sought_forgiveness_daily',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch4',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch4_character_speech',
    title: 'Chapter Quiz: Character & Speech',
    description: 'Practice adab, truthful speech, and emotional discipline.',
    quranReflection: QuranConnection(
      surahName: 'Al-Qalam',
      surahNumber: 68,
      verseRange: '4',
      label: 'The Prophet\'s exalted character',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c4_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which hadith summarizes the Prophet\'s mission in conduct?',
        options: [
          'I was sent to perfect noble character',
          'The dunya is a prison for the believer',
          'Knowledge is an obligation',
          'Visit graves for reflection',
        ],
        correctAnswer: 'I was sent to perfect noble character',
        explanation:
            'Noble character is central to prophetic guidance, not a side topic.',
        lessonId: 'sent_to_perfect_character',
      ),
      HadithQuizQuestion(
        id: 'c4_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'Someone is known for long worship but harsh manners. Which hadith challenges that imbalance?',
        options: [
          'The best of you are those with the best character',
          'The first matter judged is prayer',
          'Every son of Adam sins',
          'A man was forgiven for giving water to a dog',
        ],
        correctAnswer: 'The best of you are those with the best character',
        explanation:
            'Excellent character is a core measure of faith and spiritual maturity.',
        lessonId: 'best_character_among_you',
      ),
      HadithQuizQuestion(
        id: 'c4_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text:
            'Complete: "Whoever believes in Allah and the Last Day should speak ____ or remain silent."',
        options: ['briefly', 'good', 'softly', 'rarely'],
        correctAnswer: 'good',
        explanation:
            'Speech is accountable; silence can be worship when words are harmful.',
        lessonId: 'kind_speech',
      ),
      HadithQuizQuestion(
        id: 'c4_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which verse set most directly supports avoiding mockery and harmful speech?',
        options: [
          'Qur\'an 49:11-12',
          'Qur\'an 3:185',
          'Qur\'an 4:103',
          'Qur\'an 57:20',
        ],
        correctAnswer: 'Qur\'an 49:11-12',
        explanation:
            'Qur\'an 49:11-12 addresses social speech ethics and protecting dignity.',
        lessonId: 'not_insulting_or_cursing',
      ),
      HadithQuizQuestion(
        id: 'c4_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'Which practice best trains truthfulness?',
        options: [
          'Exaggerating for humor',
          'Reviewing one daily conversation for honesty',
          'Avoiding difficult conversations entirely',
          'Speaking quickly before thinking',
        ],
        correctAnswer: 'Reviewing one daily conversation for honesty',
        explanation:
            'Truthfulness is cultivated in daily habits and leads to righteousness.',
        lessonId: 'truthfulness_to_righteousness',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch5',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch5_mercy_relationships',
    title: 'Chapter Quiz: Mercy & Relationships',
    description: 'Apply mercy in family, neighborhood, and community life.',
    quranReflection: QuranConnection(
      surahName: 'Al-Anbiya',
      surahNumber: 21,
      verseRange: '107',
      label: 'Mercy to the worlds',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c5_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which hadith directly links showing mercy and receiving mercy?',
        options: [
          'Whoever does not show mercy will not be shown mercy',
          'The just will be on pulpits of light',
          'Knowledge is an obligation',
          'Remember the destroyer of pleasures',
        ],
        correctAnswer: 'Whoever does not show mercy will not be shown mercy',
        explanation:
            'Mercy is reciprocal in spirit; believers are called to embody it consistently.',
        lessonId: 'no_mercy_no_mercy',
      ),
      HadithQuizQuestion(
        id: 'c5_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'A parent is strict and dismissive at home while kind outside. Which hadith is most corrective?',
        options: [
          'The best of you are those best to their families',
          'The strong believer is better than the weak believer',
          'Part of excellent Islam is leaving what does not concern him',
          'The first matter judged is prayer',
        ],
        correctAnswer: 'The best of you are those best to their families',
        explanation:
            'Prophetic excellence begins at home, where character is tested most deeply.',
        lessonId: 'family_best_to_family',
      ),
      HadithQuizQuestion(
        id: 'c5_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text: 'Complete: "Allah is gentle and loves ____ in all matters."',
        options: ['strength', 'gentleness', 'silence', 'speed'],
        correctAnswer: 'gentleness',
        explanation:
            'Gentleness is not weakness; it is a prophetic method of reform.',
        lessonId: 'gentleness_all_matters',
      ),
      HadithQuizQuestion(
        id: 'c5_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which verse anchor supports mercy-centered leadership and conduct?',
        options: [
          'Qur\'an 3:159',
          'Qur\'an 57:20',
          'Qur\'an 99:7-8',
          'Qur\'an 75:36',
        ],
        correctAnswer: 'Qur\'an 3:159',
        explanation:
            'Qur\'an 3:159 links gentleness and mercy with effective guidance.',
        lessonId: 'mercy_creation',
      ),
      HadithQuizQuestion(
        id: 'c5_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'What is the strongest practical sign of honoring neighbors?',
        options: [
          'Only greeting neighbors during festivals',
          'Protecting them from harm and inconvenience',
          'Avoiding all contact',
          'Advising them publicly in harsh language',
        ],
        correctAnswer: 'Protecting them from harm and inconvenience',
        explanation:
            'Neighbor rights are ongoing ethical duties, not occasional gestures.',
        lessonId: 'honor_your_neighbor',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch6',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch6_discipline_self_control',
    title: 'Chapter Quiz: Discipline & Self-Control',
    description: 'Build patience, gratitude, and emotional strength.',
    quranReflection: QuranConnection(
      surahName: 'Al-Baqarah',
      surahNumber: 2,
      verseRange: '153',
      label: 'Seek help through patience and prayer',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c6_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'According to hadith, true strength is primarily what?',
        options: [
          'Physical dominance',
          'Controlling anger',
          'Public influence',
          'Winning arguments',
        ],
        correctAnswer: 'Controlling anger',
        explanation:
            'Prophetic strength is inner mastery, especially in moments of provocation.',
        lessonId: 'anger_control_strength',
      ),
      HadithQuizQuestion(
        id: 'c6_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'Someone receives bad news and erupts immediately. Which hadith principle applies most?',
        options: [
          'Patience is at the first strike of calamity',
          'The world is a prison for the believer',
          'Whoever cheats us is not among us',
          'Each of you is a shepherd',
        ],
        correctAnswer: 'Patience is at the first strike of calamity',
        explanation: 'The initial response reveals trained patience and trust.',
        lessonId: 'patience_first_strike',
      ),
      HadithQuizQuestion(
        id: 'c6_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text: 'Complete: "Whoever remains patient, Allah will make him ____."',
        options: ['grateful', 'patient', 'strong', 'quiet'],
        correctAnswer: 'patient',
        explanation:
            'Patience is strengthened by divine support when sincerely pursued.',
        lessonId: 'whoever_remains_patient',
      ),
      HadithQuizQuestion(
        id: 'c6_q4',
        type: HadithQuizQuestionType.quranConnection,
        text: 'Which verse anchor aligns with gratitude increasing blessings?',
        options: [
          'Qur\'an 14:7',
          'Qur\'an 25:70',
          'Qur\'an 40:60',
          'Qur\'an 5:8',
        ],
        correctAnswer: 'Qur\'an 14:7',
        explanation:
            'Qur\'an 14:7 reinforces grateful awareness in times of ease.',
        lessonId: 'look_at_those_below',
      ),
      HadithQuizQuestion(
        id: 'c6_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'How should "the strong believer" be understood in this chapter?',
        options: [
          'Only physical strength matters',
          'Faith-strength combines resolve, hope, and effort',
          'Weak believers have no value',
          'Strength means avoiding all hardship',
        ],
        correctAnswer: 'Faith-strength combines resolve, hope, and effort',
        explanation:
            'The hadith values strong, proactive faith while affirming goodness in all believers.',
        lessonId: 'strong_believer_patience',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch7',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch7_knowledge_responsibility',
    title: 'Chapter Quiz: Knowledge & Responsibility',
    description: 'Seek beneficial knowledge and uphold trusts in leadership.',
    quranReflection: QuranConnection(
      surahName: 'Taha',
      surahNumber: 20,
      verseRange: '114',
      label: 'My Lord, increase me in knowledge',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c7_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which hadith frames learning as an obligation?',
        options: [
          'Seeking knowledge is an obligation upon every Muslim',
          'The merciful are shown mercy',
          'Be in this world as a traveler',
          'The grave is the first stage of the hereafter',
        ],
        correctAnswer: 'Seeking knowledge is an obligation upon every Muslim',
        explanation:
            'Beneficial knowledge is a duty, not an optional luxury in Islam.',
        lessonId: 'knowledge_obligation',
      ),
      HadithQuizQuestion(
        id: 'c7_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'A person learns but refuses to teach beneficial basics to others. Which hadith offers correction?',
        options: [
          'The scholars are the inheritors of the prophets',
          'Smiling is charity',
          'The strong person controls anger',
          'Whoever loves to meet Allah',
        ],
        correctAnswer: 'The scholars are the inheritors of the prophets',
        explanation:
            'Inheritance of prophetic knowledge includes conveying benefit responsibly.',
        lessonId: 'scholars_inheritors_prophets',
      ),
      HadithQuizQuestion(
        id: 'c7_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text:
            'Complete: "Each of you is a ____ and each is responsible for his flock."',
        options: ['teacher', 'leader', 'shepherd', 'traveler'],
        correctAnswer: 'shepherd',
        explanation:
            'The hadith emphasizes accountability at every level of responsibility.',
        lessonId: 'each_shepherd',
      ),
      HadithQuizQuestion(
        id: 'c7_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which anchor best fits trust and responsibility in this chapter?',
        options: [
          'Qur\'an 33:72',
          'Qur\'an 94:5-6',
          'Qur\'an 21:107',
          'Qur\'an 13:28',
        ],
        correctAnswer: 'Qur\'an 33:72',
        explanation:
            'Qur\'an 33:72 highlights the trust (amanah), matching ethical responsibility themes.',
        lessonId: 'trust_honesty',
      ),
      HadithQuizQuestion(
        id: 'c7_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'What is the best way to live "seeking knowledge" today?',
        options: [
          'Collect information without practice',
          'Study small portions regularly and apply them',
          'Debate constantly without listening',
          'Wait for ideal conditions before learning',
        ],
        correctAnswer: 'Study small portions regularly and apply them',
        explanation:
            'Beneficial knowledge is steady, practiced, and transformative.',
        lessonId: 'seek_knowledge',
      ),
    ],
  ),
  HadithChapterQuiz(
    id: 'quiz_essential_ch8',
    pathId: 'beginner_40_essential',
    chapterId: 'essential_ch8_life_death_return',
    title: 'Chapter Quiz: Life, Death & Return to Allah',
    description:
        'Conclude with accountability, mortality, and long-view spiritual purpose.',
    quranReflection: QuranConnection(
      surahName: "Aal 'Imran",
      surahNumber: 3,
      verseRange: '185',
      label: 'Every soul shall taste death',
    ),
    questions: [
      HadithQuizQuestion(
        id: 'c8_q1',
        type: HadithQuizQuestionType.multipleChoice,
        text: 'Which hadith captures worldly detachment most directly?',
        options: [
          'Be in this world as a traveler',
          'The merciful are shown mercy',
          'Prayer in congregation is superior',
          'Whoever remains patient',
        ],
        correctAnswer: 'Be in this world as a traveler',
        explanation:
            'The hadith teaches purposeful living without being consumed by dunya.',
        lessonId: 'be_in_world_as_traveler',
      ),
      HadithQuizQuestion(
        id: 'c8_q2',
        type: HadithQuizQuestionType.scenarioBased,
        text:
            'A person postpones repentance because they are still young. Which hadith best responds?',
        options: [
          'The intelligent person prepares for what comes after death',
          'Knowledge is an obligation',
          'Smiling is charity',
          'The just will be on pulpits of light',
        ],
        correctAnswer:
            'The intelligent person prepares for what comes after death',
        explanation:
            'Spiritual intelligence includes timely preparation before life ends.',
        lessonId: 'intelligent_prepares_after_death',
      ),
      HadithQuizQuestion(
        id: 'c8_q3',
        type: HadithQuizQuestionType.fillInPhrase,
        text: 'Complete: "The grave is the first stage of the ____."',
        options: ['world', 'journey', 'hereafter', 'reckoning'],
        correctAnswer: 'hereafter',
        explanation:
            'This hadith orients the believer to accountability beyond worldly life.',
        lessonId: 'grave_first_stage_hereafter',
      ),
      HadithQuizQuestion(
        id: 'c8_q4',
        type: HadithQuizQuestionType.quranConnection,
        text:
            'Which verse pair aligns with accountability for even small deeds?',
        options: [
          'Qur\'an 99:7-8',
          'Qur\'an 13:28',
          'Qur\'an 20:114',
          'Qur\'an 2:43',
        ],
        correctAnswer: 'Qur\'an 99:7-8',
        explanation:
            'Qur\'an 99:7-8 mirrors the chapter\'s focus on precise accountability.',
        lessonId: 'accountability_day_of_judgment',
      ),
      HadithQuizQuestion(
        id: 'c8_q5',
        type: HadithQuizQuestionType.reflection,
        text: 'What is the healthiest intention behind visiting graves?',
        options: [
          'Public display of sadness',
          'Competing over funeral etiquette details',
          'Softening the heart and remembering return to Allah',
          'Avoiding all worldly responsibilities',
        ],
        correctAnswer: 'Softening the heart and remembering return to Allah',
        explanation:
            'The purpose is reflection, humility, and preparation for the hereafter.',
        lessonId: 'visit_graves_reflection',
      ),
    ],
  ),
];
