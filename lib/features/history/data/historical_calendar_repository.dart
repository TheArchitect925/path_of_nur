import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/hijri_date_utils.dart';
import '../domain/historical_event_models.dart';

const String historicalCalendarSeedAssetPath =
    'assets/data/historical_calendar_seed.json';

List<HistoricalEvent> parseHistoricalCalendarSeed(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! List) return const <HistoricalEvent>[];
  return decoded
      .whereType<Map>()
      .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
      .map(HistoricalEvent.fromJson)
      .where((event) => event.id.isNotEmpty && event.slug.isNotEmpty)
      .toList(growable: false);
}

List<HistoricalTodayMatch> buildHistoricalTodayMatches({
  required List<HistoricalEvent> events,
  required DateTime today,
  required HijriDateParts hijriToday,
}) {
  final matches = <HistoricalTodayMatch>[];
  for (final event in events) {
    if (!event.isPublished) continue;
    final matchesGregorian =
        event.gregorian.day == today.day && event.gregorian.month == today.month;
    final matchesHijri =
        event.hijri.day == hijriToday.day && event.hijri.month == hijriToday.month;
    if (!matchesGregorian && !matchesHijri) continue;
    matches.add(
      HistoricalTodayMatch(
        event: event,
        matchesGregorian: matchesGregorian,
        matchesHijri: matchesHijri,
      ),
    );
  }

  matches.sort((a, b) {
    final bucketCompare = a.rankingBucket.compareTo(b.rankingBucket);
    if (bucketCompare != 0) return bucketCompare;

    final featuredCompare =
        b.event.featuredPriority.compareTo(a.event.featuredPriority);
    if (featuredCompare != 0) return featuredCompare;

    final titleCompare = a.event.title.compareTo(b.event.title);
    if (titleCompare != 0) return titleCompare;

    return a.event.id.compareTo(b.event.id);
  });
  return matches;
}

class HistoricalCalendarRepository {
  List<HistoricalEvent>? _cachedEvents;

  Future<List<HistoricalEvent>> loadAllEvents() async {
    if (_cachedEvents != null) return _cachedEvents!;
    final raw = await rootBundle.loadString(historicalCalendarSeedAssetPath);
    final parsed = parseHistoricalCalendarSeed(raw);
    parsed.sort((a, b) {
      final featuredCompare = b.featuredPriority.compareTo(a.featuredPriority);
      if (featuredCompare != 0) return featuredCompare;
      return a.title.compareTo(b.title);
    });
    _cachedEvents = parsed;
    return parsed;
  }

  Future<List<HistoricalEvent>> getAllEvents() => loadAllEvents();

  Future<HistoricalEvent?> getEventById(String id) async {
    final all = await loadAllEvents();
    for (final event in all) {
      if (event.id == id) return event;
    }
    return null;
  }

  Future<HistoricalEvent?> getEventBySlug(String slug) async {
    final all = await loadAllEvents();
    for (final event in all) {
      if (event.slug == slug) return event;
    }
    return null;
  }

  Future<List<HistoricalEvent>> getEventsByCategory(
    HistoricalEventCategory category,
  ) async {
    final all = await loadAllEvents();
    return all
        .where((event) => event.categories.contains(category))
        .toList(growable: false);
  }

  Future<List<HistoricalEvent>> getEventsByGregorianMonth(int month) async {
    final all = await loadAllEvents();
    return all
        .where((event) => event.gregorian.month == month)
        .toList(growable: false);
  }

  Future<List<HistoricalEvent>> getEventsByHijriMonth(int month) async {
    final all = await loadAllEvents();
    return all.where((event) => event.hijri.month == month).toList(growable: false);
  }

  Future<List<HistoricalTodayMatch>> getTodayMatches({
    required DateTime today,
    required HijriDateParts hijriToday,
  }) async {
    final all = await loadAllEvents();
    return buildHistoricalTodayMatches(
      events: all,
      today: today,
      hijriToday: hijriToday,
    );
  }

  Future<HistoricalUpcomingEvent?> getNextUpcomingGregorianEvent({
    required DateTime today,
  }) async {
    final all = await loadAllEvents();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final candidates = <HistoricalUpcomingEvent>[];

    for (final event in all) {
      if (!event.isPublished || !event.gregorian.hasMonthDay) continue;
      final month = event.gregorian.month!;
      final day = event.gregorian.day!;
      var occurrenceDate = DateTime(normalizedToday.year, month, day);
      if (occurrenceDate.isBefore(normalizedToday)) {
        occurrenceDate = DateTime(normalizedToday.year + 1, month, day);
      }
      if (occurrenceDate.isAtSameMomentAs(normalizedToday)) {
        continue;
      }
      candidates.add(
        HistoricalUpcomingEvent(
          event: event,
          occurrenceDate: occurrenceDate,
        ),
      );
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final dateCompare = a.occurrenceDate.compareTo(b.occurrenceDate);
      if (dateCompare != 0) return dateCompare;

      final featuredCompare =
          b.event.featuredPriority.compareTo(a.event.featuredPriority);
      if (featuredCompare != 0) return featuredCompare;

      final titleCompare = a.event.title.compareTo(b.event.title);
      if (titleCompare != 0) return titleCompare;

      return a.event.id.compareTo(b.event.id);
    });

    return candidates.first;
  }
}

final historicalCalendarRepositoryProvider = Provider<HistoricalCalendarRepository>(
  (ref) => HistoricalCalendarRepository(),
);
