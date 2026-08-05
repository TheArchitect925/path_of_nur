import '../../../../l10n/app_localizations.dart';
import '../models/wudu_models.dart';

const int wuduTrainerStepCount = 14;

List<WuduStep> buildWuduStepContent(AppLocalizations l10n) {
  return <WuduStep>[
    WuduStep(
      id: 'niyyah',
      number: 1,
      title: l10n.wuduTrainerStep1Title,
      subtitle: l10n.wuduTrainerStep1Subtitle,
      teachingNote: l10n.wuduTrainerStep1Note,
      iconKey: 'intention',
      imageAssetPath: 'assets/images/wudu/step_01_niyyah.webp',
      quizKeywords: const <String>['niyyah', 'intention', 'beginning'],
    ),
    WuduStep(
      id: 'prepare_water',
      number: 2,
      title: l10n.wuduTrainerStep2Title,
      subtitle: l10n.wuduTrainerStep2Subtitle,
      iconKey: 'water',
      imageAssetPath: 'assets/images/wudu/step_02_prepare_water.webp',
      quizKeywords: const <String>['water', 'clean', 'prepare'],
    ),
    WuduStep(
      id: 'bismillah',
      number: 3,
      title: l10n.wuduTrainerStep3Title,
      subtitle: l10n.wuduTrainerStep3Subtitle,
      iconKey: 'bismillah',
      imageAssetPath: 'assets/images/wudu/step_03_bismillah.webp',
      quizKeywords: const <String>['bismillah', 'start', 'name of Allah'],
    ),
    WuduStep(
      id: 'wash_hands',
      number: 4,
      title: l10n.wuduTrainerStep4Title,
      subtitle: l10n.wuduTrainerStep4Subtitle,
      iconKey: 'hands',
      imageAssetPath: 'assets/images/wudu/step_04_wash_hands.webp',
      quizKeywords: const <String>['hands', 'wash'],
    ),
    WuduStep(
      id: 'rinse_mouth',
      number: 5,
      title: l10n.wuduTrainerStep5Title,
      subtitle: l10n.wuduTrainerStep5Subtitle,
      iconKey: 'mouth',
      imageAssetPath: 'assets/images/wudu/step_05_rinse_mouth_card.webp',
      quizKeywords: const <String>['mouth', 'rinse'],
    ),
    WuduStep(
      id: 'sniff_water',
      number: 6,
      title: l10n.wuduTrainerStep6Title,
      subtitle: l10n.wuduTrainerStep6Subtitle,
      iconKey: 'nose',
      imageAssetPath: 'assets/images/wudu/step_06_sniff_nose_card.webp',
      quizKeywords: const <String>['nose', 'sniff', 'nostrils'],
    ),
    WuduStep(
      id: 'blow_nose',
      number: 7,
      title: l10n.wuduTrainerStep7Title,
      subtitle: l10n.wuduTrainerStep7Subtitle,
      iconKey: 'nose',
      imageAssetPath: 'assets/images/wudu/step_07_blow_nose_card.webp',
      quizKeywords: const <String>['nose', 'blow'],
    ),
    WuduStep(
      id: 'wash_face',
      number: 8,
      title: l10n.wuduTrainerStep8Title,
      subtitle: l10n.wuduTrainerStep8Subtitle,
      iconKey: 'face',
      imageAssetPath: 'assets/images/wudu/step_08_wash_face_card.webp',
      quizKeywords: const <String>['face', 'wash'],
    ),
    WuduStep(
      id: 'wash_arms',
      number: 9,
      title: l10n.wuduTrainerStep9Title,
      subtitle: l10n.wuduTrainerStep9Subtitle,
      iconKey: 'arm_right',
      imageAssetPath: 'assets/images/wudu/step_09_wash_arms.webp',
      quizKeywords: const <String>['arms', 'elbows', 'wash'],
    ),
    WuduStep(
      id: 'wipe_head',
      number: 10,
      title: l10n.wuduTrainerStep10Title,
      subtitle: l10n.wuduTrainerStep10Subtitle,
      iconKey: 'head',
      imageAssetPath: 'assets/images/wudu/step_10_wipe_head.webp',
      quizKeywords: const <String>['head', 'wipe'],
    ),
    WuduStep(
      id: 'wash_feet',
      number: 11,
      title: l10n.wuduTrainerStep11Title,
      subtitle: l10n.wuduTrainerStep11Subtitle,
      iconKey: 'foot_right',
      imageAssetPath: 'assets/images/wudu/step_11_wash_feet_card.webp',
      quizKeywords: const <String>['feet', 'ankles', 'toes'],
    ),
    WuduStep(
      id: 'shahada',
      number: 12,
      title: l10n.wuduTrainerStep12Title,
      subtitle: l10n.wuduTrainerStep12Subtitle,
      iconKey: 'shahada',
      imageAssetPath: 'assets/images/wudu/step_12_shahada_card.webp',
      quizKeywords: const <String>['shahada', 'testimony'],
    ),
    WuduStep(
      id: 'dua',
      number: 13,
      title: l10n.wuduTrainerStep13Title,
      subtitle: l10n.wuduTrainerStep13Subtitle,
      iconKey: 'dua',
      imageAssetPath: 'assets/images/wudu/step_13_dua.webp',
      quizKeywords: const <String>['dua', 'supplication'],
    ),
    WuduStep(
      id: 'cleanup',
      number: 14,
      title: l10n.wuduTrainerStep14Title,
      subtitle: l10n.wuduTrainerStep14Subtitle,
      iconKey: 'cleanup',
      imageAssetPath: 'assets/images/wudu/step_14_cleanup_card.webp',
      quizKeywords: const <String>['cleanup', 'water', 'tidy'],
    ),
  ];
}

