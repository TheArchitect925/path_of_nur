enum BabyNameGender { boy, girl, unisex }

enum BabyNameRarity { classic, common, uncommon, rare }

enum BabyNameSort {
  alphabetical,
  popularity,
  quranicPriority,
  shortest,
  mostSaved,
}

class BabyNameRecord {
  const BabyNameRecord({
    required this.id,
    required this.english,
    required this.arabic,
    required this.transliteration,
    required this.gender,
    required this.meaning,
    required this.extendedMeaning,
    required this.origin,
    required this.rootLetters,
    required this.regions,
    required this.variants,
    required this.relatedIds,
    required this.meaningTags,
    required this.styleTags,
    required this.historicalTags,
    required this.quranicAssociations,
    required this.historicalAssociations,
    required this.reflection,
    required this.popularityScore,
    required this.isQuranic,
    required this.isCompanionName,
    required this.rarity,
    required this.easyInEnglish,
  });

  final String id;
  final String english;
  final String arabic;
  final String transliteration;
  final BabyNameGender gender;
  final String meaning;
  final String extendedMeaning;
  final String origin;
  final String? rootLetters;
  final List<String> regions;
  final List<String> variants;
  final List<String> relatedIds;
  final List<String> meaningTags;
  final List<String> styleTags;
  final List<String> historicalTags;
  final List<String> quranicAssociations;
  final List<String> historicalAssociations;
  final String reflection;
  final int popularityScore;
  final bool isQuranic;
  final bool isCompanionName;
  final BabyNameRarity rarity;
  final bool easyInEnglish;
}

class BabyNameCollection {
  const BabyNameCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.nameIds,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> nameIds;
}

class BabyNameFilters {
  const BabyNameFilters({
    this.gender,
    this.region,
    this.origin,
    this.onlyQuranic = false,
    this.onlyCompanion = false,
    this.rarity,
    this.meaningTags = const <String>{},
  });

  final BabyNameGender? gender;
  final String? region;
  final String? origin;
  final bool onlyQuranic;
  final bool onlyCompanion;
  final BabyNameRarity? rarity;
  final Set<String> meaningTags;

  BabyNameFilters copyWith({
    BabyNameGender? gender,
    String? region,
    String? origin,
    bool? onlyQuranic,
    bool? onlyCompanion,
    BabyNameRarity? rarity,
    Set<String>? meaningTags,
  }) {
    return BabyNameFilters(
      gender: gender ?? this.gender,
      region: region ?? this.region,
      origin: origin ?? this.origin,
      onlyQuranic: onlyQuranic ?? this.onlyQuranic,
      onlyCompanion: onlyCompanion ?? this.onlyCompanion,
      rarity: rarity ?? this.rarity,
      meaningTags: meaningTags ?? this.meaningTags,
    );
  }
}

class BabyNameFinderInput {
  const BabyNameFinderInput({
    required this.fatherName,
    required this.motherName,
    required this.gender,
    required this.meaningTags,
    required this.regionPreference,
    required this.firstLetter,
    required this.classicVsRare,
    required this.easyInEnglish,
  });

  final String fatherName;
  final String motherName;
  final BabyNameGender? gender;
  final Set<String> meaningTags;
  final String? regionPreference;
  final String? firstLetter;
  final String classicVsRare;
  final bool easyInEnglish;
}

class BabyNameSuggestion {
  const BabyNameSuggestion({
    required this.record,
    required this.score,
    required this.reasons,
  });

  final BabyNameRecord record;
  final double score;
  final List<String> reasons;
}
