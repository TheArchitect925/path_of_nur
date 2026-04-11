import '../domain/editorial_relation_models.dart';

const List<EditorialRelationEntry> seededEditorialRelationEntries = [
  EditorialRelationEntry(
    source: EditorialRelationContentRef.hadith('whoever_remains_patient'),
    target: EditorialRelationContentRef.dua('quran_002_250_pour_patience'),
    type: EditorialRelationType.relatedPractice,
    origin: EditorialRelationOrigin.seededEditorial,
    editorialLabel: 'Supplication for patience',
    editorialNote:
        'This dua gives the reader a direct supplication to pair with the hadith’s teaching on patience and steadfastness.',
    editorialConfidence: 1,
  ),
  EditorialRelationEntry(
    source: EditorialRelationContentRef.hadith('repentance_joy'),
    target: EditorialRelationContentRef.dua(
      'quran_007_023_we_wronged_ourselves',
    ),
    type: EditorialRelationType.relatedDua,
    origin: EditorialRelationOrigin.seededEditorial,
    editorialLabel: 'Supplication of repentance',
    editorialNote:
        'This dua gives a clear repentance follow-up for the hadith’s theme of returning to Allah.',
    editorialConfidence: 1,
  ),
  EditorialRelationEntry(
    source: EditorialRelationContentRef.hadith('paradise_feet_mothers'),
    target: EditorialRelationContentRef.dua('quran_017_024_mercy_for_parents'),
    type: EditorialRelationType.relatedDua,
    origin: EditorialRelationOrigin.seededEditorial,
    editorialLabel: 'Supplication for parents',
    editorialNote:
        'This dua turns the hadith’s lesson on honoring mothers into a direct practice of mercy and prayer for parents.',
    editorialConfidence: 1,
  ),
  EditorialRelationEntry(
    source: EditorialRelationContentRef.hadith('seek_knowledge'),
    target: EditorialRelationContentRef.dua('quran_020_114_increase_knowledge'),
    type: EditorialRelationType.relatedDua,
    origin: EditorialRelationOrigin.seededEditorial,
    editorialLabel: 'Supplication for beneficial knowledge',
    editorialNote:
        'This dua reinforces the hadith’s call to seek knowledge with a Qur’anic prayer for increase in knowledge.',
    editorialConfidence: 1,
  ),
];
