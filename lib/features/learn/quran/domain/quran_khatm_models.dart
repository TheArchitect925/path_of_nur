import 'package:quran/quran.dart' as q;

/// Whole-Qur'an positions are tracked as a single global ayah index
/// (1..6236, mushaf order). All juz/page math delegates to package:quran so
/// the boundaries match the standard Madani mushaf.
class QuranGlobalPosition {
  QuranGlobalPosition._();

  static final List<int> _cumulativeBefore = _buildCumulative();

  static List<int> _buildCumulative() {
    final result = List<int>.filled(q.totalSurahCount + 1, 0);
    var running = 0;
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      result[surah] = running;
      running += q.getVerseCount(surah);
    }
    return result;
  }

  static const int totalAyahs = q.totalVerseCount;

  static int indexOf(int surah, int ayah) => _cumulativeBefore[surah] + ayah;

  /// Inverse of [indexOf]; index is clamped into 1..6236.
  static (int surah, int ayah) positionOf(int index) {
    var clamped = index.clamp(1, totalAyahs);
    var surah = 1;
    while (surah < q.totalSurahCount &&
        _cumulativeBefore[surah + 1] < clamped) {
      surah++;
    }
    return (surah, clamped - _cumulativeBefore[surah]);
  }

  static final List<int> _juzStarts = _buildJuzStarts();

  static List<int> _buildJuzStarts() {
    // package:quran's juz table overlaps by one verse at some boundaries and
    // getJuzNumber resolves overlaps first-match; we define juz k as
    // [start_k, start_{k+1} - 1] from each juz's own start so the math here
    // is internally consistent.
    final starts = List<int>.filled(31, 0);
    for (var juzNumber = 1; juzNumber <= 30; juzNumber++) {
      final verses = q.getSurahAndVersesFromJuz(juzNumber);
      final firstSurah = verses.keys.reduce((a, b) => a < b ? a : b);
      starts[juzNumber] = indexOf(firstSurah, verses[firstSurah]![0]);
    }
    return starts;
  }

  /// Global index of the first ayah of a juz (1..30).
  static int juzStartIndex(int juzNumber) => _juzStarts[juzNumber];

  /// Juz number (1..30) containing a global index, by this class's own
  /// boundary definition.
  static int juzOf(int index) {
    final clamped = index.clamp(1, totalAyahs);
    var juzNumber = 30;
    while (juzNumber > 1 && _juzStarts[juzNumber] > clamped) {
      juzNumber--;
    }
    return juzNumber;
  }

  /// Completed-juz equivalent (0..30) for a completed-through index, exact at
  /// juz boundaries and linear within a juz.
  static double juzEquivalent(int completedIndex) {
    if (completedIndex <= 0) return 0;
    if (completedIndex >= totalAyahs) return 30;
    final juz = juzOf(completedIndex);
    final start = juzStartIndex(juz);
    final end = juz == 30 ? totalAyahs + 1 : juzStartIndex(juz + 1);
    return (juz - 1) + (completedIndex - start + 1) / (end - start);
  }

  /// Global index for a fractional juz-equivalent target (inverse of
  /// [juzEquivalent]).
  static int indexAtJuzEquivalent(double juzEquivalentTarget) {
    if (juzEquivalentTarget <= 0) return 0;
    if (juzEquivalentTarget >= 30) return totalAyahs;
    final juz = juzEquivalentTarget.floor() + 1;
    final fraction = juzEquivalentTarget - (juz - 1);
    final start = juzStartIndex(juz);
    final end = juz == 30 ? totalAyahs + 1 : juzStartIndex(juz + 1);
    final offset = (fraction * (end - start)).round();
    return (start - 1 + offset).clamp(0, totalAyahs);
  }

  /// Global index of the last ayah on a mushaf page (1..604).
  static int pageEndIndex(int pageNumber) {
    if (pageNumber >= q.totalPagesCount) return totalAyahs;
    final next = q.getPageData(pageNumber + 1).first;
    final surah = next['surah'] as int;
    final start = next['start'] as int;
    return indexOf(surah, start) - 1;
  }
}

enum QuranKhatmPaceMode { juzPerDay, pagesPerDay, finishBy }

/// A whole-Qur'an reading plan. `completedIndex` is the global ayah index the
/// reader has completed through (0 = nothing yet).
class QuranKhatmPlan {
  const QuranKhatmPlan({
    required this.paceMode,
    required this.juzPerDay,
    required this.pagesPerDay,
    required this.targetDateIso,
    required this.startedAtIso,
    required this.completedIndex,
    required this.lastPortionDayKey,
  });

