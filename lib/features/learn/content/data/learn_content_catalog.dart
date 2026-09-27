import '../../../../shared/application/special_mode_provider.dart';
import '../domain/learn_topic_category.dart';
import 'learn_content_data.dart';

class LearnTopicCatalogItem {
  const LearnTopicCatalogItem({
    required this.topicId,
    required this.category,
    required this.displayTitle,
    required this.teaser,
    required this.tags,
    required this.reflectionPrompts,
    required this.kidsSnippet,
    this.seasonalMode,
    this.relatedQuranRef,
    this.relatedHadithRef,
  });

  final String topicId;
  final LearnTopicCategory category;
  final String displayTitle;
  final String teaser;
  final List<String> tags;
  final List<String> reflectionPrompts;
  final String kidsSnippet;
  final AppSpecialMode? seasonalMode;
  final String? relatedQuranRef;
  final String? relatedHadithRef;
}

const List<LearnTopicCatalogItem> learnExpansionCatalog = [
  LearnTopicCatalogItem(
    topicId: 'marriage',
    category: LearnTopicCategory.life,
    displayTitle: 'Marriage: Mercy and Trust',
    teaser: 'Build small daily habits that protect compassion in the home.',
    tags: ['family', 'character', 'mercy'],
    reflectionPrompts: [
      'What one sentence can soften communication today?',
      'Where can you choose listening over reacting?',
    ],
    kidsSnippet: 'Families grow with kind words and patient hearts.',
    relatedQuranRef: 'Qur’an reference placeholder',
  ),
  LearnTopicCatalogItem(
    topicId: 'patience',
    category: LearnTopicCategory.life,
    displayTitle: 'Patience in Daily Life',
    teaser: 'Steady action and sincere restraint build long-term strength.',
    tags: ['sabr', 'consistency', 'discipline'],
    reflectionPrompts: [
      'Where do you need calm patience today?',
      'What action can you keep steady for 7 days?',
    ],
    kidsSnippet: 'Patience means taking a deep breath and choosing good words.',
    relatedQuranRef: 'Qur’an reference placeholder',
  ),
  LearnTopicCatalogItem(
    topicId: 'moon',
    category: LearnTopicCategory.world,
    displayTitle: 'Moon and Time',
    teaser: 'Observe cycles to reconnect worship, rhythm, and gratitude.',
    tags: ['creation', 'time', 'observation'],
    reflectionPrompts: [
      'What cycle in nature reminds you to reset intention?',
      'How can you plan your week around worship anchors?',
    ],
    kidsSnippet:
        'The moon reminds us that every night is a chance to begin again.',
    relatedQuranRef: 'Qur’an reference placeholder',
    seasonalMode: AppSpecialMode.ramadan,
  ),
  LearnTopicCatalogItem(
    topicId: 'animals',
    category: LearnTopicCategory.world,
    displayTitle: 'Animals and Mercy',
    teaser: 'Compassion toward creation refines the heart.',
    tags: ['mercy', 'creation', 'stewardship'],
    reflectionPrompts: [
      'How did you show mercy to creation this week?',
      'Which observation taught you humility today?',
    ],
    kidsSnippet: 'Being gentle with animals is part of being kind.',
    relatedHadithRef: 'Hadith reference placeholder',
  ),
  LearnTopicCatalogItem(
    topicId: 'life-lessons',
    category: LearnTopicCategory.hadith,
    displayTitle: 'Life Lessons through Hadith',
    teaser: 'Apply one prophetic teaching in a practical daily action.',
    tags: ['hadith', 'practice', 'intention'],
    reflectionPrompts: [
      'Which lesson can become a daily routine?',
      'What habit can you purify with intention today?',
    ],
    kidsSnippet: 'The Prophet taught us to be truthful and kind every day.',
    relatedHadithRef: 'Hadith reference placeholder',
  ),
  LearnTopicCatalogItem(
    topicId: 'world-lessons',
    category: LearnTopicCategory.hadith,
    displayTitle: 'World Lessons through Hadith',
    teaser: 'Balance dunya and akhirah through intentional priorities.',
    tags: ['balance', 'priorities', 'society'],
    reflectionPrompts: [
      'What one priority needs correction this week?',
      'How can you make work and worship support each other?',
    ],
    kidsSnippet: 'Doing your tasks with honesty is part of faith.',
    relatedHadithRef: 'Hadith reference placeholder',
    seasonalMode: AppSpecialMode.gentle,
  ),
  LearnTopicCatalogItem(
    topicId: 'character-manners',
    category: LearnTopicCategory.hadith,
    displayTitle: 'Character and Manners',
    teaser: 'Strong faith appears in speech, manners, and mercy.',
    tags: ['adab', 'speech', 'patience'],
    reflectionPrompts: [
      'Which manner should lead your next conversation?',
      'How can you practice gentleness while correcting mistakes?',
    ],
    kidsSnippet: 'Good manners make hearts feel safe.',
    relatedHadithRef: 'Hadith reference placeholder',
    seasonalMode: AppSpecialMode.loss,
  ),
  LearnTopicCatalogItem(
    topicId: 'jealousy-heart-purification',
    category: LearnTopicCategory.life,
    displayTitle: 'Jealousy and Heart Purification',
    teaser:
        'Replace comparison with gratitude and dua for healthier inner states.',
    tags: ['heart', 'gratitude', 'ethics'],
    reflectionPrompts: [
      'When do comparisons affect your peace most?',
      'How can gratitude redirect envy into growth?',
    ],
    kidsSnippet: 'Be happy for others and ask Allah for your own good too.',
    relatedQuranRef: '4:32 thematic reminder',
  ),
  LearnTopicCatalogItem(
    topicId: 'gossip-idle-talk-ethics',
    category: LearnTopicCategory.life,
    displayTitle: 'Speech Ethics: Gossip and Idle Talk',
    teaser: 'Guard your tongue to protect trust and unity.',
    tags: ['speech', 'community', 'adab'],
    reflectionPrompts: [
      'What speech habit should you remove this week?',
      'How can your words become more useful and kind?',
    ],
    kidsSnippet: 'Use kind and true words.',
    relatedQuranRef: 'Speech ethics themes',
  ),
  LearnTopicCatalogItem(
    topicId: 'workplace-ethics-safety',
    category: LearnTopicCategory.life,
    displayTitle: 'Workplace Dignity and Safety',
    teaser:
        'Respect boundaries and uphold dignity in professional environments.',
    tags: ['work', 'safety', 'dignity'],
    reflectionPrompts: [
      'How can you improve workplace respect this month?',
      'What boundary helps keep professional spaces safe?',
    ],
    kidsSnippet: 'Respect people and their boundaries.',
    relatedQuranRef: 'Workplace adab guidance',
  ),
  LearnTopicCatalogItem(
    topicId: 'time-mindful-use',
    category: LearnTopicCategory.life,
    displayTitle: 'Mindful Use of Time',
    teaser: 'Treat time as a trust and make your routines intentional.',
    tags: ['time', 'discipline', 'focus'],
    reflectionPrompts: [
      'Which hour of your day needs reclaiming?',
      'What one routine can anchor your day better?',
    ],
    kidsSnippet: 'Time is a gift. Use it for good things.',
    relatedQuranRef: 'Time accountability themes',
  ),
];

List<String> get allLearnTopicIds {
  final ids = <String>[];
  for (final topic in topicsForCategory(LearnTopicCategory.life)) {
    ids.add(topic.id);
  }
  for (final topic in topicsForCategory(LearnTopicCategory.world)) {
    ids.add(topic.id);
  }
  for (final topic in topicsForCategory(LearnTopicCategory.hadith)) {
    ids.add(topic.id);
  }
  return ids;
}

List<LearnTopicCatalogItem> catalogForMode(
  AppSpecialMode mode, {
  required bool kidsMode,
}) {
  if (kidsMode) {
    return learnExpansionCatalog
        .where((item) => item.kidsSnippet.isNotEmpty)
        .toList();
  }
  if (mode == AppSpecialMode.none) return learnExpansionCatalog;
  final seasonal = learnExpansionCatalog
      .where((item) => item.seasonalMode == mode)
      .toList();
  if (seasonal.isNotEmpty) return seasonal;
  return learnExpansionCatalog;
}

LearnTopicCatalogItem? catalogByTopicId(String topicId) {
  for (final item in learnExpansionCatalog) {
    if (item.topicId == topicId) return item;
  }
  return null;
}
