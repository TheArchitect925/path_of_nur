import '../../../../learn/quran/domain/quran_content_refs.dart';
import '../../domain/bedtime_story_illustration_models.dart';
import '../../domain/bedtime_story_models.dart';

const String _bookNarratorDisplayName = 'Path of Nur Kids Story Narration';

/// Builds a picture book seed from its spreads. Everything the wider story
/// system needs (the read-aloud text, the duration, the scene manifest,
/// the reward and download flags every story carries) is derived here, so
/// a book file holds only what a writer decides.
///
/// Rewritten books keep the id of the seed they replace: quizzes, memory
/// decks, progress and related-story links are all keyed on it.
///
/// A book written in English may carry its German as [de] (C6); the
/// repository hands out `story.localized(languageCode)` for the app locale.
BedtimeStorySeed kidsPictureBook({
  required String id,
  required String title,
  required String shortTitle,
  required String summary,
  required BedtimeStoryCategory category,
  required KidsIslamicStoryCollectionType collectionType,
  required KidsIslamicStoryType storyType,
  required List<KidsBookSpread> spreads,
  required String refrain,
  required String lesson,
  required String bedtimeClosing,
  required String coverAssetPath,
  required int sortOrder,
  String prophetId = '',
  String storyFamilyId = '',
  List<KidsIslamicStoryTheme> themes = const <KidsIslamicStoryTheme>[],
  BedtimeStoryAgeGroup ageGroup = BedtimeStoryAgeGroup.kids,
  String backdropAssetPath = '',
  String? quranQuote,
  String? quranReference,
  QuranQuoteRef? quranQuoteRef,
  String? hadithQuote,
  String? hadithReference,
  KidsIslamicStorySourceCategory sourceCategory =
      KidsIslamicStorySourceCategory.quran,
  String? sourceNote,
  List<String> tags = const <String>[],
  bool isFeatured = false,
  bool bedtimeEligible = true,
  bool recommendedForTonight = false,
  List<String> relatedStoryIds = const <String>[],
  List<String> quizRefs = const <String>[],
  List<String> memoryRefs = const <String>[],
  String audioFileName = '',
  String audioManifestRef = '',
  int partNumber = 1,
  int totalParts = 1,
  KidsBookTranslation? de,
}) {
  return BedtimeStorySeed(
    id: id,
    prophetId: prophetId,
    storyFamilyId: storyFamilyId,
    title: title,
    shortTitle: shortTitle,
    category: category,
    collectionType: collectionType,
    storyType: storyType,
    themes: themes,
    ageGroup: ageGroup,
    summary: summary,
    audioFileName: audioFileName,
    audioManifestRef: audioManifestRef,
    ttsText: kidsBookReadAloudText(spreads),
    lesson: lesson,
    quranQuote: quranQuote,
    quranReference: quranReference,
    quranQuoteRef: quranQuoteRef,
    hadithQuote: hadithQuote,
    hadithReference: hadithReference,
    sourceCategory: sourceCategory,
    sourceNote: sourceNote,
    estimatedDurationSeconds: kidsBookDurationSeconds(spreads),
    isFeatured: isFeatured,
    isMultipart: totalParts > 1,
    partNumber: partNumber,
    totalParts: totalParts,
    tags: tags,
    sortOrder: sortOrder,
    coverAssetPath: coverAssetPath,
    backdropAssetPath: backdropAssetPath.isEmpty
        ? coverAssetPath
        : backdropAssetPath,
    narratorDisplayName: _bookNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: true,
    isAvailableOffline: true,
    recommendedForTonight: recommendedForTonight,
    relatedStoryIds: relatedStoryIds,
    quizRefs: quizRefs,
    memoryRefs: memoryRefs,
    bedtimeEligible: bedtimeEligible,
    routineEligible: true,
    quietReflectionFriendly: true,
    // The age band (K6) reads ageGroup; no reader looks at the older
    // suitableForYoungerLearners flag, so a book never sets it.
    sceneIllustrations: [
      for (var i = 0; i < spreads.length; i++)
        if (spreads[i].hasOwnPicture)
          BedtimeStorySceneIllustration(
            id: '$id:spread-${i + 1}',
            storyId: id,
            sortOrder: i + 1,
            title: 'Spread ${i + 1}',
            description: spreads[i].text,
            imageAssetPath: spreads[i].illustrationAsset!,
            caption: spreads[i].lines.first,
            useCase: BedtimeStoryIllustrationUseCase.inline,
          ),
    ],
    spreads: spreads,
    bedtimeClosing: bedtimeClosing,
    refrain: refrain,
    translations: {'de': ?de},
  );
}
