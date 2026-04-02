import '../domain/quran_ayah_action_models.dart';
import '../domain/quran_ayah_explanation_models.dart';
import '../domain/quran_reference_models.dart';

class QuranAyahActionRepository {
  const QuranAyahActionRepository();

  QuranAyahAction? actionForEntry(
    QuranAyahExplanationEntry entry, {
    String languageCode = 'en',
    bool preferKids = false,
  }) {
    if (!entry.hasSimpleSummary || !entry.hasStandardExplanation) {
      return null;
    }

    final seed = _actionSeeds[entry.ayahKey] ?? _buildFallbackSeed(entry);
    final resolvedExplanation =
        entry.resolve(
          preferKids
              ? QuranExplanationDetailLevel.kids
              : QuranExplanationDetailLevel.standard,
          languageCode: languageCode,
        ) ??
        entry.resolve(
          QuranExplanationDetailLevel.simple,
          languageCode: languageCode,
        );
    if (resolvedExplanation == null) {
      return null;
    }

    return QuranAyahAction(
      surahNumber: entry.surahNumber,
      ayahNumber: entry.ayahNumber,
      actionText: seed.actionText,
      category: seed.category,
      difficulty: seed.difficulty,
      suggestedDurationMinutes: seed.suggestedDurationMinutes,
      reflectionPrompt:
          seed.reflectionPrompt ?? resolvedExplanation.reflectionPrompt,
      rewardDrops: 1,
      tags: seed.tags,
    );
  }
}

class _ActionSeed {
  const _ActionSeed({
    required this.actionText,
    required this.category,
    required this.difficulty,
    required this.tags,
    this.suggestedDurationMinutes,
    this.reflectionPrompt,
  });

  final String actionText;
  final QuranAyahActionCategory category;
  final QuranAyahActionDifficulty difficulty;
  final List<String> tags;
  final int? suggestedDurationMinutes;
  final String? reflectionPrompt;
}

const Map<String, _ActionSeed> _actionSeeds = <String, _ActionSeed>{
  '1:1': _ActionSeed(
    actionText: 'Begin one task today by saying bismillah with attention.',
    category: QuranAyahActionCategory.worship,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['worship', 'beginning', 'daily_life'],
  ),
  '1:5': _ActionSeed(
    actionText: 'Ask Allah for help before one challenge today.',
    category: QuranAyahActionCategory.trust,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['trust', 'dua', 'dependence'],
  ),
  '1:6': _ActionSeed(
    actionText: 'Make a short dua for guidance before one decision today.',
    category: QuranAyahActionCategory.guidance,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['guidance', 'dua', 'choices'],
  ),
  '2:255': _ActionSeed(
    actionText: 'Remember Allah’s protection when one fear appears today.',
    category: QuranAyahActionCategory.protection,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['protection', 'trust', 'dhikr'],
  ),
  '93:11': _ActionSeed(
    actionText: 'Thank Allah out loud for one blessing you often overlook.',
    category: QuranAyahActionCategory.gratitude,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['gratitude', 'blessings'],
  ),
  '94:5': _ActionSeed(
    actionText: 'Stay patient in one hard moment today and ask Allah for ease.',
    category: QuranAyahActionCategory.patience,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['patience', 'ease', 'difficulty'],
  ),
  '95:4': _ActionSeed(
    actionText: 'Use one ability Allah gave you to do a quiet good today.',
    category: QuranAyahActionCategory.kindness,
    difficulty: QuranAyahActionDifficulty.medium,
    tags: <String>['kindness', 'responsibility', 'gifts'],
  ),
  '96:1': _ActionSeed(
    actionText:
        'Read or learn one beneficial thing today while remembering Allah.',
    category: QuranAyahActionCategory.knowledge,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['knowledge', 'learning', 'bismillah'],
    suggestedDurationMinutes: 5,
  ),
  '99:7': _ActionSeed(
    actionText: 'Do one small good deed today and do not belittle it.',
    category: QuranAyahActionCategory.kindness,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['good_deeds', 'kindness', 'consistency'],
  ),
  '99:8': _ActionSeed(
    actionText: 'Leave one small wrong today and ask Allah to forgive you.',
    category: QuranAyahActionCategory.repentance,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['repentance', 'self_accounting'],
  ),
  '103:3': _ActionSeed(
    actionText: 'Encourage one person toward truth or patience today.',
    category: QuranAyahActionCategory.truthfulness,
    difficulty: QuranAyahActionDifficulty.medium,
    tags: <String>['truth', 'patience', 'community'],
  ),
  '107:7': _ActionSeed(
    actionText: 'Help someone in one small practical way today.',
    category: QuranAyahActionCategory.kindness,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['kindness', 'service', 'help'],
  ),
  '108:2': _ActionSeed(
    actionText: 'Turn one blessing today into a small act of worship.',
    category: QuranAyahActionCategory.worship,
    difficulty: QuranAyahActionDifficulty.medium,
    tags: <String>['worship', 'gratitude'],
  ),
  '110:3': _ActionSeed(
    actionText:
        'When something goes well today, say alhamdulillah and astaghfirullah.',
    category: QuranAyahActionCategory.humility,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['humility', 'gratitude', 'repentance'],
  ),
  '112:1': _ActionSeed(
    actionText: 'Renew your intention to worship Allah alone in one act today.',
    category: QuranAyahActionCategory.worship,
    difficulty: QuranAyahActionDifficulty.medium,
    tags: <String>['tawhid', 'worship', 'intention'],
  ),
  '113:1': _ActionSeed(
    actionText:
        'Ask Allah for protection this evening with a calm sincere dua.',
    category: QuranAyahActionCategory.protection,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['protection', 'dua', 'evening'],
  ),
  '114:1': _ActionSeed(
    actionText:
        'When your heart feels unsettled today, run back to Allah in dhikr.',
    category: QuranAyahActionCategory.remembrance,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['remembrance', 'protection', 'heart'],
  ),
  '114:4': _ActionSeed(
    actionText:
        'Push back one bad whisper today by remembering Allah once right away.',
    category: QuranAyahActionCategory.remembrance,
    difficulty: QuranAyahActionDifficulty.easy,
    tags: <String>['remembrance', 'whispers', 'protection'],
  ),
};

