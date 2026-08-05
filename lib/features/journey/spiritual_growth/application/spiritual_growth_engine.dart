import '../../../../shared/persistence/local_store.dart';
import '../../../learn/knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../../application/journey_progression_provider.dart';
import '../domain/spiritual_growth_models.dart';

class SpiritualGrowthEngine {
  const SpiritualGrowthEngine();

  DailyIntention suggestedIntention({
    required SpiritualGrowthCatalog catalog,
    required DateTime date,
    required String audience,
    required UserLearningProfile adaptiveProfile,
    required JourneyActivitySnapshot snapshot,
    required bool dailyBundleCompleted,
  }) {
    final ranked = rankedIntentions(
      catalog: catalog,
      date: date,
      audience: audience,
      adaptiveProfile: adaptiveProfile,
      snapshot: snapshot,
      dailyBundleCompleted: dailyBundleCompleted,
    );
    return ranked.first;
  }

  List<DailyIntention> rankedIntentions({
    required SpiritualGrowthCatalog catalog,
    required DateTime date,
    required String audience,
    required UserLearningProfile adaptiveProfile,
    required JourneyActivitySnapshot snapshot,
    required bool dailyBundleCompleted,
  }) {
    final eligible = catalog.intentions
        .where(
          (item) =>
              item.isDailyEligible &&
              (item.audience == audience || item.audience == 'mixed'),
        )
        .toList(growable: false);
    final preferredThemes = _preferredThemes(
      adaptiveProfile: adaptiveProfile,
      snapshot: snapshot,
      dailyBundleCompleted: dailyBundleCompleted,
    );
    final seed = _seedFor(LocalStore.todayKey(date));
    final ranked = [...eligible]
      ..sort((a, b) {
        final aScore = _intentionScore(a, preferredThemes);
        final bScore = _intentionScore(b, preferredThemes);
        if (aScore != bScore) return bScore.compareTo(aScore);
        final aBias = (seed + a.id.length) % 7;
        final bBias = (seed + b.id.length) % 7;
        if (aBias != bBias) return aBias.compareTo(bBias);
        return a.id.compareTo(b.id);
      });
    return ranked;
  }

  SpiritualReflectionPrompt suggestedReflectionPrompt({
    required SpiritualGrowthCatalog catalog,
    required DateTime date,
    required String audience,
    required String? selectedTheme,
  }) {
    final eligible = catalog.reflectionPrompts
        .where((item) => item.audience == audience || item.audience == 'mixed')
        .toList(growable: false);
    final seed = _seedFor(
      '${LocalStore.todayKey(date)}:${selectedTheme ?? ''}',
    );
    final ranked = [...eligible]
      ..sort((a, b) {
        final aMatches = a.theme == selectedTheme ? 1 : 0;
        final bMatches = b.theme == selectedTheme ? 1 : 0;
        if (aMatches != bMatches) return bMatches.compareTo(aMatches);
        final aBias = (seed + a.id.length) % 5;
        final bBias = (seed + b.id.length) % 5;
        if (aBias != bBias) return aBias.compareTo(bBias);
        return a.id.compareTo(b.id);
      });
    return ranked.first;
  }

