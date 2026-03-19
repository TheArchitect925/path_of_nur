import 'package:flutter/material.dart';

enum LearnHubCategoryId {
  foundations,
  quranHadith,
  prophetsStories,
  worshipPractice,
  characterAdab,
  arabicLanguage,
  kidsLearning,
  quizzesChallenges,
  faq,
  notes,
  toolsExplore,
}

enum LearnHubContentType {
  category,
  subcategory,
  lesson,
  story,
  quiz,
  challenge,
  tool,
  note,
  faq,
  journey,
}

class LearnHubRouteTarget {
  const LearnHubRouteTarget({
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearnHubCategoryStyle {
  const LearnHubCategoryStyle({
    required this.baseColor,
    required this.accentColor,
    required this.icon,
  });

  final Color baseColor;
  final Color accentColor;
  final IconData icon;
}

class LearnHubCategoryDescriptor {
  const LearnHubCategoryDescriptor({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.routeTarget,
  });

  final LearnHubCategoryId id;
  final String title;
  final String subtitle;
  final LearnHubRouteTarget routeTarget;
}

class LearnHubSubcategoryDescriptor {
  const LearnHubSubcategoryDescriptor({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.routeTarget,
    this.searchKeywords = const <String>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final LearnHubCategoryId categoryId;
  final LearnHubRouteTarget routeTarget;
  final List<String> searchKeywords;
}

class LearnHubKnowledgeItem {
  const LearnHubKnowledgeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.contentType,
    required this.routeTarget,
    this.summary = '',
    this.subcategoryId,
    this.subcategoryTitle,
    this.searchKeywords = const <String>[],
    this.badgeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String summary;
  final LearnHubCategoryId categoryId;
  final String? subcategoryId;
  final String? subcategoryTitle;
  final LearnHubContentType contentType;
  final LearnHubRouteTarget routeTarget;
  final List<String> searchKeywords;
  final String? badgeLabel;
}
