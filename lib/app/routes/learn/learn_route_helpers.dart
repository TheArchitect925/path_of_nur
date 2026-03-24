import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/learn/content/domain/learn_topic_category.dart';
import '../../../features/learn/prophets/domain/prophets_tab.dart';
import '../../../features/learn/prophets/presentation/prophets_page.dart';
import '../../../features/learn/salah/models/salah_trainer_models.dart';

String learnRedirectWithQuery(String path, GoRouterState state) {
  return Uri(
    path: path,
    queryParameters: state.uri.queryParameters.isEmpty
        ? null
        : state.uri.queryParameters,
  ).toString();
}

ProphetsTab? prophetsTabFromState(GoRouterState state) {
  final tabParam = state.uri.queryParameters['tab'];
  if (tabParam == null || tabParam.isEmpty) return null;
  for (final tab in ProphetsTab.values) {
    if (tab.name == tabParam) return tab;
  }
  return null;
}

Page<void> buildProphetsHubPage(GoRouterState state) {
  String? initialProphetId;
  String? initialProphetQuizMode;
  String? initialProphetQuizDifficulty;
  final prophetParam = state.uri.queryParameters['prophet'];
  if (prophetParam != null && prophetParam.trim().isNotEmpty) {
    initialProphetId = prophetParam.trim();
  }
  final quizModeParam = state.uri.queryParameters['quizMode'];
  if (quizModeParam != null && quizModeParam.trim().isNotEmpty) {
    initialProphetQuizMode = quizModeParam.trim();
  }
  final quizDifficultyParam = state.uri.queryParameters['quizDifficulty'];
  if (quizDifficultyParam != null && quizDifficultyParam.trim().isNotEmpty) {
    initialProphetQuizDifficulty = quizDifficultyParam.trim();
  }
  return MaterialPage(
    child: ProphetsPage(
      initialTab: prophetsTabFromState(state),
      initialProphetId: initialProphetId,
      initialQuizModeName: initialProphetQuizMode,
      initialQuizDifficultyName: initialProphetQuizDifficulty,
    ),
  );
}

LearnTopicCategory learnTopicCategoryFromParam(String value) {
  switch (value) {
    case 'world':
      return LearnTopicCategory.world;
    case 'hadith':
      return LearnTopicCategory.hadith;
    case 'life':
    default:
      return LearnTopicCategory.life;
  }
}

SalahPrayerId parsePrayerId(String value) {
  for (final item in SalahPrayerId.values) {
    if (item.name == value) return item;
  }
  return SalahPrayerId.fajr;
}