  SpiritualGrowthProfile buildProfile({
    required SpiritualGrowthCatalog catalog,
    required SpiritualGrowthState state,
    required String todayKey,
    required List<GrowthActionStatus> todayActions,
  }) {
    final themeAffinity = <String, int>{};
    final consistency = <String, Set<String>>{};

    for (final entry in state.selectedIntentionIdByDateKey.entries) {
      final intention = catalog.intentions
          .where((item) => item.id == entry.value)
          .firstOrNull;
      if (intention == null) continue;
      themeAffinity.update(
        intention.theme,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      consistency.putIfAbsent(intention.theme, () => <String>{}).add(entry.key);
    }

    for (final entry in state.manualActionIdsByDateKey.entries) {
      for (final actionId in entry.value) {
        final action = catalog.actions
            .where((item) => item.id == actionId)
            .firstOrNull;
        if (action == null) continue;
        themeAffinity.update(
          action.theme,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        consistency.putIfAbsent(action.theme, () => <String>{}).add(entry.key);
      }
    }

    for (final entry in state.reflectionEntryByDateKey.entries) {
      final prompt = catalog.reflectionPrompts
          .where((item) => item.id == entry.value.reflectionPromptId)
          .firstOrNull;
      if (prompt == null) continue;
      themeAffinity.update(
        prompt.theme,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      consistency.putIfAbsent(prompt.theme, () => <String>{}).add(entry.key);
    }

    for (final action in todayActions.where((item) => item.isCompleted)) {
      themeAffinity.update(
        action.action.theme,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      consistency
          .putIfAbsent(action.action.theme, () => <String>{})
          .add(todayKey);
    }

    final strongestTheme = themeAffinity.entries.isEmpty
        ? null
        : (themeAffinity.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key;
    final recommendedTheme = themeAffinity.entries.isEmpty
        ? null
        : (themeAffinity.entries.toList()
                ..sort((a, b) => a.value.compareTo(b.value)))
              .first
              .key;

    return SpiritualGrowthProfile(
      themeAffinity: themeAffinity,
      habitConsistency: {
        for (final entry in consistency.entries) entry.key: entry.value.length,
      },
      reflectionStreak: _reflectionStreak(state, todayKey),
      activeIntentionId: state.selectedIntentionFor(todayKey),
      completedGrowthActionsToday: todayActions
          .where((item) => item.isCompleted)
          .map((item) => item.action.id)
          .toList(growable: false),
      strongestTheme: strongestTheme,
      recommendedTheme: recommendedTheme,
    );
  }

  List<SpiritualGrowthThemeSummary> buildThemeSummaries({
    required SpiritualGrowthProfile profile,
  }) {
    final themes = <String>{
      ...profile.themeAffinity.keys,
      ...profile.habitConsistency.keys,
    };
    final list =
        themes
            .map(
              (theme) => SpiritualGrowthThemeSummary(
                theme: theme,
                activityCount: profile.themeAffinity[theme] ?? 0,
                consistencyCount: profile.habitConsistency[theme] ?? 0,
              ),
            )
            .toList(growable: false)
          ..sort((a, b) {
            if (a.activityCount != b.activityCount) {
              return b.activityCount.compareTo(a.activityCount);
            }
            return b.consistencyCount.compareTo(a.consistencyCount);
          });
    return list;
  }

  List<String> _preferredThemes({
    required UserLearningProfile adaptiveProfile,
    required JourneyActivitySnapshot snapshot,
    required bool dailyBundleCompleted,
  }) {
    final themes = <String>[];
    final mappedFocus = _themeFromAdaptiveCategory(
      adaptiveProfile.focusCategory,
    );
    if (mappedFocus != null) themes.add(mappedFocus);
    if (snapshot.prayerProgress < 0.5) themes.add('discipline');
    if (snapshot.dhikrSessionsToday == 0) themes.add('gratitude');
    if (snapshot.quranEngagementsToday == 0) themes.add('trust_in_allah');
    if (!dailyBundleCompleted) themes.add('discipline');
    themes.addAll(const <String>['patience', 'kindness', 'sincerity']);
    return themes;
  }

  String? _themeFromAdaptiveCategory(String? category) {
    return switch (category) {
      'quran' => 'trust_in_allah',
      'hadith' => 'adab',
      'duas' => 'gratitude',
      'prophets' => 'patience',
      'worship' => 'discipline',
      'character' => 'kindness',
      _ => null,
    };
  }

  int _intentionScore(DailyIntention intention, List<String> preferredThemes) {
    var score = 0;
    final themeIndex = preferredThemes.indexOf(intention.theme);
    if (themeIndex != -1) {
      score += 20 - themeIndex;
    }
    score += intention.audience == 'mixed' ? 1 : 0;
    score += 3 - intention.difficulty;
    return score;
  }

  int _reflectionStreak(SpiritualGrowthState state, String todayKey) {
    var streak = 0;
    var cursor = DateTime.parse(todayKey);
    while (true) {
      final key = LocalStore.todayKey(cursor);
      final entry = state.reflectionEntryFor(key);
      if (entry?.isCompleted != true) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int _seedFor(String input) =>
      input.codeUnits.fold<int>(0, (sum, item) => sum + item);
}
