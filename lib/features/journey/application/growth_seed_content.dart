import 'package:flutter/foundation.dart';

import 'growth_models.dart';

@immutable
class GrowthCategoryContent {
  const GrowthCategoryContent({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconKey,
    required this.sortOrder,
  });

  final String id;
  final GrowthHabitCategory category;
  final String title;
  final String subtitle;
  final String description;
  final String iconKey;
  final int sortOrder;
}

@immutable
class GrowthStageContent {
  const GrowthStageContent({
    required this.id,
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.introductionCopy,
    required this.unlockCopy,
  });

  final String id;
  final int stage;
  final String title;
  final String subtitle;
  final String description;
  final String introductionCopy;
  final String unlockCopy;
}

@immutable
class GrowthHabitContent {
  const GrowthHabitContent({
    required this.habitId,
    required this.suggestedRecurrence,
    required this.reminderCopy,
  });

  final String habitId;
  final String suggestedRecurrence;
  final String reminderCopy;
}

@immutable
class GrowthPathContent {
  const GrowthPathContent({
    required this.pathId,
    required this.whyItMatters,
    required this.stageLabel,
    required this.milestoneNames,
  });

  final String pathId;
  final String whyItMatters;
  final String stageLabel;
  final List<String> milestoneNames;
}

@immutable
class GrowthPromptGroup {
  const GrowthPromptGroup({
    required this.id,
    required this.title,
    required this.prompts,
  });

  final String id;
  final String title;
  final List<String> prompts;
}

@immutable
class GrowthEncouragementCopy {
  const GrowthEncouragementCopy({
    required this.completion,
    required this.returning,
    required this.streak,
    required this.dayEnd,
    required this.pathProgress,
    required this.gentleReminders,
  });

  final List<String> completion;
  final List<String> returning;
  final List<String> streak;
  final List<String> dayEnd;
  final List<String> pathProgress;
  final List<String> gentleReminders;
}

@immutable
class GrowthMilestoneContent {
  const GrowthMilestoneContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.unlockCondition,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String unlockCondition;
  final int sortOrder;
}

const List<GrowthCategoryContent> seededGrowthCategories = [
  GrowthCategoryContent(
    id: 'cat_daily_worship',
    category: GrowthHabitCategory.dailyWorship,
    title: 'Daily Ibadah',
    subtitle: 'The daily anchors of faith',
    description:
        'Core acts of remembrance and ibadah that structure the day around Allah.',
    iconKey: 'prayer_beads',
    sortOrder: 1,
  ),
  GrowthCategoryContent(
    id: 'cat_sunnah',
    category: GrowthHabitCategory.sunnahPractices,
    title: 'Sunnah Practices',
    subtitle: 'Extra acts that deepen love and discipline',
    description:
        'Voluntary practices that strengthen faith and revive prophetic habits.',
    iconKey: 'crescent',
    sortOrder: 2,
  ),
  GrowthCategoryContent(
    id: 'cat_character',
    category: GrowthHabitCategory.character,
    title: 'Character',
    subtitle: 'Refining how the heart shows up',
    description:
        'Habits that shape speech, patience, humility, restraint, and conduct.',
    iconKey: 'leaf',
    sortOrder: 3,
  ),
  GrowthCategoryContent(
    id: 'cat_knowledge',
    category: GrowthHabitCategory.knowledge,
    title: 'Knowledge',
    subtitle: 'Learning that guides action',
    description:
        'Qur’anic reflection, memorization, study, and understanding that lead to wiser living.',
    iconKey: 'book',
    sortOrder: 4,
  ),
  GrowthCategoryContent(
    id: 'cat_service',
    category: GrowthHabitCategory.charityService,
    title: 'Charity & Service',
    subtitle: 'Faith expressed through benefit to others',
    description:
        'Habits of generosity, service, family connection, and practical care.',
    iconKey: 'hands',
    sortOrder: 5,
  ),
  GrowthCategoryContent(
    id: 'cat_discipline',
    category: GrowthHabitCategory.healthDiscipline,
    title: 'Health & Discipline',
    subtitle: 'Caring for the vessel entrusted to you',
    description:
        'Physical discipline, routine, moderation, and healthy structure that support ibadah.',
    iconKey: 'mountain',
    sortOrder: 6,
  ),
  GrowthCategoryContent(
    id: 'cat_reflection',
    category: GrowthHabitCategory.reflectionGratitude,
    title: 'Reflection & Gratitude',
    subtitle: 'Notice, return, and realign',
    description:
        'Habits of gratitude, self-review, tawbah, and journaling that deepen sincerity.',
    iconKey: 'heart_journal',
    sortOrder: 7,
  ),
];

