import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../data/historical_calendar_repository.dart';
import '../domain/historical_event_models.dart';

class HistoricalTodayState {
  const HistoricalTodayState({
    required this.today,
    required this.hijriToday,
    required this.matches,
    required this.nextUpcomingEvent,
  });

  final DateTime today;
  final HijriDateParts hijriToday;
  final List<HistoricalTodayMatch> matches;
  final HistoricalUpcomingEvent? nextUpcomingEvent;

  HistoricalTodayMatch? get featuredMatch =>
      matches.isEmpty ? null : matches.first;
}

final historicalCalendarEventsProvider =
    FutureProvider<List<HistoricalEvent>>((ref) async {
      return ref.watch(historicalCalendarRepositoryProvider).getAllEvents();
    });

final historicalTodayProvider = FutureProvider<HistoricalTodayState>((ref) async {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final hijriToday = toHijriDate(today);
  final matches = await ref
      .watch(historicalCalendarRepositoryProvider)
      .getTodayMatches(today: today, hijriToday: hijriToday);
  final nextUpcomingEvent = await ref
      .watch(historicalCalendarRepositoryProvider)
      .getNextUpcomingGregorianEvent(today: today);
  return HistoricalTodayState(
    today: today,
    hijriToday: hijriToday,
    matches: matches,
    nextUpcomingEvent: nextUpcomingEvent,
  );
});

final historicalEventBySlugProvider =
    FutureProvider.family<HistoricalEvent?, String>((ref, slug) async {
      return ref.watch(historicalCalendarRepositoryProvider).getEventBySlug(slug);
    });

final historicalEventsByCategoryProvider =
    FutureProvider.family<List<HistoricalEvent>, HistoricalEventCategory>((
      ref,
      category,
    ) async {
      return ref
          .watch(historicalCalendarRepositoryProvider)
          .getEventsByCategory(category);
    });
