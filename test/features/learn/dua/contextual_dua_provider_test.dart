import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/dua/application/contextual_dua_provider.dart';
import 'package:path_of_nur/features/learn/dua/domain/dua_models.dart';

DuaItem _dua({
  required String id,
  List<String> timeContexts = const <String>[],
  List<String> prayerContexts = const <String>[],
  List<String> dateContexts = const <String>[],
  int priorityScore = 0,
  bool isCore = false,
}) {
  return DuaItem(
    id: id,
    // ignore: deprecated_member_use_from_same_package
    category: 'daily_life',
    timeContexts: timeContexts,
    prayerContexts: prayerContexts,
    dateContexts: dateContexts,
    priorityScore: priorityScore,
    subcategory: 'general',
    title: id,
    arabic: '',
    transliteration: '',
    translation: '',
    whenToSay: '',
    sourceType: 'quran',
    sourceRef: '',
    difficulty: DuaDifficulty.beginner,
    tags: const <String>[],
    audioKey: '',
    isCore: isCore,
    verificationStatus: 'verified_strong',
    completionStatus: DuaCompletionStatus.complete,
  );
}

void main() {
  group('activeTimeContexts', () {
    test('early morning includes upon_waking', () {
      final contexts = activeTimeContexts(DateTime(2026, 8, 27, 6));
      expect(contexts, containsAll(<String>{'morning', 'upon_waking'}));
    });

    test('late night includes before_sleep', () {
      final contexts = activeTimeContexts(DateTime(2026, 8, 27, 22));
      expect(contexts, containsAll(<String>{'night', 'before_sleep'}));
    });

    test('afternoon is only afternoon', () {
      expect(activeTimeContexts(DateTime(2026, 8, 27, 14)), {'afternoon'});
    });
  });

  group('scoreDuaForContext', () {
    const morning = <String>{'morning', 'upon_waking'};

    test('matching time context beats any-time', () {
      final matching = scoreDuaForContext(
        _dua(id: 'a', timeContexts: const ['morning']),
        timeContexts: morning,
        dateContexts: const <String>{},
        prayerContexts: const <String>{},
      );
      final anyTime = scoreDuaForContext(
        _dua(id: 'b', timeContexts: const ['any']),
        timeContexts: morning,
        dateContexts: const <String>{},
        prayerContexts: const <String>{},
      );
      expect(matching, greaterThan(anyTime));
    });

    test('a dua authored for a different moment is pushed out', () {
      final evening = scoreDuaForContext(
        _dua(id: 'c', timeContexts: const ['evening'], priorityScore: 50),
        timeContexts: morning,
        dateContexts: const <String>{},
        prayerContexts: const <String>{},
      );
      expect(evening, lessThan(0));
    });

    test('prayer and date matches stack on top of time', () {
      final stacked = scoreDuaForContext(
        _dua(
          id: 'd',
          timeContexts: const ['morning'],
          prayerContexts: const ['fajr_window'],
          dateContexts: const ['friday'],
        ),
        timeContexts: morning,
        dateContexts: const <String>{'friday'},
        prayerContexts: const <String>{'fajr_window'},
      );
      expect(stacked, 40 + 30 + 25);
    });
  });
}
