import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../domain/seerah_journey_models.dart';

const KidsSeerahJourney kKidsSeerahJourney = KidsSeerahJourney(
  journeyId: 'journey_seerah_muhammad_kids_v1',
  title: 'Seerah Journey',
  description:
      'A calm children’s journey through key moments in the life of Prophet Muhammad ﷺ, with companion stories, gentle reflection, and short review steps.',
  ageGroup: BedtimeStoryAgeGroup.kids,
  totalStages: 4,
  isFeatured: true,
  coverAssetPath: 'assets/images/kids_stories/covers/seerah_journey_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/seerah_journey_backdrop.webp',
  tags: ['seerah', 'prophet muhammad', 'companions', 'timeline'],
  timeline: [
    KidsSeerahTimelineMarker(
      markerId: 'seerah_timeline_childhood',
      journeyId: 'journey_seerah_muhammad_kids_v1',
      stageId: 'seerah_stage_childhood',
      label: 'Childhood',
      sortOrder: 1,
    ),
    KidsSeerahTimelineMarker(
      markerId: 'seerah_timeline_revelation',
      journeyId: 'journey_seerah_muhammad_kids_v1',
      stageId: 'seerah_stage_revelation',
      label: 'First Revelation',
      sortOrder: 2,
    ),
    KidsSeerahTimelineMarker(
      markerId: 'seerah_timeline_hijrah',
      journeyId: 'journey_seerah_muhammad_kids_v1',
      stageId: 'seerah_stage_hijrah',
      label: 'Hijrah',
      sortOrder: 3,
    ),
    KidsSeerahTimelineMarker(
      markerId: 'seerah_timeline_return',
      journeyId: 'journey_seerah_muhammad_kids_v1',
      stageId: 'seerah_stage_return',
      label: 'Mercy and Return',
      sortOrder: 4,
    ),
  ],
);

const List<KidsSeerahJourneyStage> kKidsSeerahJourneyStages = [
  KidsSeerahJourneyStage(
    stageId: 'seerah_stage_childhood',
    journeyId: 'journey_seerah_muhammad_kids_v1',
    title: 'Before Prophethood',
    description:
        'Meet Muhammad ﷺ as a truthful young person known for beautiful character.',
    sortOrder: 1,
    nodeIds: ['seerah_node_story_part1', 'seerah_node_reflection_character'],
    estimatedDurationMinutes: 9,
  ),
  KidsSeerahJourneyStage(
    stageId: 'seerah_stage_revelation',
    journeyId: 'journey_seerah_muhammad_kids_v1',
    title: 'First Revelation',
    description:
        'Learn about Cave Hira, the first revelation, and the support of Khadijah رضي الله عنها.',
    sortOrder: 2,
    unlockAfterStageId: 'seerah_stage_childhood',
    nodeIds: [
      'seerah_node_story_part2',
      'seerah_node_companion_khadijah',
      'seerah_node_quiz_part2',
    ],
    estimatedDurationMinutes: 12,
  ),
  KidsSeerahJourneyStage(
    stageId: 'seerah_stage_hijrah',
    journeyId: 'journey_seerah_muhammad_kids_v1',
    title: 'Migration to Madinah',
    description:
        'Walk through the Hijrah with Abu Bakr رضي الله عنه and the building of a caring community.',
    sortOrder: 3,
    unlockAfterStageId: 'seerah_stage_revelation',
    nodeIds: [
      'seerah_node_story_part3',
      'seerah_node_companion_abu_bakr',
      'seerah_node_quiz_part3',
      'seerah_node_milestone_hijrah',
    ],
    estimatedDurationMinutes: 14,
  ),
  KidsSeerahJourneyStage(
    stageId: 'seerah_stage_return',
    journeyId: 'journey_seerah_muhammad_kids_v1',
    title: 'Mercy, Patience, and the Final Message',
    description:
        'See mercy in the return to Makkah, learn from Bilal رضي الله عنه, and close with a gentle reflection.',
    sortOrder: 4,
    unlockAfterStageId: 'seerah_stage_hijrah',
    nodeIds: [
      'seerah_node_companion_bilal',
      'seerah_node_story_part4',
      'seerah_node_quiz_part4',
      'seerah_node_reflection_mercy',
    ],
    estimatedDurationMinutes: 14,
  ),
];

