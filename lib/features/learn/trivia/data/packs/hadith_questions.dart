import '../../domain/trivia_models.dart';
import '../trivia_question_builders.dart';

const _pack = 'hadith_starter';

final List<TriviaQuestion> hadithTriviaQuestions = [
  multipleChoiceQuestion(
    id: 'hadith_easy_001',
    categoryId: 'hadith',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Which famous hadith begins with “Actions are judged by intentions”?',
    options: const [
      ('innama', 'Innama al-a\'malu bin-niyyat'),
      ('rahmah', 'Ar-Rahimuna yarhamuhum ar-Rahman'),
      ('nasihah', 'Ad-dinu an-nasihah'),
      ('hayaa', 'Al-hayaa\'u min al-iman'),
    ],
    correctOptionId: 'innama',
    explanation:
        'This foundational hadith teaches that deeds are weighed by the intentions behind them.',
    sourceReference: 'Sahih al-Bukhari 1; Sahih Muslim 1907',
    tags: const ['hadith', 'intentions', 'foundations'],
    beginnerFriendly: true,
    packId: _pack,
    sortOrder: 1,
  ),
  trueFalseQuestion(
    id: 'hadith_easy_002',
    categoryId: 'hadith',
    difficulty: TriviaDifficulty.easy,
    prompt:
        'Sunnah only refers to optional deeds and never to the Prophet’s teachings more broadly.',
    correct: false,
    explanation:
        'The Sunnah refers broadly to the Prophet’s teachings, example, and guidance. Some Sunnah acts are optional, but the term is wider than that.',
    sourceReference: 'General hadith sciences usage',
    tags: const ['hadith', 'sunnah', 'beginner'],
    beginnerFriendly: true,
    packId: _pack,
    sortOrder: 2,
  ),
  multipleChoiceQuestion(
    id: 'hadith_med_003',
    categoryId: 'hadith',
    difficulty: TriviaDifficulty.medium,
    prompt: 'Which act was described by the Prophet as a form of charity?',
    options: const [
      ('removing_harm', 'Removing harm from the road'),
      ('silent_fast', 'Keeping silent all day'),
      ('avoiding_work', 'Avoiding work to focus on worship only'),
      ('sleeping_after_asr', 'Sleeping after Asr every day'),
    ],
    correctOptionId: 'removing_harm',
    explanation:
        'Removing harm from the path benefits others and was counted among acts of charity.',
    sourceReference: 'Sahih Muslim 1009',
    tags: const ['hadith', 'ethics', 'service'],
    packId: _pack,
    sortOrder: 3,
  ),
  multipleChoiceQuestion(
    id: 'hadith_med_004',
    categoryId: 'hadith',
    difficulty: TriviaDifficulty.medium,
    prompt:
        'Which trait was directly linked to faith in the statement “modesty is part of faith”?',
    options: const [
      ('haya', 'Modesty'),
      ('anger', 'Anger'),
      ('wealth', 'Wealth'),
      ('silence', 'Silence'),
    ],
    correctOptionId: 'haya',
    explanation: 'The Prophet taught that haya, or modesty, is part of iman.',
    sourceReference: 'Sahih al-Bukhari 24; Sahih Muslim 36',
    tags: const ['hadith', 'iman', 'ethics'],
    reflectionFriendly: true,
    packId: _pack,
    sortOrder: 4,
  ),
];
