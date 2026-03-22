import '../domain/crossword_models.dart';

class CrosswordPlacementSeed {
  const CrosswordPlacementSeed({
    required this.entryId,
    required this.row,
    required this.col,
    required this.isAcross,
  });

  final String entryId;
  final int row;
  final int col;
  final bool isAcross;
}

class CrosswordPuzzleSeed {
  const CrosswordPuzzleSeed({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.gridSize,
    required this.tags,
    required this.placements,
    this.levelBandMin = 1,
    this.levelBandMax = 10,
    this.clueType = CrosswordClueType.direct,
    this.dailyThemes = const <String>[],
    this.isDailyEligible = false,
    this.layoutKey = 'classic',
  });

  final String id;
  final CrosswordMode mode;
  final String category;
  final int difficulty;
  final int gridSize;
  final List<String> tags;
  final List<CrosswordPlacementSeed> placements;
  final int levelBandMin;
  final int levelBandMax;
  final CrosswordClueType clueType;
  final List<String> dailyThemes;
  final bool isDailyEligible;
  final String layoutKey;
}

const crosswordContentBundle = CrosswordContentBundle(
  bundleId: 'crossword.seed.bundle',
  schemaVersion: 1,
  contentVersion: '2026.03.phase5',
  layoutVersion: '2026.03.templates.v1',
);

