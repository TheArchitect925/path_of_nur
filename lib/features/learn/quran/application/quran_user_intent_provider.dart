import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_guided_learning_path_models.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_guided_learning_paths_provider.dart';

const _quranUserIntentKey = 'learn.quran.user_intent.v1';

class QuranUserIntentState {
  const QuranUserIntentState({this.intent, this.updatedAtIso});

  final QuranUserIntent? intent;
  final String? updatedAtIso;

  bool get hasIntent => intent != null;

  QuranUserIntentState copyWith({
    QuranUserIntent? intent,
    String? updatedAtIso,
    bool clearIntent = false,
  }) {
    return QuranUserIntentState(
      intent: clearIntent ? null : (intent ?? this.intent),
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'intent': intent?.wireName,
    'updatedAtIso': updatedAtIso,
  };

  static QuranUserIntentState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QuranUserIntentState();
    return QuranUserIntentState(
      intent: QuranUserIntentWire.tryParse(json['intent']?.toString()),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }
}

class QuranUserIntentNotifier extends StateNotifier<QuranUserIntentState> {
  QuranUserIntentNotifier(this._store)
    : super(
        QuranUserIntentState.fromJson(_store.getJsonMap(_quranUserIntentKey)),
      );

  final LocalStore _store;

  void setIntent(QuranUserIntent intent) {
    state = QuranUserIntentState(
      intent: intent,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_quranUserIntentKey, state.toJson());
  }

  void clearIntent() {
    state = QuranUserIntentState(
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_quranUserIntentKey, state.toJson());
  }
}

class QuranUserIntentSummary {
  const QuranUserIntentSummary({
    required this.selectedIntent,
    required this.preferredReaderMode,
    this.suggestedPath,
  });

  final QuranUserIntent? selectedIntent;
  final QuranReaderStudyMode preferredReaderMode;
  final QuranGuidedLearningPath? suggestedPath;
}

final quranUserIntentStateProvider =
    StateNotifierProvider<QuranUserIntentNotifier, QuranUserIntentState>((ref) {
      return QuranUserIntentNotifier(ref.watch(localStoreProvider));
    });

final quranSelectedUserIntentProvider = Provider<QuranUserIntent?>((ref) {
  return ref.watch(quranUserIntentStateProvider).intent;
});

final quranUserIntentSummaryProvider = Provider<QuranUserIntentSummary>((ref) {
  final selectedIntent = ref.watch(quranSelectedUserIntentProvider);
  final featuredPaths = ref.watch(quranGuidedFeaturedLearningPathsProvider);
  final allPaths = ref.watch(quranGuidedLearningPathsProvider);
  final continuePath = ref.watch(quranGuidedContinuePathProvider);

  final preferredReaderMode = selectedIntent == null
      ? QuranReaderStudyMode.reading
      : quranPreferredReaderModeForIntent(selectedIntent);

  QuranGuidedLearningPath? suggestedPath = continuePath;
  if (selectedIntent != null) {
    suggestedPath = _suggestedPathForIntent(
      selectedIntent,
      featuredPaths: featuredPaths,
      allPaths: allPaths,
      continuePath: continuePath,
    );
  }

  return QuranUserIntentSummary(
    selectedIntent: selectedIntent,
    preferredReaderMode: preferredReaderMode,
    suggestedPath: suggestedPath,
  );
});

QuranGuidedLearningPath? _suggestedPathForIntent(
  QuranUserIntent intent, {
  required List<QuranGuidedLearningPath> featuredPaths,
  required List<QuranGuidedLearningPath> allPaths,
  required QuranGuidedLearningPath? continuePath,
}) {
  if (continuePath != null &&
      (intent == QuranUserIntent.guidedPath ||
          quranPreferredPathTypeForIntent(intent) == continuePath.type)) {
    return continuePath;
  }

  final preferredType = quranPreferredPathTypeForIntent(intent);
  if (preferredType != null) {
    for (final path in featuredPaths) {
      if (path.type == preferredType) return path;
    }
    // Some path types (e.g. memorization support) may not be featured; still
    // surface a matching path rather than no suggestion at all.
    for (final path in allPaths) {
      if (path.type == preferredType) return path;
    }
  }

  if (intent == QuranUserIntent.guidedPath && featuredPaths.isNotEmpty) {
    return featuredPaths.first;
  }

  return continuePath;
}
