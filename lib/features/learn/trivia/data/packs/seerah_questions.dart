import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

final List<TriviaQuestion> seerahTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'seerah_easy_001',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt: 'In which city was Prophet Muhammad ﷺ born?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Makkah'),
      ('b', 'Madinah'),
      ('c', 'Jerusalem'),
      ('d', 'Taif'),
    ],
    explanation:
        'Prophet Muhammad ﷺ was born in Makkah, where the first part of his mission also unfolded.',
    tags: const ['seerah', 'makkah', 'prophet_muhammad', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    featured: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_002',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'What title was the Prophet ﷺ known by before prophethood because of his honesty and trustworthiness?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Al-Fatih'),
      ('b', 'As-Sabir'),
      ('c', 'Al-Qari'),
      ('d', 'Al-Amin'),
    ],
    explanation:
        'The Prophet ﷺ was known as Al-Amin, the trustworthy one, even before revelation came to him.',
    tags: const ['seerah', 'character', 'al_amin', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_003',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Where did the first revelation come to the Prophet ﷺ?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Masjid an-Nabawi'),
      ('b', 'Cave Hira'),
      ('c', 'Mount Sinai'),
      ('d', 'Mina'),
    ],
    explanation:
        'The first revelation came while the Prophet ﷺ was in Cave Hira, beginning his mission as Allah’s Messenger.',
    tags: const ['seerah', 'revelation', 'hira', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    featured: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_004',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Who accompanied the Prophet ﷺ during the Hijrah?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Umar ibn al-Khattab'),
      ('b', 'Ali ibn Abi Talib'),
      ('c', 'Abu Bakr'),
      ('d', 'Bilal ibn Rabah'),
    ],
    explanation:
        'Abu Bakr accompanied the Prophet ﷺ on the Hijrah, showing deep loyalty and trust in Allah.',
    tags: const ['seerah', 'hijrah', 'abu_bakr', 'madinah'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  trueFalseQuestion(
    id: 'seerah_easy_005',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'The Seerah is the study of the life and mission of Prophet Muhammad ﷺ.',
    correct: true,
    explanation:
        'Seerah refers to the life, character, struggle, leadership, and example of the Prophet Muhammad ﷺ.',
    tags: const ['seerah', 'definition', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_006',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which city welcomed the Prophet ﷺ after the Hijrah?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Madinah'),
      ('b', 'Basrah'),
      ('c', 'Taif'),
      ('d', 'Jerusalem'),
    ],
    explanation:
        'Madinah welcomed the Prophet ﷺ and became the home of the Muslim community after the Hijrah.',
    tags: const ['seerah', 'madinah', 'hijrah', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_007',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which battle is the first major battle in the Prophet’s Madinan period?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Uhud'),
      ('b', 'Badr'),
      ('c', 'Khandaq'),
      ('d', 'Hunayn'),
    ],
    explanation:
        'Badr was the first major battle in the Madinan period and remains one of the defining moments of the Seerah.',
    tags: const ['seerah', 'badr', 'battle', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  trueFalseQuestion(
    id: 'seerah_easy_008',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'The Prophet ﷺ showed mercy even toward many who had once opposed him.',
    correct: true,
    explanation:
        'The Seerah repeatedly shows the Prophet’s mercy, patience, and restraint, especially in moments of power.',
    tags: const ['seerah', 'mercy', 'character', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_009',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which event is associated with the peaceful return to Makkah and the removal of idols from the Ka‘bah?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Battle of Uhud'),
      ('b', 'Treaty of Hudaybiyyah'),
      ('c', 'Isra and Mi‘raj'),
      ('d', 'Conquest of Makkah'),
    ],
    explanation:
        'The conquest of Makkah was a decisive Seerah moment in which tawhid was openly restored at the Ka‘bah.',
    tags: const ['seerah', 'conquest_of_makkah', 'tawhid', 'beginner'],
    dailyEligible: true,
    beginnerFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_easy_010',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which quality is especially learned from the Prophet’s early years in Makkah?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Harshness'),
      ('b', 'Pride'),
      ('c', 'Patience'),
      ('d', 'Isolation from all people'),
    ],
    explanation:
        'The Makkan period of the Seerah teaches patience, perseverance, and faithfulness under pressure.',
    tags: const ['seerah', 'makkah', 'patience', 'reflection'],
    dailyEligible: true,
    beginnerFriendly: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_011',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Why is the study of Seerah important for Muslims today?',
    correctOptionId: 'a',
    options: const [
      ('a', 'It teaches how the Prophet ﷺ lived Islam with wisdom, mercy, and firmness'),
      ('b', 'It replaces the Qur’an'),
      ('c', 'It is only about military history'),
      ('d', 'It is only for scholars of language'),
    ],
    explanation:
        'Seerah helps believers see revelation lived out in character, worship, leadership, hardship, and mercy.',
    tags: const ['seerah', 'learning', 'prophet_muhammad', 'intermediate'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_012',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'What did the title Al-Amin reflect about the Prophet ﷺ before revelation?',
    correctOptionId: 'd',
    options: const [
      ('a', 'His skill in warfare'),
      ('b', 'His wealth'),
      ('c', 'His political rank'),
      ('d', 'His honesty and trustworthiness'),
    ],
    explanation:
        'This title shows that truthfulness and trustworthiness were already deeply recognized in his character.',
    tags: const ['seerah', 'character', 'al_amin', 'intermediate'],
    dailyEligible: true,
  ),
  trueFalseQuestion(
    id: 'seerah_int_013',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'The Hijrah teaches reliance on Allah while also taking wise practical means.',
    correct: true,
    explanation:
        'The Hijrah shows both tawakkul and planning: trust in Allah alongside wise preparation and action.',
    tags: const ['seerah', 'hijrah', 'tawakkul', 'wisdom'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_014',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which event is often taught as an example of strategic patience and long-term wisdom in the Seerah?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Battle of Uhud'),
      ('b', 'Treaty of Hudaybiyyah'),
      ('c', 'Opening of Khaybar'),
      ('d', 'Farewell pilgrimage'),
    ],
    explanation:
        'Hudaybiyyah shows how patience and restraint can open doors that immediate force would not.',
    tags: const ['seerah', 'hudaybiyyah', 'patience', 'wisdom'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_015',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'What broad lesson is often drawn from the Prophet’s treatment of people after the conquest of Makkah?',
    correctOptionId: 'c',
    options: const [
      ('a', 'Leadership means revenge'),
      ('b', 'Mercy is weakness'),
      ('c', 'Mercy and forgiveness can be stronger than retaliation'),
      ('d', 'Power is the final goal'),
    ],
    explanation:
        'The conquest of Makkah is remembered as a powerful example of mercy, restraint, and principled leadership.',
    tags: const ['seerah', 'conquest_of_makkah', 'mercy', 'leadership'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_016',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which city was the setting for the Prophet’s mission before the Hijrah?',
    correctOptionId: 'a',
    options: const [
      ('a', 'Makkah'),
      ('b', 'Madinah'),
      ('c', 'Kufa'),
      ('d', 'Alexandria'),
    ],
    explanation:
        'The Makkan phase of the Seerah centered on calling people to tawhid with patience under persecution.',
    tags: const ['seerah', 'makkah', 'dawah', 'intermediate'],
    dailyEligible: true,
  ),
  trueFalseQuestion(
    id: 'seerah_int_017',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'The Seerah only teaches events and does not teach manners or character.',
    correct: false,
    explanation:
        'The Seerah teaches both events and character. It is one of the richest sources for learning mercy, patience, courage, and wisdom.',
    tags: const ['seerah', 'character', 'learning', 'intermediate'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_int_018',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which answer best describes Madinah in the Seerah?',
    correctOptionId: 'd',
    options: const [
      ('a', 'Only a place of trade'),
      ('b', 'Only a battlefield'),
      ('c', 'A place unrelated to community building'),
      ('d', 'The city where the Muslim community took organized shape'),
    ],
    explanation:
        'Madinah is central in the Seerah because it was where communal Islamic life, law, worship, and social bonds took clearer form.',
    tags: const ['seerah', 'madinah', 'community', 'intermediate'],
    dailyEligible: true,
  ),
  multipleChoiceQuestion(
    id: 'seerah_hard_019',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'Why is the Makkan period of the Seerah especially important for understanding faith?',
    correctOptionId: 'b',
    options: const [
      ('a', 'Because it focused only on politics'),
      ('b', 'Because it shows tawhid, patience, and steadfastness before political strength'),
      ('c', 'Because it ended the need for later revelation'),
      ('d', 'Because it removed all hardship quickly'),
    ],
    explanation:
        'The Makkan years teach the deep roots of iman, tawhid, patience, and endurance before visible worldly strength appears.',
    tags: const ['seerah', 'makkah', 'tawhid', 'patience', 'advanced'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
  trueFalseQuestion(
    id: 'seerah_hard_020',
    categoryId: 'seerah',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'A serious study of Seerah should increase both love for the Prophet ﷺ and a clearer understanding of how Islam is lived.',
    correct: true,
    explanation:
        'Seerah is not only historical knowledge. It helps believers understand worship, leadership, patience, mercy, and prophetic character in practice.',
    tags: const ['seerah', 'learning', 'love_of_prophet', 'advanced', 'reflection'],
    dailyEligible: true,
    reflectionFriendly: true,
  ),
];