const List<KidsSeerahJourneyNode> kKidsSeerahJourneyNodes = [
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_story_part1',
    stageId: 'seerah_stage_childhood',
    title: 'A Trustworthy Young Muhammad ﷺ',
    description:
        'Open the first story to learn about childhood, honesty, and being known as Al-Ameen.',
    nodeType: KidsSeerahJourneyNodeType.storyEvent,
    sortOrder: 1,
    relatedStoryId: 'story_prophet_muhammad_part1_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_reflection_character',
    stageId: 'seerah_stage_childhood',
    title: 'Quiet Reflection',
    description:
        'Think about one beautiful quality you want to carry this week.',
    nodeType: KidsSeerahJourneyNodeType.reflection,
    sortOrder: 2,
    reflectionPrompt:
        'What beautiful quality from the young Muhammad ﷺ would you like to practice?',
    reflectionChoices: [
      'Truthfulness',
      'Kindness to people',
      'Keeping promises',
    ],
    nodeXpReward: 2,
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_story_part2',
    stageId: 'seerah_stage_revelation',
    title: 'The First Revelation',
    description:
        'Revisit the moment revelation began and how the Prophet ﷺ was comforted at home.',
    nodeType: KidsSeerahJourneyNodeType.storyEvent,
    sortOrder: 1,
    relatedStoryId: 'story_prophet_muhammad_part2_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_companion_khadijah',
    stageId: 'seerah_stage_revelation',
    title: 'Companion Story: Khadijah رضي الله عنها',
    description:
        'Learn how Khadijah رضي الله عنها believed, supported, and comforted the Prophet ﷺ.',
    nodeType: KidsSeerahJourneyNodeType.companionStory,
    sortOrder: 2,
    relatedStoryId: 'story_companion_khadijah_support_v1',
    relatedCompanionId: 'khadijah',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_quiz_part2',
    stageId: 'seerah_stage_revelation',
    title: 'Little Review',
    description:
        'Answer a few calm questions about revelation and first support.',
    nodeType: KidsSeerahJourneyNodeType.quiz,
    sortOrder: 3,
    relatedStoryId: 'story_prophet_muhammad_part2_bedtime_v1',
    relatedQuizStoryId: 'story_prophet_muhammad_part2_bedtime_v1',
    relatedQuizId: 'quiz_story_prophet_muhammad_part2_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_story_part3',
    stageId: 'seerah_stage_hijrah',
    title: 'The Hijrah',
    description:
        'Continue the journey with the migration to Madinah and the building of a caring community.',
    nodeType: KidsSeerahJourneyNodeType.storyEvent,
    sortOrder: 1,
    relatedStoryId: 'story_prophet_muhammad_part3_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_companion_abu_bakr',
    stageId: 'seerah_stage_hijrah',
    title: 'Companion Story: Abu Bakr رضي الله عنه',
    description: 'See what loyalty and friendship looked like on the Hijrah.',
    nodeType: KidsSeerahJourneyNodeType.companionStory,
    sortOrder: 2,
    relatedStoryId: 'story_companion_abu_bakr_friendship_v1',
    relatedCompanionId: 'abu_bakr',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_quiz_part3',
    stageId: 'seerah_stage_hijrah',
    title: 'Journey Check-In',
    description: 'Review the Hijrah with one short quiz step.',
    nodeType: KidsSeerahJourneyNodeType.quiz,
    sortOrder: 3,
    relatedStoryId: 'story_prophet_muhammad_part3_bedtime_v1',
    relatedQuizStoryId: 'story_prophet_muhammad_part3_bedtime_v1',
    relatedQuizId: 'quiz_story_prophet_muhammad_part3_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_milestone_hijrah',
    stageId: 'seerah_stage_hijrah',
    title: 'Milestone: A New Beginning',
    description:
        'Pause and remember how Madinah became a place of care, faith, and community.',
    nodeType: KidsSeerahJourneyNodeType.milestone,
    sortOrder: 4,
    reflectionPrompt: 'What makes a community feel caring and safe?',
    reflectionChoices: [
      'Helping each other',
      'Welcoming people',
      'Remembering Allah together',
    ],
    nodeXpReward: 2,
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_companion_bilal',
    stageId: 'seerah_stage_return',
    title: 'Companion Story: Bilal رضي الله عنه',
    description:
        'Read a simple story about patience, faith, and staying firm with truth.',
    nodeType: KidsSeerahJourneyNodeType.companionStory,
    sortOrder: 1,
    relatedStoryId: 'story_companion_bilal_patience_v1',
    relatedCompanionId: 'bilal',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_story_part4',
    stageId: 'seerah_stage_return',
    title: 'Mercy in the Return to Makkah',
    description:
        'Open the final story to see mercy, forgiveness, and the final message.',
    nodeType: KidsSeerahJourneyNodeType.storyEvent,
    sortOrder: 2,
    relatedStoryId: 'story_prophet_muhammad_part4_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_quiz_part4',
    stageId: 'seerah_stage_return',
    title: 'Final Review',
    description:
        'Finish with a short review about mercy and the final message.',
    nodeType: KidsSeerahJourneyNodeType.quiz,
    sortOrder: 3,
    relatedStoryId: 'story_prophet_muhammad_part4_bedtime_v1',
    relatedQuizStoryId: 'story_prophet_muhammad_part4_bedtime_v1',
    relatedQuizId: 'quiz_story_prophet_muhammad_part4_bedtime_v1',
  ),
  KidsSeerahJourneyNode(
    nodeId: 'seerah_node_reflection_mercy',
    stageId: 'seerah_stage_return',
    title: 'Reflection: A Merciful Ending',
    description:
        'End the journey with one calm reflection about mercy and fairness.',
    nodeType: KidsSeerahJourneyNodeType.reflection,
    sortOrder: 4,
    reflectionPrompt:
        'What did the life of Prophet Muhammad ﷺ teach you most strongly in this journey?',
    reflectionChoices: [
      'Mercy matters',
      'Patience matters',
      'Truthfulness matters',
    ],
    nodeXpReward: 2,
  ),
];

