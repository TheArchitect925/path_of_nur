import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hadith_foundation_repository.dart';
import '../domain/hadith_foundation_models.dart';

const List<String> _kidsHadithIds = <String>[
  'love_for_brother',
  'speak_good_or_silent_faith',
  'smiling_is_charity',
  'man_forgiven_water_dog',
  'seek_knowledge',
  'mercy_young_respect_elders',
];

final kidsHadithEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final entries = ref.watch(hadithEntriesProvider);
  final entryById = {for (final entry in entries) entry.id: entry};
  return _kidsHadithIds
      .map((id) => entryById[id])
      .whereType<HadithEntry>()
      .toList(growable: false);
});
