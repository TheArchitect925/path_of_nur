import '../../../../l10n/app_localizations.dart';
import '../domain/learning_path_models.dart';

class LearningPathRegistry {
  static const paths = <LearningPath>[
    LearningPath(
      id: 'beginner-path',
      level: LearningPathLevel.beginner,
      title: 'Beginner Path',
      description: 'A calm first route through Islam, worship, and identity.',
      phases: [
        LearningPathPhase(
          id: 'beginner-foundations',
          title: 'Foundations',
          description: 'Start with Islam, Allah, and the pillars.',
          order: 1,
          journeyIds: ['islam-foundations', 'foundations-of-faith'],
          guidedPathIds: ['foundations-starter'],
          triviaPathId: 'foundations_of_islam',
        ),
        LearningPathPhase(
          id: 'beginner-daily-practice',
          title: 'Daily Practice',
          description:
              'Build the essentials of worship one calm step at a time.',
          order: 2,
          journeyIds: [
            'salah-foundations',
            'journey-of-wudu',
            'duas-daily-life',
          ],
          guidedPathIds: ['salah-starter'],
          triviaPathId: 'learning_salah',
        ),
        LearningPathPhase(
          id: 'beginner-connection',
          title: 'Connection',
          description: 'Deepen prayer, recitation, and a first hadith rhythm.',
          order: 3,
          journeyIds: [
            'understanding-al-fatihah',
            'short-surahs',
            'hadith-essentials',
          ],
          guidedPathIds: ['quran-beginner-starter'],
          triviaPathId: 'understanding_the_quran',
        ),
        LearningPathPhase(
          id: 'beginner-identity',
          title: 'Identity',
          description:
              'Grow through stories, belonging, and beautiful character.',
          order: 4,
          journeyIds: ['prophets-journey', 'beautiful-character'],
          guidedPathIds: ['stories-starter', 'character-starter'],
          triviaPathId: 'prophets_journey',
        ),
      ],
    ),
    LearningPath(
      id: 'practicing-path',
      level: LearningPathLevel.practicing,
      title: 'Practicing Path',
      description: 'Strengthen consistency in worship and understanding.',
      phases: [
        LearningPathPhase(
          id: 'practicing-worship',
          title: 'Strengthen Worship',
          description: 'Rebuild daily worship through salah, dhikr, and duas.',
          order: 1,
          journeyIds: ['salah-foundations', 'daily-dhikr', 'duas-daily-life'],
          guidedPathIds: ['salah-starter', 'daily-dhikr-starter'],
          triviaPathId: 'learning_salah',
        ),
        LearningPathPhase(
          id: 'practicing-understanding',
          title: 'Understanding',
          description: 'Connect Quran reading, meaning, and recurring words.',
          order: 2,
          journeyIds: [
            'journey-quran',
            'understand-what-you-recite',
            '100-quranic-words',
          ],
          guidedPathIds: ['quran-beginner-starter'],
          triviaPathId: 'understanding_the_quran',
        ),
        LearningPathPhase(
          id: 'practicing-character',
          title: 'Character',
          description:
              'Keep worship connected to manners, reflection, and hadith.',
          order: 3,
          journeyIds: ['beautiful-character', 'hadith-essentials'],
          guidedPathIds: ['character-starter'],
        ),
        LearningPathPhase(
          id: 'practicing-structure',
          title: 'Structure',
          description: 'Add Ramadan preparation and a steady daily rhythm.',
          order: 4,
          journeyIds: ['ramadan-foundations', 'daily-routines'],
        ),
      ],
    ),
    LearningPath(
      id: 'seeker-path',
      level: LearningPathLevel.seeker,
      title: 'Knowledge Seeker Path',
      description:
          'A more structured route through belief, history, and integration.',
      phases: [
        LearningPathPhase(
          id: 'seeker-foundations',
          title: 'Foundations',
          description: 'Strengthen belief, practice, and historical context.',
          order: 1,
          journeyIds: [
            'foundations-of-faith',
            'fiqh-basics',
            'timeline-of-islam',
          ],
          guidedPathIds: ['foundations-starter'],
          triviaPathId: 'foundations_of_islam',
        ),
        LearningPathPhase(
          id: 'seeker-quran-depth',
          title: 'Quran Depth',
          description:
              'Move from reading toward themes, surahs, and guided reflection.',
          order: 2,
          journeyIds: ['journey-quran', 'short-surahs'],
          guidedPathIds: ['quran-beginner-starter'],
          triviaPathId: 'understanding_the_quran',
        ),
        LearningPathPhase(
          id: 'seeker-arabic',
          title: 'Arabic',
          description: 'Build reading fluency and recurring word recognition.',
          order: 3,
          journeyIds: ['reading-basics', '100-quranic-words'],
        ),
        LearningPathPhase(
          id: 'seeker-integration',
          title: 'Integration',
          description: 'Tie history, signs, and prophetic life together.',
          order: 4,
          journeyIds: ['seerah-journey', 'stories-signs'],
          guidedPathIds: ['stories-starter'],
          triviaPathId: 'prophets_journey',
        ),
      ],
    ),
    LearningPath(
      id: 'advanced-path',
      level: LearningPathLevel.advanced,
      title: 'Advanced Path',
      description:
          'A quieter route focused on refinement, reflection, and action.',
      phases: [
        LearningPathPhase(
          id: 'advanced-reflection',
          title: 'Reflection',
          description:
              'Keep learning alive through daily reflection and synthesis.',
          order: 1,
          journeyIds: ['reflection-mode', 'daily-wisdom'],
        ),
        LearningPathPhase(
          id: 'advanced-refinement',
          title: 'Refinement',
          description:
              'Refine recitation and deepen understanding with intention.',
          order: 2,
          journeyIds: ['tajweed-basics', 'journey-quran'],
          triviaPathId: 'understanding_the_quran',
        ),
        LearningPathPhase(
          id: 'advanced-character-action',
          title: 'Character and Action',
          description:
              'Connect refinement to habit, service, and sustained worship.',
          order: 3,
          journeyIds: ['beautiful-character', 'daily-routines', 'daily-dhikr'],
          guidedPathIds: ['character-starter', 'daily-dhikr-starter'],
        ),
      ],
    ),
  ];

