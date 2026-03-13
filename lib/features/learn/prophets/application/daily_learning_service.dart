import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../journey/application/growth_seasonal.dart';
import '../data/seeded_daily_learning_data.dart';
import '../domain/daily_learning_item.dart';
import '../domain/prophet_quiz.dart';
import 'prophet_quiz_pool_service.dart';

class DailyLearningState {
  const DailyLearningState({
    this.entries = const <String, DailyLearningDayStatus>{},
  });

  final Map<String, DailyLearningDayStatus> entries;

  DailyLearningState copyWith({Map<String, DailyLearningDayStatus>? entries}) {
    return DailyLearningState(entries: entries ?? this.entries);
  }
}

class DailyLearningBundle {
  const DailyLearningBundle({
    required this.dateKey,
    required this.item,
    required this.quizQuestion,
    required this.status,
  });

  final String dateKey;
  final DailyLearningItem item;
  final ProphetQuizQuestion quizQuestion;
  final DailyLearningDayStatus status;
}

class DailyLearningController extends StateNotifier<DailyLearningState> {
  DailyLearningController(this._store, this._specialMode)
    : super(const DailyLearningState()) {
    _load();
  }

  final LocalStore _store;
  final SpecialModeState _specialMode;
  static const _stateKey = 'learn.prophets.dailyLearning.state';

  List<ProphetQuizQuestion> get _questionPool =>
      ProphetQuizPoolService.buildExpandedPool();

  void _load() {
    final raw = _store.getJsonMap(_stateKey);
    if (raw == null) return;

    final entries = <String, DailyLearningDayStatus>{};
    final entriesRaw = raw['entries'];
    if (entriesRaw is Map) {
      for (final entry in entriesRaw.entries) {
        if (entry.key is! String || entry.value is! Map) continue;
        final parsed = DailyLearningDayStatus.fromJson(
          (entry.value as Map).map((k, v) => MapEntry(k.toString(), v)),
        );
        if (parsed.dateKey.isNotEmpty) {
          entries[entry.key.toString()] = parsed;
        }
      }
    }

    state = DailyLearningState(entries: entries);
  }

  Future<void> _save() async {
    final trimmed = _trimToRecent(state.entries, keepDays: 60);
    final payload = <String, dynamic>{
      'entries': {
        for (final entry in trimmed.entries) entry.key: entry.value.toJson(),
      },
    };
    await _store.setJsonMap(_stateKey, payload);
  }

  DailyLearningBundle todayBundle() {
    final today = LocalStore.todayKey();
    return bundleForDate(today);
  }

  DailyLearningBundle bundleForDate(String dateKey) {
    final item = _itemForDate(dateKey);
    final question = _questionForDate(dateKey, item);
    final status =
        state.entries[dateKey] ?? DailyLearningDayStatus(dateKey: dateKey);

    return DailyLearningBundle(
      dateKey: dateKey,
      item: item,
      quizQuestion: question,
      status: status,
    );
  }

  Future<void> markTodayCardOpened() async {
    final key = LocalStore.todayKey();
    final current = state.entries[key] ?? DailyLearningDayStatus(dateKey: key);
    if (current.cardOpened) return;
    final updated = current.copyWith(cardOpened: true);
    final next = <String, DailyLearningDayStatus>{
      ...state.entries,
      key: updated,
    };
    state = state.copyWith(entries: next);
    await _save();
  }

  Future<void> markTodayLinkedProphetOpened(String prophetId) async {
    final key = LocalStore.todayKey();
    final current = state.entries[key] ?? DailyLearningDayStatus(dateKey: key);
    final updated = current.copyWith(
      cardOpened: true,
      lastLinkedProphetId: prophetId,
    );
    final next = <String, DailyLearningDayStatus>{
      ...state.entries,
      key: updated,
    };
    state = state.copyWith(entries: next);
    await _save();
  }

  Future<void> answerTodayQuiz({
    required String questionId,
    required int selectedIndex,
    required int correctIndex,
  }) async {
    final key = LocalStore.todayKey();
    final current = state.entries[key] ?? DailyLearningDayStatus(dateKey: key);
    final updated = current.copyWith(
      quizAnswered: true,
      quizQuestionId: questionId,
      quizSelectedIndex: selectedIndex,
      quizCorrect: selectedIndex == correctIndex,
    );
    final next = <String, DailyLearningDayStatus>{
      ...state.entries,
      key: updated,
    };
    state = state.copyWith(entries: next);
    await _save();
  }

  DailyLearningItem _itemForDate(String dateKey) {
    final date = DateTime.tryParse(dateKey) ?? DateTime.now();
    final pool = _dailyPoolForDate(date);
    final index = _dateIndex(dateKey, pool.length);
    return pool[index];
  }

  ProphetQuizQuestion _questionForDate(String dateKey, DailyLearningItem item) {
    final pool = _questionPool;
    if (item.dailyQuizQuestionId != null) {
      for (final q in pool) {
        if (q.id == item.dailyQuizQuestionId) return q;
      }
    }

    List<ProphetQuizQuestion> filtered;
    if (item.linkedProphetId != null) {
      filtered = pool
          .where((q) => q.relatedProphetId == item.linkedProphetId)
          .toList();
    } else if (item.linkedEraId != null) {
      filtered = pool.where((q) => q.eraId == item.linkedEraId).toList();
    } else {
      filtered = pool;
    }

    if (filtered.isEmpty) filtered = pool;
    filtered.sort((a, b) => a.id.compareTo(b.id));
    final index = _dateIndex(dateKey, filtered.length);
    return filtered[index];
  }

  int _dateIndex(String dateKey, int length) {
    if (length <= 0) return 0;
    final date = DateTime.tryParse(dateKey) ?? DateTime.now();
    final utc = DateTime.utc(date.year, date.month, date.day);
    final days = utc.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    return days % length;
  }

  Map<String, DailyLearningDayStatus> _trimToRecent(
    Map<String, DailyLearningDayStatus> entries, {
    required int keepDays,
  }) {
    final parsed = entries.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    if (parsed.length <= keepDays) return entries;
    final keep = parsed.take(keepDays);
    return {for (final e in keep) e.key: e.value};
  }

  List<DailyLearningItem> _dailyPoolForDate(DateTime date) {
    final items = <DailyLearningItem>[...seededDailyLearningItems];

    if (_specialMode.isRamadan || _specialMode.ramadanDateWindowActive) {
      items.addAll(seededRamadanDailyLearningItems);
    }
    if (date.weekday == DateTime.friday) {
      items.addAll(seededFridayDailyLearningItems);
    }

    final hijri = growthToHijriDate(date);
    if (hijri.month == 12 && hijri.day <= 10) {
      items.addAll(seededDhulHijjahDailyLearningItems);
    }

    return items;
  }
}

final dailyLearningControllerProvider =
    StateNotifierProvider<DailyLearningController, DailyLearningState>((ref) {
      return DailyLearningController(
        ref.watch(localStoreProvider),
        ref.watch(specialModeProvider),
      );
    });

final todayDailyLearningBundleProvider = Provider<DailyLearningBundle>((ref) {
  ref.watch(dailyLearningControllerProvider);
  return ref.read(dailyLearningControllerProvider.notifier).todayBundle();
});
