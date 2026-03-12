enum BabyNameGender { male, female, unisex }

enum BabyNameSort {
  alphabeticalAz,
  alphabeticalZa,
  mostPopular,
  classicFirst,
  modernFirst,
  shortestFirst,
}

enum BabyNameCategory { quranic, prophet, companions, popular, classic, modern }

class BabyNameEntry {
  const BabyNameEntry({
    required this.id,
    required this.name,
    required this.arabic,
    required this.transliteration,
    required this.gender,
    required this.meaning,
    required this.origin,
    required this.meaningThemes,
    required this.isQuranic,
    required this.associatedCategories,
    required this.startsWith,
    required this.pronunciation,
    required this.description,
    required this.quranReferences,
    required this.associatedFigures,
    required this.popularityRegions,
    required this.variants,
    required this.similarNames,
    required this.syllables,
    required this.isPopular,
    required this.styleTags,
    required this.audioPronunciation,
  });

  factory BabyNameEntry.fromJson(Map<String, dynamic> json) {
    List<String> asStringList(dynamic value) {
      if (value is! List) return const <String>[];
      return value
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    BabyNameGender parseGender(String raw) {
      switch (raw.toLowerCase()) {
        case 'male':
          return BabyNameGender.male;
        case 'female':
          return BabyNameGender.female;
        default:
          return BabyNameGender.unisex;
      }
    }

    return BabyNameEntry(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ?? '',
      gender: parseGender(json['gender']?.toString() ?? ''),
      meaning: json['meaning']?.toString() ?? '',
      origin: asStringList(json['origin']),
      meaningThemes: asStringList(json['meaningThemes']),
      isQuranic: json['isQuranic'] == true,
      associatedCategories: asStringList(json['associatedCategories']),
      startsWith: json['startsWith']?.toString() ?? '',
      pronunciation: json['pronunciation']?.toString(),
      description: json['description']?.toString(),
      quranReferences: asStringList(json['quranReferences']),
      associatedFigures: asStringList(json['associatedFigures']),
      popularityRegions: asStringList(json['popularityRegions']),
      variants: asStringList(json['variants']),
      similarNames: asStringList(json['similarNames']),
      syllables: (json['syllables'] is num)
          ? (json['syllables'] as num).toInt()
          : null,
      isPopular: json['isPopular'] == true,
      styleTags: asStringList(json['styleTags']),
      audioPronunciation: json['audioPronunciation']?.toString(),
    );
  }

  final String id;
  final String name;
  final String arabic;
  final String transliteration;
  final BabyNameGender gender;
  final String meaning;
  final List<String> origin;
  final List<String> meaningThemes;
  final bool isQuranic;
  final List<String> associatedCategories;
  final String startsWith;

  final String? pronunciation;
  final String? description;
  final List<String> quranReferences;
  final List<String> associatedFigures;
  final List<String> popularityRegions;
  final List<String> variants;
  final List<String> similarNames;
  final int? syllables;
  final bool isPopular;
  final List<String> styleTags;
  final String? audioPronunciation;

  bool get isProphetAssociated => associatedCategories.contains('prophet');
  bool get isCompanionAssociated => associatedCategories.contains('companion');

  int get popularityScore {
    var score = 0;
    if (isPopular) score += 3;
    if (associatedCategories.contains('classic')) score += 2;
    if (isQuranic) score += 2;
    if (isProphetAssociated) score += 2;
    if (isCompanionAssociated) score += 1;
    return score;
  }
}

class BabyNameFilters {
  const BabyNameFilters({
    this.gender,
    this.category,
    this.quranicOnly = false,
    this.prophetAssociationOnly = false,
    this.companionAssociationOnly = false,
    this.origin,
    this.meaningTheme,
    this.startingLetter,
    this.favoritesOnly = false,
    this.featuredOnly = false,
  });

  final BabyNameGender? gender;
  final BabyNameCategory? category;
  final bool quranicOnly;
  final bool prophetAssociationOnly;
  final bool companionAssociationOnly;
  final String? origin;
  final String? meaningTheme;
  final String? startingLetter;
  final bool favoritesOnly;
  final bool featuredOnly;

  BabyNameFilters copyWith({
    BabyNameGender? gender,
    BabyNameCategory? category,
    bool? quranicOnly,
    bool? prophetAssociationOnly,
    bool? companionAssociationOnly,
    String? origin,
    String? meaningTheme,
    String? startingLetter,
    bool? favoritesOnly,
    bool? featuredOnly,
  }) {
    return BabyNameFilters(
      gender: gender ?? this.gender,
      category: category ?? this.category,
      quranicOnly: quranicOnly ?? this.quranicOnly,
      prophetAssociationOnly:
          prophetAssociationOnly ?? this.prophetAssociationOnly,
      companionAssociationOnly:
          companionAssociationOnly ?? this.companionAssociationOnly,
      origin: origin ?? this.origin,
      meaningTheme: meaningTheme ?? this.meaningTheme,
      startingLetter: startingLetter ?? this.startingLetter,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      featuredOnly: featuredOnly ?? this.featuredOnly,
    );
  }
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

class BabyNameFinderInput {
  const BabyNameFinderInput({
    required this.fatherName,
    required this.motherName,
    required this.preferredGender,
    required this.meaningThemes,
    required this.quranicOnly,
    required this.originPreference,
  });

  final String fatherName;
  final String motherName;
  final BabyNameGender? preferredGender;
  final Set<String> meaningThemes;
  final bool quranicOnly;
  final String? originPreference;

  BabyNameFinderInput copyWith({
    String? fatherName,
    String? motherName,
    BabyNameGender? preferredGender,
    Set<String>? meaningThemes,
    bool? quranicOnly,
    String? originPreference,
  }) {
    return BabyNameFinderInput(
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      preferredGender: preferredGender ?? this.preferredGender,
      meaningThemes: meaningThemes ?? this.meaningThemes,
      quranicOnly: quranicOnly ?? this.quranicOnly,
      originPreference: originPreference ?? this.originPreference,
    );
  }
}

class BabyNameSuggestion {
  const BabyNameSuggestion({
    required this.entry,
    required this.score,
    required this.explanations,
  });

  final BabyNameEntry entry;
  final double score;
  final List<String> explanations;
}

const defaultBabyNameMeaningThemes = <String>[
  'light',
  'mercy',
  'faith',
  'guidance',
  'wisdom',
  'patience',
  'strength',
  'beauty',
  'purity',
  'hope',
  'gratitude',
  'peace',
  'generosity',
  'nobility',
  'joy',
  'protection',
  'blessing',
  'knowledge',
  'devotion',
  'kindness',
];

const defaultBabyNameOrigins = <String>[
  'Arabic',
  'Persian',
  'Turkish',
  'Urdu',
  'Hebrew',
  'Swahili',
  'Muslim global / mixed',
];
