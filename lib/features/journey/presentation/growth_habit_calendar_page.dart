import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';

class GrowthHabitCalendarPage extends ConsumerStatefulWidget {
  const GrowthHabitCalendarPage({super.key});

  @override
  ConsumerState<GrowthHabitCalendarPage> createState() =>
      _GrowthHabitCalendarPageState();
}

class _GrowthHabitCalendarPageState
    extends ConsumerState<GrowthHabitCalendarPage> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthLabel = DateFormat.yMMMM(locale).format(_visibleMonth);
    final state = ref.watch(growthControllerProvider);
    final habits = ref.watch(growthEnabledHabitsProvider);
    final days = _buildMonthDays(_visibleMonth);

    return AppPageScaffold(
      title: l10n.growthTrackingCalendarTitle,
      subtitle: l10n.growthTrackingCalendarSubtitle,
      children: [
        PremiumCard(
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(
                  () => _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month - 1,
                  ),
                ),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => setState(
                  () => _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month + 1,
                  ),
                ),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final date = days[index];
            if (date == null) {
              return const SizedBox.shrink();
            }
            final summary = _calendarSummaryForDate(
              date: date,
              habits: habits,
              state: state,
            );
            return _CalendarDayTile(date: date, summary: summary);
          },
        ),
      ],
    );
  }

  List<DateTime?> _buildMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmpty = firstDay.weekday % 7;
    final items = <DateTime?>[
      for (var i = 0; i < leadingEmpty; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(month.year, month.month, day),
    ];
    while (items.length % 7 != 0) {
      items.add(null);
    }
    return items;
  }
}

class _CalendarSummary {
  const _CalendarSummary({
    required this.dueCount,
    required this.completedCount,
    required this.missedCount,
  });

  final int dueCount;
  final int completedCount;
  final int missedCount;
}

_CalendarSummary _calendarSummaryForDate({
  required DateTime date,
  required List<GrowthHabit> habits,
  required GrowthState state,
}) {
  var dueCount = 0;
  var completedCount = 0;
  var missedCount = 0;
  final dayKey = LocalStore.todayKey(date);
  final logs = state.habitLogsByDay[dayKey] ?? const <String, GrowthHabitLog>{};

  for (final habit in habits) {
    if (!isHabitDueOnDate(habit, date, state)) continue;
    dueCount += 1;
    final log = logs[habit.id];
    if (log?.status == GrowthHabitStatus.completed) {
      completedCount += 1;
    } else if (date.isBefore(DateUtils.dateOnly(DateTime.now()))) {
      missedCount += 1;
    }
  }

  return _CalendarSummary(
    dueCount: dueCount,
    completedCount: completedCount,
    missedCount: missedCount,
  );
}

class _CalendarDayTile extends StatelessWidget {
  const _CalendarDayTile({required this.date, required this.summary});

  final DateTime date;
  final _CalendarSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final completionRatio = summary.dueCount == 0
        ? 0.0
        : summary.completedCount / summary.dueCount;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFFF5EEE3) : const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? const Color(0xFFD7B98A) : const Color(0xFFE7DED1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (summary.dueCount > 0) ...[
            LinearProgressIndicator(value: completionRatio, minHeight: 6),
            const SizedBox(height: 6),
            Text(
              '${summary.completedCount}/${summary.dueCount}',
              style: const TextStyle(fontSize: 12),
            ),
          ] else
            Text(
              l10n.growthTrackingCalendarNoHabits,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8B7C6A)),
            ),
          if (summary.missedCount > 0)
            Text(
              l10n.growthTrackingCalendarMissedValue(summary.missedCount),
              style: const TextStyle(fontSize: 11, color: Color(0xFF8B5C55)),
            ),
        ],
      ),
    );
  }
}
