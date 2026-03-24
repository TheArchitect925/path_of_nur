class LearnCompanionRouteTarget {
  const LearnCompanionRouteTarget({
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearnCompanionLinkItem {
  const LearnCompanionLinkItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.routeTarget,
    this.description,
    this.sourceLabel,
    this.whyItMatters,
    this.nextExploration,
    this.practicalExpression,
    this.nextStep,
  });

  final String id;
  final String title;
  final String subtitle;
  final LearnCompanionRouteTarget routeTarget;
  final String? description;
  final String? sourceLabel;
  final String? whyItMatters;
  final String? nextExploration;
  final String? practicalExpression;
  final String? nextStep;
}

enum DailyWisdomSourceType { quran, hadith, prophets, life }

class DailyWisdomEntry {
  const DailyWisdomEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.practicalStep,
    required this.sourceType,
    required this.sourceRouteTarget,
    required this.themeLabel,
    required this.sourceTitle,
    required this.sourceSubtitle,
    required this.ownerLabel,
  });

  final String id;
  final String title;
  final String body;
  final String practicalStep;
  final DailyWisdomSourceType sourceType;
  final LearnCompanionRouteTarget sourceRouteTarget;
  final String themeLabel;
  final String sourceTitle;
  final String sourceSubtitle;
  final String ownerLabel;
}
