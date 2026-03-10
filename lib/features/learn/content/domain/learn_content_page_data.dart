import 'learn_topic_category.dart';

enum LearnContentVariant { standard, ramadan, loss, gentle, kids }

class RelatedTopic {
  const RelatedTopic({
    required this.topicId,
    required this.title,
  });

  final String topicId;
  final String title;
}

class LearnContentBlock {
  const LearnContentBlock({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class LearnContentPageData {
  const LearnContentPageData({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.keyThemes,
    required this.referencePlaceholders,
    required this.reflectionPrompt,
    required this.relatedTopics,
    this.nextTopicId,
    this.contentBlocks = const [],
    this.modePrompts = const {},
    this.kidsSummary,
    this.seasonalTag,
  });

  final String id;
  final LearnTopicCategory category;
  final String title;
  final String subtitle;
  final String overview;
  final List<String> keyThemes;
  final List<String> referencePlaceholders;
  final String reflectionPrompt;
  final List<RelatedTopic> relatedTopics;
  final String? nextTopicId;
  final List<LearnContentBlock> contentBlocks;
  final Map<LearnContentVariant, String> modePrompts;
  final String? kidsSummary;
  final String? seasonalTag;
}