_ActionSeed _buildFallbackSeed(QuranAyahExplanationEntry entry) {
  final category = _inferCategory(entry);
  return _ActionSeed(
    actionText: _fallbackActionText(category),
    category: category,
    difficulty: _fallbackDifficulty(category),
    tags: _fallbackTags(category),
    reflectionPrompt: _fallbackPrompt(category),
  );
}

QuranAyahActionCategory _inferCategory(QuranAyahExplanationEntry entry) {
  final corpus = [
    entry.simpleSummary,
    entry.standardExplanation,
    entry.deepExplanation ?? '',
    entry.kidsExplanation ?? '',
    ...entry.keyLessons,
    entry.reflectionPrompt ?? '',
  ].join(' ').toLowerCase();

  if (_containsAny(corpus, <String>[
    'guide',
    'guidance',
    'straight path',
    'path',
  ])) {
    return QuranAyahActionCategory.guidance;
  }
  if (_containsAny(corpus, <String>[
    'grateful',
    'gratitude',
    'thank',
    'blessing',
  ])) {
    return QuranAyahActionCategory.gratitude;
  }
  if (_containsAny(corpus, <String>[
    'patient',
    'patience',
    'hardship',
    'ease',
  ])) {
    return QuranAyahActionCategory.patience;
  }
  if (_containsAny(corpus, <String>[
    'orphan',
    'poor',
    'help',
    'kind',
    'mercy',
    'gentle',
    'feeding',
  ])) {
    return QuranAyahActionCategory.kindness;
  }
  if (_containsAny(corpus, <String>[
    'prayer',
    'salah',
    'dua',
    'supplication',
  ])) {
    return QuranAyahActionCategory.prayer;
  }
  if (_containsAny(corpus, <String>[
    'remember',
    'dhikr',
    'mercy',
    'return',
    'hope',
  ])) {
    return QuranAyahActionCategory.remembrance;
  }
  if (_containsAny(corpus, <String>[
    'seek refuge',
    'protection',
    'refuge',
    'whisper',
    'envy',
    'fear',
  ])) {
    return QuranAyahActionCategory.protection;
  }
  if (_containsAny(corpus, <String>[
    'read',
    'knowledge',
    'taught',
    'learn',
    'pen',
  ])) {
    return QuranAyahActionCategory.knowledge;
  }
  if (_containsAny(corpus, <String>[
    'truth',
    'sincere',
    'show off',
    'honest',
  ])) {
    return QuranAyahActionCategory.truthfulness;
  }
  if (_containsAny(corpus, <String>['forgive', 'repent', 'astaghfir', 'sin'])) {
    return QuranAyahActionCategory.repentance;
  }
  if (_containsAny(corpus, <String>['depend', 'help', 'trust', 'rely'])) {
    return QuranAyahActionCategory.trust;
  }
  if (_containsAny(corpus, <String>[
    'alone',
    'worship',
    'obedience',
    'sacrifice',
  ])) {
    return QuranAyahActionCategory.worship;
  }
  if (_containsAny(corpus, <String>[
    'justice',
    'judge',
    'accountability',
    'answer',
  ])) {
    return QuranAyahActionCategory.humility;
  }
  return QuranAyahActionCategory.worship;
}

