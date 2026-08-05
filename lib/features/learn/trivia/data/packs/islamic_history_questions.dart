import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

final List<TriviaQuestion> islamicHistoryTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'history_easy_001',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt: 'What is the Hijrah?',
    correctOptionId: 'b',
    options: const [
      ('a', 'The first collection of hadith'),
      ('b', 'The migration from Makkah to Madinah'),
      ('c', 'The conquest of Persia'),
      ('d', 'The building of the Ka‘bah'),
    ],
    explanation:
        'The Hijrah refers to the migration of the Prophet ﷺ and the believers from Makkah to Madinah, marking a major turning point in Islamic history.',
    tags: const ['history', 'hijrah', 'makkah', 'madinah', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    featured: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_002',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which city became the home of the Muslim community after the Hijrah?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Taif'),
      ('b', 'Jerusalem'),
      ('c', 'Madinah'),
      ('d', 'Basrah'),
    ],
    explanation:
        'After the Hijrah, Madinah became the new center of the Muslim community and the place where the Islamic society developed.',
    tags: const ['history', 'madinah', 'hijrah', 'community'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_003',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which battle is known as the first major battle in Islamic history?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Badr'),
      ('b', 'Uhud'),
      ('c', 'Khandaq'),
      ('d', 'Hunayn'),
    ],
    explanation:
        'The Battle of Badr was the first major battle between the Muslims and Quraysh and remains one of the most significant events in early Islamic history.',
    tags: const ['history', 'badr', 'battle', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  trueFalseQuestion(
    id: 'history_easy_004',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Makkah was the birthplace of the Prophet ﷺ.',
    correct: true,
    explanation:
        'The Prophet Muhammad ﷺ was born in Makkah, which remained central throughout the early stages of Islam.',
    tags: const ['history', 'makkah', 'seerah', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_005',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which mosque is widely known as the first mosque established in Islam?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Masjid al-Haram'),
      ('b', 'Masjid al-Aqsa'),
      ('c', 'Masjid an-Nabawi'),
      ('d', 'Masjid Quba'),
    ],
    explanation:
        'Masjid Quba is closely associated with being the first mosque established in the Prophet’s era after the Hijrah.',
    tags: const ['history', 'mosque', 'madinah', 'hijrah'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_006',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which city contains Masjid al-Haram?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Makkah'),
      ('b', 'Madinah'),
      ('c', 'Damascus'),
      ('d', 'Kufa'),
    ],
    explanation:
        'Masjid al-Haram is in Makkah and surrounds the Ka‘bah, the qiblah of the Muslims.',
    tags: const ['history', 'makkah', 'masjid_al_haram', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_007',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which city is associated with Masjid al-Aqsa?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Cairo'),
      ('b', 'Jerusalem'),
      ('c', 'Madinah'),
      ('d', 'Makkah'),
    ],
    explanation:
        'Masjid al-Aqsa is in Jerusalem and holds a special place in Islamic history and devotion.',
    tags: const ['history', 'masjid_al_aqsa', 'jerusalem', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  trueFalseQuestion(
    id: 'history_easy_008',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt: 'The Islamic calendar begins from the Hijrah.',
    correct: true,
    explanation:
        'The Hijri calendar is counted from the Hijrah because of its major importance in the life of the Muslim community.',
    tags: const ['history', 'hijri_calendar', 'hijrah', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_009',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which battle followed Badr and tested the Muslims through hardship?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Tabuk'),
      ('b', 'Hunayn'),
      ('c', 'Uhud'),
      ('d', 'Yarmuk'),
    ],
    explanation:
        'Uhud came after Badr and taught the Muslim community important lessons about obedience, patience, and perseverance.',
    tags: const ['history', 'uhud', 'battle', 'lessons'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_easy_010',
    categoryId: 'history',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'What was the broad purpose of the Trench in the Battle of Khandaq?',
    correctOptionId: 'd',
    options: const [
      ('a', 'To build a market'),
      ('b', 'To collect zakah'),
      ('c', 'To mark prayer rows'),
      ('d', 'To defend Madinah from attack'),
    ],
    explanation:
        'The trench was dug around exposed parts of Madinah as a defensive strategy during the Battle of Khandaq.',
    tags: const ['history', 'khandaq', 'madinah', 'defense'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_011',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'The Treaty of Hudaybiyyah is remembered especially as what?',
    correctOptionId: 'a',
    options: const [
      ('a', 'A peace agreement that later proved deeply beneficial'),
      ('b', 'The first call to prayer'),
      ('c', 'The beginning of Ramadan fasting'),
      ('d', 'The final revelation'),
    ],
    explanation:
        'Hudaybiyyah seemed difficult at first, but it opened space for stability, da‘wah, and later success.',
    tags: const ['history', 'hudaybiyyah', 'peace', 'intermediate'],
    dailyEligible: true,
  ),
  trueFalseQuestion(
    id: 'history_int_012',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'The conquest of Makkah is remembered as a moment of mercy and the removal of idols from the Ka‘bah.',
    correct: true,
    explanation:
        'The conquest of Makkah was a decisive moment in which tawhid was publicly restored in the sacred sanctuary.',
    tags: const ['history', 'conquest_of_makkah', 'tawhid', 'intermediate'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_013',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Why is the Hijrah considered more than just a change of location?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Because it ended all hardship permanently'),
      (
        'b',
        'Because it marked the formation of a new Muslim community and public order',
      ),
      ('c', 'Because it replaced the Qur’an'),
      ('d', 'Because it cancelled prayer'),
    ],
    explanation:
        'The Hijrah was a social, spiritual, and political turning point for the Muslim ummah, not just a journey.',
    tags: const ['history', 'hijrah', 'community', 'madinah'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_014',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which battle is especially associated with a lesson about obeying the Prophet’s command and not abandoning one’s post?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Badr'),
      ('b', 'Hunayn'),
      ('c', 'Uhud'),
      ('d', 'Tabuk'),
    ],
    explanation:
        'Uhud taught enduring lessons about obedience, discipline, and the consequences of leaving assigned responsibilities.',
    tags: const ['history', 'uhud', 'obedience', 'lessons'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_015',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'What broad lesson is often taken from the Battle of Badr?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Numbers alone guarantee success'),
      ('b', 'Patience is unnecessary'),
      ('c', 'Preparation has no value'),
      ('d', 'Victory comes from Allah, even when believers seem outnumbered'),
    ],
    explanation:
        'Badr reminds believers that success is tied to Allah’s support, sincere faith, and steadfastness, not numbers alone.',
    tags: const ['history', 'badr', 'trust_in_allah', 'reflection'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'history_int_016',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Islamic history is only useful for memorizing dates.',
    correct: false,
    explanation:
        'Islamic history is studied for lessons, wisdom, courage, mistakes, leadership, patience, and faithfulness to revelation.',
    tags: const ['history', 'lessons', 'reflection', 'intermediate'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_017',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Why is Madinah central in early Islamic history?',
    correctOptionId: 'a',
    options: const [
      (
        'a',
        'It became the place where the Muslim community grew and Islamic life was organized',
      ),
      ('b', 'It replaced Makkah as qiblah'),
      ('c', 'It was the birthplace of Ibrahim'),
      ('d', 'It was the only city where prayer was allowed'),
    ],
    explanation:
        'Madinah became the home of the Prophet ﷺ and the center where the Muslim community was established and nurtured.',
    tags: const ['history', 'madinah', 'community', 'seerah'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'history_int_018',
    categoryId: 'history',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which answer best describes the Islamic calendar?',
    correctOptionId: 'b',
    options: const [
      ('a', 'A solar calendar beginning at the conquest of Makkah'),
      ('b', 'A lunar calendar whose starting point is the Hijrah'),
      ('c', 'A Roman calendar with Arabic names'),
      ('d', 'A calendar beginning with the Battle of Badr'),
    ],
    explanation:
        'The Hijri calendar is lunar and begins from the Hijrah, reflecting its importance in Islamic history.',
    tags: const ['history', 'hijri_calendar', 'lunar', 'hijrah'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'history_hard_019',
    categoryId: 'history',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'Why is the Treaty of Hudaybiyyah often taught as a lesson in strategic patience?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Because it ended all conflict forever'),
      ('b', 'Because it had no long-term consequence'),
      (
        'c',
        'Because what looked difficult in the moment opened the door to later growth and stability',
      ),
      ('d', 'Because it removed the need for da‘wah'),
    ],
    explanation:
        'Hudaybiyyah shows that immediate appearances can be misleading; patient restraint can open major doors for the future.',
    tags: const ['history', 'hudaybiyyah', 'patience', 'strategy', 'advanced'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'history_hard_020',
    categoryId: 'history',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'A careful study of Islamic history should increase reflection and wisdom, not just pride in past events.',
    correct: true,
    explanation:
        'History in Islam is studied for guidance, humility, gratitude, and lessons in faith and leadership.',
    tags: const ['history', 'reflection', 'wisdom', 'advanced'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
];
