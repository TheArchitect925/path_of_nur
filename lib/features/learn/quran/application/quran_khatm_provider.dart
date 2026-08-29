import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_khatm_models.dart';
import 'quran_providers.dart';

const _khatmPlanKey = 'learn.quran.khatm.v1';

class QuranKhatmPlanNotifier extends Notifier<QuranKhatmPlan?> {
  @override
  QuranKhatmPlan? build() {
    final store = ref.watch(localStoreProvider);
    return QuranKhatmPlan.fromJson(store.getJsonMap(_khatmPlanKey));
  }

  void _save(QuranKhatmPlan? plan) {
    state = plan;
    final store = ref.read(localStoreProvider);
    if (plan == null) {
      store.remove(_khatmPlanKey);
    } else {
      store.setJsonMap(_khatmPlanKey, plan.toJson());
    }
  }

  void startPlan({
    required QuranKhatmPaceMode paceMode,
    double juzPerDay = 1,
    int pagesPerDay = 10,
    DateTime? targetDate,
    int completedIndex = 0,
  }) {
    _save(
      QuranKhatmPlan(
        paceMode: paceMode,
        juzPerDay: juzPerDay,
        pagesPerDay: pagesPerDay,
        targetDateIso: targetDate?.toIso8601String(),
        startedAtIso: DateTime.now().toIso8601String(),
        completedIndex: completedIndex.clamp(
          0,
          QuranGlobalPosition.totalAyahs,
        ),
        lastPortionDayKey: null,
      ),
    );
  }

  void updatePace({
    required QuranKhatmPaceMode paceMode,
    double? juzPerDay,
    int? pagesPerDay,
    DateTime? targetDate,
  }) {
    final current = state;
    if (current == null) return;
    _save(
      current.copyWith(
        paceMode: paceMode,
        juzPerDay: juzPerDay,
        pagesPerDay: pagesPerDay,
        targetDateIso: targetDate?.toIso8601String(),
      ),
    );
  }

  /// Marks today's portion read: completion advances to the portion end.
  void markPortionDone(DateTime today) {
    final current = state;
    if (current == null || current.isComplete) return;
    final portion = khatmPortionFor(current, today);
    _save(
      current.copyWith(
        completedIndex: portion.endIndex,
        lastPortionDayKey: LocalStore.todayKey(today),
      ),
    );
  }

  /// Moves the completed-through marker to an explicit position (e.g. "set to
  /// where I'm reading"). Never moves backwards implicitly — callers decide.
  void setCompletedThrough(int surah, int ayah) {
    final current = state;
    if (current == null) return;
    _save(
      current.copyWith(
        completedIndex: QuranGlobalPosition.indexOf(surah, ayah),
      ),
    );
  }

  void clearPlan() => _save(null);
}

final quranKhatmPlanProvider =
    NotifierProvider<QuranKhatmPlanNotifier, QuranKhatmPlan?>(
      QuranKhatmPlanNotifier.new,
    );

/// Live view of the plan for surfaces: labels, portion, done-today flag.
class QuranKhatmStatus {
  const QuranKhatmStatus({
    required this.plan,
    required this.portion,
    required this.currentJuz,
    required this.progressFraction,
    required this.portionDoneToday,
    required this.portionLabel,
  });

  final QuranKhatmPlan plan;
  final QuranKhatmPortion portion;
  final int currentJuz;
  final double progressFraction;
  final bool portionDoneToday;

  /// "Al-Baqarah 45 → Aal-Imran 20" style range label.
  final String portionLabel;
}

final quranKhatmStatusProvider = Provider<QuranKhatmStatus?>((ref) {
  final plan = ref.watch(quranKhatmPlanProvider);
  if (plan == null) return null;
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final portion = khatmPortionFor(plan, now);
  final (startSurah, startAyah) = portion.startPosition;
  final (endSurah, endAyah) = portion.endPosition;
  final repository = ref.watch(quranRepositoryProvider);
  final surahs = repository.getSurahs();
  String label(int surah, int ayah) =>
      '${surahs[surah - 1].transliteratedName} $ayah';
  final nextIndex = (plan.completedIndex + 1).clamp(
    1,
    QuranGlobalPosition.totalAyahs,
  );
  return QuranKhatmStatus(
    plan: plan,
    portion: portion,
    currentJuz: plan.isComplete ? 30 : QuranGlobalPosition.juzOf(nextIndex),
    progressFraction:
        plan.completedIndex / QuranGlobalPosition.totalAyahs,
    portionDoneToday:
        plan.lastPortionDayKey == LocalStore.todayKey(now) || plan.isComplete,
    portionLabel: startSurah == endSurah
        ? '${surahs[startSurah - 1].transliteratedName} $startAyah–$endAyah'
        : '${label(startSurah, startAyah)} → ${label(endSurah, endAyah)}',
  );
});

/// Juz-equivalent progress (0..30) for garden unlocks; replaces the manual
/// Ramadan juz slider as the source of Qur'an completion.
final quranKhatmJuzEquivalentProvider = Provider<double>((ref) {
  final plan = ref.watch(quranKhatmPlanProvider);
  if (plan == null) return 0;
  return QuranGlobalPosition.juzEquivalent(plan.completedIndex);
});
