import '../../../learn/quran/domain/quran_content_refs.dart';
import '../domain/bedtime_story_illustration_models.dart';
import '../domain/bedtime_story_models.dart';
import 'kids_story_scene_plans.dart';

const _generalNarratorDisplayName = 'Path of Nur Kids Story Narration';

BedtimeStorySceneIllustration _scene({
  required String id,
  required String storyId,
  required int sortOrder,
  required String title,
  required String description,
  required String imageName,
  required String caption,
}) {
  return BedtimeStorySceneIllustration(
    id: id,
    storyId: storyId,
    sortOrder: sortOrder,
    title: title,
    description: description,
    imageAssetPath: 'assets/images/kids_stories/scenes/$imageName',
    caption: caption,
    useCase: BedtimeStoryIllustrationUseCase.inline,
  );
}

final List<BedtimeStorySeed> kKidsIslamicStories = [
  BedtimeStorySeed(
    id: 'story_bismillah_before_eating_v1',
    storyFamilyId: 'bismillah_before_eating',
    title: 'Bismillah Before Eating',
    shortTitle: 'Bismillah Before Eating',
    category: BedtimeStoryCategory.dailyLifeDuas,
    collectionType: KidsIslamicStoryCollectionType.dailyLifeDuas,
    storyType: KidsIslamicStoryType.duaLesson,
    themes: [KidsIslamicStoryTheme.dua, KidsIslamicStoryTheme.manners],
    ageGroup: BedtimeStoryAgeGroup.kidsEarly,
    summary: 'A gentle story about remembering Allah before a meal.',
    audioFileName: 'bismillah_before_eating_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:bismillah_before_eating',
    ttsText: '''
Bismillah...

Safa sat at the table with warm soup and soft bread.

She was hungry.

Her little hand reached forward quickly.

Then she stopped.

She smiled and whispered,
"Bismillah."

Her mother smiled too.

"When we begin with Allah's name," she said,
"our hearts remember Who gave us our food."

Safa took a careful bite.

She ate slowly.

She shared a piece of bread with her younger brother.

At the end, she said,
"Alhamdulillah."

Her meal felt warm,
peaceful,
and full of blessing.
''',
    lesson:
        'We begin with Allah’s name before eating and thank Him after we finish.',
    hadithQuote:
        'O young boy, mention Allah’s name, eat with your right hand, and eat from what is near you.',
    hadithReference: 'Sahih al-Bukhari 5376; Sahih Muslim 2022',
    sourceCategory: KidsIslamicStorySourceCategory.hadith,
    sourceNote:
        'A child-friendly manners story inspired by authentic teachings about eating with adab.',
    estimatedDurationSeconds: 58,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['bismillah', 'eating', 'dua', 'daily life', 'manners'],
    sortOrder: 210,
    coverAssetPath:
        'assets/images/kids_stories/covers/bismillah_before_eating_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/bismillah_before_eating_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: false,
    bedtimeEligible: false,
    routineEligible: true,
    relatedStoryIds: ['story_sharing_with_others_v1'],
    quizRefs: ['quiz_story_bismillah_before_eating_v1'],
    memoryRefs: ['memory_story_bismillah_before_eating_v1'],
    sceneIllustrations: [
      _scene(
        id: 'scene_bismillah_before_eating_1',
        storyId: 'story_bismillah_before_eating_v1',
        sortOrder: 1,
        title: 'A hungry moment',
        description: 'Safa is ready to eat and remembers to pause first.',
        imageName: 'bismillah_before_eating_scene_1.webp',
        caption: 'She pauses before taking her first bite.',
      ),
      _scene(
        id: 'scene_bismillah_before_eating_2',
        storyId: 'story_bismillah_before_eating_v1',
        sortOrder: 2,
        title: 'A blessed meal',
        description: 'The meal becomes gentle and thankful.',
        imageName: 'bismillah_before_eating_scene_2.webp',
        caption: 'Remembering Allah brings barakah to simple moments.',
      ),
    ],
  ),
  BedtimeStorySeed(
    id: 'story_sharing_with_others_v1',
    sceneIllustrations: kidsStoryScenes('story_sharing_with_others_v1'),
    storyFamilyId: 'sharing_with_others',
    title: 'Sharing With Others',
    shortTitle: 'Sharing With Others',
    category: BedtimeStoryCategory.familyKindness,
    collectionType: KidsIslamicStoryCollectionType.familyKindness,
    storyType: KidsIslamicStoryType.kindness,
    themes: [KidsIslamicStoryTheme.sharing, KidsIslamicStoryTheme.kindness],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A warm story about sharing something loved with a friend.',
    audioFileName: 'sharing_with_others_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:sharing_with_others',
    ttsText: '''
Yusuf had two dates left in his small lunch box.

He wanted both.

Then he saw his friend Harun.

Harun had forgotten his snack.

Yusuf looked at the dates.

He looked at his friend.

Then he broke his smile wide
and placed one date in Harun’s hand.

"We can share," he said.

Harun smiled back.

The date was small.

But the kindness felt big.

Both boys said,
"Alhamdulillah."
''',
    lesson: 'Sharing for the sake of Allah fills small moments with kindness.',
    quranQuote:
        'They give others preference over themselves, even when they are in need.',
    quranReference: 'Qur’an 59:9',
    quranQuoteRef: QuranQuoteRef(surah: 59, ayah: 9),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    sourceNote:
        'A child-friendly sharing story inspired by the Qur’anic value of preferring others with generosity.',
    estimatedDurationSeconds: 52,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['sharing', 'kindness', 'friends', 'generosity'],
    sortOrder: 220,
    coverAssetPath:
        'assets/images/kids_stories/covers/sharing_with_others_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/sharing_with_others_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    quietReflectionFriendly: true,
    suitableForYoungerLearners: true,
    relatedStoryIds: ['story_helping_parents_v1', 'story_telling_the_truth_v1'],
    quizRefs: ['quiz_story_sharing_with_others_v1'],
    memoryRefs: ['memory_story_sharing_with_others_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_telling_the_truth_v1',
    sceneIllustrations: kidsStoryScenes('story_telling_the_truth_v1'),
    storyFamilyId: 'telling_the_truth',
    title: 'Telling the Truth',
    shortTitle: 'Telling the Truth',
    category: BedtimeStoryCategory.characterAdab,
    collectionType: KidsIslamicStoryCollectionType.characterAdab,
    storyType: KidsIslamicStoryType.honesty,
    themes: [KidsIslamicStoryTheme.honesty, KidsIslamicStoryTheme.truthfulness],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A child learns that truth brings peace, even after a mistake.',
    audioFileName: 'telling_the_truth_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:telling_the_truth',
    ttsText: '''
Maryam knocked over the blue cup.

Water slipped across the table.

For one quiet moment,
she thought about saying,
"I did not do it."

But her heart felt heavy.

She took a breath.

"Mama," she said softly,
"I spilled the water."

Her mother came close.

Together they wiped the table clean.

"Thank you for telling the truth," Mama said.

Maryam felt light again.
''',
    lesson:
        'Truthfulness brings peace to the heart, even when we have made a mistake.',
    quranQuote:
        'O you who believe, fear Allah and be with those who are truthful.',
    quranReference: 'Qur’an 9:119',
    quranQuoteRef: QuranQuoteRef(surah: 9, ayah: 119),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    sourceNote:
        'A child-friendly honesty story anchored in the Qur’anic command to stay with truthfulness.',
    estimatedDurationSeconds: 54,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['truth', 'honesty', 'mistake', 'adab'],
    sortOrder: 230,
    coverAssetPath:
        'assets/images/kids_stories/covers/telling_the_truth_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/telling_the_truth_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    relatedStoryIds: ['story_saying_sorry_and_forgiving_v1'],
    quizRefs: ['quiz_story_telling_the_truth_v1'],
    memoryRefs: ['memory_story_telling_the_truth_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_helping_parents_v1',
    sceneIllustrations: kidsStoryScenes('story_helping_parents_v1'),
    storyFamilyId: 'helping_parents',
    title: 'Helping Parents',
    shortTitle: 'Helping Parents',
    category: BedtimeStoryCategory.familyKindness,
    collectionType: KidsIslamicStoryCollectionType.familyKindness,
    storyType: KidsIslamicStoryType.family,
    themes: [KidsIslamicStoryTheme.family, KidsIslamicStoryTheme.helpingOthers],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A small act of service becomes a way to earn Allah’s pleasure.',
    audioFileName: 'helping_parents_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:helping_parents',
    ttsText: '''
Layth heard the grocery bags at the door.

His father looked tired.

His mother was carrying fruit.

Layth hurried over.

"I can help," he said.

He carried the light bag carefully.

Then he brought water for his mother.

No one told him to do it.

He just wanted to help.

His parents smiled.

Layth felt happy,
because kindness begins at home.
''',
    lesson:
        'Helping our parents with kindness is a beautiful act beloved to Allah.',
    quranQuote: 'And lower to them the wing of humility out of mercy.',
    quranReference: 'Qur’an 17:24',
    quranQuoteRef: QuranQuoteRef(surah: 17, ayah: 24),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    estimatedDurationSeconds: 53,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['parents', 'helping', 'family', 'kindness'],
    sortOrder: 240,
    coverAssetPath:
        'assets/images/kids_stories/covers/helping_parents_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/helping_parents_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    quietReflectionFriendly: true,
    suitableForYoungerLearners: true,
    relatedStoryIds: ['story_sharing_with_others_v1'],
    quizRefs: ['quiz_story_helping_parents_v1'],
    memoryRefs: ['memory_story_helping_parents_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_kindness_to_animals_v1',
    sceneIllustrations: kidsStoryScenes('story_kindness_to_animals_v1'),
    storyFamilyId: 'kindness_to_animals',
    title: 'Kindness to Animals',
    shortTitle: 'Kindness to Animals',
    category: BedtimeStoryCategory.familyKindness,
    collectionType: KidsIslamicStoryCollectionType.familyKindness,
    storyType: KidsIslamicStoryType.animals,
    themes: [
      KidsIslamicStoryTheme.compassionForAnimals,
      KidsIslamicStoryTheme.kindness,
    ],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A child notices a thirsty kitten and learns mercy.',
    audioFileName: 'kindness_to_animals_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:kindness_to_animals',
    ttsText: '''
A kitten sat near the garden wall.

Its tiny voice was soft.

Huda noticed the empty bowl nearby.

She ran to fill it with water.

Then she placed it down gently.

The kitten drank.

Its little tail lifted happily.

Huda smiled.

Her grandmother said,
"Allah loves mercy."

Huda looked at the kitten again
and thanked Allah for letting her be kind.
''',
    lesson: 'Mercy toward animals is part of a soft and faithful Muslim heart.',
    hadithQuote:
        'A person was forgiven because he gave water to a thirsty dog.',
    hadithReference: 'Sahih al-Bukhari 2363; Sahih Muslim 2244',
    sourceCategory: KidsIslamicStorySourceCategory.hadith,
    estimatedDurationSeconds: 55,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['animals', 'mercy', 'kindness', 'care'],
    sortOrder: 250,
    coverAssetPath:
        'assets/images/kids_stories/covers/kindness_to_animals_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/kindness_to_animals_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    quietReflectionFriendly: true,
    relatedStoryIds: ['story_sharing_with_others_v1'],
    quizRefs: ['quiz_story_kindness_to_animals_v1'],
    memoryRefs: ['memory_story_kindness_to_animals_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_masjid_manners_v1',
    sceneIllustrations: kidsStoryScenes('story_masjid_manners_v1'),
    storyFamilyId: 'masjid_manners',
    title: 'Good Manners in the Masjid',
    shortTitle: 'Masjid Manners',
    category: BedtimeStoryCategory.dailyLifeDuas,
    collectionType: KidsIslamicStoryCollectionType.dailyLifeDuas,
    storyType: KidsIslamicStoryType.masjid,
    themes: [KidsIslamicStoryTheme.masjid, KidsIslamicStoryTheme.manners],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A calm visit to the masjid teaches quiet steps and respect.',
    audioFileName: 'masjid_manners_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:masjid_manners',
    ttsText: '''
Hasan held his father’s hand at the masjid door.

He took off his shoes neatly.

Inside, he used a quiet voice.

He walked gently.

He made room for others.

When he saw someone reading Qur'an,
he sat peacefully nearby.

The masjid felt calm,
clean,
and full of remembrance.

Hasan learned that respect can be soft and beautiful.
''',
    lesson: 'The masjid is a place of peace, respect, and remembrance.',
    sourceCategory: KidsIslamicStorySourceCategory.islamicManners,
    sourceNote:
        'A child-friendly adab story about calm and respectful behavior in the masjid.',
    estimatedDurationSeconds: 51,
    isFeatured: false,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['masjid', 'manners', 'respect', 'quiet'],
    sortOrder: 260,
    coverAssetPath:
        'assets/images/kids_stories/covers/masjid_manners_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/masjid_manners_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: false,
    bedtimeEligible: false,
    routineEligible: false,
    relatedStoryIds: ['story_bismillah_before_eating_v1'],
    quizRefs: ['quiz_story_masjid_manners_v1'],
    memoryRefs: ['memory_story_masjid_manners_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_ramadan_kindness_v1',
    sceneIllustrations: kidsStoryScenes('story_ramadan_kindness_v1'),
    storyFamilyId: 'ramadan_kindness',
    title: 'A Ramadan Kindness Story',
    shortTitle: 'Ramadan Kindness',
    category: BedtimeStoryCategory.ramadanEid,
    collectionType: KidsIslamicStoryCollectionType.ramadanEid,
    storyType: KidsIslamicStoryType.ramadan,
    themes: [KidsIslamicStoryTheme.ramadan, KidsIslamicStoryTheme.kindness],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'Children prepare dates and water for others at iftar.',
    audioFileName: 'ramadan_kindness_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:ramadan_kindness',
    ttsText: '''
The sky was turning gold.

Iftar was almost here.

Zaynab and her brother placed dates on small plates.

They poured water into cups.

"These are for our neighbors," Mama said.

The children smiled.

They carried the tray carefully.

At the door, everyone said,
"JazakAllahu khayran."

The evening felt bright with kindness.

Ramadan was not only about hunger.

It was also about giving.
''',
    lesson:
        'Ramadan teaches us to care for others with generosity and soft hearts.',
    quranQuote:
        'O you who believe, fasting has been prescribed for you as it was prescribed for those before you so that you may become mindful of Allah.',
    quranReference: 'Qur’an 2:183',
    quranQuoteRef: QuranQuoteRef(surah: 2, ayah: 183),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    estimatedDurationSeconds: 59,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['ramadan', 'kindness', 'iftar', 'giving'],
    sortOrder: 270,
    coverAssetPath:
        'assets/images/kids_stories/covers/ramadan_kindness_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/ramadan_kindness_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: true,
    relatedStoryIds: ['story_eid_gratitude_v1'],
    quizRefs: ['quiz_story_ramadan_kindness_v1'],
    memoryRefs: ['memory_story_ramadan_kindness_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_eid_gratitude_v1',
    sceneIllustrations: kidsStoryScenes('story_eid_gratitude_v1'),
    storyFamilyId: 'eid_gratitude',
    title: 'An Eid Gratitude Story',
    shortTitle: 'Eid Gratitude',
    category: BedtimeStoryCategory.ramadanEid,
    collectionType: KidsIslamicStoryCollectionType.ramadanEid,
    storyType: KidsIslamicStoryType.eid,
    themes: [KidsIslamicStoryTheme.eid, KidsIslamicStoryTheme.gratitude],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'A joyful Eid morning becomes a moment of thankful remembrance.',
    audioFileName: 'eid_gratitude_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:eid_gratitude',
    ttsText: '''
The home was bright on Eid morning.

New clothes were ready.

Sweet smells filled the kitchen.

Bilal laughed and ran to the window.

Then his grandmother called softly,
"Before the fun, remember Who gave this day."

Bilal stood still.

He looked around the room.

"Alhamdulillah," he said.

The joy stayed,
but now it felt fuller,
because gratitude was inside it.
''',
    lesson:
        'Eid joy becomes more beautiful when it is filled with gratitude to Allah.',
    quranQuote: 'If you are grateful, I will surely give you more.',
    quranReference: 'Qur’an 14:7',
    quranQuoteRef: QuranQuoteRef(surah: 14, ayah: 7),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    estimatedDurationSeconds: 53,
    isFeatured: false,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['eid', 'gratitude', 'celebration', 'thankfulness'],
    sortOrder: 280,
    coverAssetPath:
        'assets/images/kids_stories/covers/eid_gratitude_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/eid_gratitude_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    quietReflectionFriendly: true,
    relatedStoryIds: ['story_ramadan_kindness_v1'],
    quizRefs: ['quiz_story_eid_gratitude_v1'],
    memoryRefs: ['memory_story_eid_gratitude_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_patience_v1',
    sceneIllustrations: kidsStoryScenes('story_patience_v1'),
    storyFamilyId: 'patience_story',
    title: 'A Story About Patience',
    shortTitle: 'Patience',
    category: BedtimeStoryCategory.characterAdab,
    collectionType: KidsIslamicStoryCollectionType.characterAdab,
    storyType: KidsIslamicStoryType.patience,
    themes: [KidsIslamicStoryTheme.patience],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'Waiting calmly becomes a lesson in strength.',
    audioFileName: 'patience_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:patience',
    ttsText: '''
Mina planted a seed in a cup of soil.

The next morning,
she looked for a flower.

Nothing yet.

The day after,
still nothing.

Her grandfather smiled.

"Some good things need patient hearts," he said.

Mina kept watering the soil.

One quiet morning,
a little green shoot appeared.

Mina clapped gently.

Patience had been growing in her too.
''',
    lesson:
        'Patience means trusting Allah while we wait for good things to grow.',
    quranQuote: 'Indeed, Allah is with the patient.',
    quranReference: 'Qur’an 2:153',
    quranQuoteRef: QuranQuoteRef(surah: 2, ayah: 153),
    sourceCategory: KidsIslamicStorySourceCategory.quran,
    estimatedDurationSeconds: 57,
    isFeatured: false,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['patience', 'waiting', 'growth', 'trust'],
    sortOrder: 290,
    coverAssetPath: 'assets/images/kids_stories/covers/patience_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/patience_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    relatedStoryIds: ['story_saying_sorry_and_forgiving_v1'],
    quizRefs: ['quiz_story_patience_v1'],
    memoryRefs: ['memory_story_patience_v1'],
  ),
  BedtimeStorySeed(
    id: 'story_saying_sorry_and_forgiving_v1',
    sceneIllustrations: kidsStoryScenes('story_saying_sorry_and_forgiving_v1'),
    storyFamilyId: 'saying_sorry_and_forgiving',
    title: 'Saying Sorry and Forgiving',
    shortTitle: 'Sorry and Forgiving',
    category: BedtimeStoryCategory.characterAdab,
    collectionType: KidsIslamicStoryCollectionType.characterAdab,
    storyType: KidsIslamicStoryType.forgiveness,
    themes: [KidsIslamicStoryTheme.forgiveness, KidsIslamicStoryTheme.kindness],
    ageGroup: BedtimeStoryAgeGroup.kids,
    summary: 'Two children mend a hurt moment with honesty and mercy.',
    audioFileName: 'saying_sorry_and_forgiving_kids_story_en_v1.mp3',
    audioManifestRef: 'kids_story:saying_sorry_and_forgiving',
    ttsText: '''
Hamza bumped into his sister’s tower of blocks.

It fell all at once.

His sister looked sad.

Hamza wanted to walk away.

But he remembered something better.

"I am sorry," he said.

He began picking up the blocks.

His sister watched him.

Then she smiled and said,
"I forgive you."

Together they built again.

The room felt peaceful once more.
''',
    lesson:
        'Saying sorry and forgiving each other brings hearts back together.',
    sourceCategory: KidsIslamicStorySourceCategory.islamicManners,
    sourceNote:
        'A simple child-friendly manners story about apology, mercy, and making things right.',
    estimatedDurationSeconds: 54,
    isFeatured: true,
    isMultipart: false,
    partNumber: 1,
    totalParts: 1,
    tags: ['sorry', 'forgiveness', 'siblings', 'mercy'],
    sortOrder: 300,
    coverAssetPath:
        'assets/images/kids_stories/covers/saying_sorry_and_forgiving_cover.webp',
    backdropAssetPath:
        'assets/images/kids_stories/backdrops/saying_sorry_and_forgiving_backdrop.webp',
    narratorDisplayName: _generalNarratorDisplayName,
    isLocked: false,
    unlockXp: 0,
    oceanDropsReward: 1,
    xpReward: 5,
    isDownloadedByDefault: false,
    isAvailableOffline: false,
    recommendedForTonight: true,
    bedtimeEligible: true,
    routineEligible: false,
    quietReflectionFriendly: true,
    relatedStoryIds: ['story_telling_the_truth_v1', 'story_patience_v1'],
    quizRefs: ['quiz_story_saying_sorry_and_forgiving_v1'],
    memoryRefs: ['memory_story_saying_sorry_and_forgiving_v1'],
  ),
];