const List<GrowthStageContent> seededGrowthStages = [
  GrowthStageContent(
    id: 'stage_1_foundations',
    stage: 1,
    title: 'Foundations of Light',
    subtitle: 'Start with what anchors you',
    description:
        'Build reliable basics: prayer, Qur’an, remembrance, du’a, gratitude, and guarded speech.',
    introductionCopy:
        'Begin again today with simple, sincere consistency. Small steps matter.',
    unlockCopy: 'Your foundation is forming. Consistency grows over time.',
  ),
  GrowthStageContent(
    id: 'stage_2_strengthening',
    stage: 2,
    title: 'Strengthening the Heart',
    subtitle: 'Deepen what you already began',
    description:
        'Add practices that strengthen patience, service, and inward steadiness.',
    introductionCopy:
        'Continue your path with steadiness. Depth comes with repetition.',
    unlockCopy: 'Your heart is in motion. Keep walking the path gently.',
  ),
  GrowthStageContent(
    id: 'stage_3_excellence',
    stage: 3,
    title: 'Path of Excellence',
    subtitle: 'Refine intention and presence',
    description:
        'Advance with ihsan through disciplined ibadah, reflection, and character refinement.',
    introductionCopy:
        'Return gently to what elevates your soul, one sincere act at a time.',
    unlockCopy: 'Light upon light. Continue with humility and steadiness.',
  ),
];

const List<GrowthHabitContent> seededGrowthHabitContent = [
  GrowthHabitContent(
    habitId: 'h_pray_five',
    suggestedRecurrence: 'Daily at salah times',
    reminderCopy: 'Salah time is near. Continue your path with presence.',
  ),
  GrowthHabitContent(
    habitId: 'h_read_quran',
    suggestedRecurrence: 'Daily, even a few ayat',
    reminderCopy: 'Open the Qur’an for a few moments. Small steps matter.',
  ),
  GrowthHabitContent(
    habitId: 'h_morning_adhkar',
    suggestedRecurrence: 'Each morning',
    reminderCopy: 'Begin again this morning with remembrance.',
  ),
  GrowthHabitContent(
    habitId: 'h_evening_adhkar',
    suggestedRecurrence: 'Each evening',
    reminderCopy: 'Return gently this evening with adhkar.',
  ),
  GrowthHabitContent(
    habitId: 'h_make_dua',
    suggestedRecurrence: 'Daily, after salah or quiet moments',
    reminderCopy: 'Raise one sincere du’a before Allah.',
  ),
  GrowthHabitContent(
    habitId: 'h_gratitude',
    suggestedRecurrence: 'Daily',
    reminderCopy: 'Name one blessing. Consistency grows over time.',
  ),
  GrowthHabitContent(
    habitId: 'h_harmful_speech',
    suggestedRecurrence: 'Daily awareness',
    reminderCopy: 'Pause gently before speaking.',
  ),
  GrowthHabitContent(
    habitId: 'h_sunnah_prayer',
    suggestedRecurrence: 'Most weekdays',
    reminderCopy: 'Add one Sunnah salah today if you can.',
  ),
  GrowthHabitContent(
    habitId: 'h_salawat',
    suggestedRecurrence: 'Daily',
    reminderCopy: 'Send salawat with love and calmness.',
  ),
  GrowthHabitContent(
    habitId: 'h_istighfar',
    suggestedRecurrence: 'Daily, in short moments',
    reminderCopy: 'Return with istighfar. Begin again today.',
  ),
  GrowthHabitContent(
    habitId: 'h_study_knowledge',
    suggestedRecurrence: '3-4 times weekly',
    reminderCopy: 'Take one short knowledge step today.',
  ),
  GrowthHabitContent(
    habitId: 'h_help_someone',
    suggestedRecurrence: 'Several times weekly',
    reminderCopy: 'Offer one quiet act of help today.',
  ),
  GrowthHabitContent(
    habitId: 'h_give_charity',
    suggestedRecurrence: '1-2 times weekly',
    reminderCopy: 'Give even a little. Small steps matter.',
  ),
  GrowthHabitContent(
    habitId: 'h_patience_anger',
    suggestedRecurrence: 'Daily awareness',
    reminderCopy: 'When tested, return gently to patience.',
  ),
  GrowthHabitContent(
    habitId: 'h_tahajjud',
    suggestedRecurrence: 'Occasional weekly',
    reminderCopy: 'If possible tonight, stand briefly in salah.',
  ),
  GrowthHabitContent(
    habitId: 'h_sunnah_fasts',
    suggestedRecurrence: 'Weekly or bi-weekly',
    reminderCopy: 'Prepare for your next Sunnah fast with intention.',
  ),
  GrowthHabitContent(
    habitId: 'h_memorize_quran',
    suggestedRecurrence: 'Several times weekly',
    reminderCopy: 'Review one ayah. Consistency grows over time.',
  ),
  GrowthHabitContent(
    habitId: 'h_reflect_verse',
    suggestedRecurrence: 'Daily',
    reminderCopy: 'Choose one verse and live it today.',
  ),
  GrowthHabitContent(
    habitId: 'h_reconnect_family',
    suggestedRecurrence: 'Several times weekly',
    reminderCopy: 'Reach out gently and strengthen a family tie.',
  ),
  GrowthHabitContent(
    habitId: 'h_humility',
    suggestedRecurrence: 'Daily intention',
    reminderCopy: 'Lower the ego and keep walking the path.',
  ),
  GrowthHabitContent(
    habitId: 'h_day_end_reflection',
    suggestedRecurrence: 'Nightly',
    reminderCopy: 'Close the day with reflection and return.',
  ),
];

