import '../models/faq_item.dart';

const faqSeedDataset = FaqDataset(
  version: '0.1',
  app: 'Path of Nur',
  datasetName: 'Islam FAQ Learning Page Dataset',
  notes: <String>[
    'This dataset is intended for educational onboarding and beginner-friendly learning.',
    'Answers are concise by design and should be expandable in-app.',
    'Content should go through a final scholarly review before public release.',
    'Quran references are stored as strings for easy linking to the app\'s Quran module.',
  ],
  categoryLabels: <String, String>{
    'foundations_of_islam': 'Foundations of Islam',
    'worship_and_practice': 'Worship and Practice',
    'misconceptions_about_islam': 'Misconceptions About Islam',
    'women_in_islam': 'Women in Islam',
    'science_and_quran': 'Science and the Qur\'an',
    'quran_and_revelation': 'The Qur\'an and Revelation',
    'prophets_and_history': 'Prophets and History',
    'ethics_and_lifestyle': 'Ethics and Lifestyle',
    'afterlife_and_purpose': 'Afterlife and Purpose',
    'islam_in_the_modern_world': 'Islam in the Modern World',
  },
  fields: <String>[
    'id',
    'category',
    'question',
    'short_answer',
    'answer',
    'quran_refs',
    'hadith_refs',
    'misconception_tag',
    'related_topics',
    'difficulty',
    'is_featured',
  ],
  items: <FaqItem>[
    FaqItem(
      id: 'foundations_001',
      category: 'foundations_of_islam',
      question: 'What does Islam mean?',
      shortAnswer: 'Islam means willing submission to Allah, the one Creator.',
      answer:
          'Islam means submitting oneself to Allah in faith, worship, and obedience. A Muslim is someone who chooses that submission sincerely.',
      quranRefs: <String>['3:19'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['Who is Allah?', 'What is iman?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_002',
      category: 'foundations_of_islam',
      question: 'Who is Allah?',
      shortAnswer:
          'Allah is the one, unique, eternal Creator with no partner or equal.',
      answer:
          'Muslims believe Allah is the one and only God: unique, eternal, independent, and unlike creation. He has no partner, child, or equal.',
      quranRefs: <String>['112:1-4'],
      hadithRefs: <String>[],
      misconceptionTag: 'allah_is_not_a_different_god',
      relatedTopics: <String>['Tawhid', 'What is shirk?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_003',
      category: 'foundations_of_islam',
      question: 'Do Muslims worship the same God as Abraham, Moses, and Jesus?',
      shortAnswer:
          'Yes. Islam teaches worship of the same one God worshipped by the earlier prophets.',
      answer:
          'Islam teaches continuity of revelation. Muslims believe the prophets, including Abraham, Moses, and Jesus, all called people to worship the same one God.',
      quranRefs: <String>['2:136'],
      hadithRefs: <String>[],
      misconceptionTag: 'same_god_of_abrahamic_prophets',
      relatedTopics: <String>['Who is Allah?', 'What is revelation?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_004',
      category: 'foundations_of_islam',
      question: 'Who is Prophet Muhammad ﷺ?',
      shortAnswer:
          'He is the final messenger of Allah, sent to guide humanity.',
      answer:
          'Muslims believe Muhammad ﷺ is the final prophet and messenger, sent with the Qur\'an and as a model of how to live faithfully.',
      quranRefs: <String>['33:40'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['Why follow the Sunnah?', 'What is revelation?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_005',
      category: 'foundations_of_islam',
      question: 'Do Muslims worship Prophet Muhammad ﷺ?',
      shortAnswer: 'No. Muslims worship Allah alone.',
      answer:
          'Muslims love and follow Prophet Muhammad ﷺ, but worship belongs only to Allah. The Prophet ﷺ is a messenger, not divine.',
      quranRefs: <String>['3:144', '41:6'],
      hadithRefs: <String>[],
      misconceptionTag: 'muslims_do_not_worship_muhammad',
      relatedTopics: <String>['Who is Prophet Muhammad ﷺ?', 'What is shirk?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_006',
      category: 'foundations_of_islam',
      question: 'What are the Five Pillars of Islam?',
      shortAnswer:
          'Faith testimony, prayer, charity, fasting Ramadan, and Hajj.',
      answer:
          'The Five Pillars are the Shahadah, Salah, Zakah, Sawm in Ramadan, and Hajj for those able. They are the core outward foundations of Muslim practice.',
      quranRefs: <String>['2:43', '2:183', '3:97'],
      hadithRefs: <String>['Sahih al-Bukhari 8', 'Sahih Muslim 16'],
      misconceptionTag: null,
      relatedTopics: <String>['What is iman?', 'Why do Muslims pray?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'foundations_007',
      category: 'foundations_of_islam',
      question: 'What is iman?',
      shortAnswer:
          'Iman means faith in Allah, His angels, books, messengers, the Last Day, and divine decree.',
      answer:
          'Iman is the inward foundation of belief. It includes belief in Allah, His angels, His books, His messengers, the Last Day, and divine decree.',
      quranRefs: <String>['2:285'],
      hadithRefs: <String>['Sahih Muslim 8'],
      misconceptionTag: null,
      relatedTopics: <String>['What are the Five Pillars?', 'What is ihsan?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'worship_001',
      category: 'worship_and_practice',
      question: 'Why do Muslims pray five times a day?',
      shortAnswer:
          'Prayer keeps a Muslim connected to Allah throughout the day.',
      answer:
          'Salah structures the day around remembrance, discipline, humility, and gratitude. It is both worship and spiritual grounding.',
      quranRefs: <String>['20:14', '29:45'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What are the Five Pillars?',
        'What is khushu\'?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'worship_002',
      category: 'worship_and_practice',
      question: 'Why do Muslims fast in Ramadan?',
      shortAnswer: 'To grow in taqwa, self-control, gratitude, and compassion.',
      answer:
          'Ramadan fasting trains the soul through restraint, remembrance, charity, and Qur\'an. Its purpose is taqwa: conscious awareness of Allah.',
      quranRefs: <String>['2:183-185'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['What is taqwa?', 'Why is Ramadan important?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'worship_003',
      category: 'worship_and_practice',
      question: 'Why do Muslims give zakah?',
      shortAnswer: 'Zakah purifies wealth and supports people in need.',
      answer:
          'Zakah is an act of worship tied to justice, compassion, and responsibility. It purifies wealth from selfishness and helps strengthen the community.',
      quranRefs: <String>['9:103', '2:110'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['What are the Five Pillars?', 'What is sadaqah?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'worship_004',
      category: 'worship_and_practice',
      question: 'Why do Muslims make wudu before prayer?',
      shortAnswer:
          'Wudu prepares a person physically and spiritually for worship.',
      answer:
          'Wudu is ritual purification before salah. It cultivates cleanliness, attentiveness, and readiness to stand before Allah in prayer.',
      quranRefs: <String>['5:6'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['Why do Muslims pray?', 'What breaks wudu?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'worship_005',
      category: 'worship_and_practice',
      question: 'Why is the Qur\'an recited in Arabic during prayer?',
      shortAnswer:
          'Because the Qur\'an was revealed in Arabic and its recited form is preserved that way.',
      answer:
          'Translations help with understanding, but the Qur\'an itself is the revealed Arabic text. In salah, Muslims recite the preserved Qur\'anic wording.',
      quranRefs: <String>['12:2', '43:3'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Why is the Qur\'an in Arabic?',
        'Can I read a translation?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'quran_001',
      category: 'quran_and_revelation',
      question: 'What is the Qur\'an?',
      shortAnswer:
          'The Qur\'an is the final revelation from Allah to Prophet Muhammad ﷺ.',
      answer:
          'Muslims believe the Qur\'an is the direct revelation of Allah, sent to Prophet Muhammad ﷺ over about twenty-three years as guidance for humanity.',
      quranRefs: <String>['2:185', '15:9'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'How was the Qur\'an preserved?',
        'Why is the Qur\'an in Arabic?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'quran_002',
      category: 'quran_and_revelation',
      question: 'Has the Qur\'an been preserved?',
      shortAnswer:
          'Muslims believe Allah preserved the Qur\'an and its recitation.',
      answer:
          'Islam teaches that Allah Himself protected the Qur\'an. Its memorization and written transmission became central to Muslim life from the beginning.',
      quranRefs: <String>['15:9'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What is the Qur\'an?',
        'Why is recitation important?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'quran_003',
      category: 'quran_and_revelation',
      question: 'Why is the Qur\'an in Arabic?',
      shortAnswer:
          'It was revealed in Arabic to the first audience, and that wording is preserved.',
      answer:
          'The Qur\'an came in Arabic because that was the language of the first recipients. Translations communicate meaning, but the Qur\'an itself is the Arabic revelation.',
      quranRefs: <String>['12:2', '43:3'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What is the Qur\'an?',
        'Can I read a translation?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'quran_004',
      category: 'quran_and_revelation',
      question: 'Can a translation be called the Qur\'an?',
      shortAnswer:
          'A translation conveys meaning, but the Qur\'an itself is the Arabic revelation.',
      answer:
          'A translation can help understanding, but it is an interpretation of meaning. The Qur\'an in the strict sense is the revealed Arabic wording.',
      quranRefs: <String>['26:192-195'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Why is the Qur\'an in Arabic?',
        'How should beginners study the Qur\'an?',
      ],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'misconceptions_001',
      category: 'misconceptions_about_islam',
      question: 'Does Islam force people to become Muslim?',
      shortAnswer: 'No. The Qur\'an states there is no compulsion in religion.',
      answer:
          'Faith has meaning only when it is chosen sincerely. The Qur\'an explicitly says there is no compulsion in religion.',
      quranRefs: <String>['2:256'],
      hadithRefs: <String>[],
      misconceptionTag: 'no_compulsion_in_religion',
      relatedTopics: <String>[
        'What is Islam?',
        'How should Muslims speak about faith?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'misconceptions_002',
      category: 'misconceptions_about_islam',
      question: 'Does Islam promote violence?',
      shortAnswer:
          'No. Islam forbids aggression and condemns killing innocents.',
      answer:
          'The Qur\'an permits fighting only within strict limits, such as self-defense, and forbids transgression. Unjust killing is treated as a grave crime.',
      quranRefs: <String>['2:190', '5:32'],
      hadithRefs: <String>[],
      misconceptionTag: 'islam_does_not_promote_violence',
      relatedTopics: <String>[
        'What does jihad mean?',
        'What is justice in Islam?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'misconceptions_003',
      category: 'misconceptions_about_islam',
      question: 'What does jihad actually mean?',
      shortAnswer:
          'Jihad means striving or struggling in a just and disciplined way for Allah\'s sake.',
      answer:
          'Jihad is broader than warfare. It includes moral struggle, speaking truth, self-discipline, and, in limited cases, armed defense under ethical rules.',
      quranRefs: <String>['22:78', '25:52'],
      hadithRefs: <String>[],
      misconceptionTag: 'jihad_not_equivalent_to_terrorism',
      relatedTopics: <String>[
        'Does Islam promote violence?',
        'What is patience in Islam?',
      ],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: true,
    ),
    FaqItem(
      id: 'misconceptions_004',
      category: 'misconceptions_about_islam',
      question: 'Is Islam a new religion?',
      shortAnswer:
          'No. Islam teaches the same core message brought by earlier prophets.',
      answer:
          'Islam sees itself as the continuation and restoration of the message of tawhid taught by Adam, Noah, Abraham, Moses, Jesus, and other prophets.',
      quranRefs: <String>['2:136', '42:13'],
      hadithRefs: <String>[],
      misconceptionTag: 'islam_continuation_of_prophetic_message',
      relatedTopics: <String>[
        'Do Muslims believe in earlier prophets?',
        'What is revelation?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'misconceptions_005',
      category: 'misconceptions_about_islam',
      question: 'Do Muslims hate non-Muslims?',
      shortAnswer:
          'No. Islam commands justice, honesty, and good conduct with others.',
      answer:
          'Islam distinguishes between disagreement in belief and injustice in conduct. The Qur\'an commands fairness and good treatment toward those who are not hostile.',
      quranRefs: <String>['60:8', '16:90'],
      hadithRefs: <String>[],
      misconceptionTag: 'justice_and_good_conduct_with_others',
      relatedTopics: <String>[
        'No compulsion in religion',
        'How should Muslims treat neighbors?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'women_001',
      category: 'women_in_islam',
      question: 'Do women have rights in Islam?',
      shortAnswer:
          'Yes. Islam recognizes women as morally equal and gives them legal and financial rights.',
      answer:
          'The Qur\'an addresses men and women as equal in human worth and accountability before Allah. Women also have rights in marriage, property, inheritance, and learning.',
      quranRefs: <String>['33:35', '4:7', '2:228'],
      hadithRefs: <String>[],
      misconceptionTag: 'women_have_rights_in_islam',
      relatedTopics: <String>[
        'Why do some Muslim women wear hijab?',
        'Marriage in Islam',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'women_002',
      category: 'women_in_islam',
      question: 'Why do some Muslim women wear hijab?',
      shortAnswer:
          'Many wear hijab as an act of modesty, devotion, and identity.',
      answer:
          'Hijab is understood by many Muslim women as obedience to Allah and a visible expression of modesty and dignity. Muslim practice varies by culture and conviction.',
      quranRefs: <String>['24:31', '33:59'],
      hadithRefs: <String>[],
      misconceptionTag: 'hijab_is_not_inherently_oppression',
      relatedTopics: <String>[
        'What is modesty in Islam?',
        'Do men also have modesty rules?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'women_003',
      category: 'women_in_islam',
      question: 'Do men also have rules of modesty in Islam?',
      shortAnswer: 'Yes. Modesty in Islam applies to both men and women.',
      answer:
          'The Qur\'an first instructs believing men to lower their gaze and guard their modesty, then gives guidance to believing women as well.',
      quranRefs: <String>['24:30-31'],
      hadithRefs: <String>[],
      misconceptionTag: 'modesty_applies_to_both_men_and_women',
      relatedTopics: <String>[
        'Why do some Muslim women wear hijab?',
        'What is haya?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'women_004',
      category: 'women_in_islam',
      question: 'Can a woman own property and wealth in Islam?',
      shortAnswer:
          'Yes. A woman can own, manage, inherit, and keep her own property.',
      answer:
          'Islamic law recognizes a woman\'s independent legal and financial identity. Her wealth remains hers and is not automatically controlled by a husband or male relative.',
      quranRefs: <String>['4:7', '4:32'],
      hadithRefs: <String>[],
      misconceptionTag: 'women_can_own_property',
      relatedTopics: <String>[
        'Do women have rights in Islam?',
        'Marriage in Islam',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'science_001',
      category: 'science_and_quran',
      question: 'Is the Qur\'an a science textbook?',
      shortAnswer: 'No. The Qur\'an is a book of guidance, not a lab manual.',
      answer:
          'The Qur\'an invites reflection on nature as signs of Allah, but its primary purpose is guidance, worship, ethics, and remembrance.',
      quranRefs: <String>['3:190-191', '41:53'],
      hadithRefs: <String>[],
      misconceptionTag: 'quran_is_guidance_not_science_textbook',
      relatedTopics: <String>[
        'Does the Qur\'an mention nature?',
        'How should science verses be understood?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'science_002',
      category: 'science_and_quran',
      question: 'Does the Qur\'an encourage reflection on the natural world?',
      shortAnswer: 'Yes. The Qur\'an repeatedly points to creation as signs.',
      answer:
          'The Qur\'an calls people to observe the heavens, earth, life, and history as signs pointing to wisdom, power, and truth.',
      quranRefs: <String>['3:190-191', '51:20-21', '41:53'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Is the Qur\'an a science textbook?',
        'Why does Islam value knowledge?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'prophets_001',
      category: 'prophets_and_history',
      question: 'How many prophets are mentioned in the Qur\'an?',
      shortAnswer: 'The Qur\'an names 25 prophets explicitly.',
      answer:
          'Muslims believe many prophets were sent to humanity, while the Qur\'an explicitly names 25 of them.',
      quranRefs: <String>['4:164', '6:83-86'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Do Muslims believe in Jesus?',
        'Is Islam a new religion?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'prophets_002',
      category: 'prophets_and_history',
      question: 'What does Islam say about Jesus (Isa عليه السلام)?',
      shortAnswer:
          'Jesus is a mighty prophet, Messiah, and miracle-born servant of Allah, not divine.',
      answer:
          'Muslims deeply honor Jesus عليه السلام. Islam teaches he was born miraculously, performed miracles by Allah\'s permission, and called people to worship Allah.',
      quranRefs: <String>['3:45-49', '4:171', '5:75'],
      hadithRefs: <String>[],
      misconceptionTag: 'jesus_honored_but_not_divine',
      relatedTopics: <String>[
        'Do Muslims believe in earlier prophets?',
        'Who is Allah?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'prophets_003',
      category: 'prophets_and_history',
      question: 'Do Muslims believe in Moses and Abraham?',
      shortAnswer: 'Yes. Muslims must believe in all of Allah\'s messengers.',
      answer:
          'Belief in the prophets is part of Islamic faith. Muslims honor Abraham, Moses, Jesus, and many others as real messengers of Allah.',
      quranRefs: <String>['2:136', '2:285'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['Is Islam a new religion?', 'What is iman?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'ethics_001',
      category: 'ethics_and_lifestyle',
      question: 'What is the purpose of life in Islam?',
      shortAnswer: 'To worship Allah and live in faithful obedience to Him.',
      answer:
          'The Qur\'an states that humans and jinn were created to worship Allah. In Islam, worship includes prayer, ethics, service, and every sincere righteous act.',
      quranRefs: <String>['51:56'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['What is ihsan?', 'Why do Muslims pray?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'ethics_002',
      category: 'ethics_and_lifestyle',
      question: 'Does Islam care about character and manners?',
      shortAnswer: 'Yes. Good character is central to Islamic life.',
      answer:
          'Truthfulness, patience, mercy, justice, gratitude, and humility are central Islamic values. Worship without character misses the point.',
      quranRefs: <String>['16:90', '68:4'],
      hadithRefs: <String>['Jami\' at-Tirmidhi 2018'],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Why do Muslims pray?',
        'How should Muslims treat others?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'ethics_003',
      category: 'ethics_and_lifestyle',
      question: 'How should Muslims treat neighbors and strangers?',
      shortAnswer: 'With kindness, fairness, honesty, and respect.',
      answer:
          'Islam teaches believers to uphold justice and excellence in dealings. That includes neighbors, strangers, coworkers, and wider society.',
      quranRefs: <String>['4:36', '16:90'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Do Muslims hate non-Muslims?',
        'What is good character?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'afterlife_001',
      category: 'afterlife_and_purpose',
      question: 'What happens after death in Islam?',
      shortAnswer:
          'Islam teaches resurrection, judgment, and eternal life in the Hereafter.',
      answer:
          'Every soul will die, be resurrected, judged by Allah with perfect justice, and then enter the Hereafter according to Allah\'s mercy and judgment.',
      quranRefs: <String>['3:185', '99:6-8'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What is the purpose of life?',
        'What is the Last Day?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'afterlife_002',
      category: 'afterlife_and_purpose',
      question: 'What is Jannah?',
      shortAnswer:
          'Jannah is Paradise, the eternal reward prepared for the righteous by Allah\'s mercy.',
      answer:
          'Jannah is described as a place of peace, nearness to Allah, joy, and lasting reward beyond worldly imagination.',
      quranRefs: <String>['9:72', '32:17'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['What happens after death?', 'What is taqwa?'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'afterlife_003',
      category: 'afterlife_and_purpose',
      question: 'What is Jahannam?',
      shortAnswer:
          'Jahannam is Hell, a place of punishment and consequence in the Hereafter.',
      answer:
          'The Qur\'an warns of Jahannam as a reality tied to rejection, injustice, and rebellion against Allah. These warnings are meant to awaken moral seriousness.',
      quranRefs: <String>['4:56', '25:65-66'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What happens after death?',
        'What is repentance?',
      ],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'modern_001',
      category: 'islam_in_the_modern_world',
      question: 'Can Islam be practiced in modern life?',
      shortAnswer:
          'Yes. Islam gives timeless principles that apply across times and places.',
      answer:
          'Islam is not limited to a single century or culture. Its core beliefs, ethics, and worship remain constant while many social applications require wisdom and scholarship.',
      quranRefs: <String>['5:3', '16:89'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Why ask scholars?',
        'How do Muslims make decisions today?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'modern_002',
      category: 'islam_in_the_modern_world',
      question: 'Does Islam value knowledge and learning?',
      shortAnswer: 'Yes. Seeking knowledge is deeply rooted in Islam.',
      answer:
          'The Qur\'an repeatedly calls people to think, reflect, remember, and understand. Knowledge is part of faithful living and wise action.',
      quranRefs: <String>['20:114', '39:9', '16:43'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Is the Qur\'an a science textbook?',
        'What is iman?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'modern_003',
      category: 'islam_in_the_modern_world',
      question: 'Why do Muslims ask scholars when they do not know?',
      shortAnswer:
          'Because the Qur\'an instructs people to ask those with knowledge.',
      answer:
          'Islam values learning with humility. When a person does not know, the proper response is to ask qualified people rather than guess about religion.',
      quranRefs: <String>['16:43'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Does Islam value knowledge?',
        'How should beginners learn Islam?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'clarification_001',
      category: 'foundations_of_islam',
      question: 'What is tawhid?',
      shortAnswer:
          'Tawhid is affirming Allah\'s absolute oneness in lordship, worship, and names and attributes.',
      answer:
          'Tawhid is the heart of Islam. It means Allah alone created, sustains, deserves worship, and possesses perfect names and attributes without equal.',
      quranRefs: <String>['112:1-4', '2:163'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>['Who is Allah?', 'What is shirk?'],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'clarification_002',
      category: 'foundations_of_islam',
      question: 'What is shirk?',
      shortAnswer:
          'Shirk is associating partners with Allah in worship or divinity.',
      answer:
          'Shirk is the opposite of tawhid. It includes directing worship, ultimate devotion, or divine qualities to other than Allah.',
      quranRefs: <String>['4:48', '31:13'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What is tawhid?',
        'Do Muslims worship Muhammad?',
      ],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'clarification_003',
      category: 'worship_and_practice',
      question: 'What is halal and haram?',
      shortAnswer: 'Halal means permitted; haram means forbidden.',
      answer:
          'Halal and haram are moral and legal categories in Islam. They shape food, finance, behavior, and lifestyle in ways meant to protect faith and wellbeing.',
      quranRefs: <String>['2:168', '5:87-88'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'What is taqwa?',
        'How do Muslims make decisions?',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: false,
    ),
    FaqItem(
      id: 'clarification_004',
      category: 'worship_and_practice',
      question: 'What is taqwa?',
      shortAnswer:
          'Taqwa is mindful awareness of Allah that leads to careful, faithful living.',
      answer:
          'Taqwa is often described as God-consciousness. It means living with awareness, restraint, sincerity, and fear of displeasing Allah.',
      quranRefs: <String>['2:183', '49:13'],
      hadithRefs: <String>[],
      misconceptionTag: null,
      relatedTopics: <String>[
        'Why fast in Ramadan?',
        'What is the purpose of life?',
      ],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'clarification_005',
      category: 'worship_and_practice',
      question: 'What is ihsan?',
      shortAnswer:
          'Ihsan means worshipping Allah with excellence and awareness.',
      answer:
          'Ihsan is to worship Allah as though you see Him, and if you do not see Him, then know He sees you. It is the inner beauty of faith.',
      quranRefs: <String>['16:90'],
      hadithRefs: <String>['Sahih Muslim 8'],
      misconceptionTag: null,
      relatedTopics: <String>['What is iman?', 'What is taqwa?'],
      difficulty: FaqDifficulty.intermediate,
      isFeatured: false,
    ),
    FaqItem(
      id: 'clarification_006',
      category: 'misconceptions_about_islam',
      question: 'Is Islam against reason and reflection?',
      shortAnswer:
          'No. The Qur\'an repeatedly calls people to think, reflect, and observe.',
      answer:
          'Islam does not ask for blind irrationality. The Qur\'an repeatedly appeals to reflection, understanding, memory, and observation of signs in creation and history.',
      quranRefs: <String>['3:190-191', '10:101', '39:9'],
      hadithRefs: <String>[],
      misconceptionTag: 'islam_encourages_reflection',
      relatedTopics: <String>[
        'Does Islam value knowledge?',
        'Science and the Qur\'an',
      ],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
    FaqItem(
      id: 'clarification_007',
      category: 'misconceptions_about_islam',
      question: 'Is every cultural practice by Muslims part of Islam?',
      shortAnswer:
          'No. Culture and religion overlap, but they are not identical.',
      answer:
          'Muslims live in many cultures. Some practices are religious, some are cultural, and some may even contradict Islam. They should not be confused automatically.',
      quranRefs: <String>['49:13'],
      hadithRefs: <String>[],
      misconceptionTag: 'culture_is_not_identical_to_islam',
      relatedTopics: <String>['Women in Islam', 'Islam in the modern world'],
      difficulty: FaqDifficulty.beginner,
      isFeatured: true,
    ),
  ],
);