  final QuranKhatmPaceMode paceMode;
  final double juzPerDay;
  final int pagesPerDay;
  final String? targetDateIso;
  final String startedAtIso;
  final int completedIndex;
  final String? lastPortionDayKey;

  QuranKhatmPlan copyWith({
    QuranKhatmPaceMode? paceMode,
    double? juzPerDay,
    int? pagesPerDay,
    String? targetDateIso,
    String? startedAtIso,
    int? completedIndex,
    String? lastPortionDayKey,
  }) {
    return QuranKhatmPlan(
      paceMode: paceMode ?? this.paceMode,
      juzPerDay: juzPerDay ?? this.juzPerDay,
      pagesPerDay: pagesPerDay ?? this.pagesPerDay,
      targetDateIso: targetDateIso ?? this.targetDateIso,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedIndex: completedIndex ?? this.completedIndex,
      lastPortionDayKey: lastPortionDayKey ?? this.lastPortionDayKey,
    );
  }

  bool get isComplete => completedIndex >= QuranGlobalPosition.totalAyahs;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'paceMode': paceMode.name,
    'juzPerDay': juzPerDay,
    'pagesPerDay': pagesPerDay,
    'targetDateIso': targetDateIso,
    'startedAtIso': startedAtIso,
    'completedIndex': completedIndex,
    'lastPortionDayKey': lastPortionDayKey,
  };

  static QuranKhatmPlan? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final paceMode = QuranKhatmPaceMode.values
        .where((mode) => mode.name == json['paceMode'])
        .firstOrNull;
    if (paceMode == null) return null;
    return QuranKhatmPlan(
      paceMode: paceMode,
      juzPerDay: (json['juzPerDay'] as num?)?.toDouble() ?? 1,
      pagesPerDay: (json['pagesPerDay'] as num?)?.toInt() ?? 10,
      targetDateIso: json['targetDateIso'] as String?,
      startedAtIso: json['startedAtIso'] as String? ?? '',
      completedIndex: (json['completedIndex'] as num?)?.toInt() ?? 0,
      lastPortionDayKey: json['lastPortionDayKey'] as String?,
    );
  }
}

/// Today's reading portion for a plan: a contiguous global-index range.
class QuranKhatmPortion {
  const QuranKhatmPortion({required this.startIndex, required this.endIndex});

  final int startIndex;
  final int endIndex;

  (int surah, int ayah) get startPosition =>
      QuranGlobalPosition.positionOf(startIndex);
  (int surah, int ayah) get endPosition =>
      QuranGlobalPosition.positionOf(endIndex);
  int get ayahCount => endIndex - startIndex + 1;
}

/// Computes today's portion from the plan. Pure so the math is testable.
QuranKhatmPortion khatmPortionFor(QuranKhatmPlan plan, DateTime today) {
  final start = plan.completedIndex + 1;
  int end;
  switch (plan.paceMode) {
    case QuranKhatmPaceMode.juzPerDay:
      final target =
          QuranGlobalPosition.juzEquivalent(plan.completedIndex) +
          plan.juzPerDay;
      end = QuranGlobalPosition.indexAtJuzEquivalent(target);
    case QuranKhatmPaceMode.pagesPerDay:
      final (surah, ayah) = QuranGlobalPosition.positionOf(
        start.clamp(1, QuranGlobalPosition.totalAyahs),
      );
      final page = q.getPageNumber(surah, ayah);
      final endPage = (page + plan.pagesPerDay - 1).clamp(
        1,
        q.totalPagesCount,
      );
      end = QuranGlobalPosition.pageEndIndex(endPage);
    case QuranKhatmPaceMode.finishBy:
      final target = DateTime.tryParse(plan.targetDateIso ?? '');
      final daysLeft = target == null
          ? 30
          : (DateTime(
                  target.year,
                  target.month,
                  target.day,
                ).difference(DateTime(today.year, today.month, today.day)).inDays +
                1)
              .clamp(1, 100000);
      final remaining = QuranGlobalPosition.totalAyahs - plan.completedIndex;
      end = plan.completedIndex + (remaining / daysLeft).ceil();
  }
  if (end < start) end = start;
  return QuranKhatmPortion(
    startIndex: start.clamp(1, QuranGlobalPosition.totalAyahs),
    endIndex: end.clamp(1, QuranGlobalPosition.totalAyahs),
  );
}