const List<GrowthPathContent> seededGrowthPathContent = [
  GrowthPathContent(
    pathId: 'core-muslim-habits',
    whyItMatters:
        'A complete spiritual base that supports lifelong consistency.',
    stageLabel: 'All Stages',
    milestoneNames: ['First Light', 'Steady Footsteps', 'Light Upon Light'],
  ),
  GrowthPathContent(
    pathId: 'foundations-of-light',
    whyItMatters: 'Strong foundations reduce overwhelm and keep ibadah steady.',
    stageLabel: 'Foundations of Light',
    milestoneNames: ['First Light', 'Growth Beginnings'],
  ),
  GrowthPathContent(
    pathId: 'strengthening-heart',
    whyItMatters: 'Inner steadiness helps consistency remain sincere and calm.',
    stageLabel: 'Strengthening the Heart',
    milestoneNames: ['Heart in Motion', 'Path Strengthened'],
  ),
  GrowthPathContent(
    pathId: 'path-of-excellence',
    whyItMatters:
        'Ihsan grows through patient refinement, not sudden intensity.',
    stageLabel: 'Path of Excellence',
    milestoneNames: ['Light Upon Light', 'Path Strengthened'],
  ),
  GrowthPathContent(
    pathId: 'quran-companion',
    whyItMatters:
        'Qur’an companionship keeps guidance present in daily choices.',
    stageLabel: 'Strengthening the Heart',
    milestoneNames: ['First Light', 'Heart in Motion'],
  ),
  GrowthPathContent(
    pathId: 'character-builder',
    whyItMatters:
        'Character habits protect relationships and purify intention.',
    stageLabel: 'Strengthening the Heart',
    milestoneNames: ['Steady Footsteps', 'Path Strengthened'],
  ),
  GrowthPathContent(
    pathId: 'sunnah-revival',
    whyItMatters: 'Revived Sunnah acts bring barakah to ordinary routines.',
    stageLabel: 'Strengthening the Heart',
    milestoneNames: ['First Light', 'Steady Footsteps'],
  ),
  GrowthPathContent(
    pathId: 'family-service',
    whyItMatters: 'Service and family ties turn growth outward with mercy.',
    stageLabel: 'Strengthening the Heart',
    milestoneNames: ['Growth Beginnings', 'Heart in Motion'],
  ),
];

const List<GrowthPromptGroup> seededGrowthPromptGroups = [
  GrowthPromptGroup(
    id: 'awareness',
    title: 'Awareness',
    prompts: [
      'What stayed with you today?',
      'When did your heart feel most awake today?',
      'What distracted you most today?',
      'What moment felt heavier than it looked?',
      'Where did you feel the most peace today?',
    ],
  ),
  GrowthPromptGroup(
    id: 'gratitude',
    title: 'Gratitude',
    prompts: [
      'What blessing did you almost overlook today?',
      'What ease came to you today?',
      'Who are you grateful for today?',
      'What small mercy appeared in your day?',
      'What did Allah make easier than expected?',
    ],
  ),
  GrowthPromptGroup(
    id: 'tawbah',
    title: 'Tawbah',
    prompts: [
      'What needs correction today?',
      'Where do you need to return more sincerely?',
      'What do you want to leave behind before tomorrow?',
      'What would you do differently if given the moment again?',
      'What burden should be handed back in tawbah tonight?',
    ],
  ),
  GrowthPromptGroup(
    id: 'character',
    title: 'Character',
    prompts: [
      'Did your words bring peace today?',
      'Where were you tested in patience?',
      'Did you react or respond?',
      'Where did pride try to enter?',
      'Did you make things easier or heavier for someone else?',
    ],
  ),
  GrowthPromptGroup(
    id: 'worship',
    title: 'Ibadah',
    prompts: [
      'Which act of worship felt most alive today?',
      'What drew you closer to Allah today?',
      'Which prayer felt most focused?',
      'What remembrance benefited your heart today?',
      'What act of worship needs more care tomorrow?',
    ],
  ),
  GrowthPromptGroup(
    id: 'consistency',
    title: 'Consistency',
    prompts: [
      'What small act did you protect today?',
      'What helped you stay steady today?',
      'Where did you stop halfway, and why?',
      'What is one small thing you can continue tomorrow?',
      'What part of your path needs gentleness, not pressure?',
    ],
  ),
];

