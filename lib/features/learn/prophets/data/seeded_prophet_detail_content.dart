import '../domain/prophet_detail_content.dart';
import '../domain/prophet_entry.dart';

const List<ProphetDetailContent> seededProphetDetailContent = [
  ProphetDetailContent(
    prophetId: 'adam',
    name: 'Adam',
    arabicName: 'آدم',
    eraTitle: 'Early Humanity',
    regionLabel: 'Early Earth / Symbolic Human Beginning',
    shortSummary:
        'The first human and first prophet, created by Allah and taught knowledge, then guided through repentance after error.',
    overview:
        'Adam is the first human being and the first prophet in Islamic belief. Allah created him from clay, taught him knowledge, and honored him before the angels. His story marks the beginning of human life on earth and teaches that human beings can fall into error, but the path back to Allah is always opened through sincere repentance.',
    storySections: [
      ProphetStorySection(
        title: 'Creation and Honor',
        content:
            'Allah created Adam from clay and taught him names and knowledge that the angels did not know. This showed the special place of knowledge in the human story and the honor Allah gave to Adam.',
      ),
      ProphetStorySection(
        title: 'The Refusal of Iblis',
        content:
            'When Allah commanded the angels to bow in respect to Adam, Iblis refused out of arrogance. His pride became the beginning of his downfall and a warning against self-importance.',
      ),
      ProphetStorySection(
        title: 'Life in Paradise',
        content:
            'Adam and his wife were allowed to live in Paradise and enjoy its blessings, but they were told not to approach a specific tree. This was a test of obedience.',
      ),
      ProphetStorySection(
        title: 'The Slip and the Descent',
        content:
            'Shaytan whispered to Adam and his wife until they ate from the forbidden tree. They were then sent down to earth, beginning the earthly human journey of struggle, worship, and return.',
      ),
      ProphetStorySection(
        title: 'Repentance and Mercy',
        content:
            'Adam did not persist in pride. He turned back to Allah, received words of repentance, and Allah accepted his tawbah. His story teaches that falling is not the end if one returns sincerely.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Knowledge is a Divine Gift',
        description:
            'Adam\'s story begins with knowledge, showing that learning is central to human dignity and responsibility.',
      ),
      ProphetLesson(
        title: 'Arrogance Destroys',
        description:
            'Iblis fell not because of ignorance, but because of pride.',
      ),
      ProphetLesson(
        title: 'Repentance Restores',
        description:
            'Human beings make mistakes, but sincere repentance brings them back to Allah.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '30-39',
        label: 'Creation of Adam, knowledge, and repentance',
        startAyah: 30,
      ),
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '11-27',
        label: 'Command to bow and temptation by Shaytan',
        startAyah: 11,
      ),
      QuranReferenceItem(
        surahName: 'Al-Hijr',
        surahNumber: 15,
        verseRange: '26-44',
        label: 'Creation of Adam and refusal of Iblis',
        startAyah: 26,
      ),
      QuranReferenceItem(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '115-123',
        label: 'The slip, descent, and guidance',
        startAyah: 115,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '71-85',
        label: 'Creation and arrogance of Iblis',
        startAyah: 71,
      ),
    ],
    reflectionPrompts: [
      'When I make mistakes, do I respond with excuses or with repentance?',
      'Where does pride quietly try to enter my life?',
      'How am I using the gift of knowledge?',
    ],
    relatedProphetIds: ['nuh', 'ibrahim'],
    relatedLifeLessonIds: ['repentance', 'humility', 'knowledge', 'obedience'],
    relatedGrowthHabitIds: [
      'make_dua_daily',
      'daily_istighfar',
      'study_islamic_knowledge',
    ],
    locationLabel: 'Early Earth / Symbolic Human Beginning',
    locationConfidence: ProphetLocationConfidence.symbolic,
  ),
  ProphetDetailContent(
    prophetId: 'idris',
    name: 'Idris',
    arabicName: 'إدريس',
    eraTitle: 'Early Humanity',
    regionLabel: 'Mesopotamia Region (Traditional / Approximate)',
    shortSummary:
        'A truthful and patient prophet remembered for righteousness and being raised to a high station.',
    overview:
        'Idris is among the early prophets mentioned in the Qur\'an with honor and brevity. Though the Qur\'anic narrative about him is concise, he is praised for truthfulness, patience, and righteousness. His story reminds the reader that some of Allah\'s most honored servants are known not through lengthy narrative detail, but through the clarity of their character.',
    storySections: [
      ProphetStorySection(
        title: 'A Truthful Servant',
        content:
            'The Qur\'an describes Idris as truthful, which marks him as a prophet of sincerity and reliability in speech and faith.',
      ),
      ProphetStorySection(
        title: 'Patience and Righteousness',
        content:
            'He is also counted among the patient and righteous, indicating a life of constancy, obedience, and endurance.',
      ),
      ProphetStorySection(
        title: 'Raised to a High Station',
        content:
            'The Qur\'an states that Allah raised Idris to a high station, a phrase that conveys honor and special rank.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Truthfulness Elevates',
        description:
            'Idris teaches that truthfulness is not a small virtue but a mark of prophetic nobility.',
      ),
      ProphetLesson(
        title: 'Quiet Righteousness Matters',
        description:
            'A life may be brief in public narrative yet immense in the sight of Allah.',
      ),
      ProphetLesson(
        title: 'Patience is a Prophetic Quality',
        description:
            'Steadfastness and endurance are recurring marks of those close to Allah.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '56-57',
        label: 'Truthfulness and elevated station',
        startAyah: 56,
      ),
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '85-86',
        label: 'Mention among the patient and righteous',
        startAyah: 85,
      ),
    ],
    reflectionPrompts: [
      'How much do I value truthfulness in daily life?',
      'What forms of quiet righteousness go unnoticed by people but are seen by Allah?',
      'How does patience shape a person\'s spiritual rank?',
    ],
    relatedProphetIds: ['adam', 'nuh', 'alyasa'],
    relatedLifeLessonIds: [
      'truthfulness',
      'patience',
      'sincerity',
      'righteousness',
    ],
    relatedGrowthHabitIds: [
      'daily_istighfar',
      'make_dua_daily',
      'practice_humility',
    ],
    locationLabel: 'Mesopotamia Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'nuh',
    name: 'Nuh',
    arabicName: 'نوح',
    eraTitle: 'Early Civilizations',
    regionLabel: 'Mesopotamia Region (Traditional / Approximate)',
    shortSummary:
        'A prophet of extraordinary patience who called his people to Allah for many years despite rejection and mockery.',
    overview:
        'Nuh was sent to a people who had fallen deeply into shirk and idol worship. He called them to worship Allah alone with persistence, wisdom, and compassion. His story is one of patience, rejection, warning, the ark, and ultimate trust in Allah\'s command.',
    storySections: [
      ProphetStorySection(
        title: 'The Call to His People',
        content:
            'Nuh called his people to leave idol worship and return to Allah alone. He preached openly and privately, by day and by night, for a very long time.',
      ),
      ProphetStorySection(
        title: 'Years of Rejection',
        content:
            'Most of his people responded with denial, ridicule, and stubbornness. They rejected his message even after repeated reminders and warnings.',
      ),
      ProphetStorySection(
        title: 'The Ark',
        content:
            'Allah instructed Nuh to build an ark under divine guidance. Even as he built it, his people mocked him, unable to see the storm that was coming.',
      ),
      ProphetStorySection(
        title: 'The Flood',
        content:
            'When Allah\'s command came, the flood overwhelmed the land. Those who believed were saved in the ark, while the rejectors were destroyed.',
      ),
      ProphetStorySection(
        title: 'A Personal Test',
        content:
            'Nuh\'s story includes the painful reality that even his own son did not believe. This teaches that guidance cannot be forced, even by the most sincere of callers.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Patience in Da\'wah',
        description:
            'Nuh teaches that truth may require years of patience without visible results.',
      ),
      ProphetLesson(
        title: 'Guidance Belongs to Allah',
        description:
            'Even a prophet cannot force faith into the heart of another person.',
      ),
      ProphetLesson(
        title: 'Trust the Command of Allah',
        description:
            'Building the ark before the flood required trust before evidence became visible.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '59-64',
        label: 'Call to his people',
        startAyah: 59,
      ),
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '25-49',
        label: 'Ark, flood, and dialogue with his people',
        startAyah: 25,
      ),
      QuranReferenceItem(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '23-30',
        label: 'Warning and salvation',
        startAyah: 23,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '105-122',
        label: 'Rejection of Nuh\'s message',
        startAyah: 105,
      ),
      QuranReferenceItem(
        surahName: 'Al-Qamar',
        surahNumber: 54,
        verseRange: '9-16',
        label: 'The flood',
        startAyah: 9,
      ),
      QuranReferenceItem(
        surahName: 'Nuh',
        surahNumber: 71,
        verseRange: '1-28',
        label: 'Entire surah about his call and people',
        startAyah: 1,
      ),
    ],
    reflectionPrompts: [
      'How do I react when my efforts are ignored or misunderstood?',
      'What does patience with purpose look like in my life?',
      'Do I remain sincere even when results are slow?',
    ],
    relatedProphetIds: ['adam', 'ibrahim', 'musa'],
    relatedLifeLessonIds: [
      'patience',
      'trust_in_allah',
      'steadfastness',
      'calling_to_good',
    ],
    relatedGrowthHabitIds: [
      'practice_patience',
      'make_dua_daily',
      'read_quran_daily',
    ],
    locationLabel: 'Mesopotamia Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'ibrahim',
    name: 'Ibrahim',
    arabicName: 'إبراهيم',
    eraTitle: 'Age of Ibrahim',
    regionLabel: 'Iraq / Palestine / Arabia (Traditional / Approximate)',
    shortSummary:
        'A model of faith, courage, and surrender who challenged falsehood and trusted Allah through great tests.',
    overview:
        'Ibrahim is one of the greatest prophets in Islam and a central figure in the history of tawhid. He rejected idol worship, reasoned with his people, endured persecution, and showed complete submission to Allah. His life is tied to the Ka\'bah, sacrifice, family legacy, and the pure path of monotheism.',
    storySections: [
      ProphetStorySection(
        title: 'Questioning False Worship',
        content:
            'Ibrahim grew up among people devoted to idols. He reflected deeply on the nature of truth and rejected worship of created things.',
      ),
      ProphetStorySection(
        title: 'Breaking the Idols',
        content:
            'He shattered the idols of his people except the largest one, exposing the weakness of what they worshipped and forcing them to confront the emptiness of their beliefs.',
      ),
      ProphetStorySection(
        title: 'Thrown into the Fire',
        content:
            'His people responded with anger and cast him into a great fire. Allah saved him, showing that those who stand for truth are never abandoned by their Lord.',
      ),
      ProphetStorySection(
        title: 'The Test of Sacrifice',
        content:
            'Ibrahim saw in a dream that he must sacrifice his son. He and his son both submitted to Allah\'s command, and Allah replaced the sacrifice with a ram, honoring their surrender.',
      ),
      ProphetStorySection(
        title: 'Building the Ka\'bah',
        content:
            'Ibrahim and Ismail raised the foundations of the Ka\'bah and prayed that their work be accepted. This tied his mission directly to the sacred center of worship.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Tawhid Above All',
        description:
            'Ibrahim teaches clear devotion to Allah alone without compromise.',
      ),
      ProphetLesson(
        title: 'Courage Against Falsehood',
        description:
            'He stood for truth even when it isolated him from his society.',
      ),
      ProphetLesson(
        title: 'Submission is Strength',
        description:
            'His life shows that surrender to Allah is not weakness, but the highest form of strength.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '124-141',
        label: 'Tests, Ka\'bah, and legacy',
        startAyah: 124,
      ),
      QuranReferenceItem(
        surahName: 'Al-An\'am',
        surahNumber: 6,
        verseRange: '74-83',
        label: 'Reasoning about false worship',
        startAyah: 74,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '41-50',
        label: 'Dialogue with his father',
        startAyah: 41,
      ),
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '51-73',
        label: 'Idols and the fire',
        startAyah: 51,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '69-104',
        label: 'Debate with his people',
        startAyah: 69,
      ),
      QuranReferenceItem(
        surahName: 'As-Saffat',
        surahNumber: 37,
        verseRange: '83-113',
        label: 'Sacrifice and glad tidings',
        startAyah: 83,
      ),
      QuranReferenceItem(
        surahName: 'Ibrahim',
        surahNumber: 14,
        verseRange: '35-41',
        label: 'Supplications of Ibrahim',
        startAyah: 35,
      ),
    ],
    reflectionPrompts: [
      'What false priorities compete with devotion to Allah in modern life?',
      'Where do I need more courage in holding to truth?',
      'What would deeper surrender to Allah look like for me?',
    ],
    relatedProphetIds: ['ismail', 'ishaq', 'musa', 'muhammad'],
    relatedLifeLessonIds: [
      'tawakkul',
      'courage',
      'sincerity',
      'sacrifice',
      'tawhid',
    ],
    relatedGrowthHabitIds: [
      'make_dua_daily',
      'give_charity',
      'practice_humility',
      'read_quran_daily',
    ],
    locationLabel: 'Iraq / Palestine / Arabia (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'yusuf',
    name: 'Yusuf',
    arabicName: 'يوسف',
    eraTitle: 'Children of Israel',
    regionLabel: 'Canaan and Egypt (Traditional / Approximate)',
    shortSummary:
        'A prophet whose life moved from jealousy and betrayal to dignity, wisdom, and forgiveness.',
    overview:
        'Yusuf, the son of Yaqub, is the center of one of the most detailed stories in the Qur\'an. His life includes dreams, jealousy, betrayal, temptation, prison, political responsibility, and reunion. His story is a deep lesson in patience, purity, trust, and forgiveness.',
    storySections: [
      ProphetStorySection(
        title: 'The Dream and Jealousy',
        content:
            'Yusuf shared a meaningful dream with his father, who recognized its significance. His brothers became jealous of the love and promise they saw around him.',
      ),
      ProphetStorySection(
        title: 'The Well and Separation',
        content:
            'His brothers cast him into a well and he was later taken away into Egypt. This began a chain of hardship that seemed dark on the surface but was unfolding under Allah\'s plan.',
      ),
      ProphetStorySection(
        title: 'Temptation and Integrity',
        content:
            'Yusuf faced seduction and social pressure but chose obedience to Allah over desire. His moral strength became one of the central lessons of his story.',
      ),
      ProphetStorySection(
        title: 'Prison and Wisdom',
        content:
            'Though innocent, Yusuf was imprisoned. Even there he remained truthful, insightful, and connected to Allah, eventually interpreting dreams for others.',
      ),
      ProphetStorySection(
        title: 'Rise, Reunion, and Forgiveness',
        content:
            'Yusuf was eventually elevated to authority in Egypt. When his brothers came before him in need, he forgave them instead of taking revenge, completing his story with mercy and dignity.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Patience Through Hidden Wisdom',
        description:
            'Yusuf shows that hardship may hide a future mercy beyond what we can see.',
      ),
      ProphetLesson(
        title: 'Purity Under Pressure',
        description:
            'His resistance to temptation teaches moral strength in private and public.',
      ),
      ProphetLesson(
        title: 'Forgiveness is a Form of Nobility',
        description:
            'Yusuf had power, yet chose mercy when the chance for revenge arrived.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Yusuf',
        surahNumber: 12,
        verseRange: '4-101',
        label: 'Main narrative of Yusuf',
        startAyah: 4,
      ),
    ],
    reflectionPrompts: [
      'How do I respond when I am treated unfairly?',
      'What helps a person remain clean-hearted under temptation?',
      'Where in my life do I need to choose forgiveness over resentment?',
    ],
    relatedProphetIds: ['yaqub', 'ibrahim', 'musa'],
    relatedLifeLessonIds: [
      'patience',
      'forgiveness',
      'chastity',
      'trust_in_allah',
    ],
    relatedGrowthHabitIds: [
      'practice_patience',
      'end_day_with_reflection_and_tawbah',
      'read_quran_daily',
    ],
    locationLabel: 'Canaan and Egypt (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'musa',
    name: 'Musa',
    arabicName: 'موسى',
    eraTitle: 'Children of Israel',
    regionLabel: 'Egypt and Sinai',
    shortSummary:
        'A prophet of courage, leadership, and reliance on Allah who confronted tyranny and guided a people through trial.',
    overview:
        'Musa is the most mentioned prophet in the Qur\'an. His life includes rescue in infancy, confrontation with Pharaoh, revelation at Mount Sinai, miracles, struggle, leadership, and repeated lessons in trust and responsibility. His story is one of courage before power and dependence on Allah through intense trials.',
    storySections: [
      ProphetStorySection(
        title: 'Birth Under Tyranny',
        content:
            'Musa was born in a time when Pharaoh was slaughtering the sons of the Israelites. Allah inspired his mother to place him in the river, and he was raised in Pharaoh\'s own household.',
      ),
      ProphetStorySection(
        title: 'Leaving Egypt',
        content:
            'After an unintended killing, Musa left Egypt in fear and uncertainty. In exile he found shelter, work, and a path toward the mission Allah had prepared for him.',
      ),
      ProphetStorySection(
        title: 'The Call at the Fire',
        content:
            'At Mount Sinai, Musa heard the call of Allah and was chosen as a messenger. He was given signs and commanded to confront Pharaoh.',
      ),
      ProphetStorySection(
        title: 'Confronting Pharaoh',
        content:
            'Musa and Harun stood before one of history\'s great tyrants and called him to truth. Allah supported Musa with clear signs, yet Pharaoh persisted in arrogance.',
      ),
      ProphetStorySection(
        title: 'Deliverance and Ongoing Trial',
        content:
            'Allah saved Musa and the Children of Israel through the parted sea, but their journey remained filled with tests, weakness, ingratitude, and lessons in obedience.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Courage Before Oppression',
        description:
            'Musa teaches that truth must be spoken even before immense worldly power.',
      ),
      ProphetLesson(
        title: 'Leadership Requires Patience',
        description:
            'Guiding people is not only about strength, but endurance, wisdom, and returning to Allah.',
      ),
      ProphetLesson(
        title: 'Reliance on Allah in Uncertainty',
        description:
            'Again and again, Musa moved forward through situations where only Allah could open the way.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '49-61',
        label: 'Deliverance and the Israelites',
        startAyah: 49,
      ),
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '103-160',
        label: 'Signs, Pharaoh, and the sea',
        startAyah: 103,
      ),
      QuranReferenceItem(
        surahName: 'Yunus',
        surahNumber: 10,
        verseRange: '75-93',
        label: 'Musa and Pharaoh',
        startAyah: 75,
      ),
      QuranReferenceItem(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '9-98',
        label: 'Call of Musa and confrontation with Pharaoh',
        startAyah: 9,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '10-68',
        label: 'Mission to Pharaoh and the sea',
        startAyah: 10,
      ),
      QuranReferenceItem(
        surahName: 'Al-Qasas',
        surahNumber: 28,
        verseRange: '3-46',
        label: 'Birth, exile, and mission',
        startAyah: 3,
      ),
    ],
    reflectionPrompts: [
      'What fears stop people from standing for what is right?',
      'How do I act when responsibility feels heavy?',
      'Where in my life do I need to trust Allah before the path is fully visible?',
    ],
    relatedProphetIds: ['harun', 'ibrahim', 'yusuf', 'muhammad'],
    relatedLifeLessonIds: [
      'courage',
      'leadership',
      'patience',
      'trust_in_allah',
      'justice',
    ],
    relatedGrowthHabitIds: [
      'study_islamic_knowledge',
      'practice_patience',
      'make_dua_daily',
      'read_quran_daily',
    ],
    locationLabel: 'Egypt and Sinai',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'shuayb',
    name: 'Shu\'ayb',
    arabicName: 'شعيب',
    eraTitle: 'Post-Flood Peoples',
    regionLabel: 'Madyan Region (Traditional / Approximate)',
    shortSummary:
        'A prophet who called his people to honesty, justice, and fairness, especially in trade and public dealings.',
    overview:
        'Shu\'ayb was sent to the people of Madyan, who were known for corruption in trade, dishonesty in measure, and social wrongdoing. His message highlights moral economics, fairness, justice, and integrity in dealing with others. His story is especially powerful because it connects worship of Allah with honesty in society.',
    storySections: [
      ProphetStorySection(
        title: 'A People Corrupted in Dealings',
        content:
            'The people of Madyan were not only astray in belief but corrupt in commerce and public behavior. Their dishonesty had become normalized.',
      ),
      ProphetStorySection(
        title: 'Call to Justice and Honesty',
        content:
            'Shu\'ayb called them to worship Allah and to give full measure and weight fairly. His message joined faith and ethics inseparably.',
      ),
      ProphetStorySection(
        title: 'Mockery and Resistance',
        content:
            'His people resisted him and treated economic honesty as an inconvenience rather than a moral obligation.',
      ),
      ProphetStorySection(
        title: 'The Consequence of Corruption',
        content:
            'Because they persisted in corruption after warning, divine punishment overtook them. Their story is a warning that injustice in public life is not small in the sight of Allah.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Faith and Ethics Cannot Be Separated',
        description:
            'Shu\'ayb teaches that worship is not real if dishonesty rules business and public conduct.',
      ),
      ProphetLesson(
        title: 'Corruption Often Hides in Everyday Transactions',
        description:
            'Small injustices repeated in trade and behavior become societal corruption.',
      ),
      ProphetLesson(
        title: 'Justice is a Form of Worship',
        description: 'Fairness in dealings is part of obedience to Allah.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '85-93',
        label: 'Call to honesty and justice',
        startAyah: 85,
      ),
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '84-95',
        label: 'Madyan and corruption in trade',
        startAyah: 84,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '176-191',
        label: 'Warning to the people',
        startAyah: 176,
      ),
    ],
    reflectionPrompts: [
      'How does honesty show up in the smallest daily transactions?',
      'Why do people separate faith from ethics in public life?',
      'What injustices become normal simply because they are common?',
    ],
    relatedProphetIds: ['salih', 'hud', 'musa'],
    relatedLifeLessonIds: ['justice', 'honesty', 'social_ethics', 'integrity'],
    relatedGrowthHabitIds: [
      'help_someone',
      'practice_humility',
      'avoid_harmful_speech',
    ],
    locationLabel: 'Madyan Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'lut',
    name: 'Lut',
    arabicName: 'لوط',
    eraTitle: 'Age of Ibrahim',
    regionLabel: 'Region of Sodom (Traditional / Approximate)',
    shortSummary:
        'A prophet who stood firmly for moral truth in the face of corruption, mockery, and social decay.',
    overview:
        'Lut was sent to a people who had sunk into serious moral corruption and shameless wrongdoing. He called them to purity, righteousness, and fear of Allah, but they rejected him and persisted in their evil. His story is a warning about corruption becoming normalized and a lesson in standing for truth even when surrounded by decay.',
    storySections: [
      ProphetStorySection(
        title: 'A People in Moral Decline',
        content:
            'Lut was sent to a society that openly committed grave wrongdoing and had become proud of its corruption. What should have been shameful had become normalized among them.',
      ),
      ProphetStorySection(
        title: 'The Call to Purity',
        content:
            'He called his people to leave their indecency and return to what is pure and lawful. His message was not only a rejection of sin, but a call to restore dignity and obedience to Allah.',
      ),
      ProphetStorySection(
        title: 'Mockery and Rejection',
        content:
            'Instead of listening, his people mocked him and treated righteousness itself as strange. This is one of the painful patterns repeated in prophetic history.',
      ),
      ProphetStorySection(
        title: 'The Guests and the Final Warning',
        content:
            'When the angels came in the form of guests, the corruption of Lut\'s people became fully exposed. The moment of judgment was near.',
      ),
      ProphetStorySection(
        title: 'Rescue and Destruction',
        content:
            'Allah rescued Lut and the believers with him, while the corrupt people were destroyed. The story closes as a severe warning against moral arrogance and persistent sin.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Truth Can Feel Lonely',
        description:
            'Lut teaches that righteousness may stand isolated when corruption becomes common.',
      ),
      ProphetLesson(
        title: 'Normalization Does Not Make Wrong Right',
        description:
            'A society repeating a sin does not change its reality before Allah.',
      ),
      ProphetLesson(
        title: 'Moral Courage Matters',
        description:
            'Calling to what is right often requires steadiness under pressure and mockery.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '80-84',
        label: 'Call of Lut and destruction of his people',
        startAyah: 80,
      ),
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '77-83',
        label: 'The guests and final punishment',
        startAyah: 77,
      ),
      QuranReferenceItem(
        surahName: 'Al-Hijr',
        surahNumber: 15,
        verseRange: '57-77',
        label: 'The angels and destruction',
        startAyah: 57,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '160-175',
        label: 'Lut\'s warning to his people',
        startAyah: 160,
      ),
      QuranReferenceItem(
        surahName: 'An-Naml',
        surahNumber: 27,
        verseRange: '54-58',
        label: 'Moral corruption and punishment',
        startAyah: 54,
      ),
    ],
    reflectionPrompts: [
      'How should a person hold onto truth when wrongdoing becomes socially accepted?',
      'Where do people confuse popularity with morality?',
      'What helps a believer remain clear-hearted in a corrupted environment?',
    ],
    relatedProphetIds: ['ibrahim', 'nuh', 'yusuf'],
    relatedLifeLessonIds: [
      'moral_courage',
      'purity',
      'steadfastness',
      'truthfulness',
    ],
    relatedGrowthHabitIds: [
      'practice_humility',
      'avoid_harmful_speech',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Region of Sodom (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'ismail',
    name: 'Ismail',
    arabicName: 'إسماعيل',
    eraTitle: 'Age of Ibrahim',
    regionLabel: 'Arabia / Makkah (Traditional)',
    shortSummary:
        'A prophet of obedience, patience, and devotion whose life is closely tied to sacrifice and the Ka\'bah.',
    overview:
        'Ismail, the son of Ibrahim, is remembered for his patience, truthfulness, and willingness to submit to Allah. His story is tied to some of the most sacred moments in Islamic history, including the test of sacrifice and the raising of the foundations of the Ka\'bah.',
    storySections: [
      ProphetStorySection(
        title: 'A Blessed Son',
        content:
            'Ismail was a son given to Ibrahim after longing and prayer. His life would become central to the spiritual legacy of his father.',
      ),
      ProphetStorySection(
        title: 'The Test of Sacrifice',
        content:
            'When Ibrahim saw in a dream that he must sacrifice his son, Ismail responded with patience and surrender. Their shared submission became one of the most powerful moments in prophetic history.',
      ),
      ProphetStorySection(
        title: 'Replaced by Mercy',
        content:
            'Allah did not intend destruction, but obedience. The sacrifice was replaced, and the event became a lasting sign of sincere submission.',
      ),
      ProphetStorySection(
        title: 'Building the Ka\'bah',
        content:
            'Ibrahim and Ismail raised the foundations of the Ka\'bah together, praying that their deed be accepted and that guidance continue through future generations.',
      ),
      ProphetStorySection(
        title: 'Truthfulness and Prayer',
        content:
            'The Qur\'an praises Ismail for being true to his promise and for encouraging prayer and devotion among his people.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Submission Brings Honor',
        description:
            'Ismail\'s greatness lies in his willing obedience to Allah.',
      ),
      ProphetLesson(
        title: 'Patience is Strength',
        description:
            'His calm acceptance of trial reflects inner strength, not passivity.',
      ),
      ProphetLesson(
        title: 'Legacy is Built Through Worship',
        description:
            'His role in the Ka\'bah shows that sacred legacy is built through obedience and service.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '125-129',
        label: 'Ka\'bah and supplication of Ibrahim and Ismail',
        startAyah: 125,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '54-55',
        label: 'Truthfulness and devotion',
        startAyah: 54,
      ),
      QuranReferenceItem(
        surahName: 'As-Saffat',
        surahNumber: 37,
        verseRange: '100-111',
        label: 'The sacrifice test',
        startAyah: 100,
      ),
    ],
    reflectionPrompts: [
      'What does real submission to Allah look like when life becomes difficult?',
      'How can worship become part of a family legacy?',
      'Where do patience and obedience meet in daily life?',
    ],
    relatedProphetIds: ['ibrahim', 'ishaq', 'muhammad'],
    relatedLifeLessonIds: [
      'obedience',
      'patience',
      'sacrifice',
      'truthfulness',
    ],
    relatedGrowthHabitIds: [
      'pray_one_sunnah_prayer',
      'make_dua_daily',
      'read_quran_daily',
    ],
    locationLabel: 'Arabia / Makkah (Traditional)',
    locationConfidence: ProphetLocationConfidence.traditional,
  ),
  ProphetDetailContent(
    prophetId: 'ishaq',
    name: 'Ishaq',
    arabicName: 'إسحاق',
    eraTitle: 'Age of Ibrahim',
    regionLabel: 'Palestine Region (Traditional / Approximate)',
    shortSummary:
        'A prophet from the blessed family of Ibrahim whose life reflects divine promise, continuity, and mercy.',
    overview:
        'Ishaq was granted to Ibrahim and Sarah as glad tidings in old age. His story is less detailed in the Qur\'an than some other prophets, but he stands as an important link in the blessed chain of prophecy and the continuation of Ibrahim\'s legacy.',
    storySections: [
      ProphetStorySection(
        title: 'Glad Tidings',
        content:
            'Ishaq was given as a gift and glad tiding to Ibrahim and Sarah at a time when such news seemed impossible by normal expectation.',
      ),
      ProphetStorySection(
        title: 'A Sign of Divine Promise',
        content:
            'His birth demonstrated that Allah\'s decree is not constrained by age, weakness, or human assumption.',
      ),
      ProphetStorySection(
        title: 'Continuation of the Lineage',
        content:
            'Through Ishaq, prophetic guidance continued through future generations, including Yaqub and later prophets.',
      ),
      ProphetStorySection(
        title: 'Honor Within a Blessed House',
        content:
            'The Qur\'an mentions Ishaq among the honored prophets and righteous servants of Allah.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Allah Gives Beyond Expectation',
        description:
            'Ishaq\'s story reminds believers not to reduce divine possibility to human limits.',
      ),
      ProphetLesson(
        title: 'A Family Can Carry Faith Across Generations',
        description:
            'The prophetic lineage shows the power of inherited devotion and guidance.',
      ),
      ProphetLesson(
        title: 'Quiet Importance Matters',
        description:
            'A prophet may have fewer narrated details yet still hold immense significance in the chain of guidance.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '71-73',
        label: 'Glad tidings of Ishaq',
        startAyah: 71,
      ),
      QuranReferenceItem(
        surahName: 'As-Saffat',
        surahNumber: 37,
        verseRange: '112-113',
        label: 'Glad tidings and blessing',
        startAyah: 112,
      ),
      QuranReferenceItem(
        surahName: 'Al-An\'am',
        surahNumber: 6,
        verseRange: '84',
        label: 'Mention among the guided prophets',
        startAyah: 84,
      ),
    ],
    reflectionPrompts: [
      'Where do I underestimate what Allah can bring into a difficult situation?',
      'How can faith continue through generations in a family?',
      'What quiet blessings in life deserve more attention?',
    ],
    relatedProphetIds: ['ibrahim', 'ismail', 'yaqub'],
    relatedLifeLessonIds: [
      'hope',
      'gratitude',
      'family_legacy',
      'trust_in_allah',
    ],
    relatedGrowthHabitIds: [
      'practice_gratitude',
      'make_dua_daily',
      'reconnect_with_family',
    ],
    locationLabel: 'Palestine Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'yaqub',
    name: 'Yaqub',
    arabicName: 'يعقوب',
    eraTitle: 'Children of Israel',
    regionLabel: 'Canaan Region (Traditional / Approximate)',
    shortSummary:
        'A prophet of deep patience and trust whose fatherhood, grief, and hope are among the most moving in the Qur\'an.',
    overview:
        'Yaqub, also known as Israel, was a prophet and the father of Yusuf and his brothers. His story in the Qur\'an highlights patient grief, trust in Allah, wise fatherhood, and the endurance of hope through long trials.',
    storySections: [
      ProphetStorySection(
        title: 'A Father of a Household',
        content:
            'Yaqub was the father of a large family through whom major events in prophetic history unfolded. His role as a father is central to his story.',
      ),
      ProphetStorySection(
        title: 'The Loss of Yusuf',
        content:
            'When Yusuf was taken from him through the plotting of his sons, Yaqub experienced profound grief. Yet he did not sever his hope from Allah.',
      ),
      ProphetStorySection(
        title: 'Beautiful Patience',
        content:
            'Yaqub became a model of sabr jamil, beautiful patience - grief without rebellion, sorrow without despair, and trust without collapse.',
      ),
      ProphetStorySection(
        title: 'Hope Through Separation',
        content:
            'Even after years of pain and uncertainty, Yaqub continued to believe that Allah\'s mercy was near and that reunion was possible.',
      ),
      ProphetStorySection(
        title: 'A Legacy of Faith',
        content:
            'The Qur\'an also presents Yaqub as a father who cared deeply about the faith of his children and what they would worship after him.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Beautiful Patience is Active Faith',
        description:
            'Yaqub\'s patience did not erase pain, but it kept pain tied to trust in Allah.',
      ),
      ProphetLesson(
        title: 'Grief and Faith Can Coexist',
        description:
            'His sorrow was deep, yet it never turned into despair of Allah\'s mercy.',
      ),
      ProphetLesson(
        title: 'Family is a Trust',
        description:
            'His concern for the spiritual future of his children teaches the importance of faith within the home.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '132-133',
        label: 'Faith legacy and final counsel',
        startAyah: 132,
      ),
      QuranReferenceItem(
        surahName: 'Yusuf',
        surahNumber: 12,
        verseRange: 'Various',
        label: 'Fatherhood, grief, patience, and reunion',
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '45-47',
        label: 'Mention among the chosen servants',
        startAyah: 45,
      ),
    ],
    reflectionPrompts: [
      'What does beautiful patience look like when hardship lasts a long time?',
      'How can a person grieve without losing hope?',
      'What faith legacy am I helping build in my family?',
    ],
    relatedProphetIds: ['yusuf', 'ishaq', 'ibrahim'],
    relatedLifeLessonIds: ['patience', 'hope', 'family', 'trust_in_allah'],
    relatedGrowthHabitIds: [
      'practice_patience',
      'reconnect_with_family',
      'make_dua_daily',
    ],
    locationLabel: 'Canaan Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'dawud',
    name: 'Dawud',
    arabicName: 'داود',
    eraTitle: 'Children of Israel',
    regionLabel: 'Palestine Region (Traditional / Approximate)',
    shortSummary:
        'A prophet-king known for justice, gratitude, worship, and strength guided by humility before Allah.',
    overview:
        'Dawud was both a prophet and a king, blessed with strength, wisdom, judgment, and the Zabur. His story combines leadership, worship, justice, and repentance, showing how authority should remain anchored in submission to Allah.',
    storySections: [
      ProphetStorySection(
        title: 'Rise Through Courage',
        content:
            'Dawud is associated in the Qur\'an with courage and victory, including the slaying of Jalut. He rose not merely through strength, but through Allah\'s support.',
      ),
      ProphetStorySection(
        title: 'Prophethood and Kingship',
        content:
            'Allah gave Dawud authority, wisdom, and revelation. His life shows that power and revelation can coexist when ruled by humility.',
      ),
      ProphetStorySection(
        title: 'The Zabur',
        content:
            'Dawud was given the Zabur and became known for worship and praise. The mountains and birds are described as joining him in glorification.',
      ),
      ProphetStorySection(
        title: 'Justice and Judgment',
        content:
            'The Qur\'an presents Dawud as a judge who was entrusted to rule with justice and not follow desire.',
      ),
      ProphetStorySection(
        title: 'Repentance and Nearness',
        content:
            'His story also includes correction, return, and repentance, reminding believers that closeness to Allah includes accepting guidance when one errs.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Leadership Must Serve Justice',
        description:
            'Dawud teaches that authority without justice becomes corruption.',
      ),
      ProphetLesson(
        title: 'Strength and Worship Belong Together',
        description:
            'True strength is not dry or arrogant; it remains softened by remembrance.',
      ),
      ProphetLesson(
        title: 'Correction is a Mercy',
        description:
            'Even those granted much must remain willing to repent and return.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '251',
        label: 'Dawud and Jalut',
        startAyah: 251,
      ),
      QuranReferenceItem(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '163',
        label: 'Gift of the Zabur',
        startAyah: 163,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '17-26',
        label: 'Worship, judgment, and justice',
        startAyah: 17,
      ),
      QuranReferenceItem(
        surahName: 'Saba',
        surahNumber: 34,
        verseRange: '10-11',
        label: 'Favors given to Dawud',
        startAyah: 10,
      ),
    ],
    reflectionPrompts: [
      'How should strength be balanced by humility?',
      'What does justice require when someone has influence or authority?',
      'How can worship protect a person from the corruption of power?',
    ],
    relatedProphetIds: ['sulayman', 'musa', 'muhammad'],
    relatedLifeLessonIds: ['justice', 'gratitude', 'leadership', 'repentance'],
    relatedGrowthHabitIds: [
      'practice_humility',
      'study_islamic_knowledge',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Palestine Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'sulayman',
    name: 'Sulayman',
    arabicName: 'سليمان',
    eraTitle: 'Children of Israel',
    regionLabel: 'Palestine Region (Traditional / Approximate)',
    shortSummary:
        'A prophet-king of remarkable wisdom and vast authority who remained grateful to Allah for every gift.',
    overview:
        'Sulayman, the son of Dawud, was granted a kingdom of extraordinary reach, wisdom, and unique blessings. His story in the Qur\'an includes authority, judgment, gratitude, communication with creation, and humility before Allah despite immense worldly power.',
    storySections: [
      ProphetStorySection(
        title: 'Inheritance of Wisdom',
        content:
            'Sulayman inherited not only kingship but also prophetic wisdom. He recognized his blessings as gifts from Allah, not proofs of his own greatness.',
      ),
      ProphetStorySection(
        title: 'Power Over Creation by Allah\'s Leave',
        content:
            'Allah granted Sulayman unusual favors, including command over winds and jinn by divine permission. These gifts were tests of gratitude as much as signs of power.',
      ),
      ProphetStorySection(
        title: 'The Ant and Awareness',
        content:
            'When Sulayman heard the speech of an ant, he smiled and immediately turned to gratitude, showing a heart that remained aware of Allah even in small moments.',
      ),
      ProphetStorySection(
        title: 'The Queen of Sheba',
        content:
            'His interaction with the Queen of Sheba showed intelligence, diplomacy, and invitation to truth, rather than crude domination.',
      ),
      ProphetStorySection(
        title: 'A Kingdom as a Test',
        content:
            'Sulayman\'s life demonstrates that abundance can be as great a test as hardship, and that gratitude is the right response to power.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Power is a Test',
        description:
            'Sulayman teaches that gifts, authority, and success must lead to gratitude, not self-glorification.',
      ),
      ProphetLesson(
        title: 'Wisdom Uses Strength Well',
        description:
            'His story shows intelligence, restraint, and thoughtful leadership.',
      ),
      ProphetLesson(
        title: 'Gratitude Protects the Heart',
        description:
            'A grateful heart is less likely to be corrupted by worldly advantage.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'An-Naml',
        surahNumber: 27,
        verseRange: '15-44',
        label: 'Ant, hoopoe, and Queen of Sheba',
        startAyah: 15,
      ),
      QuranReferenceItem(
        surahName: 'Saba',
        surahNumber: 34,
        verseRange: '12-14',
        label: 'Favors granted to Sulayman',
        startAyah: 12,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '30-40',
        label: 'Sulayman\'s devotion and kingdom',
        startAyah: 30,
      ),
    ],
    reflectionPrompts: [
      'How can success remain tied to gratitude instead of ego?',
      'What does wise leadership look like in practice?',
      'Which blessings in life are actually tests of thankfulness?',
    ],
    relatedProphetIds: ['dawud', 'ibrahim', 'muhammad'],
    relatedLifeLessonIds: ['gratitude', 'wisdom', 'leadership', 'humility'],
    relatedGrowthHabitIds: [
      'practice_gratitude',
      'practice_humility',
      'study_islamic_knowledge',
    ],
    locationLabel: 'Palestine Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'yunus',
    name: 'Yunus',
    arabicName: 'يونس',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Nineveh Region (Traditional / Approximate)',
    shortSummary:
        'A prophet whose story is a profound lesson in turning back to Allah, humility, and the mercy that follows sincere return.',
    overview:
        'Yunus was sent to a people who initially resisted guidance. His story is remembered for his departure, the trial of the great fish, his prayer in darkness, and Allah\'s mercy in restoring him. It is one of the Qur\'an\'s clearest lessons in repentance, humility, and divine rescue.',
    storySections: [
      ProphetStorySection(
        title: 'Mission to His People',
        content:
            'Yunus was sent to call his people to Allah. His mission, like those before him, involved warning, patience, and concern for a people slow to respond.',
      ),
      ProphetStorySection(
        title: 'Departure Before the Command',
        content:
            'Yunus left before the matter had fully unfolded. This became the beginning of a painful but transformative trial.',
      ),
      ProphetStorySection(
        title: 'Darkness and the Great Fish',
        content:
            'He was swallowed by the great fish and found himself surrounded by darkness - the darkness of night, sea, and his condition. There he turned back to Allah with one of the most famous supplications in the Qur\'an.',
      ),
      ProphetStorySection(
        title: 'The Prayer of Return',
        content:
            'Yunus called out, acknowledging Allah\'s perfection and his own wrongdoing. This prayer became a model for repentance in moments of distress.',
      ),
      ProphetStorySection(
        title: 'Mercy and Restoration',
        content:
            'Allah rescued Yunus, restored him, and allowed his people to benefit when they believed. His story ends in mercy after humility.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'No Darkness Blocks a Sincere Prayer',
        description:
            'Yunus teaches that when a person turns fully to Allah, the door of mercy remains open.',
      ),
      ProphetLesson(
        title: 'Humility Opens Relief',
        description:
            'His rescue followed honesty about his own wrong and complete dependence on Allah.',
      ),
      ProphetLesson(
        title: 'Return is Always Possible',
        description:
            'The story shows that failure is not final when repentance is real.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Yunus',
        surahNumber: 10,
        verseRange: '98',
        label: 'His people and belief',
        startAyah: 98,
      ),
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '87-88',
        label: 'Prayer in darkness and rescue',
        startAyah: 87,
      ),
      QuranReferenceItem(
        surahName: 'As-Saffat',
        surahNumber: 37,
        verseRange: '139-148',
        label: 'Departure, fish, and restoration',
        startAyah: 139,
      ),
      QuranReferenceItem(
        surahName: 'Al-Qalam',
        surahNumber: 68,
        verseRange: '48-50',
        label: 'Reminder through Yunus',
        startAyah: 48,
      ),
    ],
    reflectionPrompts: [
      'What does sincere return to Allah look like in moments of distress?',
      'How does a person admit fault without falling into despair?',
      'Which prayer or act of repentance do I return to when life feels dark?',
    ],
    relatedProphetIds: ['nuh', 'musa', 'muhammad'],
    relatedLifeLessonIds: ['repentance', 'hope', 'humility', 'dua'],
    relatedGrowthHabitIds: [
      'make_dua_daily',
      'daily_istighfar',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Nineveh Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'ayyub',
    name: 'Ayyub',
    arabicName: 'أيوب',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Levant / Surrounding Region (Traditional / Approximate)',
    shortSummary:
        'A prophet remembered for extraordinary patience in suffering and unwavering return to Allah in hardship.',
    overview:
        'Ayyub is one of the clearest Qur\'anic models of patience under severe trial. His story centers on hardship, endurance, supplication, and divine mercy. He did not deny his pain, but he remained turned toward Allah through it. For that, his story has become one of the greatest lessons in sabr and trust.',
    storySections: [
      ProphetStorySection(
        title: 'A Life Touched by Trial',
        content:
            'Ayyub faced severe hardship, including suffering that tested the limits of human endurance. Yet trial did not sever his bond with Allah.',
      ),
      ProphetStorySection(
        title: 'A Prayer Without Rebellion',
        content:
            'He called upon Allah with humility, acknowledging his suffering while still honoring Allah\'s mercy.',
      ),
      ProphetStorySection(
        title: 'Mercy After Hardship',
        content:
            'Allah responded to Ayyub, removed his harm, and restored him. His story shows that relief belongs to Allah, and that patient endurance is never unseen.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Patience Does Not Mean Denying Pain',
        description:
            'Ayyub teaches that one may feel deep suffering while still remaining faithful and dignified before Allah.',
      ),
      ProphetLesson(
        title: 'Turn to Allah in Hardship',
        description: 'His response to pain was dua, not bitterness.',
      ),
      ProphetLesson(
        title: 'Mercy Follows Steadfastness',
        description:
            'Relief may come late, but Allah does not waste the patience of His servants.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '83-84',
        label: 'Supplication and relief',
        startAyah: 83,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '41-44',
        label: 'Trial, patience, and restoration',
        startAyah: 41,
      ),
    ],
    reflectionPrompts: [
      'How do I respond when hardship lasts longer than expected?',
      'What does patient dignity look like in pain?',
      'How can dua remain alive when relief feels distant?',
    ],
    relatedProphetIds: ['yunus', 'yaqub', 'muhammad'],
    relatedLifeLessonIds: ['patience', 'hardship', 'trust_in_allah', 'dua'],
    relatedGrowthHabitIds: [
      'practice_patience',
      'make_dua_daily',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Levant / Surrounding Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'dhul_kifl',
    name: 'Dhul-Kifl',
    arabicName: 'ذو الكفل',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Levant / Iraq Region (Traditional / Approximate)',
    shortSummary:
        'A prophet or righteous servant mentioned among the patient and honored, remembered for steadfastness and goodness.',
    overview:
        'Dhul-Kifl is mentioned briefly in the Qur\'an among the righteous and patient. The Qur\'anic presentation is concise, but the honor of being named among the steadfast servants of Allah is itself significant. His story teaches that not all greatness comes with long narrative detail; some lives are honored through constancy, patience, and righteousness.',
    storySections: [
      ProphetStorySection(
        title: 'Mentioned Among the Patient',
        content:
            'The Qur\'an includes Dhul-Kifl among those marked by patience, which is one of the most repeated qualities of honored servants.',
      ),
      ProphetStorySection(
        title: 'Included Among the Righteous',
        content:
            'His mention in the Qur\'an ties him to goodness, endurance, and closeness to Allah.',
      ),
      ProphetStorySection(
        title: 'Honor in Brevity',
        content:
            'Though little narrative detail is given, his inclusion itself teaches that faithfulness and steadfastness can be enough to make a life noble in the sight of Allah.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Steadfastness Has Great Value',
        description:
            'A life of constancy and patience may be hidden from people yet exalted by Allah.',
      ),
      ProphetLesson(
        title: 'Brevity Does Not Mean Smallness',
        description: 'Less narrated detail does not mean less honor.',
      ),
      ProphetLesson(
        title: 'Righteousness Can Be Quiet',
        description:
            'Some of Allah\'s honored servants are remembered through character more than dramatic events.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '85-86',
        label: 'Mention among the patient and righteous',
        startAyah: 85,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '48',
        label: 'Mention among the excellent servants',
        startAyah: 48,
      ),
    ],
    reflectionPrompts: [
      'Do I wrongly measure greatness only by visibility or detail?',
      'What does quiet steadfastness look like in my life?',
      'How can patience become a deeper part of my character?',
    ],
    relatedProphetIds: ['idris', 'alyasa', 'ayyub'],
    relatedLifeLessonIds: [
      'patience',
      'steadfastness',
      'quiet_righteousness',
      'sincerity',
    ],
    relatedGrowthHabitIds: [
      'practice_patience',
      'make_dua_daily',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Levant / Iraq Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'hud',
    name: 'Hud',
    arabicName: 'هود',
    eraTitle: 'Post-Flood Peoples',
    regionLabel: 'People of \'Ad / Arabia (Traditional / Approximate)',
    shortSummary:
        'A prophet sent to a powerful people destroyed by arrogance, denial, and misplaced confidence in their own strength.',
    overview:
        'Hud was sent to the people of \'Ad, a nation known for strength, stature, and worldly power. They became arrogant and turned away from Allah, trusting in their might instead of their Creator. Hud called them back to worship Allah alone, but they mocked the warning until divine punishment came.',
    storySections: [
      ProphetStorySection(
        title: 'A Powerful People',
        content:
            'The people of \'Ad were known for strength and worldly dominance. Their material power became a source of arrogance rather than gratitude.',
      ),
      ProphetStorySection(
        title: 'The Call of Hud',
        content:
            'Hud called them to abandon false worship and return to Allah alone. He reminded them that all strength is granted by Allah and can be taken away.',
      ),
      ProphetStorySection(
        title: 'Arrogance and Mockery',
        content:
            'Instead of listening, they mocked Hud and dismissed his message. Their pride made them treat warning as weakness.',
      ),
      ProphetStorySection(
        title: 'False Confidence',
        content:
            'They assumed no force could overcome them. Their error was not only disbelief, but the illusion that worldly strength guarantees safety.',
      ),
      ProphetStorySection(
        title: 'The Destructive Wind',
        content:
            'Allah sent a fierce wind that destroyed them completely, showing how fragile human power is before divine command.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Strength Without Humility Becomes Ruin',
        description:
            'Hud\'s people show how power can corrupt when it is not anchored in gratitude and obedience.',
      ),
      ProphetLesson(
        title: 'Arrogance Blinds',
        description:
            'They could not see truth because pride made them too impressed with themselves.',
      ),
      ProphetLesson(
        title: 'Worldly Power is Temporary',
        description:
            'What seems unshakable can vanish quickly when Allah\'s decree arrives.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '65-72',
        label: 'Hud and the people of \'Ad',
        startAyah: 65,
      ),
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '50-60',
        label: 'Call, rejection, and destruction',
        startAyah: 50,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '123-140',
        label: 'Hud\'s warning to his people',
        startAyah: 123,
      ),
      QuranReferenceItem(
        surahName: 'Al-Haqqah',
        surahNumber: 69,
        verseRange: '6-8',
        label: 'Destruction by violent wind',
        startAyah: 6,
      ),
    ],
    reflectionPrompts: [
      'Where does worldly strength make people forget their dependence on Allah?',
      'How can confidence become arrogance?',
      'What helps a person remain humble when they have influence or success?',
    ],
    relatedProphetIds: ['salih', 'nuh', 'ibrahim'],
    relatedLifeLessonIds: [
      'humility',
      'gratitude',
      'arrogance',
      'dependence_on_allah',
    ],
    relatedGrowthHabitIds: [
      'practice_humility',
      'practice_gratitude',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'People of \'Ad / Arabia (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'salih',
    name: 'Salih',
    arabicName: 'صالح',
    eraTitle: 'Post-Flood Peoples',
    regionLabel: 'People of Thamud / Arabia (Traditional / Approximate)',
    shortSummary:
        'A prophet sent to a people of skill and pride who rejected a clear sign and were destroyed for their defiance.',
    overview:
        'Salih was sent to the people of Thamud, who were known for carving homes into mountains and enjoying a sophisticated way of life. Yet their civilization did not lead them to humility. When they demanded a sign, Allah gave them the miracle of the she-camel, but they still rebelled and brought destruction upon themselves.',
    storySections: [
      ProphetStorySection(
        title: 'A Gifted but Proud People',
        content:
            'The people of Thamud possessed skill, craftsmanship, and stability. Like other nations before them, they mistook worldly ability for security.',
      ),
      ProphetStorySection(
        title: 'The Call of Salih',
        content:
            'Salih called them to worship Allah alone and to use their blessings with gratitude and righteousness.',
      ),
      ProphetStorySection(
        title: 'The Sign of the She-Camel',
        content:
            'When they demanded a sign, Allah granted a clear miracle: the she-camel. It was both a sign and a test.',
      ),
      ProphetStorySection(
        title: 'Defiance Against the Sign',
        content:
            'Rather than submit, they harmed the she-camel and openly defied Allah\'s warning. Their sin was deliberate rejection after clarity.',
      ),
      ProphetStorySection(
        title: 'The Final Punishment',
        content:
            'After continued defiance, a devastating punishment overtook them. Their carved homes could not protect them from the consequence of rebellion.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Clear Signs Do Not Benefit a Proud Heart',
        description:
            'The issue is often not lack of evidence, but unwillingness to submit.',
      ),
      ProphetLesson(
        title: 'Blessings Can Become Tests',
        description:
            'Skill and stability are not proof of divine approval if they lead to arrogance.',
      ),
      ProphetLesson(
        title: 'Defiance After Clarity is Dangerous',
        description:
            'The story warns against knowingly crossing sacred limits.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '73-79',
        label: 'Salih and the she-camel',
        startAyah: 73,
      ),
      QuranReferenceItem(
        surahName: 'Hud',
        surahNumber: 11,
        verseRange: '61-68',
        label: 'Call, miracle, and punishment',
        startAyah: 61,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Shu\'ara',
        surahNumber: 26,
        verseRange: '141-159',
        label: 'Warning to Thamud',
        startAyah: 141,
      ),
      QuranReferenceItem(
        surahName: 'Al-Qamar',
        surahNumber: 54,
        verseRange: '23-31',
        label: 'The she-camel and destruction',
        startAyah: 23,
      ),
    ],
    reflectionPrompts: [
      'How do people react when truth asks them to change?',
      'What blessings in life might be testing my gratitude and humility?',
      'Am I receptive to warning, or defensive against it?',
    ],
    relatedProphetIds: ['hud', 'nuh', 'lut'],
    relatedLifeLessonIds: [
      'gratitude',
      'obedience',
      'humility',
      'heed_warnings',
    ],
    relatedGrowthHabitIds: [
      'practice_gratitude',
      'make_dua_daily',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'People of Thamud / Arabia (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'harun',
    name: 'Harun',
    arabicName: 'هارون',
    eraTitle: 'Children of Israel',
    regionLabel: 'Egypt and Sinai',
    shortSummary:
        'A prophet of support, gentleness, and shared mission who stood beside Musa in one of history\'s greatest confrontations with tyranny.',
    overview:
        'Harun, the brother of Musa, was chosen by Allah to assist him in the prophetic mission to Pharaoh. His story highlights the importance of partnership in da\'wah, patient leadership, and responsibility during moments of pressure and confusion.',
    storySections: [
      ProphetStorySection(
        title: 'Chosen as a Support',
        content:
            'Musa asked Allah to strengthen him through his brother Harun, recognizing his eloquence and support. Allah granted this request.',
      ),
      ProphetStorySection(
        title: 'Mission to Pharaoh',
        content:
            'Harun stood alongside Musa in calling Pharaoh to truth. His presence reflects how major missions are often carried by more than one righteous servant.',
      ),
      ProphetStorySection(
        title: 'Leadership During Absence',
        content:
            'When Musa went to meet Allah, Harun remained with the people. He faced the turmoil of the golden calf episode and tried to restrain the people from greater corruption.',
      ),
      ProphetStorySection(
        title: 'Gentleness Under Pressure',
        content:
            'Harun\'s conduct reflects wisdom, restraint, and concern for unity even during difficult moments.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Righteous Work Needs Support',
        description:
            'Harun reminds us that even prophets seek helpers and companions in difficult missions.',
      ),
      ProphetLesson(
        title: 'Gentleness is not Weakness',
        description:
            'His restraint shows that patience and softness can be forms of strength.',
      ),
      ProphetLesson(
        title: 'Shared Duty Matters',
        description:
            'Supporting truth may mean standing behind or beside others rather than always leading from the front.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '29-36',
        label: 'Musa asks for Harun as support',
        startAyah: 29,
      ),
      QuranReferenceItem(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '142-150',
        label: 'Harun and the golden calf incident',
        startAyah: 142,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '53',
        label: 'Harun mentioned as a prophet',
        startAyah: 53,
      ),
    ],
    reflectionPrompts: [
      'How can supporting others become a form of worship?',
      'What kind of strength is needed when leadership becomes chaotic?',
      'Do I value sincere helpers the way I value visible leaders?',
    ],
    relatedProphetIds: ['musa', 'dawud', 'muhammad'],
    relatedLifeLessonIds: ['brotherhood', 'support', 'patience', 'leadership'],
    relatedGrowthHabitIds: [
      'help_someone',
      'practice_patience',
      'reconnect_with_family',
    ],
    locationLabel: 'Egypt and Sinai',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'ilyas',
    name: 'Ilyas',
    arabicName: 'إلياس',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Levant Region (Traditional / Approximate)',
    shortSummary:
        'A prophet who called his people away from false worship and back to devotion to Allah alone.',
    overview:
        'Ilyas was sent to people who had turned toward false worship and neglected their duty to Allah. Though the Qur\'an mentions him briefly, it presents him as one of the righteous and honored prophets who stood firmly for tawhid.',
    storySections: [
      ProphetStorySection(
        title: 'A Call Against False Worship',
        content:
            'Ilyas asked his people why they turned to idols and false deities when Allah, the Best of Creators, was their true Lord.',
      ),
      ProphetStorySection(
        title: 'A Brief but Powerful Reminder',
        content:
            'Though his story is concise in the Qur\'an, its focus is sharp: worship Allah alone and reject all partners beside Him.',
      ),
      ProphetStorySection(
        title: 'Honor Among the Righteous',
        content:
            'The Qur\'an counts Ilyas among the righteous and leaves his story as a distilled lesson in tawhid and steadfastness.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Tawhid is the Core Message',
        description:
            'Even brief prophetic stories return us to the central truth: worship Allah alone.',
      ),
      ProphetLesson(
        title: 'Clarity Can Be Powerful',
        description:
            'A concise message delivered with conviction may carry more force than many words.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'As-Saffat',
        surahNumber: 37,
        verseRange: '123-132',
        label: 'Ilyas and his people',
        startAyah: 123,
      ),
    ],
    reflectionPrompts: [
      'What modern distractions behave like idols in people\'s lives?',
      'How can a believer keep worship centered on Allah alone?',
      'What truths in life are simple, even if people complicate them?',
    ],
    relatedProphetIds: ['alyasa', 'ibrahim', 'muhammad'],
    relatedLifeLessonIds: ['tawhid', 'clarity', 'steadfastness'],
    relatedGrowthHabitIds: [
      'read_quran_daily',
      'make_dua_daily',
      'daily_istighfar',
    ],
    locationLabel: 'Levant Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'alyasa',
    name: 'Alyasa',
    arabicName: 'اليسع',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Levant Region (Traditional / Approximate)',
    shortSummary:
        'A righteous prophet mentioned among the honored servants of Allah, remembered for steadfastness and goodness.',
    overview:
        'Alyasa is mentioned briefly in the Qur\'an among the guided and righteous prophets. Though fewer narrative details are given, his inclusion among the honored servants of Allah highlights the quiet greatness of steadfast righteousness.',
    storySections: [
      ProphetStorySection(
        title: 'Mentioned Among the Chosen',
        content:
            'The Qur\'an names Alyasa among the prophets who were favored and guided by Allah.',
      ),
      ProphetStorySection(
        title: 'Quiet Greatness',
        content:
            'Not every prophet\'s story is narrated in long detail. Alyasa\'s brief mention reminds us that honor with Allah does not depend on how much public attention a person receives.',
      ),
      ProphetStorySection(
        title: 'Steadfast Righteousness',
        content:
            'His presence among the prophets points to constancy, goodness, and a life anchored in obedience.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Recognition from Allah Matters Most',
        description:
            'Alyasa shows that a life can be great in the sight of Allah even if little is known publicly.',
      ),
      ProphetLesson(
        title: 'Quiet Righteousness Has Weight',
        description:
            'Not every meaningful life is dramatic or widely remembered by people.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-An\'am',
        surahNumber: 6,
        verseRange: '86',
        label: 'Mention among the prophets',
        startAyah: 86,
      ),
      QuranReferenceItem(
        surahName: 'Sad',
        surahNumber: 38,
        verseRange: '48',
        label: 'Mention among the righteous',
        startAyah: 48,
      ),
    ],
    reflectionPrompts: [
      'Do I overvalue public recognition?',
      'What does quiet righteousness look like today?',
      'How can a person remain sincere when no one notices their effort?',
    ],
    relatedProphetIds: ['ilyas', 'zakariya', 'yahya'],
    relatedLifeLessonIds: ['sincerity', 'steadfastness', 'quiet_goodness'],
    relatedGrowthHabitIds: [
      'practice_humility',
      'make_dua_daily',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Levant Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'zakariya',
    name: 'Zakariya',
    arabicName: 'زكريا',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Palestine Region (Traditional / Approximate)',
    shortSummary:
        'A prophet of gentle devotion and hopeful prayer who turned to Allah even when worldly expectations seemed closed.',
    overview:
        'Zakariya is remembered in the Qur\'an for his quiet sincerity, care for Maryam, and his heartfelt prayer for a child despite old age. His story teaches hope, private supplication, and trust in Allah beyond what seems possible.',
    storySections: [
      ProphetStorySection(
        title: 'A Caretaker of Worship',
        content:
            'Zakariya cared for Maryam and witnessed signs of Allah\'s provision in her life, which strengthened his hope and longing in prayer.',
      ),
      ProphetStorySection(
        title: 'A Prayer in Old Age',
        content:
            'Despite weakness and old age, Zakariya turned to Allah and asked for a righteous heir. His prayer rose from hope, not worldly probability.',
      ),
      ProphetStorySection(
        title: 'Glad Tidings of Yahya',
        content:
            'Allah answered Zakariya\'s prayer with the glad tidings of Yahya, showing that divine mercy is not limited by human expectation.',
      ),
      ProphetStorySection(
        title: 'A Sign and a Mercy',
        content:
            'His story stands as a sign that private prayer, even after long waiting, is never wasted with Allah.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Hope Belongs in Dua',
        description:
            'Zakariya teaches that a believer should ask Allah even when worldly reasons seem absent.',
      ),
      ProphetLesson(
        title: 'Private Supplication is Powerful',
        description:
            'His story highlights the beauty of calling upon Allah quietly and sincerely.',
      ),
      ProphetLesson(
        title: 'Allah Opens What Seems Closed',
        description: 'Divine mercy is not bound by human limits or statistics.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Aal \'Imran',
        surahNumber: 3,
        verseRange: '37-41',
        label: 'Prayer for a child and glad tidings',
        startAyah: 37,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '2-15',
        label: 'Private supplication and answer',
        startAyah: 2,
      ),
    ],
    reflectionPrompts: [
      'What hopes have I stopped bringing to Allah?',
      'How can private dua become more central in my life?',
      'Where do I need to trust Allah beyond visible possibility?',
    ],
    relatedProphetIds: ['yahya', 'isa', 'muhammad'],
    relatedLifeLessonIds: ['hope', 'dua', 'trust_in_allah', 'private_worship'],
    relatedGrowthHabitIds: [
      'make_dua_daily',
      'pray_one_sunnah_prayer',
      'end_day_with_reflection_and_tawbah',
    ],
    locationLabel: 'Palestine Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'yahya',
    name: 'Yahya',
    arabicName: 'يحيى',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Palestine Region (Traditional / Approximate)',
    shortSummary:
        'A prophet marked by purity, wisdom, and devotion from an early age, remembered for gentleness and righteousness.',
    overview:
        'Yahya, the son of Zakariya, was granted wisdom and purity while still young. The Qur\'an presents him as noble, dutiful, and deeply devoted to Allah. His story is a reminder that spiritual maturity can begin early and that purity of heart is a great honor.',
    storySections: [
      ProphetStorySection(
        title: 'A Child of Answered Prayer',
        content:
            'Yahya came as the answer to Zakariya\'s long and hopeful supplication, showing Allah\'s mercy across generations.',
      ),
      ProphetStorySection(
        title: 'Wisdom from a Young Age',
        content:
            'The Qur\'an describes Yahya as being given wisdom while still a child, highlighting early devotion and seriousness in faith.',
      ),
      ProphetStorySection(
        title: 'Purity and Dutifulness',
        content:
            'He is remembered for purity, compassion, and dutifulness to his parents, qualities that reflect inner nobility.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Purity is a Strength',
        description:
            'Yahya teaches that a clean heart and disciplined soul are signs of true honor.',
      ),
      ProphetLesson(
        title: 'Youth Can Carry Great Faith',
        description: 'Spiritual seriousness is not reserved for old age.',
      ),
      ProphetLesson(
        title: 'Devotion Appears in Character',
        description:
            'Faith shows itself through gentleness, duty, and integrity.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Aal \'Imran',
        surahNumber: 3,
        verseRange: '39',
        label: 'Glad tidings of Yahya',
        startAyah: 39,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '12-15',
        label: 'Wisdom, purity, and character',
        startAyah: 12,
      ),
    ],
    reflectionPrompts: [
      'How early should spiritual discipline begin in a person\'s life?',
      'What does purity of heart look like in practice?',
      'How can faith shape the way a person treats parents and others?',
    ],
    relatedProphetIds: ['zakariya', 'isa'],
    relatedLifeLessonIds: ['purity', 'discipline', 'dutifulness', 'gentleness'],
    relatedGrowthHabitIds: [
      'study_islamic_knowledge',
      'practice_humility',
      'avoid_harmful_speech',
    ],
    locationLabel: 'Palestine Region (Traditional / Approximate)',
    locationConfidence: ProphetLocationConfidence.approximate,
  ),
  ProphetDetailContent(
    prophetId: 'isa',
    name: 'Isa',
    arabicName: 'عيسى',
    eraTitle: 'Later Israelite Prophets',
    regionLabel: 'Palestine',
    shortSummary:
        'A prophet born by miracle, strengthened with signs, and sent to call people back to sincere faith and obedience to Allah.',
    overview:
        'Isa, son of Maryam, holds a special place in Islam as a mighty prophet born miraculously without a father. Allah supported him with clear signs and miracles, yet his message remained the same as that of the prophets before him: worship Allah alone and follow divine guidance. His story is one of purity, mercy, truth, and clarity.',
    storySections: [
      ProphetStorySection(
        title: 'Miraculous Birth',
        content:
            'Isa was born to Maryam by Allah\'s command without a father. His birth was a sign of divine power, not a break from divine oneness.',
      ),
      ProphetStorySection(
        title: 'Speech in the Cradle',
        content:
            'Even as an infant, Isa spoke by Allah\'s permission to defend his mother and declare himself a servant of Allah.',
      ),
      ProphetStorySection(
        title: 'Signs and Miracles',
        content:
            'Allah supported Isa with miracles, including healing and other signs by His permission. These were proofs of prophethood, not grounds for worshipping him.',
      ),
      ProphetStorySection(
        title: 'Call to Faith',
        content:
            'Isa called his people back to obedience, sincerity, and recognition of Allah\'s authority.',
      ),
      ProphetStorySection(
        title: 'Honor and Protection',
        content:
            'The Qur\'an honors Isa greatly while correcting false beliefs about him. He remains one of the great messengers of Allah.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Miracles Point to Allah, Not Themselves',
        description:
            'Isa\'s signs were proofs of Allah\'s power and his prophethood.',
      ),
      ProphetLesson(
        title: 'Purity and Truth Matter',
        description:
            'His story is deeply tied to purity, clarity, and defense of truth.',
      ),
      ProphetLesson(
        title: 'Honor Does Not Mean Divinity',
        description: 'Islam honors Isa while preserving pure tawhid.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Aal \'Imran',
        surahNumber: 3,
        verseRange: '45-55',
        label: 'Glad tidings and mission of Isa',
        startAyah: 45,
      ),
      QuranReferenceItem(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '157-159',
        label: 'Clarification about Isa',
        startAyah: 157,
      ),
      QuranReferenceItem(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '110-120',
        label: 'Signs and dialogue on the Day of Judgment',
        startAyah: 110,
      ),
      QuranReferenceItem(
        surahName: 'Maryam',
        surahNumber: 19,
        verseRange: '16-36',
        label: 'Birth and speech in the cradle',
        startAyah: 16,
      ),
    ],
    reflectionPrompts: [
      'How can great honor exist without crossing into exaggeration?',
      'What does Isa\'s story teach about truth and purity?',
      'How do miracles deepen faith in Allah rather than distract from Him?',
    ],
    relatedProphetIds: ['zakariya', 'yahya', 'muhammad'],
    relatedLifeLessonIds: ['tawhid', 'purity', 'truth', 'mercy'],
    relatedGrowthHabitIds: [
      'read_quran_daily',
      'make_dua_daily',
      'study_islamic_knowledge',
    ],
    locationLabel: 'Palestine',
    locationConfidence: ProphetLocationConfidence.strong,
  ),
  ProphetDetailContent(
    prophetId: 'muhammad',
    name: 'Muhammad ﷺ',
    arabicName: 'محمد ﷺ',
    eraTitle: 'Final Messenger',
    regionLabel: 'Makkah and Madinah',
    shortSummary:
        'The final messenger, sent as a mercy to the worlds, who completed the prophetic chain and delivered the Qur’an.',
    overview:
        'Muhammad ﷺ is the final prophet and messenger in Islam. Born in Makkah and later migrating to Madinah, he received the Qur’an and conveyed the final message of tawhid, justice, mercy, and guidance. His life is the clearest practical model of worship, leadership, patience, and character for the Muslim community.',
    storySections: [
      ProphetStorySection(
        title: 'Early Life and Trustworthiness',
        content:
            'Before prophethood, Muhammad ﷺ was already known for honesty and trustworthiness. His early life prepared him to carry the weight of revelation.',
      ),
      ProphetStorySection(
        title: 'The Beginning of Revelation',
        content:
            'At the age of forty, revelation began in the cave of Hira through Jibril. This marked the beginning of the final prophetic mission.',
      ),
      ProphetStorySection(
        title: 'Patience in Makkah',
        content:
            'He faced mockery, rejection, pressure, and persecution, yet remained steady in calling people to Allah with wisdom and mercy.',
      ),
      ProphetStorySection(
        title: 'Hijrah and Community in Madinah',
        content:
            'The migration to Madinah was not only relocation but the beginning of a living Muslim community shaped by revelation, justice, and brotherhood.',
      ),
      ProphetStorySection(
        title: 'Mercy, Leadership, and Completion of the Message',
        content:
            'His life combined worship, leadership, family care, law, forgiveness, courage, and mercy. Through him, Allah completed the religion and sealed prophethood.',
      ),
    ],
    keyLessons: [
      ProphetLesson(
        title: 'Mercy is Strength',
        description:
            'The Prophet ﷺ shows that true leadership is rooted in compassion, not hardness.',
      ),
      ProphetLesson(
        title: 'Character Carries the Message',
        description:
            'His honesty, patience, and integrity were central to the way people encountered Islam.',
      ),
      ProphetLesson(
        title: 'Steadfastness Under Pressure',
        description:
            'He remained faithful to the mission through years of opposition and hardship.',
      ),
    ],
    quranReferences: [
      QuranReferenceItem(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '21, 40',
        label: 'Excellent example and seal of the prophets',
        startAyah: 21,
      ),
      QuranReferenceItem(
        surahName: 'Al-Fath',
        surahNumber: 48,
        verseRange: '1-3, 29',
        label: 'Victory and the believing community',
        startAyah: 1,
      ),
      QuranReferenceItem(
        surahName: 'Al-Qalam',
        surahNumber: 68,
        verseRange: '4',
        label: 'Exalted character',
        startAyah: 4,
      ),
      QuranReferenceItem(
        surahName: 'Ad-Duha',
        surahNumber: 93,
        verseRange: '1-11',
        label: 'Comfort and reassurance',
        startAyah: 1,
      ),
      QuranReferenceItem(
        surahName: 'Ash-Sharh',
        surahNumber: 94,
        verseRange: '1-8',
        label: 'Relief after hardship',
        startAyah: 1,
      ),
      QuranReferenceItem(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '107',
        label: 'Mercy to the worlds',
        startAyah: 107,
      ),
    ],
    reflectionPrompts: [
      'How can mercy become more visible in my daily conduct?',
      'What does it mean to follow the Prophet ﷺ as an example rather than just admire him?',
      'How should patience shape a believer during long hardship?',
    ],
    relatedProphetIds: ['ibrahim', 'musa', 'isa'],
    relatedLifeLessonIds: [
      'mercy',
      'character',
      'patience',
      'leadership',
      'tawhid',
    ],
    relatedGrowthHabitIds: [
      'send_salawat',
      'read_quran_daily',
      'practice_humility',
      'help_someone',
    ],
    locationLabel: 'Makkah and Madinah',
    locationConfidence: ProphetLocationConfidence.strong,
  ),
];
