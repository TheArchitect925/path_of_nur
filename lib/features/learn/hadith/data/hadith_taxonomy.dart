import '../domain/hadith_foundation_models.dart';

const String hadithCategoryFaithId = 'faith';
const String hadithCategoryWorshipId = 'worship';
const String hadithCategoryCharacterId = 'character';
const String hadithCategoryFamilyId = 'family';
const String hadithCategoryKnowledgeId = 'knowledge';
const String hadithCategorySocialEthicsId = 'social_ethics';
const String hadithCategoryHereafterId = 'hereafter';

const String hadithSubcategoryIntentionSincerityId = 'intention_sincerity';
const String hadithSubcategoryPrayerPresenceId = 'prayer_presence';
const String hadithSubcategoryDuaRemembranceId = 'dua_remembrance';
const String hadithSubcategoryCharacterMannersId = 'character_manners';
const String hadithSubcategoryRepentanceReturnId = 'repentance_return';
const String hadithSubcategoryPatienceGratitudeId = 'patience_gratitude';
const String hadithSubcategoryFamilyHomeId = 'family_home';
const String hadithSubcategoryKnowledgeLearningId = 'knowledge_learning';
const String hadithSubcategoryMercyCompassionId = 'mercy_compassion';
const String hadithSubcategoryJusticeTrustId = 'justice_trust';
const String hadithSubcategoryDeathHereafterId = 'death_hereafter';

const List<HadithCategory> seededHadithCategories = <HadithCategory>[
  HadithCategory(
    id: hadithCategoryFaithId,
    title: 'Faith',
    subcategoryIds: <String>[hadithSubcategoryIntentionSincerityId],
  ),
  HadithCategory(
    id: hadithCategoryWorshipId,
    title: 'Worship',
    subcategoryIds: <String>[
      hadithSubcategoryPrayerPresenceId,
      hadithSubcategoryDuaRemembranceId,
    ],
  ),
  HadithCategory(
    id: hadithCategoryCharacterId,
    title: 'Character',
    subcategoryIds: <String>[
      hadithSubcategoryCharacterMannersId,
      hadithSubcategoryRepentanceReturnId,
      hadithSubcategoryPatienceGratitudeId,
    ],
  ),
  HadithCategory(
    id: hadithCategoryFamilyId,
    title: 'Family',
    subcategoryIds: <String>[hadithSubcategoryFamilyHomeId],
  ),
  HadithCategory(
    id: hadithCategoryKnowledgeId,
    title: 'Knowledge',
    subcategoryIds: <String>[hadithSubcategoryKnowledgeLearningId],
  ),
  HadithCategory(
    id: hadithCategorySocialEthicsId,
    title: 'Social Ethics',
    subcategoryIds: <String>[
      hadithSubcategoryMercyCompassionId,
      hadithSubcategoryJusticeTrustId,
    ],
  ),
  HadithCategory(
    id: hadithCategoryHereafterId,
    title: 'Hereafter',
    subcategoryIds: <String>[hadithSubcategoryDeathHereafterId],
  ),
];

const List<HadithSubcategory> seededHadithSubcategories = <HadithSubcategory>[
  HadithSubcategory(
    id: hadithSubcategoryIntentionSincerityId,
    categoryId: hadithCategoryFaithId,
    title: 'Intention & Sincerity',
  ),
  HadithSubcategory(
    id: hadithSubcategoryPrayerPresenceId,
    categoryId: hadithCategoryWorshipId,
    title: 'Prayer & Presence',
  ),
  HadithSubcategory(
    id: hadithSubcategoryDuaRemembranceId,
    categoryId: hadithCategoryWorshipId,
    title: 'Du\'a & Remembrance',
  ),
  HadithSubcategory(
    id: hadithSubcategoryCharacterMannersId,
    categoryId: hadithCategoryCharacterId,
    title: 'Character & Manners',
  ),
  HadithSubcategory(
    id: hadithSubcategoryRepentanceReturnId,
    categoryId: hadithCategoryCharacterId,
    title: 'Repentance & Return',
  ),
  HadithSubcategory(
    id: hadithSubcategoryPatienceGratitudeId,
    categoryId: hadithCategoryCharacterId,
    title: 'Patience & Gratitude',
  ),
  HadithSubcategory(
    id: hadithSubcategoryFamilyHomeId,
    categoryId: hadithCategoryFamilyId,
    title: 'Family & Home',
  ),
  HadithSubcategory(
    id: hadithSubcategoryKnowledgeLearningId,
    categoryId: hadithCategoryKnowledgeId,
    title: 'Knowledge & Learning',
  ),
  HadithSubcategory(
    id: hadithSubcategoryMercyCompassionId,
    categoryId: hadithCategorySocialEthicsId,
    title: 'Mercy & Compassion',
  ),
  HadithSubcategory(
    id: hadithSubcategoryJusticeTrustId,
    categoryId: hadithCategorySocialEthicsId,
    title: 'Justice & Trust',
  ),
  HadithSubcategory(
    id: hadithSubcategoryDeathHereafterId,
    categoryId: hadithCategoryHereafterId,
    title: 'Death & Hereafter',
  ),
];

const Map<String, String> _themeIdToSubcategoryId = <String, String>{
  'faith_intention': hadithSubcategoryIntentionSincerityId,
  'prayer': hadithSubcategoryPrayerPresenceId,
  'character_manners': hadithSubcategoryCharacterMannersId,
  'mercy_compassion': hadithSubcategoryMercyCompassionId,
  'knowledge': hadithSubcategoryKnowledgeLearningId,
  'dua_remembrance': hadithSubcategoryDuaRemembranceId,
  'family': hadithSubcategoryFamilyHomeId,
  'justice_trust': hadithSubcategoryJusticeTrustId,
  'repentance': hadithSubcategoryRepentanceReturnId,
  'patience_gratitude': hadithSubcategoryPatienceGratitudeId,
  'death_hereafter': hadithSubcategoryDeathHereafterId,
};

final Map<String, HadithCategory> hadithCategoryById = <String, HadithCategory>{
  for (final category in seededHadithCategories) category.id: category,
};

final Map<String, HadithSubcategory> hadithSubcategoryById =
    <String, HadithSubcategory>{
      for (final subcategory in seededHadithSubcategories)
        subcategory.id: subcategory,
    };

HadithTaxonomyAssignment? resolveHadithTaxonomyAssignment(HadithEntry entry) {
  final explicit = entry.taxonomyAssignment;
  if (explicit != null) return explicit;

  final mappedSubcategoryId = _themeIdToSubcategoryId[entry.themeId];
  if (mappedSubcategoryId == null) return null;
  final subcategory = hadithSubcategoryById[mappedSubcategoryId];
  if (subcategory == null) return null;
  final category = hadithCategoryById[subcategory.categoryId];
  if (category == null) return null;

  return HadithTaxonomyAssignment(
    categoryId: category.id,
    categoryTitle: category.title,
    subcategoryId: subcategory.id,
    subcategoryTitle: subcategory.title,
  );
}