  static LearningPath? pathForLevel(LearningPathLevel level) {
    return paths.where((item) => item.level == level).firstOrNull;
  }

  static String localizedPathTitle(AppLocalizations l10n, LearningPath path) {
    return switch (path.id) {
      'beginner-path' => l10n.learningPathBeginnerTitle,
      'practicing-path' => l10n.learningPathPracticingTitle,
      'seeker-path' => l10n.learningPathSeekerTitle,
      'advanced-path' => l10n.learningPathAdvancedTitle,
      _ => path.title,
    };
  }

  static String localizedPathDescription(
    AppLocalizations l10n,
    LearningPath path,
  ) {
    return switch (path.id) {
      'beginner-path' => l10n.learningPathBeginnerDescription,
      'practicing-path' => l10n.learningPathPracticingDescription,
      'seeker-path' => l10n.learningPathSeekerDescription,
      'advanced-path' => l10n.learningPathAdvancedDescription,
      _ => path.description,
    };
  }

  static String localizedPhaseTitle(
    AppLocalizations l10n,
    LearningPathPhase phase,
  ) {
    return switch (phase.id) {
      'beginner-foundations' => l10n.learningPathPhaseBeginnerFoundationsTitle,
      'beginner-daily-practice' =>
        l10n.learningPathPhaseBeginnerDailyPracticeTitle,
      'beginner-connection' => l10n.learningPathPhaseBeginnerConnectionTitle,
      'beginner-identity' => l10n.learningPathPhaseBeginnerIdentityTitle,
      'practicing-worship' => l10n.learningPathPhasePracticingWorshipTitle,
      'practicing-understanding' =>
        l10n.learningPathPhasePracticingUnderstandingTitle,
      'practicing-character' => l10n.learningPathPhasePracticingCharacterTitle,
      'practicing-structure' => l10n.learningPathPhasePracticingStructureTitle,
      'seeker-foundations' => l10n.learningPathPhaseSeekerFoundationsTitle,
      'seeker-quran-depth' => l10n.learningPathPhaseSeekerQuranDepthTitle,
      'seeker-arabic' => l10n.learningPathPhaseSeekerArabicTitle,
      'seeker-integration' => l10n.learningPathPhaseSeekerIntegrationTitle,
      'advanced-reflection' => l10n.learningPathPhaseAdvancedReflectionTitle,
      'advanced-refinement' => l10n.learningPathPhaseAdvancedRefinementTitle,
      'advanced-character-action' =>
        l10n.learningPathPhaseAdvancedCharacterActionTitle,
      _ => phase.title,
    };
  }

  static String localizedPhaseDescription(
    AppLocalizations l10n,
    LearningPathPhase phase,
  ) {
    return switch (phase.id) {
      'beginner-foundations' =>
        l10n.learningPathPhaseBeginnerFoundationsDescription,
      'beginner-daily-practice' =>
        l10n.learningPathPhaseBeginnerDailyPracticeDescription,
      'beginner-connection' =>
        l10n.learningPathPhaseBeginnerConnectionDescription,
      'beginner-identity' => l10n.learningPathPhaseBeginnerIdentityDescription,
      'practicing-worship' =>
        l10n.learningPathPhasePracticingWorshipDescription,
      'practicing-understanding' =>
        l10n.learningPathPhasePracticingUnderstandingDescription,
      'practicing-character' =>
        l10n.learningPathPhasePracticingCharacterDescription,
      'practicing-structure' =>
        l10n.learningPathPhasePracticingStructureDescription,
      'seeker-foundations' =>
        l10n.learningPathPhaseSeekerFoundationsDescription,
      'seeker-quran-depth' => l10n.learningPathPhaseSeekerQuranDepthDescription,
      'seeker-arabic' => l10n.learningPathPhaseSeekerArabicDescription,
      'seeker-integration' =>
        l10n.learningPathPhaseSeekerIntegrationDescription,
      'advanced-reflection' =>
        l10n.learningPathPhaseAdvancedReflectionDescription,
      'advanced-refinement' =>
        l10n.learningPathPhaseAdvancedRefinementDescription,
      'advanced-character-action' =>
        l10n.learningPathPhaseAdvancedCharacterActionDescription,
      _ => phase.description,
    };
  }
}