const GrowthEncouragementCopy seededGrowthEncouragementCopy =
    GrowthEncouragementCopy(
      completion: [
        'Alhamdulillah. Keep walking the path with sincerity.',
        'A small completed act brings steady light.',
        'Consistency grows over time. Continue gently.',
      ],
      returning: [
        'Return gently. Begin again today.',
        'No day is wasted when you come back with intention.',
        'Small steps matter, especially on returning days.',
      ],
      streak: [
        'Steady footsteps are forming. Keep your pace gentle.',
        'Your consistency is growing quietly over time.',
        'Continue your path, one sincere step at a time.',
      ],
      dayEnd: [
        'Close the day with gratitude and tawbah.',
        'End gently. Tomorrow is another chance to begin again.',
        'Review with mercy, and continue your path tomorrow.',
      ],
      pathProgress: [
        'Your path is strengthening through steady effort.',
        'Continue your journey with calm consistency.',
        'Light increases through repeated sincere acts.',
      ],
      gentleReminders: [
        'Return gently when you are ready.',
        'Begin again today with one small act.',
        'Keep walking the path. Small steps matter.',
      ],
    );

const List<GrowthMilestoneContent> seededGrowthMilestones = [
  GrowthMilestoneContent(
    id: 'first_light',
    title: 'First Light',
    subtitle: 'The journey has begun',
    description: 'You began your growth path with sincere intention.',
    unlockCondition: 'First completion',
    sortOrder: 1,
  ),
  GrowthMilestoneContent(
    id: 'steady_footsteps',
    title: 'Steady Footsteps',
    subtitle: 'Consistency is forming',
    description: 'You maintained steady rhythm across several days.',
    unlockCondition: '7-day steady consistency',
    sortOrder: 2,
  ),
  GrowthMilestoneContent(
    id: 'heart_in_motion',
    title: 'Heart in Motion',
    subtitle: 'Inner growth is visible',
    description: 'Reflection and character habits are strengthening together.',
    unlockCondition: 'Reflection + character cadence',
    sortOrder: 3,
  ),
  GrowthMilestoneContent(
    id: 'days_of_consistency',
    title: 'Days of Consistency',
    subtitle: 'A steady rhythm is settling in',
    description: 'You are protecting daily acts with calm regularity.',
    unlockCondition: '14 days with meaningful completion',
    sortOrder: 4,
  ),
  GrowthMilestoneContent(
    id: 'quiet_resolve',
    title: 'Quiet Resolve',
    subtitle: 'Steadiness under pressure',
    description:
        'You continued your path through demanding days with sincerity.',
    unlockCondition: 'Resilience/protected consistency days',
    sortOrder: 5,
  ),
  GrowthMilestoneContent(
    id: 'returning_often',
    title: 'Returning Often',
    subtitle: 'The heart keeps coming back',
    description:
        'You repeatedly returned with reflection and renewed intention.',
    unlockCondition: 'Frequent reflection and gentle restarts',
    sortOrder: 6,
  ),
  GrowthMilestoneContent(
    id: 'garden_beginnings',
    title: 'Growth Beginnings',
    subtitle: 'Balanced growth starts',
    description: 'Consistency now spans multiple categories with balance.',
    unlockCondition: '3 category consistency markers',
    sortOrder: 7,
  ),
  GrowthMilestoneContent(
    id: 'gentle_discipline',
    title: 'Gentle Discipline',
    subtitle: 'Structure without harshness',
    description: 'You kept disciplined habits with mercy and balance.',
    unlockCondition: 'Sustained disciplined practice over weeks',
    sortOrder: 8,
  ),
  GrowthMilestoneContent(
    id: 'path_strengthened',
    title: 'Path Strengthened',
    subtitle: 'Guided path matured',
    description: 'A guided path reached strong completion and steadiness.',
    unlockCondition: 'Path completion state',
    sortOrder: 9,
  ),
  GrowthMilestoneContent(
    id: 'light_upon_light',
    title: 'Light Upon Light',
    subtitle: 'Long-view consistency',
    description: 'Repeated sincere effort has built deep, lasting rhythm.',
    unlockCondition: 'Advanced consistency milestones',
    sortOrder: 10,
  ),
];
