import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learn/dua/application/dua_repository.dart';
import '../../learn/dua/domain/dua_models.dart';
import '../domain/dhikr_preset.dart';
import '../domain/dhikr_routine.dart';
import 'dhikr_custom_routines_provider.dart';

const String kDhikrRoutineAfterSalahId = 'after-salah';
const String kDhikrRoutineMorningId = 'morning';
const String kDhikrRoutineEveningId = 'evening';
const String kDhikrRoutineSleepId = 'sleep';

/// Reads a repeat count out of a duʿā's "when to say" note. The seed writes
/// these as prose ("Three times in the morning."), so the routine builder
/// only has to recognise the handful of forms it uses.
int parseDhikrRepeatCount(String whenToSay) {
  final text = whenToSay.toLowerCase();
  final table = <MapEntry<RegExp, int>>[
    MapEntry(RegExp(r'\b(one hundred|hundred|100)\s+times\b'), 100),
    MapEntry(RegExp(r'\b(ten|10)\s+times\b'), 10),
    MapEntry(RegExp(r'\b(seven|7)\s+times\b'), 7),
    MapEntry(RegExp(r'\b(four|4)\s+times\b'), 4),
    MapEntry(RegExp(r'\b(three|3)\s+times\b'), 3),
    MapEntry(RegExp(r'\b(twice|two times|2 times)\b'), 2),
  ];
  for (final entry in table) {
    if (entry.key.hasMatch(text)) return entry.value;
  }
  return 1;
}

/// The after-salah tasbih as narrated in Sahih Muslim 597: thirty-three of
/// each glorification, then one tahlil completing the hundred.
DhikrRoutine buildAfterSalahRoutine() {
  DhikrRoutineStep presetStep(String presetId, int count) {
    final preset = DhikrPreset.byId(presetId)!;
    return DhikrRoutineStep(
      id: preset.id,
      title: preset.label,
      arabic: preset.phrase,
      transliteration: preset.transliteration,
      translation: preset.translation,
      count: count,
      sourceRef: 'Sahih Muslim 597',
    );
  }

  return DhikrRoutine(
    id: kDhikrRoutineAfterSalahId,
    kind: DhikrRoutineKind.afterSalah,
    sourceRef: 'Sahih Muslim 597',
    steps: <DhikrRoutineStep>[
      presetStep('subhanallah', 33),
      presetStep('alhamdulillah', 33),
      presetStep('allahukbar', 33),
      const DhikrRoutineStep(
        id: 'tahlil-closing',
        title: 'La ilaha illAllah (closing)',
        arabic:
            'لَا إِلَٰهَ إِلَّا ٱللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ ٱلْمُلْكُ وَلَهُ ٱلْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'La ilaha illAllahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir',
        translation:
            'There is no god but الله alone, without partner. His is the dominion and His is the praise, and He has power over all things.',
        count: 1,
        sourceRef: 'Sahih Muslim 597',
      ),
    ],
  );
}

List<DhikrRoutineStep> _stepsFromDuas(
  Iterable<DuaItem> items,
  String requiredTag,
) {
  return <DhikrRoutineStep>[
    for (final item in items)
      if (item.subcategory == 'morning_evening' &&
          item.tags.contains(requiredTag) &&
          item.arabic.trim().isNotEmpty)
        DhikrRoutineStep(
          id: item.id,
          title: item.title,
          arabic: item.arabic,
          transliteration: item.transliteration,
          translation: item.translation,
          count: parseDhikrRepeatCount(item.whenToSay),
          sourceRef: item.sourceRef,
        ),
  ];
}

/// The bedtime set: what the Duas library files under `sleep`, minus the
/// waking duʿās, with the Qur'anic recitations (Āyat al-Kursī, the closing
/// verses of al-Baqarah, the three Quls) before the spoken ones.
List<DhikrRoutineStep> _sleepSteps(Iterable<DuaItem> items) {
  bool isWaking(DuaItem item) {
    final text = '${item.title} ${item.whenToSay}'.toLowerCase();
    return item.tags.contains('morning') || text.contains('wak');
  }

  final chosen = <DuaItem>[
    for (final item in items)
      if (item.subcategory == 'sleep' &&
          item.tags.contains('sleep') &&
          item.arabic.trim().isNotEmpty &&
          !isWaking(item))
        item,
  ];
  final ordered = <DuaItem>[
    ...chosen.where((item) => item.tags.contains('quran')),
    ...chosen.where((item) => !item.tags.contains('quran')),
  ];
  return <DhikrRoutineStep>[
    for (final item in ordered)
      DhikrRoutineStep(
        id: item.id,
        title: item.title,
        arabic: item.arabic,
        transliteration: item.transliteration,
        translation: item.translation,
        count: parseDhikrRepeatCount(item.whenToSay),
        sourceRef: item.sourceRef,
      ),
  ];
}

/// Builds the routines the dhikr hub offers. Morning, evening and before
/// sleep reuse the sourced adhkar already seeded in the Duas library, so
/// they only appear once that dataset has loaded.
List<DhikrRoutine> buildDhikrRoutines(DuaDataset? dataset) {
  final routines = <DhikrRoutine>[buildAfterSalahRoutine()];
  if (dataset == null) return routines;
  final morning = _stepsFromDuas(dataset.items, 'morning');
  if (morning.isNotEmpty) {
    routines.add(
      DhikrRoutine(
        id: kDhikrRoutineMorningId,
        kind: DhikrRoutineKind.morning,
        steps: morning,
      ),
    );
  }
  final evening = _stepsFromDuas(dataset.items, 'evening');
  if (evening.isNotEmpty) {
    routines.add(
      DhikrRoutine(
        id: kDhikrRoutineEveningId,
        kind: DhikrRoutineKind.evening,
        steps: evening,
      ),
    );
  }
  final sleep = _sleepSteps(dataset.items);
  if (sleep.isNotEmpty) {
    routines.add(
      DhikrRoutine(
        id: kDhikrRoutineSleepId,
        kind: DhikrRoutineKind.sleep,
        steps: sleep,
      ),
    );
  }
  return routines;
}

/// Built-in routines first, then the user's own in the order they were made.
final dhikrRoutinesProvider = Provider<List<DhikrRoutine>>((ref) {
  final dataset = ref.watch(duaDatasetProvider).valueOrNull;
  final custom = ref.watch(dhikrCustomRoutinesProvider);
  return <DhikrRoutine>[
    ...buildDhikrRoutines(dataset),
    for (final routine in custom)
      if (routine.steps.isNotEmpty) routine.toRoutine(),
  ];
});

final dhikrRoutineByIdProvider = Provider.family<DhikrRoutine?, String>((
  ref,
  routineId,
) {
  for (final routine in ref.watch(dhikrRoutinesProvider)) {
    if (routine.id == routineId) return routine;
  }
  return null;
});
