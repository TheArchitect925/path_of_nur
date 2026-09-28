import '../domain/garden_scene_models.dart';

/// Why each element stands in the garden. Every plant and creature in the
/// vista is named in the Qur'an; the reference is the surah:ayah where it
/// appears, shown beside a one-line reflection in the element detail sheet.
class GardenElementMeaning {
  const GardenElementMeaning({
    required this.elementId,
    required this.ayahReference,
    required this.titleKey,
    required this.meaningKey,
  });

  final GardenSceneElementId elementId;

  /// Plain "surah:ayah" (or "surah:from-to") — never localized; the numerals
  /// are formatted for the locale at render time.
  final String ayahReference;
  final String titleKey;
  final String meaningKey;
}

const List<GardenElementMeaning> gardenElementMeanings = [
  GardenElementMeaning(
    elementId: GardenSceneElementId.centralTree,
    ayahReference: '14:24-25',
    titleKey: 'gardenElementCentralTreeTitle',
    meaningKey: 'gardenElementCentralTreeMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.stream,
    ayahReference: '54:11-12',
    titleKey: 'gardenElementStreamTitle',
    meaningKey: 'gardenElementStreamMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.oceanHorizon,
    ayahReference: '18:109',
    titleKey: 'gardenElementOceanTitle',
    meaningKey: 'gardenElementOceanMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.olive,
    ayahReference: '24:35',
    titleKey: 'gardenElementOliveTitle',
    meaningKey: 'gardenElementOliveMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.datePalm,
    ayahReference: '19:25',
    titleKey: 'gardenElementDatePalmTitle',
    meaningKey: 'gardenElementDatePalmMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.fig,
    ayahReference: '95:1',
    titleKey: 'gardenElementFigTitle',
    meaningKey: 'gardenElementFigMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.pomegranate,
    ayahReference: '55:68',
    titleKey: 'gardenElementPomegranateTitle',
    meaningKey: 'gardenElementPomegranateMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.grapeVine,
    ayahReference: '16:67',
    titleKey: 'gardenElementGrapeVineTitle',
    meaningKey: 'gardenElementGrapeVineMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.gourd,
    ayahReference: '37:146',
    titleKey: 'gardenElementGourdTitle',
    meaningKey: 'gardenElementGourdMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.loteTree,
    ayahReference: '53:14-16',
    titleKey: 'gardenElementLoteTreeTitle',
    meaningKey: 'gardenElementLoteTreeMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.rayhan,
    ayahReference: '55:12',
    titleKey: 'gardenElementRayhanTitle',
    meaningKey: 'gardenElementRayhanMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.bee,
    ayahReference: '16:68-69',
    titleKey: 'gardenElementBeeTitle',
    meaningKey: 'gardenElementBeeMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.ant,
    ayahReference: '27:18',
    titleKey: 'gardenElementAntTitle',
    meaningKey: 'gardenElementAntMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.hoopoe,
    ayahReference: '27:20-22',
    titleKey: 'gardenElementHoopoeTitle',
    meaningKey: 'gardenElementHoopoeMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.songbirds,
    ayahReference: '24:41',
    titleKey: 'gardenElementSongbirdsTitle',
    meaningKey: 'gardenElementSongbirdsMeaning',
  ),
  GardenElementMeaning(
    elementId: GardenSceneElementId.fish,
    ayahReference: '18:61',
    titleKey: 'gardenElementFishTitle',
    meaningKey: 'gardenElementFishMeaning',
  ),
];

GardenElementMeaning? gardenElementMeaningFor(GardenSceneElementId id) {
  for (final meaning in gardenElementMeanings) {
    if (meaning.elementId == id) {
      return meaning;
    }
  }
  return null;
}
