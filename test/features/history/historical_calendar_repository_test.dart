import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/history/data/historical_calendar_repository.dart';
import 'package:path_of_nur/features/history/domain/historical_event_models.dart';
import 'package:path_of_nur/shared/utils/hijri_date_utils.dart';

void main() {
  test('parses seeded historical calendar records', () {
    final raw = '''
[
  {
    "id": "battle_of_badr_624",
    "slug": "battle-of-badr",
    "title": "Battle of Badr",
    "summaryShort": "Short summary",
    "summaryLong": "Long summary",
    "categories": ["seerah", "battles", "islamic_history"],
    "tags": ["badr"],
    "gregorian": {"year": 624, "month": 3, "day": 13},
    "hijri": {"year": 2, "month": 9, "day": 17},
    "location": {"name": "Badr"},
    "significance": ["Important"],
    "lessons": ["Reflect"],
    "relatedEntities": ["Prophet Muhammad ﷺ"],
    "relatedContentIds": [],
    "relatedContentHooks": [],
    "featuredPriority": 100,
    "sources": [{"label": "Qur’an 8:5-19"}],
    "isPublished": true,
    "dateConfidence": "exact",
    "alternateDates": []
  }
]
''';

    final events = parseHistoricalCalendarSeed(raw);

    expect(events, hasLength(1));
    expect(events.first.slug, 'battle-of-badr');
    expect(events.first.categories, contains(HistoricalEventCategory.seerah));
    expect(events.first.gregorian.month, 3);
    expect(events.first.hijri.month, 9);
  });

  test('today matching ranks dual then hijri then gregorian matches', () {
    final events = [
      HistoricalEvent.fromJson({
        'id': 'dual',
        'slug': 'dual',
        'title': 'Dual Match',
        'summaryShort': 'dual',
        'categories': ['islamic_history'],
        'tags': [],
        'gregorian': {'year': 600, 'month': 3, 'day': 13},
        'hijri': {'year': 2, 'month': 9, 'day': 17},
        'location': {'name': 'A'},
        'significance': [],
        'lessons': [],
        'relatedEntities': [],
        'relatedContentIds': [],
        'relatedContentHooks': [],
        'featuredPriority': 1,
        'sources': [],
        'isPublished': true,
        'dateConfidence': 'exact',
        'alternateDates': [],
      }),
      HistoricalEvent.fromJson({
        'id': 'hijri',
        'slug': 'hijri',
        'title': 'Hijri Match',
        'summaryShort': 'hijri',
        'categories': ['islamic_history'],
        'tags': [],
        'gregorian': {'year': 600, 'month': 4, 'day': 1},
        'hijri': {'year': 2, 'month': 9, 'day': 17},
        'location': {'name': 'B'},
        'significance': [],
        'lessons': [],
        'relatedEntities': [],
        'relatedContentIds': [],
        'relatedContentHooks': [],
        'featuredPriority': 10,
        'sources': [],
        'isPublished': true,
        'dateConfidence': 'exact',
        'alternateDates': [],
      }),
      HistoricalEvent.fromJson({
        'id': 'gregorian',
        'slug': 'gregorian',
        'title': 'Gregorian Match',
        'summaryShort': 'gregorian',
        'categories': ['islamic_history'],
        'tags': [],
        'gregorian': {'year': 600, 'month': 3, 'day': 13},
        'hijri': {'year': 2, 'month': 8, 'day': 1},
        'location': {'name': 'C'},
        'significance': [],
        'lessons': [],
        'relatedEntities': [],
        'relatedContentIds': [],
        'relatedContentHooks': [],
        'featuredPriority': 100,
        'sources': [],
        'isPublished': true,
        'dateConfidence': 'exact',
        'alternateDates': [],
      }),
    ];

    final matches = buildHistoricalTodayMatches(
      events: events,
      today: DateTime(2026, 3, 13),
      hijriToday: const HijriDateParts(year: 1447, month: 9, day: 17),
    );

    expect(matches.map((match) => match.event.id).toList(), [
      'dual',
      'hijri',
      'gregorian',
    ]);
    expect(matches.first.matchesGregorian, isTrue);
    expect(matches.first.matchesHijri, isTrue);
  });

  test('dual-matched event appears only once in today results', () {
    final event = HistoricalEvent.fromJson({
      'id': 'dual',
      'slug': 'dual',
      'title': 'Dual Match',
      'summaryShort': 'dual',
      'categories': ['islamic_history'],
      'tags': [],
      'gregorian': {'year': 600, 'month': 3, 'day': 13},
      'hijri': {'year': 2, 'month': 9, 'day': 17},
      'location': {'name': 'A'},
      'significance': [],
      'lessons': [],
      'relatedEntities': [],
      'relatedContentIds': [],
      'relatedContentHooks': [],
      'featuredPriority': 1,
      'sources': [],
      'isPublished': true,
      'dateConfidence': 'exact',
      'alternateDates': [],
    });

    final matches = buildHistoricalTodayMatches(
      events: [event],
      today: DateTime(2026, 3, 13),
      hijriToday: const HijriDateParts(year: 1447, month: 9, day: 17),
    );

    expect(matches, hasLength(1));
    expect(matches.single.event.id, 'dual');
  });

  test(
    'real seeded dataset has stable ids, valid categories, and broad coverage',
    () {
      final raw = File(
        'assets/data/historical_calendar_seed.json',
      ).readAsStringSync();
      final events = parseHistoricalCalendarSeed(raw);

      expect(events.length, greaterThanOrEqualTo(40));

      final ids = <String>{};
      final slugs = <String>{};
      final gregorianMonths = <int>{};
      final hijriMonths = <int>{};
      var curatedLinksCount = 0;

      for (final event in events) {
        expect(event.id, isNotEmpty, reason: 'Every event needs a stable id.');
        expect(
          ids.add(event.id),
          isTrue,
          reason: 'Duplicate historical event id: ${event.id}',
        );
        expect(
          event.slug,
          isNotEmpty,
          reason: 'Every event needs a stable slug.',
        );
        expect(
          slugs.add(event.slug),
          isTrue,
          reason: 'Duplicate historical event slug: ${event.slug}',
        );
        expect(
          event.title.trim(),
          isNotEmpty,
          reason: 'Historical event title missing for ${event.id}',
        );
        expect(
          event.summaryShort.trim(),
          isNotEmpty,
          reason: 'summaryShort missing for ${event.id}',
        );
        expect(
          event.categories,
          isNotEmpty,
          reason: 'At least one category is required for ${event.id}',
        );
        expect(
          event.tags,
          isNotEmpty,
          reason: 'At least one tag is required for ${event.id}',
        );
        expect(
          event.location.name.trim(),
          isNotEmpty,
          reason: 'Location name missing for ${event.id}',
        );
        expect(
          event.significancePoints,
          isNotEmpty,
          reason: 'Significance points missing for ${event.id}',
        );
        expect(
          event.isPublished,
          isTrue,
          reason: 'Seeded events should be published.',
        );
        if (event.relatedContentIds.isNotEmpty ||
            event.relatedContentHooks.isNotEmpty) {
          curatedLinksCount += 1;
        }

        if (event.gregorian.month case final month?) {
          expect(month, inInclusiveRange(1, 12));
          gregorianMonths.add(month);
        }
        if (event.gregorian.day case final day?) {
          expect(day, inInclusiveRange(1, 31));
        }
        if (event.hijri.month case final month?) {
          expect(month, inInclusiveRange(1, 12));
          hijriMonths.add(month);
        }
        if (event.hijri.day case final day?) {
          expect(day, inInclusiveRange(1, 31));
        }

        final hasDateInfo =
            event.gregorian.year != null ||
            event.gregorian.month != null ||
            event.gregorian.day != null ||
            event.hijri.year != null ||
            event.hijri.month != null ||
            event.hijri.day != null;
        expect(
          hasDateInfo,
          isTrue,
          reason: 'Date data missing for ${event.id}',
        );
      }

      expect(
        gregorianMonths.length,
        greaterThanOrEqualTo(12),
        reason: 'Seed data should span the full Gregorian calendar.',
      );
      expect(
        hijriMonths.length,
        greaterThanOrEqualTo(12),
        reason: 'Seed data should span the full Hijri calendar.',
      );
      expect(
        curatedLinksCount,
        greaterThanOrEqualTo(4),
        reason: 'Key historical events should include curated related links.',
      );
    },
  );
}