const List<KidsSeerahCompanionStoryLink> kKidsSeerahCompanionLinks = [
  KidsSeerahCompanionStoryLink(
    companionId: 'khadijah',
    name: 'Khadijah رضي الله عنها',
    title: 'The First to Believe',
    shortSummary:
        'A calm companion story about support, comfort, and early faith.',
    lesson: 'Support for truth can be gentle, wise, and full of love.',
    relatedSeerahEventIds: ['seerah_stage_revelation'],
    storyId: 'story_companion_khadijah_support_v1',
    ageGroup: BedtimeStoryAgeGroup.kids,
    tags: ['support', 'belief', 'first revelation'],
  ),
  KidsSeerahCompanionStoryLink(
    companionId: 'abu_bakr',
    name: 'Abu Bakr رضي الله عنه',
    title: 'A Loyal Friend on the Hijrah',
    shortSummary:
        'A companion story about loyalty, trust, and friendship during migration.',
    lesson: 'A loyal friend stays close in hard moments and trusts Allah.',
    relatedSeerahEventIds: ['seerah_stage_hijrah'],
    storyId: 'story_companion_abu_bakr_friendship_v1',
    ageGroup: BedtimeStoryAgeGroup.kids,
    tags: ['friendship', 'hijrah', 'loyalty'],
  ),
  KidsSeerahCompanionStoryLink(
    companionId: 'bilal',
    name: 'Bilal رضي الله عنه',
    title: 'Patience and Faith',
    shortSummary:
        'A companion story about patience, faith, and holding tightly to truth.',
    lesson: 'Patience with faith is beautiful, even when something feels hard.',
    relatedSeerahEventIds: ['seerah_stage_return'],
    storyId: 'story_companion_bilal_patience_v1',
    ageGroup: BedtimeStoryAgeGroup.kids,
    tags: ['patience', 'faith', 'early Islam'],
  ),
];
