import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

const _pack = 'general_starter';

final List<TriviaQuestion> generalKnowledgeTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'general_easy_001',
    categoryId: 'general',
    difficulty: TriviaDifficulty.easy,
    prompt: 'What does “Alhamdulillah” mean?',
    options: const [
      ('praise', 'All praise is for Allah'),
      ('forgive', 'O Allah, forgive me'),
      ('peace', 'Peace be upon you'),
      ('guide', 'Guide us to the straight path'),
    ],
    correctOptionId: 'praise',
    explanation:
        '“Alhamdulillah” is a phrase of gratitude and praise to Allah.',
    tags: const ['general', 'dhikr', 'beginner'],
    beginnerFriendly: true,
    packId: _pack,
    sortOrder: 1,
  ),
  trueFalseQuestion(
    id: 'general_easy_002',
    categoryId: 'general',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Islam has five pillars.',
    correct: true,
    explanation:
        'The five pillars include shahadah, salah, zakah, fasting Ramadan, and hajj for those able.',
    sourceReference: 'Foundational Islamic teaching',
    tags: const ['general', 'pillars', 'beginner'],
    beginnerFriendly: true,
    featured: true,
    packId: _pack,
    sortOrder: 2,
  ),
  multipleChoiceQuestion(
    id: 'general_med_003',
    categoryId: 'general',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which greeting is the standard Islamic greeting of peace?',
    options: const [
      ('salam', 'As-salamu alaykum'),
      ('hamd', 'Alhamdulillah'),
      ('takbir', 'Allahu Akbar'),
      ('hawqala', 'La hawla wa la quwwata illa billah'),
    ],
    correctOptionId: 'salam',
    explanation:
        'As-salamu alaykum is the greeting of peace taught to Muslims.',
    tags: const ['general', 'manners', 'ethics'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 3,
  ),
  multipleChoiceQuestion(
    id: 'general_med_004',
    categoryId: 'general',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which city is home to Al-Masjid al-Haram?',
    options: const [
      ('makkah', 'Makkah'),
      ('madinah', 'Madinah'),
      ('jerusalem', 'Jerusalem'),
      ('cairo', 'Cairo'),
    ],
    correctOptionId: 'makkah',
    explanation:
        'Al-Masjid al-Haram is in Makkah and surrounds the Ka‘bah.',
    tags: const ['general', 'makkah', 'places'],
    packId: _pack,
    sortOrder: 4,
  ),
];