const kidsCrosswordPuzzleSeeds = <CrosswordPuzzleSeed>[
  CrosswordPuzzleSeed(
    id: 'kids_alif_allah',
    mode: CrosswordMode.kids,
    category: 'letters',
    difficulty: 1,
    gridSize: 5,
    tags: ['kids', 'letters', 'allah'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_alif',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_allah',
        row: 0,
        col: 0,
        isAcross: false,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_deen_dhikr',
    mode: CrosswordMode.kids,
    category: 'worship',
    difficulty: 2,
    gridSize: 5,
    tags: ['kids', 'worship', 'dhikr'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_deen',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_dhikr',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_halal_huda',
    mode: CrosswordMode.kids,
    category: 'character',
    difficulty: 2,
    gridSize: 5,
    tags: ['kids', 'halal', 'guidance'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_halal',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_huda',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_kitab_khayr',
    mode: CrosswordMode.kids,
    category: 'quran',
    difficulty: 3,
    gridSize: 5,
    tags: ['kids', 'quran', 'book'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_kitab',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_khayr',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_noon_noor',
    mode: CrosswordMode.kids,
    category: 'letters',
    difficulty: 3,
    gridSize: 4,
    tags: ['kids', 'letters', 'light'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_noon',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_noor',
        row: 0,
        col: 0,
        isAcross: false,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_qaf_quran',
    mode: CrosswordMode.kids,
    category: 'quran',
    difficulty: 3,
    gridSize: 5,
    tags: ['kids', 'quran', 'letters'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_qaf',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_quran',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_salah_sujood',
    mode: CrosswordMode.kids,
    category: 'worship',
    difficulty: 4,
    gridSize: 6,
    tags: ['kids', 'salah', 'sujood'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_salah',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_sujood',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_waw_wudu',
    mode: CrosswordMode.kids,
    category: 'worship',
    difficulty: 4,
    gridSize: 4,
    tags: ['kids', 'wudu', 'letters'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_waw',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_wudu',
        row: 1,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_ya_yaqeen',
    mode: CrosswordMode.kids,
    category: 'faith',
    difficulty: 5,
    gridSize: 6,
    tags: ['kids', 'faith', 'certainty'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_ya',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_yaqeen',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'kids_fa_fajr',
    mode: CrosswordMode.kids,
    category: 'worship',
    difficulty: 5,
    gridSize: 5,
    tags: ['kids', 'fajr', 'prayer'],
    levelBandMin: 1,
    levelBandMax: 10,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'kids_fa',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'kids_fajr',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
];

const adultCrosswordPuzzleSeeds = <CrosswordPuzzleSeed>[
  CrosswordPuzzleSeed(
    id: 'adult_prophets_adam_ayyub',
    mode: CrosswordMode.adult,
    category: 'prophets',
    difficulty: 12,
    gridSize: 5,
    tags: ['adult', 'prophets'],
    levelBandMin: 10,
    levelBandMax: 25,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['prophets'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'prophet_adam',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'prophet_ayyub',
        row: 0,
        col: 0,
        isAcross: false,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_prophets_ibrahim_isa',
    mode: CrosswordMode.adult,
    category: 'prophets',
    difficulty: 16,
    gridSize: 8,
    tags: ['adult', 'prophets', 'seerah'],
    levelBandMin: 10,
    levelBandMax: 25,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['prophets'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'prophet_ibrahim',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'prophet_isa',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_prophets_musa_muhammad',
    mode: CrosswordMode.adult,
    category: 'prophets',
    difficulty: 20,
    gridSize: 8,
    tags: ['adult', 'prophets', 'messengers'],
    levelBandMin: 10,
    levelBandMax: 25,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['prophets'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'prophet_musa',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'prophet_muhammad',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_prophets_yahya_yunus',
    mode: CrosswordMode.adult,
    category: 'prophets',
    difficulty: 24,
    gridSize: 6,
    tags: ['adult', 'prophets'],
    levelBandMin: 10,
    levelBandMax: 25,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['prophets'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'prophet_yahya',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'prophet_yunus',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_hadith_intention_sincerity',
    mode: CrosswordMode.adult,
    category: 'hadith',
    difficulty: 28,
    gridSize: 10,
    tags: ['adult', 'hadith', 'faith'],
    levelBandMin: 25,
    levelBandMax: 50,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['hadith'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'hadith_intention',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'hadith_sincerity',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_hadith_halal_ihsan',
    mode: CrosswordMode.adult,
    category: 'hadith',
    difficulty: 32,
    gridSize: 6,
    tags: ['adult', 'hadith', 'character'],
    levelBandMin: 25,
    levelBandMax: 50,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['hadith'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'hadith_halal',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'hadith_ihsan',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_quran_sabr_rahmah',
    mode: CrosswordMode.adult,
    category: 'quran',
    difficulty: 36,
    gridSize: 7,
    tags: ['adult', 'quran', 'reflection'],
    levelBandMin: 25,
    levelBandMax: 50,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['quran'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'quran_sabr',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'quran_rahmah',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_quran_salah_huda',
    mode: CrosswordMode.adult,
    category: 'worship',
    difficulty: 40,
    gridSize: 5,
    tags: ['adult', 'worship', 'quran'],
    levelBandMin: 25,
    levelBandMax: 50,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['quran', 'jummah'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'quran_salah',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'quran_huda',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_dua_rabbana_offspring',
    mode: CrosswordMode.adult,
    category: 'duas',
    difficulty: 46,
    gridSize: 9,
    tags: ['adult', 'duas', 'family'],
    levelBandMin: 25,
    levelBandMax: 50,
    clueType: CrosswordClueType.contextual,
    dailyThemes: ['duas'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'dua_rabbana',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'dua_offspring',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_mixed_dawud_salih',
    mode: CrosswordMode.adult,
    category: 'mixed',
    difficulty: 50,
    gridSize: 6,
    tags: ['adult', 'mixed', 'knowledge'],
    levelBandMin: 50,
    levelBandMax: 75,
    clueType: CrosswordClueType.conceptual,
    dailyThemes: ['mixed'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'prophet_dawud',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'prophet_salih',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_jummah_khutbah',
    mode: CrosswordMode.adult,
    category: 'worship',
    difficulty: 55,
    gridSize: 7,
    tags: ['adult', 'worship', 'jummah'],
    levelBandMin: 50,
    levelBandMax: 75,
    clueType: CrosswordClueType.conceptual,
    dailyThemes: ['jummah'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'word_jummah',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'word_khutbah',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
  CrosswordPuzzleSeed(
    id: 'adult_mixed_hira_badr',
    mode: CrosswordMode.adult,
    category: 'mixed',
    difficulty: 58,
    gridSize: 5,
    tags: ['adult', 'mixed', 'history'],
    levelBandMin: 50,
    levelBandMax: 75,
    clueType: CrosswordClueType.conceptual,
    dailyThemes: ['mixed'],
    isDailyEligible: true,
    placements: [
      CrosswordPlacementSeed(
        entryId: 'word_hira',
        row: 0,
        col: 0,
        isAcross: true,
      ),
      CrosswordPlacementSeed(
        entryId: 'word_badr',
        row: 2,
        col: 0,
        isAcross: true,
      ),
    ],
  ),
];

const crosswordLayoutTemplates = <CrosswordLayoutTemplate>[
  CrosswordLayoutTemplate(
    id: 'kids_pair_5x5',
    gridSize: 5,
    mode: CrosswordMode.kids,
    difficultyScore: 8,
    tags: ['kids', 'gentle'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 5, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 5, isAcross: true),
    ],
  ),
  CrosswordLayoutTemplate(
    id: 'kids_pair_6x6',
    gridSize: 6,
    mode: CrosswordMode.kids,
    difficultyScore: 10,
    tags: ['kids', 'extended'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 4, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 6, isAcross: true),
    ],
  ),
  CrosswordLayoutTemplate(
    id: 'adult_pair_6x6',
    gridSize: 6,
    mode: CrosswordMode.adult,
    difficultyScore: 28,
    tags: ['adult', 'steady'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 5, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 5, isAcross: true),
    ],
  ),
  CrosswordLayoutTemplate(
    id: 'adult_pair_7x7',
    gridSize: 7,
    mode: CrosswordMode.adult,
    difficultyScore: 40,
    tags: ['adult', 'reflective'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 4, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 6, isAcross: true),
    ],
  ),
  CrosswordLayoutTemplate(
    id: 'adult_pair_8x8',
    gridSize: 8,
    mode: CrosswordMode.adult,
    difficultyScore: 48,
    tags: ['adult', 'deep'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 6, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 7, isAcross: true),
    ],
  ),
  CrosswordLayoutTemplate(
    id: 'adult_pair_10x10',
    gridSize: 10,
    mode: CrosswordMode.adult,
    difficultyScore: 60,
    tags: ['adult', 'conceptual'],
    slots: [
      CrosswordSlot(row: 0, col: 0, length: 7, isAcross: true),
      CrosswordSlot(row: 2, col: 0, length: 9, isAcross: true),
    ],
  ),
];
