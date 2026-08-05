import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

final List<TriviaQuestion> duaTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'dua_easy_001',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'What does du‘a most basically mean in Islam?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Only formal public speeches'),
      ('b', 'A trade agreement'),
      ('c', 'Calling upon Allah and asking Him'),
      ('d', 'Only reciting history'),
    ],
    explanation:
        'Du‘a is calling upon Allah with hope, humility, need, praise, and trust. It is a central act of worship.',
    tags: const ['dua', 'supplication', 'worship', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    featured: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_002',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which prophet made the du‘a, “My Lord, increase me in knowledge”?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Nuh'),
      ('b', 'Musa'),
      ('c', 'Yunus'),
      ('d', 'Prophet Muhammad ﷺ'),
    ],
    explanation:
        'Allah instructed the Prophet Muhammad ﷺ to say, “My Lord, increase me in knowledge,” teaching believers to ask for beneficial knowledge.',
    quranReference: 'Qur’an 20:114',
    tags: const ['dua', 'knowledge', 'quran', 'prophet_muhammad'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'dua_easy_003',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Du‘a is only for times of hardship.',
    correct: false,
    explanation:
        'A believer makes du‘a in ease and hardship. Gratitude, hope, fear, need, and praise all belong in du‘a.',
    tags: const ['dua', 'gratitude', 'hope', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_004',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which of these is a du‘a for forgiveness?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Asking Allah to forgive one’s sins'),
      ('b', 'Ignoring mistakes'),
      ('c', 'Only asking for wealth'),
      ('d', 'Delaying repentance forever'),
    ],
    explanation:
        'Seeking forgiveness is among the most important forms of du‘a. It expresses humility and return to Allah.',
    tags: const ['dua', 'forgiveness', 'repentance', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_005',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which prophet made the famous du‘a from inside the darknesses: “There is no god but You; glory be to You; indeed I was among the wrongdoers”?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Ayyub'),
      ('b', 'Yunus'),
      ('c', 'Yusuf'),
      ('d', 'Hud'),
    ],
    explanation:
        'This famous supplication is associated with Prophet Yunus, peace be upon him, when he turned back to Allah in repentance.',
    quranReference: 'Qur’an 21:87',
    tags: const ['dua', 'yunus', 'repentance', 'quran'],
    dailyEligible: true,
    beginnerFriendly: true,
    featured: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_006',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which quality should be present in du‘a?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Arrogance'),
      ('b', 'Mockery'),
      ('c', 'Carelessness'),
      ('d', 'Humility'),
    ],
    explanation:
        'Du‘a is made with humility, sincerity, and need before Allah. This is part of its beauty and adab.',
    tags: const ['dua', 'humility', 'adab', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'dua_easy_007',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Remembering Allah with short daily supplications is part of Muslim life.',
    correct: true,
    explanation:
        'Daily supplications for waking, sleeping, travel, eating, and other moments help keep the heart connected to Allah.',
    tags: const ['dua', 'daily_supplications', 'dhikr', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_008',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'What is a believer encouraged to do besides asking for worldly benefit?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Abandon all du‘a'),
      ('b', 'Ask only for money'),
      ('c', 'Ask for guidance, forgiveness, and mercy'),
      ('d', 'Speak only to people, not Allah'),
    ],
    explanation:
        'Islam teaches believers to ask Allah for guidance, forgiveness, mercy, protection, and all good in this life and the next.',
    tags: const ['dua', 'guidance', 'mercy', 'forgiveness'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_easy_009',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which of these is most connected to du‘a?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Hope and trust in Allah'),
      ('b', 'Pride and self-sufficiency'),
      ('c', 'Refusing repentance'),
      ('d', 'Forgetting Allah entirely'),
    ],
    explanation:
        'Du‘a grows from reliance on Allah, hope in His mercy, and trust that He hears and knows.',
    tags: const ['dua', 'hope', 'trust', 'tawakkul'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'dua_easy_010',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.easy,
    prompt: 'A person can make du‘a in their own words.',
    correct: true,
    explanation:
        'A Muslim can use Qur’anic and prophetic supplications and can also ask Allah sincerely in their own words.',
    tags: const ['dua', 'supplication', 'beginner', 'practice'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_011',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which prophet made the du‘a, “My Lord, expand for me my chest and ease for me my task”?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Zakariyya'),
      ('b', 'Musa'),
      ('c', 'Dawud'),
      ('d', 'Ibrahim'),
    ],
    explanation:
        'Prophet Musa, peace be upon him, made this du‘a when asking Allah for help in his mission to Pharaoh.',
    quranReference: 'Qur’an 20:25-28',
    tags: const ['dua', 'musa', 'mission', 'quran'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_012',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which prophet asked Allah for a righteous offspring in a well-known supplication?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Yunus'),
      ('b', 'Harun'),
      ('c', 'Zakariyya'),
      ('d', 'Hud'),
    ],
    explanation:
        'Zakariyya, peace be upon him, called upon Allah for righteous offspring, and Allah answered him with Yahya.',
    quranReference: 'Qur’an 3:38',
    tags: const ['dua', 'zakariyya', 'family', 'quran'],
    dailyEligible: true,
  ),
  trueFalseQuestion(
    id: 'dua_int_013',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Du‘a teaches a believer dependence on Allah rather than dependence on self alone.',
    correct: true,
    explanation:
        'Supplication reminds a believer of human need and Allah’s complete power, mercy, and wisdom.',
    tags: const ['dua', 'dependence', 'tawakkul', 'reflection'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_014',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which of these is a balanced way to think about unanswered du‘a?',
    correctOptionId: 'a',
    options: const [
      (
        'a',
        'Allah answers with wisdom, even when the answer is not in the way or time expected',
      ),
      ('b', 'Du‘a is useless if results are delayed'),
      ('c', 'Only prophets should make du‘a'),
      ('d', 'A believer must stop asking after one attempt'),
    ],
    explanation:
        'A believer makes du‘a with trust, patience, and hope, knowing Allah answers with perfect wisdom.',
    tags: const ['dua', 'patience', 'trust', 'intermediate'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_015',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which of the following best reflects the role of daily supplications?',
    correctOptionId: 'd',
    options: const [
      ('a', 'They replace all obligatory worship'),
      ('b', 'They are only for scholars'),
      ('c', 'They are only for Ramadan'),
      ('d', 'They connect ordinary moments of life to remembrance of Allah'),
    ],
    explanation:
        'Daily supplications turn regular moments into moments of remembrance, gratitude, and reliance upon Allah.',
    tags: const ['dua', 'daily_supplications', 'dhikr', 'remembrance'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_016',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt: 'What is one wisdom behind learning prophetic supplications?',
    correctOptionId: 'b',
    options: const [
      ('a', 'To memorize words without understanding'),
      (
        'b',
        'To ask Allah with beautiful, meaningful, and sound forms of remembrance',
      ),
      ('c', 'To avoid personal sincerity'),
      ('d', 'To make worship difficult'),
    ],
    explanation:
        'Prophetic supplications are rich in meaning and teach believers how to praise, ask, repent, and rely on Allah well.',
    tags: const ['dua', 'sunnah', 'supplication', 'meaning'],
    dailyEligible: true,
  ),
  trueFalseQuestion(
    id: 'dua_int_017',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Du‘a can include both asking Allah for what is needed and praising Him.',
    correct: true,
    explanation:
        'Supplication is not only requests. It also includes praise, gratitude, humility, repentance, and hope.',
    tags: const ['dua', 'praise', 'gratitude', 'intermediate'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_int_018',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which answer best shows adab in du‘a?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Mocking the act of supplication'),
      ('b', 'Speaking with arrogance'),
      ('c', 'Asking with humility, sincerity, and hope'),
      ('d', 'Treating du‘a as meaningless words'),
    ],
    explanation:
        'Good adab in du‘a includes humility, sincerity, reverence, and trust in Allah’s wisdom.',
    tags: const ['dua', 'adab', 'humility', 'hope'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'dua_hard_019',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.hard,
    prompt: 'Why do Qur’anic supplications matter so much in Islamic learning?',
    correctOptionId: 'a',
    options: const [
      (
        'a',
        'They teach believers how revelation itself forms the heart’s requests',
      ),
      ('b', 'They cancel all other supplications'),
      ('c', 'They are only historical quotations'),
      ('d', 'They are unrelated to daily life'),
    ],
    explanation:
        'Qur’anic supplications teach what to ask, how to ask, and what priorities matter in guidance, mercy, repentance, and steadfastness.',
    tags: const ['dua', 'quran', 'learning', 'advanced', 'reflection'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'dua_hard_020',
    categoryId: 'dua',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'A mature understanding of du‘a includes both urgency in asking and patience with Allah’s decree.',
    correct: true,
    explanation:
        'Believers ask earnestly and also trust Allah’s timing, wisdom, and decree. This balance is part of deep worship.',
    tags: const ['dua', 'patience', 'decree', 'trust', 'advanced'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
];
