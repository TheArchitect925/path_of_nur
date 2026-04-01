import '../domain/learning_personalization_models.dart';

const List<LearningPathSequenceDefinition> kLearningPathSequenceDefinitions =
    <LearningPathSequenceDefinition>[
      LearningPathSequenceDefinition(
        pathId: 'foundations-starter',
        nextPathIds: <String>[
          'salah-starter',
          'quran-beginner-starter',
          'daily-dhikr-starter',
        ],
      ),
      LearningPathSequenceDefinition(
        pathId: 'salah-starter',
        nextPathIds: <String>['daily-dhikr-starter', 'character-starter'],
      ),
      LearningPathSequenceDefinition(
        pathId: 'quran-beginner-starter',
        nextPathIds: <String>['character-starter', 'daily-dhikr-starter'],
      ),
      LearningPathSequenceDefinition(
        pathId: 'daily-dhikr-starter',
        nextPathIds: <String>['character-starter', 'quran-beginner-starter'],
      ),
      LearningPathSequenceDefinition(
        pathId: 'character-starter',
        nextPathIds: <String>['stories-starter', 'quran-beginner-starter'],
      ),
      LearningPathSequenceDefinition(
        pathId: 'stories-starter',
        nextPathIds: <String>['character-starter', 'quran-beginner-starter'],
      ),
      LearningPathSequenceDefinition(
        pathId: 'kids-starter',
        nextPathIds: <String>['kids-starter'],
      ),
    ];

const Map<LearningIntentSignal, List<String>> kLearningIntentDefaultPathIds =
    <LearningIntentSignal, List<String>>{
      LearningIntentSignal.foundations: <String>['foundations-starter'],
      LearningIntentSignal.quran: <String>[
        'quran-beginner-starter',
        'foundations-starter',
      ],
      LearningIntentSignal.worship: <String>[
        'salah-starter',
        'daily-dhikr-starter',
      ],
      LearningIntentSignal.character: <String>[
        'character-starter',
        'foundations-starter',
      ],
      LearningIntentSignal.stories: <String>[
        'stories-starter',
        'character-starter',
      ],
      LearningIntentSignal.games: <String>['kids-starter', 'character-starter'],
      LearningIntentSignal.kids: <String>['kids-starter'],
      LearningIntentSignal.general: <String>[
        'foundations-starter',
        'salah-starter',
        'quran-beginner-starter',
      ],
    };
