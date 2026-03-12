import 'revelation_core_message.dart';
import 'revelation_human_pattern.dart';

class RevelationEra {
  const RevelationEra({
    required this.id,
    required this.title,
    required this.summary,
    required this.regionLabel,
    required this.civilizationTitle,
    required this.civilizationSummary,
    required this.prophetIds,
    required this.coreMessages,
    required this.humanPatterns,
    required this.reflectionPrompts,
    required this.order,
    this.featuredProphetIds = const <String>[],
    this.relatedGrowthHabitIds = const <String>[],
    this.mapMetadata,
  });

  final String id;
  final String title;
  final String summary;
  final String regionLabel;
  final String civilizationTitle;
  final String civilizationSummary;
  final List<String> prophetIds;
  final List<CoreMessageItem> coreMessages;
  final List<RevelationHumanPattern> humanPatterns;
  final List<String> reflectionPrompts;
  final List<String> featuredProphetIds;
  final List<String> relatedGrowthHabitIds;
  final RevelationMapMetadata? mapMetadata;
  final int order;

  String get regionCue => regionLabel;

  String get coreMessage => coreMessages.isEmpty
      ? 'Worship Allah alone and return with sincerity.'
      : coreMessages.first.text;
}

class RevelationMapMetadata {
  const RevelationMapMetadata({required this.label, this.locationConfidence});

  final String label;
  final String? locationConfidence;
}
