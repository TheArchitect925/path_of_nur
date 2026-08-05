import '../domain/quran_surah_summary_models.dart';
import '../domain/quran_theme_discovery_models.dart';

const List<QuranThemeDefinition> quranThemeRegistry = <QuranThemeDefinition>[
  QuranThemeDefinition(
    id: 'tawhid',
    title: 'Tawhid',
    subtitle:
        'Explore surahs that center Allah\'s oneness, majesty, and sole right to worship.',
    overview:
        'This theme gathers surahs and passages that call the heart back to Allah alone, reject partners beside Him, and deepen clarity about worship, dependence, and trust.',
    category: QuranThemeCategory.beliefCore,
    sortOrder: 10,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.tawhid],
    searchAliases: <String>['oneness', 'belief', 'shirk'],
  ),
  QuranThemeDefinition(
    id: 'guidance',
    title: 'Guidance',
    subtitle:
        'Find surahs that teach the straight path through revelation, obedience, and sincerity.',
    overview:
        'Guidance in the Quran is not only information. It is light, direction, and help from Allah for hearts that seek Him with humility.',
    category: QuranThemeCategory.beliefCore,
    sortOrder: 20,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.guidance],
    searchAliases: <String>['hidayah', 'straight path'],
    reflectionPrompt:
        'Where do I most need Allah\'s guidance in a decision or habit right now?',
  ),
  QuranThemeDefinition(
    id: 'mercy',
    title: 'Mercy',
    subtitle:
        'Study mercy through forgiveness, gentleness, compassion, and hopeful return to Allah.',
    overview:
        'The Quran repeatedly opens doors of hope. This theme follows Allah\'s mercy as it appears in repentance, gentleness, rescue, and care for the vulnerable.',
    category: QuranThemeCategory.beliefCore,
    sortOrder: 30,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.mercy],
    searchAliases: <String>['rahmah', 'compassion', 'hope'],
    reflectionPrompt:
        'How can I reflect Allah\'s mercy more clearly in the way I speak and respond today?',
  ),
  QuranThemeDefinition(
    id: 'revelation',
    title: 'Revelation',
    subtitle:
        'Follow how the Quran describes itself as guidance, reminder, and protected truth.',
    overview:
        'This theme gathers surahs that highlight the Quran as clear revelation, a source of certainty, and a living message that guides hearts and communities.',
    category: QuranThemeCategory.beliefCore,
    sortOrder: 40,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.revelation],
    searchAliases: <String>['wahy', 'quran'],
  ),
  QuranThemeDefinition(
    id: 'prophets',
    title: 'Prophets',
    subtitle:
        'Explore how prophetic stories teach patience, truthfulness, calling to Allah, and steadfastness.',
    overview:
        'The prophets are not mentioned as distant figures only. Their lives teach da\'wah, patience, courage, repentance, gratitude, and trust in Allah.',
    category: QuranThemeCategory.storiesAndProphets,
    sortOrder: 50,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.prophethood],
    searchAliases: <String>['messengers', 'stories'],
  ),
  QuranThemeDefinition(
    id: 'musa',
    title: 'Musa',
    subtitle:
        'Trace the repeated lessons of Musa through mission, fear, courage, prayer, and divine support.',
    overview:
        'The story of Musa appears across many surahs. It teaches the believer how reliance, speech, leadership, and patience grow under Allah\'s care.',
    category: QuranThemeCategory.storiesAndProphets,
    sortOrder: 60,
    linkedProphetIds: <String>['musa'],
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.prophethood],
    searchAliases: <String>['moses', 'firawn'],
  ),
  QuranThemeDefinition(
    id: 'yusuf',
    title: 'Yusuf',
    subtitle:
        'Study the story of Yusuf through purity, hardship, trust, and forgiveness.',
    overview:
        'Surah Yusuf is a sustained lesson in patience, restraint, family pain, and the way Allah brings hidden wisdom through long trials.',
    category: QuranThemeCategory.storiesAndProphets,
    sortOrder: 70,
    linkedProphetIds: <String>['yusuf'],
    linkedSurahNumbers: <int>[12],
    searchAliases: <String>['joseph', 'forgiveness', 'dreams'],
  ),
  QuranThemeDefinition(
    id: 'maryam-isa',
    title: 'Maryam and Isa',
    subtitle:
        'Explore purity, mercy, miraculous signs, and truthful speech through Maryam and Isa.',
    overview:
        'This theme gathers passages that center Maryam and Isa with reverence, mercy, and clarity about prophethood and servanthood to Allah.',
    category: QuranThemeCategory.storiesAndProphets,
    sortOrder: 80,
    linkedProphetIds: <String>['maryam', 'isa'],
    searchAliases: <String>['mary', 'jesus'],
  ),
  QuranThemeDefinition(
    id: 'people-of-the-cave',
    title: 'People of the Cave',
    subtitle:
        'Reflect on a story of faith under pressure, retreat, patience, and divine protection.',
    overview:
        'The People of the Cave teach how steadfast faith can require withdrawal from corruption, trust in Allah, and patience with the passage of time.',
    category: QuranThemeCategory.storiesAndProphets,
    sortOrder: 90,
    linkedEventIds: <String>['people-of-the-cave'],
    linkedSurahNumbers: <int>[18],
    searchAliases: <String>['ashab al-kahf', 'cave'],
  ),
  QuranThemeDefinition(
    id: 'patience',
    title: 'Patience',
    subtitle:
        'Find surahs that connect sabr to worship, hope, endurance, and dignified response.',
    overview:
        'Patience in the Quran is active and trusting. It is not numbness, but steadiness with prayer, obedience, and confidence that Allah sees every struggle.',
    category: QuranThemeCategory.characterInnerLife,
    sortOrder: 100,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.patience],
    searchAliases: <String>['sabr', 'steadfastness', 'hardship'],
    reflectionPrompt:
        'Where do I need sabr that still keeps me moving toward Allah instead of only waiting?',
  ),
  QuranThemeDefinition(
    id: 'repentance',
    title: 'Repentance',
    subtitle:
        'Follow the Quran\'s call to return, reform, seek forgiveness, and keep hope alive.',
    overview:
        'Repentance in the Quran is hopeful and practical. It means turning back to Allah, leaving wrong, and trusting that His mercy is greater than despair.',
    category: QuranThemeCategory.worshipSpiritualLife,
    sortOrder: 110,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.repentance],
    searchAliases: <String>['tawbah', 'forgiveness'],
  ),
  QuranThemeDefinition(
    id: 'gratitude',
    title: 'Gratitude',
    subtitle:
        'See how shukr shapes worship, wise living, and using blessings in ways that please Allah.',
    overview:
        'Gratitude in the Quran is more than emotion. It appears as worship, obedience, service, and careful use of Allah\'s gifts.',
    category: QuranThemeCategory.worshipSpiritualLife,
    sortOrder: 120,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.gratitude],
    searchAliases: <String>['shukr', 'thankfulness', 'blessing'],
  ),
  QuranThemeDefinition(
    id: 'worship',
    title: 'Worship',
    subtitle:
        'Explore salah, remembrance, devotion, and the inner presence that gives worship life.',
    overview:
        'This theme gathers surahs that call to prayer, remembrance, humility, and sincere worship rooted in awareness of Allah.',
    category: QuranThemeCategory.worshipSpiritualLife,
    sortOrder: 130,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.worship],
    searchAliases: <String>['ibadah', 'salah', 'dhikr'],
  ),
  QuranThemeDefinition(
    id: 'dua',
    title: 'Du\'a',
    subtitle:
        'Trace supplication through need, nearness, hope, and calling upon Allah with sincerity.',
    overview:
        'The Quran teaches that du\'a is intimate, hopeful, and rooted in certainty that Allah hears and responds in wisdom. This theme gathers passages of calling upon Him in need and trust.',
    category: QuranThemeCategory.worshipSpiritualLife,
    sortOrder: 135,
    linkedSurahNumbers: <int>[1, 2, 14, 21, 71],
    searchAliases: <String>['supplication', 'calling on Allah', 'ask Allah'],
  ),
  QuranThemeDefinition(
    id: 'trust-in-allah',
    title: 'Trust in Allah',
    subtitle:
        'Follow the Quran\'s call to tawakkul through effort, surrender, and calm reliance upon Allah.',
    overview:
        'Trust in Allah in the Quran joins action with surrender. Believers plan, strive, and then place their hearts in Allah with confidence and peace.',
    category: QuranThemeCategory.worshipSpiritualLife,
    sortOrder: 138,
    linkedSurahNumbers: <int>[3, 8, 9, 39, 65],
    searchAliases: <String>['tawakkul', 'reliance', 'dependence on Allah'],
    reflectionPrompt:
        'Where do I need to combine sincere effort with a calmer trust in Allah?',
  ),
  QuranThemeDefinition(
    id: 'judgment',
    title: 'Judgment',
    subtitle:
        'Reflect on accountability, the standing before Allah, and the seriousness of every deed.',
    overview:
        'The Quran returns often to reckoning so that urgency, honesty, and repentance stay alive in the believer\'s heart.',
    category: QuranThemeCategory.akhirahAccountability,
    sortOrder: 140,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.judgment],
    searchAliases: <String>['reckoning', 'hisab', 'accountability'],
  ),
  QuranThemeDefinition(
    id: 'resurrection',
    title: 'Resurrection',
    subtitle:
        'Trace how the Quran describes being raised again, meeting Allah, and the certainty of return.',
    overview:
        'Resurrection is a recurring Quranic anchor. It reorders worldly priorities and reminds the believer that Allah will bring every soul back to life.',
    category: QuranThemeCategory.akhirahAccountability,
    sortOrder: 150,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.resurrection],
    searchAliases: <String>['afterlife', 'return', 'ba\'th'],
  ),
  QuranThemeDefinition(
    id: 'paradise-and-hell',
    title: 'Paradise and Hell',
    subtitle:
        'Study the Quran\'s promises and warnings through scenes of reward, regret, welcome, and loss.',
    overview:
        'This theme helps the heart hold both hope and fear by following the Quran\'s vivid descriptions of final outcomes.',
    category: QuranThemeCategory.akhirahAccountability,
    sortOrder: 160,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.paradiseAndHell],
    searchAliases: <String>['jannah', 'jahannam', 'fire', 'garden'],
  ),
  QuranThemeDefinition(
    id: 'family',
    title: 'Family',
    subtitle:
        'Explore parental care, counsel, modesty, rights, and gentle conduct within the home.',
    overview:
        'The Quran treats family life as a place of worship, trust, rights, and mercy. This theme gathers guidance for relationships close to home.',
    category: QuranThemeCategory.societyEthics,
    sortOrder: 170,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.family],
    searchAliases: <String>['parents', 'home', 'marriage'],
  ),
  QuranThemeDefinition(
    id: 'justice',
    title: 'Justice',
    subtitle:
        'Follow the Quran\'s commands to uphold trusts, fairness, and integrity even when it is difficult.',
    overview:
        'Justice in the Quran is an act of taqwa. It appears in leadership, testimony, rights, and fair dealing even with those one opposes.',
    category: QuranThemeCategory.societyEthics,
    sortOrder: 180,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.justice],
    searchAliases: <String>['fairness', 'trusts', 'rights'],
  ),
  QuranThemeDefinition(
    id: 'charity',
    title: 'Charity',
    subtitle:
        'See how giving purifies wealth, softens hearts, and strengthens community responsibility.',
    overview:
        'Charity in the Quran is not only a financial act. It is purification, compassion, and obedience expressed through what one gives for Allah\'s sake.',
    category: QuranThemeCategory.societyEthics,
    sortOrder: 190,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.charity],
    searchAliases: <String>['sadaqah', 'zakah', 'spending'],
  ),
  QuranThemeDefinition(
    id: 'community',
    title: 'Community',
    subtitle:
        'Explore brotherhood, communal trust, reconciliation, and the ethics of life together.',
    overview:
        'The Quran shapes community through truthfulness, reconciliation, mutual responsibility, and obedience to Allah in public life.',
    category: QuranThemeCategory.societyEthics,
    sortOrder: 200,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.community],
    searchAliases: <String>['ummah', 'brotherhood', 'society'],
  ),
  QuranThemeDefinition(
    id: 'hypocrisy',
    title: 'Hypocrisy',
    subtitle:
        'Study the warning signs of empty religion, double-heartedness, and public appearance without sincerity.',
    overview:
        'This theme gathers passages that expose hypocrisy so the believer can seek honesty with Allah and integrity in worship and conduct.',
    category: QuranThemeCategory.societyEthics,
    sortOrder: 210,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.hypocrisy],
    searchAliases: <String>['nifaq', 'showing off', 'double-heartedness'],
  ),
  QuranThemeDefinition(
    id: 'signs-of-creation',
    title: 'Signs of Creation',
    subtitle:
        'Reflect on how the Quran points to the world, the self, and history as signs of Allah.',
    overview:
        'The Quran invites believers to think about the heavens, the earth, human origin, and ordinary life as signs that awaken remembrance and certainty.',
    category: QuranThemeCategory.signsAndReflection,
    sortOrder: 220,
    featured: true,
    linkedThemeTags: <QuranSurahThemeTag>[QuranSurahThemeTag.signsOfCreation],
    searchAliases: <String>['creation', 'nature', 'heavens', 'earth'],
    reflectionPrompt:
        'What sign of Allah in ordinary life have I stopped noticing because it feels too familiar?',
  ),
];