WuduContent buildWuduContent(AppLocalizations l10n) {
  final steps = buildWuduStepContent(l10n);

  return WuduContent(
    heroTitle: l10n.wuduTrainerPageTitle,
    heroSubtitle: l10n.wuduTrainerPageSubtitle,
    introTitle: l10n.wuduTrainerIntroTitle,
    introSubtitle: l10n.wuduTrainerIntroSubtitle,
    whyWuduMatters: l10n.wuduGuideWhyBody,
    quranVerse: l10n.wuduGuideQuranVerseTranslation,
    quranReference: l10n.wuduGuideQuranReference,
    quranReferenceLabel: l10n.wuduTrainerQuranReferenceLabel,
    quranReferenceSubtitle: l10n.wuduTrainerQuranReferenceSubtitle,
    stepsTitle: l10n.wuduGuideStepsTitle,
    stepsSubtitle: l10n.wuduGuideStepsSubtitle,
    checklistTitle: l10n.wuduTrainerChecklistTitle,
    checklistSubtitle: l10n.wuduTrainerChecklistSubtitle,
    completionTitle: l10n.wuduTrainerCompletionTitle,
    completionBody: l10n.wuduTrainerCompletionBody,
    completionNote: l10n.wuduTrainerCompletionNote,
    reviewSummary: l10n.wuduTrainerReviewSummaryText,
    steps: steps,
    quizSeeds: buildWuduQuizSeeds(steps),
    quizContent: buildWuduQuizContent(l10n, steps),
    afterWuduDua: WuduDua(
      arabic:
          'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      transliteration:
          'Ashhadu an la ilaha illa Allah wahdahu la sharika lah, wa ashhadu anna Muhammadan abduhu wa rasuluh.',
      translation: l10n.wuduAfterWuduDuaTranslation,
    ),
    learningNote: l10n.wuduTrainerLearningNote,
  );
}

List<WuduQuizSeed> buildWuduQuizSeeds(List<WuduStep> steps) {
  final seeds = <WuduQuizSeed>[];
  for (var index = 0; index < steps.length; index += 1) {
    final step = steps[index];
    final previous = index > 0 ? steps[index - 1] : null;
    final next = index < steps.length - 1 ? steps[index + 1] : null;

    seeds.add(
      WuduQuizSeed(
        id: 'identify-${step.id}',
        type: WuduQuizPromptType.identifyStep,
        targetStepId: step.id,
        relatedStepIds: <String>[
          if (previous != null) previous.id,
          step.id,
          if (next != null) next.id,
        ],
      ),
    );

    if (next != null) {
      seeds.add(
        WuduQuizSeed(
          id: 'next-after-${step.id}',
          type: WuduQuizPromptType.whatComesNext,
          targetStepId: next.id,
          relatedStepIds: <String>[step.id, next.id],
        ),
      );
    }

    seeds.add(
      WuduQuizSeed(
        id: 'order-${step.id}',
        type: WuduQuizPromptType.orderStep,
        targetStepId: step.id,
        relatedStepIds: <String>[
          if (previous != null) previous.id,
          step.id,
          if (next != null) next.id,
        ],
      ),
    );
  }
  return seeds;
}

