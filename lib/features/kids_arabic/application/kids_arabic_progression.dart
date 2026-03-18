import '../data/kids_arabic_letters_data.dart';
import '../domain/kids_arabic_models.dart';

const kidsArabicStarterReleaseOrderIds = <String>[
  'alif',
  'ba',
  'meem',
  'noon',
  'seen',
];

final List<String> kidsArabicProgressionOrderIds = <String>[
  ...kidsArabicStarterReleaseOrderIds,
  ...kidsArabicLetters
      .map((letter) => letter.id)
      .where((id) => !kidsArabicStarterReleaseOrderIds.contains(id)),
];

final List<KidsArabicLetter> kidsArabicProgressionLetters =
    kidsArabicProgressionOrderIds
        .map(_letterById)
        .whereType<KidsArabicLetter>()
        .toList(growable: false);

List<KidsArabicLetter> kidsArabicOrderedLetters(Iterable<KidsArabicLetter> letters) {
  final byId = <String, KidsArabicLetter>{for (final letter in letters) letter.id: letter};
  return kidsArabicProgressionOrderIds
      .map((id) => byId[id])
      .whereType<KidsArabicLetter>()
      .toList(growable: false);
}

Set<String> unlockedKidsArabicLetterIds(Set<String> completedLetterIds) {
  final unlocked = <String>{};
  for (final id in kidsArabicProgressionOrderIds) {
    unlocked.add(id);
    if (!completedLetterIds.contains(id)) {
      break;
    }
  }
  return unlocked;
}

bool isKidsArabicLetterUnlocked({
  required String letterId,
  required Set<String> completedLetterIds,
}) {
  return unlockedKidsArabicLetterIds(completedLetterIds).contains(letterId);
}

KidsArabicLetter? nextKidsArabicLetter(String currentId) {
  final index = kidsArabicProgressionOrderIds.indexOf(currentId);
  if (index < 0 || index + 1 >= kidsArabicProgressionOrderIds.length) {
    return null;
  }
  return _letterById(kidsArabicProgressionOrderIds[index + 1]);
}

KidsArabicLetter? _letterById(String id) {
  for (final letter in kidsArabicLetters) {
    if (letter.id == id) return letter;
  }
  return null;
}
