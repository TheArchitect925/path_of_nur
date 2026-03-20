import '../domain/quran_universe_lesson.dart';
import '../domain/quran_universe_links.dart';
import '../domain/quran_universe_location.dart';
import '../domain/quran_universe_theme.dart';

const List<UniverseTheme> seededUniverseThemes = [
  UniverseTheme(
    id: 'patience',
    name: 'Patience',
    summary: 'Steadfastness under trial with trust in Allah.',
  ),
  UniverseTheme(
    id: 'gratitude',
    name: 'Gratitude',
    summary: 'Recognizing blessings and responding with worship and humility.',
  ),
  UniverseTheme(
    id: 'repentance',
    name: 'Repentance',
    summary: 'Returning to Allah sincerely after error or delay.',
  ),
  UniverseTheme(
    id: 'justice',
    name: 'Justice',
    summary: 'Upholding truth and fairness through revelation-guided conduct.',
  ),
  UniverseTheme(
    id: 'mercy',
    name: 'Mercy',
    summary: 'Compassion in guidance, leadership, and personal character.',
  ),
  UniverseTheme(
    id: 'arrogance',
    name: 'Arrogance',
    summary: 'A recurring cause of rejection when people refuse truth.',
  ),
  UniverseTheme(
    id: 'trust_allah',
    name: 'Trust in Allah',
    summary: 'Moving forward with reliance when the path is not fully visible.',
  ),
  UniverseTheme(
    id: 'tawhid',
    name: 'Tawhid',
    summary: 'The continuous prophetic call to worship Allah alone.',
  ),
];

const List<UniverseLesson> seededUniverseLessons = [
  UniverseLesson(
    id: 'forgiveness',
    title: 'Forgiveness',
    summary: 'Choosing mercy over resentment when given power or opportunity.',
    relatedGrowthHabitIds: [
      'end_day_with_reflection_and_tawbah',
      'make_dua_daily',
    ],
  ),
  UniverseLesson(
    id: 'patience_lesson',
    title: 'Patience',
    summary: 'Staying sincere and steady through long hardship.',
    relatedGrowthHabitIds: ['practice_patience', 'read_quran_daily'],
  ),
  UniverseLesson(
    id: 'courage',
    title: 'Courage',
    summary: 'Standing for truth with humility before Allah.',
    relatedGrowthHabitIds: ['study_islamic_knowledge', 'make_dua_daily'],
  ),
  UniverseLesson(
    id: 'obedience',
    title: 'Obedience',
    summary: 'Surrendering to Allah with trust and discipline.',
    relatedGrowthHabitIds: ['pray_one_sunnah_prayer', 'read_quran_daily'],
  ),
  UniverseLesson(
    id: 'trust_allah_lesson',
    title: 'Trust in Allah',
    summary: 'Reliance that stays firm before outcomes become visible.',
    relatedGrowthHabitIds: ['make_dua_daily', 'practice_patience'],
  ),
  UniverseLesson(
    id: 'repentance_lesson',
    title: 'Repentance',
    summary: 'Returning gently to Allah after slips and delays.',
    relatedGrowthHabitIds: [
      'daily_istighfar',
      'end_day_with_reflection_and_tawbah',
    ],
  ),
  UniverseLesson(
    id: 'leadership_justice',
    title: 'Leadership and Justice',
    summary: 'Authority as trust, not self-glorification.',
    relatedGrowthHabitIds: ['help_someone', 'practice_humility'],
  ),
];

const List<UniverseLocation> seededUniverseLocations = [
  UniverseLocation(
    id: 'makkah',
    name: 'Makkah',
    regionLabel: 'Arabia',
    summary: 'Center of tawhid renewal and the beginning of final revelation.',
  ),
  UniverseLocation(
    id: 'madinah',
    name: 'Madinah',
    regionLabel: 'Arabia',
    summary: 'Formation of prophetic community, justice, and social guidance.',
  ),
  UniverseLocation(
    id: 'egypt',
    name: 'Egypt',
    regionLabel: 'Nile Civilization',
    summary:
        'Major setting for Musa and Yusuf, including oppression and governance.',
  ),
  UniverseLocation(
    id: 'sinai',
    name: 'Sinai',
    regionLabel: 'Egypt / Sinai Region',
    summary: 'Revelation, covenant, and testing after liberation.',
  ),
  UniverseLocation(
    id: 'mesopotamia',
    name: 'Mesopotamia',
    regionLabel: 'Traditional / Approximate',
    summary: 'Associated with early prophetic calls including Nuh and Ibrahim.',
  ),
  UniverseLocation(
    id: 'dead_sea',
    name: 'Dead Sea Region',
    regionLabel: 'Traditional / Approximate',
    summary: 'Traditionally associated with the people of Lut.',
  ),
  UniverseLocation(
    id: 'palestine',
    name: 'Palestine / Levant',
    regionLabel: 'Traditional / Approximate',
    summary: 'Associated with many later prophets including Isa and Zakariya.',
  ),
];

