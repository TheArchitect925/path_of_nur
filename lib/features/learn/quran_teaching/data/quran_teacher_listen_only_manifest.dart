class QuranTeacherListenOnlyPackManifestEntry {
  const QuranTeacherListenOnlyPackManifestEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.moduleId,
    required this.itemIds,
    this.coverImageAssetPath,
    this.estimatedDurationMs,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String moduleId;
  final List<String> itemIds;
  final String? coverImageAssetPath;
  final int? estimatedDurationMs;
}

const quranTeacherListenOnlyManifest =
    <String, QuranTeacherListenOnlyPackManifestEntry>{
      'alphabet_basics': QuranTeacherListenOnlyPackManifestEntry(
        id: 'alphabet_basics',
        title: 'Alphabet Basics',
        description: 'Letters for calm listening and repetition.',
        category: 'alphabet',
        moduleId: 'foundations',
        itemIds: <String>[
          'pack_alif',
          'pack_ba',
          'pack_ta',
          'pack_tha',
          'pack_jeem',
          'pack_haa',
          'pack_khaa',
          'pack_seen',
          'pack_meem',
          'pack_noon',
        ],
        coverImageAssetPath:
            'assets/images/quran_teacher/visual_mode/letters/alif_apple.webp',
        estimatedDurationMs: 45000,
      ),
      'harakat_practice': QuranTeacherListenOnlyPackManifestEntry(
        id: 'harakat_practice',
        title: 'Harakat Practice',
        description: 'Short vowels with familiar letters.',
        category: 'harakat',
        moduleId: 'foundations',
        itemIds: <String>[
          'pack_ba_fatha',
          'pack_ba_kasra',
          'pack_ba_damma',
          'pack_ta_fatha',
          'pack_ta_kasra',
          'pack_ta_damma',
          'pack_meem_fatha',
          'pack_meem_kasra',
          'pack_meem_damma',
        ],
        estimatedDurationMs: 38000,
      ),
      'first_words': QuranTeacherListenOnlyPackManifestEntry(
        id: 'first_words',
        title: 'First Words',
        description: 'Very short words for passive repetition.',
        category: 'words',
        moduleId: 'reading_basics',
        itemIds: <String>[
          'pack_word_rabb',
          'pack_word_min',
          'pack_word_fi',
          'pack_word_lahu',
          'pack_word_abd',
          'pack_word_alima',
        ],
        estimatedDurationMs: 32000,
      ),
      'common_quran_words': QuranTeacherListenOnlyPackManifestEntry(
        id: 'common_quran_words',
        title: 'Common Qur’an Words',
        description: 'A compact pack of core high-frequency words.',
        category: 'words',
        moduleId: 'recognize_words',
        itemIds: <String>[
          'pack_common_allah',
          'pack_common_rabb',
          'pack_common_rahmah',
          'pack_common_huda',
          'pack_common_nur',
          'pack_common_maa',
        ],
        estimatedDurationMs: 36000,
      ),
      'phrase_pack': QuranTeacherListenOnlyPackManifestEntry(
        id: 'phrase_pack',
        title: 'Phrase Pack',
        description: 'Short real Qur’anic phrases for calm listening.',
        category: 'phrases',
        moduleId: 'phrase_reading',
        itemIds: <String>[
          'pack_phrase_alhamdulillah',
          'pack_phrase_bismillah',
          'pack_phrase_rabbilalamin',
        ],
        estimatedDurationMs: 24000,
      ),
    };
