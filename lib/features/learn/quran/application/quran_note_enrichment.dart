import '../../content/domain/learn_note_category.dart';

const String quranNotesDefaultFolder = 'Quran';
const LearnNoteCategory quranNotesDefaultCategory = LearnNoteCategory.quran;

List<String> buildQuranNoteTags({
  required String surahName,
  required int surahNumber,
  required int ayahNumber,
  Iterable<String> extraTags = const <String>[],
}) {
  final ordered = <String>[
    quranNotesDefaultFolder,
    surahName,
    '$surahNumber:$ayahNumber',
    ...extraTags,
  ];
  final output = <String>[];
  final seen = <String>{};
  for (final raw in ordered) {
    final tag = raw.trim();
    if (tag.isEmpty) continue;
    final key = tag.toLowerCase();
    if (!seen.add(key)) continue;
    output.add(tag);
  }
  return output;
}