bool _containsAny(String corpus, List<String> needles) {
  for (final needle in needles) {
    if (corpus.contains(needle)) return true;
  }
  return false;
}

String _fallbackActionText(QuranAyahActionCategory category) {
  return switch (category) {
    QuranAyahActionCategory.worship =>
      'Turn one small act today into worship for Allah with a clear intention.',
    QuranAyahActionCategory.gratitude =>
      'Thank Allah for one blessing today and notice it with your heart.',
    QuranAyahActionCategory.patience =>
      'Practice patience in one hard moment today and ask Allah for help.',
    QuranAyahActionCategory.kindness =>
      'Do one small helpful act for someone today.',
    QuranAyahActionCategory.prayer =>
      'Give one prayer or short dua more attention today.',
    QuranAyahActionCategory.remembrance =>
      'Remember Allah once before a task or before sleep today.',
    QuranAyahActionCategory.trust =>
      'Ask Allah for help before one worry or task today.',
    QuranAyahActionCategory.protection =>
      'Ask Allah for protection at one calm moment today.',
    QuranAyahActionCategory.knowledge =>
      'Learn one beneficial thing today while asking Allah to guide you.',
    QuranAyahActionCategory.truthfulness =>
      'Speak one truthful word gently today, even if it is difficult.',
    QuranAyahActionCategory.humility =>
      'Let one success or blessing make you more humble before Allah today.',
    QuranAyahActionCategory.repentance =>
      'Say astaghfirullah sincerely and leave one small wrong today.',
    QuranAyahActionCategory.guidance =>
      'Ask Allah for guidance before making one decision today.',
  };
}

QuranAyahActionDifficulty _fallbackDifficulty(
  QuranAyahActionCategory category,
) {
  return switch (category) {
    QuranAyahActionCategory.truthfulness ||
    QuranAyahActionCategory.humility ||
    QuranAyahActionCategory.guidance => QuranAyahActionDifficulty.medium,
    QuranAyahActionCategory.worship ||
    QuranAyahActionCategory.gratitude ||
    QuranAyahActionCategory.patience ||
    QuranAyahActionCategory.kindness ||
    QuranAyahActionCategory.prayer ||
    QuranAyahActionCategory.remembrance ||
    QuranAyahActionCategory.trust ||
    QuranAyahActionCategory.protection ||
    QuranAyahActionCategory.knowledge ||
    QuranAyahActionCategory.repentance => QuranAyahActionDifficulty.easy,
  };
}

List<String> _fallbackTags(QuranAyahActionCategory category) {
  return <String>[category.name, 'daily_action', 'live_the_quran'];
}

String _fallbackPrompt(QuranAyahActionCategory category) {
  return switch (category) {
    QuranAyahActionCategory.worship =>
      'How can I make this act more sincerely for Allah today?',
    QuranAyahActionCategory.gratitude =>
      'Which blessing have I been enjoying without enough gratitude?',
    QuranAyahActionCategory.patience =>
      'Where do I need more patience and calm trust today?',
    QuranAyahActionCategory.kindness =>
      'Who could benefit from one gentle act from me today?',
    QuranAyahActionCategory.prayer =>
      'Which prayer or dua needs more presence from my heart today?',
    QuranAyahActionCategory.remembrance =>
      'When do I most forget Allah during the day?',
    QuranAyahActionCategory.trust =>
      'What am I carrying alone instead of placing before Allah?',
    QuranAyahActionCategory.protection =>
      'What fear should I place under Allah’s protection today?',
    QuranAyahActionCategory.knowledge =>
      'How can learning bring me closer to Allah today?',
    QuranAyahActionCategory.truthfulness =>
      'Where do I need more honesty and sincerity today?',
    QuranAyahActionCategory.humility =>
      'What should make me more humble before Allah today?',
    QuranAyahActionCategory.repentance =>
      'What small wrong should I stop excusing today?',
    QuranAyahActionCategory.guidance =>
      'Which choice today needs Allah’s guidance most?',
  };
}
