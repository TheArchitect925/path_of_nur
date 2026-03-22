import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../../bedtime_stories/data/bedtime_story_media_manifest.dart';
import '../../../learn/quran/domain/quran_content_refs.dart';

const List<BedtimeStorySeed> kKidsSeerahCompanionStories = [
  BedtimeStorySeed(
    id: 'story_companion_khadijah_support_v1',
    title: 'Khadijah رضي الله عنها – The First to Believe',
    shortTitle: 'Khadijah رضي الله عنها',
    prophetId: '',
    storyFamilyId: 'companion_khadijah',
    category: BedtimeStoryCategory.companions,
    collectionType: KidsIslamicStoryCollectionType.companions,
    storyType: KidsIslamicStoryType.companion,
    themes: [
      KidsIslamicStoryTheme.kindness,
      KidsIslamicStoryTheme.family,
      KidsIslamicStoryTheme.truthfulness,
    ],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary:
        'A gentle companion story about Sayyidah Khadijah رضي الله عنها supporting the Prophet ﷺ with love, wisdom, and steady faith.',
    audioFileName: 'companion_khadijah_support_v1.mp3',
    audioManifestRef: 'companion_khadijah_support_v1',
    ttsText: '''
Bismillah...

When the first words of revelation came to Prophet Muhammad ﷺ,
he felt the weight of something great.

He hurried home.

He needed comfort.

He needed someone kind.

Khadijah رضي الله عنها listened carefully.

She did not turn away.

She did not mock him.

She spoke with calm faith.

She reminded him that Allah would never abandon someone who was truthful,
kind to family,
helpful to others,
and caring for people.

Khadijah رضي الله عنها believed in him.

She stood beside him.

Her support became one of the first great lights of the Seerah.

This story teaches us that helping someone in a hard moment is a beautiful act of iman.
''',
    lesson:
        'A loving and faithful heart can bring great comfort. Khadijah رضي الله عنها teaches us to support truth with kindness.',
    sourceCategory: KidsIslamicStorySourceCategory.seerahInspired,
    sourceNote:
        'This child-friendly story is simplified from well-known Seerah reports about the first revelation and Khadijah رضي الله عنها comforting and believing in the Prophet ﷺ.',
    estimatedDurationSeconds: 80,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['companion', 'khadijah', 'seerah', 'support', 'belief'],
    sortOrder: 245,
    coverAssetPath:
        '$kidsStoryImageCoverAssetDirectory/companion_khadijah_cover.png',
    backdropAssetPath:
        '$kidsStoryImageBackdropAssetDirectory/companion_khadijah_backdrop.png',
    narratorDisplayName: 'Path of Nur Stories',
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: true,
    isAvailableOffline: true,
    recommendedForTonight: false,
    relatedStoryIds: [
      'story_prophet_muhammad_part2_bedtime_v1',
      'story_companion_abu_bakr_friendship_v1',
    ],
    bedtimeEligible: false,
    routineEligible: false,
    quietReflectionFriendly: true,
    suitableForYoungerLearners: true,
  ),
  BedtimeStorySeed(
    id: 'story_companion_abu_bakr_friendship_v1',
    title: 'Abu Bakr رضي الله عنه – A Loyal Friend on the Hijrah',
    shortTitle: 'Abu Bakr رضي الله عنه',
    prophetId: '',
    storyFamilyId: 'companion_abu_bakr',
    category: BedtimeStoryCategory.companions,
    collectionType: KidsIslamicStoryCollectionType.companions,
    storyType: KidsIslamicStoryType.companion,
    themes: [
      KidsIslamicStoryTheme.kindness,
      KidsIslamicStoryTheme.helpingOthers,
      KidsIslamicStoryTheme.truthfulness,
    ],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary:
        'A simple Seerah companion story about Abu Bakr رضي الله عنه staying close, brave, and trusting Allah during the Hijrah.',
    audioFileName: 'companion_abu_bakr_friendship_v1.mp3',
    audioManifestRef: 'companion_abu_bakr_friendship_v1',
    ttsText: '''
Bismillah...

When it was time for the Hijrah,
Prophet Muhammad ﷺ did not travel alone.

With him was his dear friend,
Abu Bakr رضي الله عنه.

Abu Bakr loved the Prophet ﷺ very much.

He wanted to help.

He wanted to protect.

He wanted to stay close on the difficult road.

When they were in the cave,
there was a tense moment.

But Allah gave calm to their hearts.

The Qur'an reminds us that the Prophet ﷺ said,
"Do not grieve. Indeed, Allah is with us."

Abu Bakr رضي الله عنه teaches us that true friendship means loyalty,
service,
and trust in Allah.
''',
    lesson:
        'A loyal friend stays close in hard times and trusts Allah. Abu Bakr رضي الله عنه teaches beautiful friendship and steady faith.',
    quranQuote:
        'Do not grieve; indeed Allah is with us.',
    quranReference: 'Qur’an 9:40',
    quranQuoteRef: QuranQuoteRef(surah: 9, ayah: 40),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    estimatedDurationSeconds: 78,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['companion', 'abu bakr', 'hijrah', 'friendship', 'seerah'],
    sortOrder: 246,
    coverAssetPath:
        '$kidsStoryImageCoverAssetDirectory/companion_abu_bakr_cover.png',
    backdropAssetPath:
        '$kidsStoryImageBackdropAssetDirectory/companion_abu_bakr_backdrop.png',
    narratorDisplayName: 'Path of Nur Stories',
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: true,
    isAvailableOffline: true,
    recommendedForTonight: false,
    relatedStoryIds: [
      'story_prophet_muhammad_part3_bedtime_v1',
      'story_companion_bilal_patience_v1',
    ],
    bedtimeEligible: false,
    routineEligible: false,
    quietReflectionFriendly: true,
    suitableForYoungerLearners: true,
  ),
  BedtimeStorySeed(
    id: 'story_companion_bilal_patience_v1',
    title: 'Bilal رضي الله عنه – Patience and Faith',
    shortTitle: 'Bilal رضي الله عنه',
    prophetId: '',
    storyFamilyId: 'companion_bilal',
    category: BedtimeStoryCategory.companions,
    collectionType: KidsIslamicStoryCollectionType.companions,
    storyType: KidsIslamicStoryType.companion,
    themes: [
      KidsIslamicStoryTheme.patience,
      KidsIslamicStoryTheme.truthfulness,
      KidsIslamicStoryTheme.kindness,
    ],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary:
        'A child-friendly companion story about Bilal رضي الله عنه holding tightly to faith with patience, courage, and hope in Allah.',
    audioFileName: 'companion_bilal_patience_v1.mp3',
    audioManifestRef: 'companion_bilal_patience_v1',
    ttsText: '''
Bismillah...

Bilal رضي الله عنه loved the truth of Islam.

He believed in Allah.

That choice was not easy.

He faced pain and hardship.

But his heart stayed firm.

He kept remembering Allah.

He kept trusting Allah.

Bilal رضي الله عنه teaches us that iman can stay strong even in difficult times.

His patience became a lesson for the whole community.

When children learn his story,
they learn that faith is precious,
and patience is beautiful.
''',
    lesson:
        'Bilal رضي الله عنه teaches us to stay firm with faith, patience, and hope in Allah even when something feels hard.',
    sourceCategory: KidsIslamicStorySourceCategory.seerahInspired,
    sourceNote:
        'This simplified child-facing story is based on authentic early Islamic accounts about Bilal رضي الله عنه and his patience in the early days of Islam.',
    estimatedDurationSeconds: 76,
    isFeatured: false,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['companion', 'bilal', 'patience', 'faith', 'seerah'],
    sortOrder: 247,
    coverAssetPath:
        '$kidsStoryImageCoverAssetDirectory/companion_bilal_cover.png',
    backdropAssetPath:
        '$kidsStoryImageBackdropAssetDirectory/companion_bilal_backdrop.png',
    narratorDisplayName: 'Path of Nur Stories',
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: true,
    isAvailableOffline: true,
    recommendedForTonight: false,
    relatedStoryIds: [
      'story_prophet_muhammad_part2_bedtime_v1',
      'story_prophet_muhammad_part4_bedtime_v1',
    ],
    bedtimeEligible: false,
    routineEligible: false,
    quietReflectionFriendly: true,
    suitableForYoungerLearners: false,
  ),
];