const List<QuranUniverseProphetLens> seededUniverseProphetLenses = [
  QuranUniverseProphetLens(
    prophetId: 'adam',
    summary:
        'First prophet; knowledge, repentance, and beginning of human accountability.',
    relatedProphetIds: ['nuh', 'ibrahim'],
    locationIds: ['mesopotamia'],
    themeIds: ['repentance', 'tawhid'],
    lessonIds: ['repentance_lesson', 'obedience'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'nuh',
    summary: 'Long patience in da\'wah despite rejection and mockery.',
    relatedProphetIds: ['hud', 'musa'],
    locationIds: ['mesopotamia'],
    themeIds: ['patience', 'tawhid', 'arrogance'],
    lessonIds: ['patience_lesson', 'trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'hud',
    summary:
        'Warning a powerful people against arrogance and false confidence.',
    relatedProphetIds: ['salih', 'nuh'],
    locationIds: ['mesopotamia'],
    themeIds: ['arrogance', 'tawhid'],
    lessonIds: ['obedience'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'salih',
    summary: 'Clear signs rejected by proud hearts despite warning.',
    relatedProphetIds: ['hud', 'lut'],
    locationIds: ['dead_sea'],
    themeIds: ['arrogance', 'tawhid'],
    lessonIds: ['obedience', 'repentance_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'ibrahim',
    summary: 'Model of tawhid, courage, and complete surrender.',
    relatedProphetIds: ['ismail', 'ishaq', 'muhammad'],
    locationIds: ['mesopotamia', 'makkah', 'palestine'],
    themeIds: ['tawhid', 'trust_allah'],
    lessonIds: ['courage', 'obedience', 'trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'yusuf',
    summary:
        'From betrayal to authority with dignity, purity, and forgiveness.',
    relatedProphetIds: ['yaqub', 'musa'],
    locationIds: ['egypt', 'palestine'],
    themeIds: ['patience', 'mercy'],
    lessonIds: ['forgiveness', 'patience_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'musa',
    summary: 'Confronting tyranny and leading through trials by Allah\'s help.',
    relatedProphetIds: ['harun', 'ibrahim', 'muhammad'],
    locationIds: ['egypt', 'sinai'],
    themeIds: ['justice', 'trust_allah', 'patience'],
    lessonIds: ['courage', 'leadership_justice', 'trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'yunus',
    summary: 'Sincere repentance and mercy after the darkness of trial.',
    relatedProphetIds: ['nuh', 'muhammad'],
    locationIds: ['mesopotamia'],
    themeIds: ['repentance', 'mercy'],
    lessonIds: ['repentance_lesson', 'trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'zakariya',
    summary: 'Private dua and hope beyond apparent worldly limits.',
    relatedProphetIds: ['yahya', 'isa'],
    locationIds: ['palestine'],
    themeIds: ['trust_allah', 'mercy'],
    lessonIds: ['trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'yahya',
    summary: 'Purity and devotion from an early age.',
    relatedProphetIds: ['zakariya', 'isa'],
    locationIds: ['palestine'],
    themeIds: ['patience', 'mercy'],
    lessonIds: ['obedience'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'isa',
    summary: 'Miraculous signs tied to tawhid, purity, and truth.',
    relatedProphetIds: ['zakariya', 'yahya', 'muhammad'],
    locationIds: ['palestine'],
    themeIds: ['tawhid', 'mercy'],
    lessonIds: ['obedience', 'trust_allah_lesson'],
  ),
  QuranUniverseProphetLens(
    prophetId: 'muhammad',
    summary:
        'Final messenger, mercy to the worlds, and completion of guidance.',
    relatedProphetIds: ['ibrahim', 'musa', 'isa'],
    locationIds: ['makkah', 'madinah'],
    themeIds: ['mercy', 'justice', 'tawhid'],
    lessonIds: ['leadership_justice', 'patience_lesson'],
  ),
];

const List<QuranUniverseVerseLink> seededUniverseVerseLinks = [
  QuranUniverseVerseLink(
    id: 'v2_30_39',
    verseReference: 'Al-Baqarah 2:30-39',
    surahNumber: 2,
    startAyah: 30,
    endAyah: 39,
    label: 'Creation, knowledge, and repentance of Adam',
    prophetIds: ['adam'],
    themeIds: ['repentance', 'tawhid'],
    lessonIds: ['repentance_lesson', 'obedience'],
    locationIds: ['mesopotamia'],
  ),
  QuranUniverseVerseLink(
    id: 'v71_1_28',
    verseReference: 'Nuh 71:1-28',
    surahNumber: 71,
    startAyah: 1,
    endAyah: 28,
    label: 'Persistent call of Nuh to his people',
    prophetIds: ['nuh'],
    themeIds: ['patience', 'tawhid'],
    lessonIds: ['patience_lesson'],
    locationIds: ['mesopotamia'],
  ),
  QuranUniverseVerseLink(
    id: 'v11_50_60',
    verseReference: 'Hud 11:50-60',
    surahNumber: 11,
    startAyah: 50,
    endAyah: 60,
    label: 'Hud and arrogance of \u0027Ad',
    prophetIds: ['hud'],
    themeIds: ['arrogance', 'tawhid'],
    lessonIds: ['obedience'],
    locationIds: ['mesopotamia'],
  ),
  QuranUniverseVerseLink(
    id: 'v7_73_79',
    verseReference: 'Al-A\'raf 7:73-79',
    surahNumber: 7,
    startAyah: 73,
    endAyah: 79,
    label: 'Salih and the sign of the she-camel',
    prophetIds: ['salih'],
    themeIds: ['arrogance', 'tawhid'],
    lessonIds: ['repentance_lesson'],
    locationIds: ['dead_sea'],
  ),
  QuranUniverseVerseLink(
    id: 'v6_74_83',
    verseReference: 'Al-An\'am 6:74-83',
    surahNumber: 6,
    startAyah: 74,
    endAyah: 83,
    label: 'Reasoning of Ibrahim against false worship',
    prophetIds: ['ibrahim'],
    themeIds: ['tawhid', 'trust_allah'],
    lessonIds: ['courage', 'trust_allah_lesson'],
    locationIds: ['mesopotamia', 'palestine'],
  ),
  QuranUniverseVerseLink(
    id: 'v12_4_101',
    verseReference: 'Yusuf 12:4-101',
    surahNumber: 12,
    startAyah: 4,
    endAyah: 101,
    label: 'Story of Yusuf: patience, purity, and forgiveness',
    prophetIds: ['yusuf'],
    themeIds: ['patience', 'mercy'],
    lessonIds: ['forgiveness', 'patience_lesson'],
    locationIds: ['egypt', 'palestine'],
  ),
  QuranUniverseVerseLink(
    id: 'v20_9_98',
    verseReference: 'Ta-Ha 20:9-98',
    surahNumber: 20,
    startAyah: 9,
    endAyah: 98,
    label: 'Call of Musa and confrontation with Pharaoh',
    prophetIds: ['musa', 'harun'],
    themeIds: ['justice', 'trust_allah'],
    lessonIds: ['courage', 'leadership_justice'],
    locationIds: ['egypt', 'sinai'],
  ),
  QuranUniverseVerseLink(
    id: 'v21_87_88',
    verseReference: 'Al-Anbiya 21:87-88',
    surahNumber: 21,
    startAyah: 87,
    endAyah: 88,
    label: 'Supplication and rescue of Yunus',
    prophetIds: ['yunus'],
    themeIds: ['repentance', 'mercy'],
    lessonIds: ['repentance_lesson', 'trust_allah_lesson'],
    locationIds: ['mesopotamia'],
  ),
  QuranUniverseVerseLink(
    id: 'v19_2_15',
    verseReference: 'Maryam 19:2-15',
    surahNumber: 19,
    startAyah: 2,
    endAyah: 15,
    label: 'Zakariya, dua, and Yahya',
    prophetIds: ['zakariya', 'yahya'],
    themeIds: ['trust_allah', 'mercy'],
    lessonIds: ['trust_allah_lesson', 'obedience'],
    locationIds: ['palestine'],
  ),
  QuranUniverseVerseLink(
    id: 'v19_16_36',
    verseReference: 'Maryam 19:16-36',
    surahNumber: 19,
    startAyah: 16,
    endAyah: 36,
    label: 'Birth of Isa and call to worship Allah',
    prophetIds: ['isa'],
    themeIds: ['tawhid', 'mercy'],
    lessonIds: ['obedience'],
    locationIds: ['palestine'],
  ),
  QuranUniverseVerseLink(
    id: 'v33_21_40',
    verseReference: 'Al-Ahzab 33:21, 40',
    surahNumber: 33,
    startAyah: 21,
    endAyah: 40,
    label: 'Muhammad \uFDFA as model and seal of prophets',
    prophetIds: ['muhammad'],
    themeIds: ['mercy', 'tawhid', 'justice'],
    lessonIds: ['leadership_justice', 'patience_lesson'],
    locationIds: ['makkah', 'madinah'],
  ),
  QuranUniverseVerseLink(
    id: 'v21_107',
    verseReference: 'Al-Anbiya 21:107',
    surahNumber: 21,
    startAyah: 107,
    endAyah: 107,
    label: 'Mercy to the worlds',
    prophetIds: ['muhammad'],
    themeIds: ['mercy'],
    lessonIds: ['leadership_justice'],
    locationIds: ['makkah', 'madinah'],
  ),
];

class _UniverseHadithSeed {
  const _UniverseHadithSeed({
    required this.id,
    required this.title,
    required this.reference,
    required this.summary,
    this.themeIds = const <String>[],
    this.conceptIds = const <String>[],
  });

  final String id;
  final String title;
  final String reference;
  final String summary;
  final List<String> themeIds;
  final List<String> conceptIds;
}

const List<_UniverseHadithSeed> _seededUniverseHadithSeeds = [
  _UniverseHadithSeed(
    id: 'intentions_core',
    title: 'Actions Are by Intentions',
    reference: 'Sahih al-Bukhari 1',
    summary: 'Intentions shape the spiritual value of deeds.',
    themeIds: ['tawhid'],
    conceptIds: ['obedience'],
  ),
  _UniverseHadithSeed(
    id: 'islam_built_on_five_prayer',
    title: 'Islam Is Built on Five',
    reference: 'Sahih al-Bukhari / Sahih Muslim',
    summary: 'Salah stands at the foundation of Muslim practice.',
    themeIds: ['tawhid'],
    conceptIds: ['obedience'],
  ),
  _UniverseHadithSeed(
    id: 'truthfulness_to_righteousness',
    title: 'Truthfulness Leads to Righteousness',
    reference: 'Sahih al-Bukhari / Sahih Muslim',
    summary: 'Truthful speech forms upright character and trust.',
    themeIds: ['justice'],
    conceptIds: ['leadership_justice'],
  ),
  _UniverseHadithSeed(
    id: 'repentance_joy',
    title: 'Allah Rejoices at Repentance',
    reference: 'Sahih Muslim',
    summary: 'Return to Allah is always met with mercy.',
    themeIds: ['repentance', 'mercy'],
    conceptIds: ['repentance_lesson'],
  ),
  _UniverseHadithSeed(
    id: 'seek_knowledge',
    title: 'Whoever Travels a Path Seeking Knowledge',
    reference: 'Sahih Muslim',
    summary: 'Beneficial learning is a path of closeness to Allah.',
    themeIds: ['tawhid'],
    conceptIds: ['trust_allah_lesson'],
  ),
  _UniverseHadithSeed(
    id: 'patience_gratitude_balance',
    title: 'Wonderful Is the Affair of the Believer',
    reference: 'Sahih Muslim',
    summary:
        'The believer responds with patience in hardship and gratitude in ease.',
    themeIds: ['patience', 'gratitude'],
    conceptIds: ['patience_lesson'],
  ),
];

String _quranNodeId(String id) => 'quran:$id';
String _prophetNodeId(String id) => 'prophet:$id';
String _themeNodeId(String id) => 'theme:$id';
String _hadithNodeId(String id) => 'hadith:$id';
String _conceptNodeId(String id) => 'concept:$id';

String _readableId(String id) {
  final words = id.split('_');
  return words
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

List<String> _dedupeConnections(Iterable<String> values) {
  final seen = <String>{};
  final result = <String>[];
  for (final value in values) {
    if (value.isEmpty || seen.contains(value)) continue;
    seen.add(value);
    result.add(value);
  }
  return result;
}

final List<QuranUniverseNode> seededUniverseNodes = [
  ...seededUniverseVerseLinks.map((link) {
    return QuranUniverseNode(
      id: _quranNodeId(link.id),
      type: QuranUniverseNodeType.quran,
      title: link.verseReference,
      reference:
          '${link.surahNumber}:${link.startAyah ?? ''}${link.endAyah != null ? '-${link.endAyah}' : ''}',
      summary: link.label ?? 'Related Qur’an passage',
      connections: _dedupeConnections([
        ...link.prophetIds.map(_prophetNodeId),
        ...link.themeIds.map(_themeNodeId),
        ...link.lessonIds.map(_conceptNodeId),
        ...link.locationIds.map(_conceptNodeId),
      ]),
    );
  }),
  ...seededUniverseProphetLenses.map((lens) {
    final connectedVerses = seededUniverseVerseLinks
        .where((link) => link.prophetIds.contains(lens.prophetId))
        .map((link) => _quranNodeId(link.id));
    return QuranUniverseNode(
      id: _prophetNodeId(lens.prophetId),
      type: QuranUniverseNodeType.prophet,
      title: _readableId(lens.prophetId),
      reference: 'Prophet',
      summary: lens.summary,
      connections: _dedupeConnections([
        ...connectedVerses,
        ...lens.relatedProphetIds.map(_prophetNodeId),
        ...lens.themeIds.map(_themeNodeId),
        ...lens.lessonIds.map(_conceptNodeId),
        ...lens.locationIds.map(_conceptNodeId),
      ]),
    );
  }),
  ...seededUniverseThemes.map((theme) {
    final connectedVerses = seededUniverseVerseLinks
        .where((link) => link.themeIds.contains(theme.id))
        .map((link) => _quranNodeId(link.id));
    final connectedProphets = seededUniverseProphetLenses
        .where((lens) => lens.themeIds.contains(theme.id))
        .map((lens) => _prophetNodeId(lens.prophetId));
    final connectedConcepts = seededUniverseLessons
        .where(
          (lesson) => seededUniverseVerseLinks.any((link) {
            return link.themeIds.contains(theme.id) &&
                link.lessonIds.contains(lesson.id);
          }),
        )
        .map((lesson) => _conceptNodeId(lesson.id));
    return QuranUniverseNode(
      id: _themeNodeId(theme.id),
      type: QuranUniverseNodeType.theme,
      title: theme.name,
      reference: 'Theme',
      summary: theme.summary,
      connections: _dedupeConnections([
        ...connectedVerses,
        ...connectedProphets,
        ...connectedConcepts,
      ]),
    );
  }),
  ...seededUniverseLessons.map((lesson) {
    final connectedVerses = seededUniverseVerseLinks
        .where((link) => link.lessonIds.contains(lesson.id))
        .map((link) => _quranNodeId(link.id));
    return QuranUniverseNode(
      id: _conceptNodeId(lesson.id),
      type: QuranUniverseNodeType.concept,
      title: lesson.title,
      reference: 'Lesson',
      summary: lesson.summary,
      connections: _dedupeConnections([
        ...connectedVerses,
        ...seededUniverseVerseLinks
            .where((link) => link.lessonIds.contains(lesson.id))
            .expand((link) => link.prophetIds)
            .map(_prophetNodeId),
        ...seededUniverseVerseLinks
            .where((link) => link.lessonIds.contains(lesson.id))
            .expand((link) => link.themeIds)
            .map(_themeNodeId),
        ...seededUniverseVerseLinks
            .where((link) => link.lessonIds.contains(lesson.id))
            .expand((link) => link.locationIds)
            .map(_conceptNodeId),
      ]),
    );
  }),
  ...seededUniverseLocations.map((location) {
    final connectedVerses = seededUniverseVerseLinks
        .where((link) => link.locationIds.contains(location.id))
        .map((link) => _quranNodeId(link.id));
    return QuranUniverseNode(
      id: _conceptNodeId(location.id),
      type: QuranUniverseNodeType.concept,
      title: location.name,
      reference: location.regionLabel,
      summary: location.summary,
      connections: _dedupeConnections([
        ...connectedVerses,
        ...seededUniverseVerseLinks
            .where((link) => link.locationIds.contains(location.id))
            .expand((link) => link.prophetIds)
            .map(_prophetNodeId),
        ...seededUniverseVerseLinks
            .where((link) => link.locationIds.contains(location.id))
            .expand((link) => link.themeIds)
            .map(_themeNodeId),
      ]),
    );
  }),
  ..._seededUniverseHadithSeeds.map((hadith) {
    final versesForTheme = seededUniverseVerseLinks
        .where((link) => link.themeIds.any(hadith.themeIds.contains))
        .map((link) => _quranNodeId(link.id));
    return QuranUniverseNode(
      id: _hadithNodeId(hadith.id),
      type: QuranUniverseNodeType.hadith,
      title: hadith.title,
      reference: hadith.reference,
      summary: hadith.summary,
      connections: _dedupeConnections([
        ...hadith.themeIds.map(_themeNodeId),
        ...hadith.conceptIds.map(_conceptNodeId),
        ...versesForTheme,
      ]),
    );
  }),
];
