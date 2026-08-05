import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

const _pack = 'akhlaq_foundations';

final List<TriviaQuestion> ethicsCharacterTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'akhlaq_easy_001',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.easy,
    prompt: 'What does akhlaq broadly refer to?',
    options: const [
      ('character', 'Character and conduct'),
      ('calendar', 'The calendar only'),
      ('trade', 'Trade rules only'),
      ('travel', 'Travel only'),
    ],
    correctOptionId: 'character',
    explanation:
        'Akhlaq refers to manners, character, and the way a person behaves.',
    tags: const ['akhlaq', 'character', 'beginner'],
    beginnerFriendly: true,
    featured: true,
    packId: _pack,
    sortOrder: 1,
  ),
  trueFalseQuestion(
    id: 'akhlaq_easy_002',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Truthfulness is part of good Islamic character.',
    correct: true,
    explanation:
        'Truthfulness is among the central qualities of upright Muslim character.',
    tags: const ['akhlaq', 'truthfulness', 'beginner'],
    beginnerFriendly: true,
    packId: _pack,
    sortOrder: 2,
  ),
  multipleChoiceQuestion(
    id: 'akhlaq_easy_003',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.easy,
    prompt: 'What is one broad sign of good character?',
    options: const [
      ('kindness', 'Kindness to people'),
      ('mockery', 'Mockery of others'),
      ('cheating', 'Cheating in dealings'),
      ('arrogance', 'Arrogance'),
    ],
    correctOptionId: 'kindness',
    explanation:
        'Good character is shown through kindness, honesty, patience, and restraint.',
    tags: const ['akhlaq', 'kindness', 'beginner'],
    beginnerFriendly: true,
    featured: true,
    packId: _pack,
    sortOrder: 3,
  ),
  multipleChoiceQuestion(
    id: 'akhlaq_easy_004',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Which quality helps a person stay steady when tested?',
    options: const [
      ('patience', 'Patience'),
      ('haste', 'Haste'),
      ('boasting', 'Boasting'),
      ('envy', 'Envy'),
    ],
    correctOptionId: 'patience',
    explanation:
        'Patience is a central part of faith and character under difficulty.',
    tags: const ['akhlaq', 'patience', 'beginner'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 4,
  ),
  trueFalseQuestion(
    id: 'akhlaq_easy_005',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.easy,
    prompt: 'Islamic character includes how a person speaks to others.',
    correct: true,
    explanation: 'Speech is one of the clearest signs of character and faith.',
    tags: const ['akhlaq', 'speech', 'beginner'],
    beginnerFriendly: true,
    packId: _pack,
    sortOrder: 5,
  ),
  multipleChoiceQuestion(
    id: 'akhlaq_med_006',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which statement best fits Islamic honesty?',
    options: const [
      ('truth', 'Speaking truth and dealing fairly'),
      ('success_only', 'Doing whatever succeeds even if unfair'),
      ('image_only', 'Looking good without substance'),
      ('silence_only', 'Never speaking at all'),
    ],
    correctOptionId: 'truth',
    explanation:
        'Islamic honesty is seen both in speech and in dealings with people.',
    tags: const ['akhlaq', 'truthfulness', 'intermediate'],
    packId: _pack,
    sortOrder: 6,
  ),
  trueFalseQuestion(
    id: 'akhlaq_med_007',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Good akhlaq includes controlling anger rather than letting it rule every response.',
    correct: true,
    explanation:
        'Self-restraint and control are signs of strength in character.',
    tags: const ['akhlaq', 'anger', 'self_control', 'intermediate'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 7,
  ),
  multipleChoiceQuestion(
    id: 'akhlaq_med_008',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.medium,
    prompt: 'What is one broad fruit of gratitude in character?',
    options: const [
      ('contentment', 'Contentment and recognition of blessings'),
      ('arrogance', 'Arrogance and pride'),
      ('neglect', 'Neglect of others'),
      ('waste', 'Wastefulness'),
    ],
    correctOptionId: 'contentment',
    explanation:
        'Gratitude softens the heart and teaches a person to notice blessings instead of resentment.',
    tags: const ['akhlaq', 'gratitude', 'intermediate'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 8,
  ),
  multipleChoiceQuestion(
    id: 'akhlaq_hard_009',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'Which statement best describes the relationship between worship and character?',
    options: const [
      ('linked', 'Worship and character are deeply linked in Islam'),
      ('separate', 'They are completely unrelated'),
      ('optional', 'Character is optional if worship exists'),
      ('private_only', 'Character matters only in private'),
    ],
    correctOptionId: 'linked',
    explanation:
        'Islam ties worship to visible character, mercy, honesty, and self-restraint.',
    tags: const ['akhlaq', 'worship', 'advanced'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 9,
  ),
  trueFalseQuestion(
    id: 'akhlaq_hard_010',
    categoryId: 'akhlaq',
    difficulty: TriviaDifficulty.hard,
    prompt:
        'Akhlaq is only about private feelings and has nothing to do with how a person treats others.',
    correct: false,
    explanation:
        'Character is seen in speech, honesty, mercy, patience, fairness, and the way one treats others.',
    tags: const ['akhlaq', 'character', 'advanced'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 10,
  ),
];