WuduQuizContent buildWuduQuizContent(
  AppLocalizations l10n,
  List<WuduStep> steps,
) {
  final stepById = <String, WuduStep>{for (final step in steps) step.id: step};

  return WuduQuizContent(
    title: l10n.wuduQuizPageTitle,
    subtitle: l10n.wuduQuizPageSubtitle,
    introTitle: l10n.wuduQuizIntroTitle,
    introSubtitle: l10n.wuduQuizIntroSubtitle,
    summaryTitle: l10n.wuduQuizSummaryTitle,
    summarySubtitle: l10n.wuduQuizSummarySubtitle,
    questions: <WuduQuizQuestion>[
      WuduQuizQuestion(
        id: 'step-order-core-sequence',
        type: WuduQuizQuestionType.stepOrder,
        questionText: l10n.wuduQuizStepOrderQuestion,
        options: <WuduQuizOption>[
          WuduQuizOption(
            id: 'correct',
            label: l10n.wuduQuizStepOrderOptionCorrect(
              stepById['wash_hands']!.title,
              stepById['rinse_mouth']!.title,
              stepById['wash_face']!.title,
            ),
          ),
          WuduQuizOption(
            id: 'mouth-first',
            label: l10n.wuduQuizStepOrderOption(
              stepById['rinse_mouth']!.title,
              stepById['wash_hands']!.title,
              stepById['wash_face']!.title,
            ),
          ),
          WuduQuizOption(
            id: 'face-first',
            label: l10n.wuduQuizStepOrderOption(
              stepById['wash_face']!.title,
              stepById['wash_hands']!.title,
              stepById['rinse_mouth']!.title,
            ),
          ),
        ],
        correctOptionId: 'correct',
        explanation: l10n.wuduQuizStepOrderExplanation,
      ),
      WuduQuizQuestion(
        id: 'what-comes-next-after-hands',
        type: WuduQuizQuestionType.whatComesNext,
        questionText: l10n.wuduQuizWhatComesNextQuestion(
          stepById['wash_hands']!.title,
        ),
        options: <WuduQuizOption>[
          WuduQuizOption(
            id: 'rinse_mouth',
            label: stepById['rinse_mouth']!.title,
          ),
          WuduQuizOption(id: 'wash_face', label: stepById['wash_face']!.title),
          WuduQuizOption(id: 'wash_feet', label: stepById['wash_feet']!.title),
        ],
        correctOptionId: 'rinse_mouth',
        explanation: l10n.wuduQuizWhatComesNextExplanation,
      ),
      WuduQuizQuestion(
        id: 'identify-valid-step',
        type: WuduQuizQuestionType.identifyValidStep,
        questionText: l10n.wuduQuizIdentifyValidStepQuestion,
        options: <WuduQuizOption>[
          WuduQuizOption(id: 'wipe_head', label: stepById['wipe_head']!.title),
          WuduQuizOption(
            id: 'clap_hands',
            label: l10n.wuduQuizDistractorClapHands,
          ),
          WuduQuizOption(
            id: 'turn_around',
            label: l10n.wuduQuizDistractorTurnAround,
          ),
          WuduQuizOption(
            id: 'close_eyes',
            label: l10n.wuduQuizDistractorCloseEyes,
          ),
        ],
        correctOptionId: 'wipe_head',
        explanation: l10n.wuduQuizIdentifyValidStepExplanation,
      ),
      WuduQuizQuestion(
        id: 'adab-clean-up',
        type: WuduQuizQuestionType.adab,
        questionText: l10n.wuduQuizAdabQuestion,
        options: <WuduQuizOption>[
          WuduQuizOption(id: 'clean_up', label: l10n.wuduQuizAdabOptionCleanUp),
          WuduQuizOption(
            id: 'waste_water',
            label: l10n.wuduQuizAdabOptionWasteWater,
          ),
          WuduQuizOption(
            id: 'leave_mess',
            label: l10n.wuduQuizAdabOptionLeaveMess,
          ),
        ],
        correctOptionId: 'clean_up',
        explanation: l10n.wuduQuizAdabExplanation,
      ),
    ],
  );
}
