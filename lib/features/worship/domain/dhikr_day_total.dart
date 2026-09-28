/// One day of remembrance, kept forever (sessions themselves are capped at
/// thirty). Feeds the streak, the month heatmap and the insights page.
class DhikrDayTotal {
  const DhikrDayTotal({
    required this.dateKey,
    required this.count,
    required this.sessions,
    this.routineEntries = const <String>[],
  });

  /// `yyyy-MM-dd` in local time.
  final String dateKey;
  final int count;
  final int sessions;

  /// Routine completions that day. Plain routine ids (`morning`, `evening`)
  /// or `after-salah:<prayerId>` so one day can hold several after-salah
  /// runs.
  final List<String> routineEntries;

  bool get isEmpty => count <= 0 && sessions <= 0;

  bool hasRoutine(String routineId) =>
      routineEntries.any((entry) => routineBaseId(entry) == routineId);

  bool hasRoutineEntry(String entry) => routineEntries.contains(entry);

  DhikrDayTotal copyWith({
    int? count,
    int? sessions,
    List<String>? routineEntries,
  }) {
    return DhikrDayTotal(
      dateKey: dateKey,
      count: count ?? this.count,
      sessions: sessions ?? this.sessions,
      routineEntries: routineEntries ?? this.routineEntries,
    );
  }

  static String routineBaseId(String entry) {
    final separator = entry.indexOf(':');
    return separator < 0 ? entry : entry.substring(0, separator);
  }
}

/// Local-date key shared by every dhikr history structure.
String dhikrDayKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime? dhikrDateFromKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}
