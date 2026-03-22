import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../ocean/application/ocean_drops_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/application/hadith_path_quiz_service.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../divine_life_lessons/data/divine_life_lessons_data.dart';
import '../../divine_life_lessons/domain/divine_life_models.dart';
import '../../life/baby_names/application/baby_names_controller.dart';
import '../../life/baby_names/data/baby_names_repository.dart';
import '../../life/baby_names/domain/baby_name_models.dart';
import '../../presentation/data/learn_category_catalog.dart';
import '../../presentation/models/learn_category_item.dart';
import '../../prophets/application/prophet_quiz_pool_service.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/application/prophets_ui_state.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../../salah/data/salah_trainer_data.dart' as salah_data;
import '../../salah/models/salah_trainer_models.dart';
import '../../quran/application/quran_learning_system_service.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/data/names_of_allah_data.dart';
import '../domain/learn_system_models.dart';

const _learnUnifiedProgressV2Key = 'learn.unified.progress.v2';

const List<LearnSharedTheme> _sharedThemes = [
  LearnSharedTheme(
    id: 'faith',
    label: 'Faith',
    summary: 'Belief, sincerity, and devotion to Allah.',
  ),
  LearnSharedTheme(
    id: 'intention',
    label: 'Intention',
    summary: 'Purifying motives and inward sincerity.',
  ),
  LearnSharedTheme(
    id: 'prayer',
    label: 'Salah',
    summary: 'Salah, humility, and steady ibadah.',
  ),
  LearnSharedTheme(
    id: 'patience',
    label: 'Patience',
    summary: 'Steadfastness through trial and delay.',
  ),
  LearnSharedTheme(
    id: 'gratitude',
    label: 'Gratitude',
    summary: 'Recognizing blessings and using them well.',
  ),
  LearnSharedTheme(
    id: 'mercy',
    label: 'Mercy',
    summary: 'Compassion in character, speech, and service.',
  ),
  LearnSharedTheme(
    id: 'repentance',
    label: 'Repentance',
    summary: 'Returning to Allah with hope and humility.',
  ),
  LearnSharedTheme(
    id: 'knowledge',
    label: 'Knowledge',
    summary: 'Seeking beneficial learning with action.',
  ),
  LearnSharedTheme(
    id: 'character',
    label: 'Character',
    summary: 'Truthfulness, discipline, and noble conduct.',
  ),
  LearnSharedTheme(
    id: 'justice',
    label: 'Justice',
    summary: 'Fairness, trust, and moral responsibility.',
  ),
  LearnSharedTheme(
    id: 'family',
    label: 'Family',
    summary: 'Mercy, rights, and care in relationships.',
  ),
  LearnSharedTheme(
    id: 'hereafter',
    label: 'Death & Hereafter',
    summary: 'Accountability, mortality, and preparation.',
  ),
  LearnSharedTheme(
    id: 'creation_signs',
    label: 'Creation & Signs',
    summary: 'Reading signs in creation with reflection.',
  ),
  LearnSharedTheme(
    id: 'trust_allah',
    label: 'Trust in Allah',
    summary: 'Reliance, hope, and surrender to divine wisdom.',
  ),
  LearnSharedTheme(
    id: 'dua_remembrance',
    label: 'Du’a & Remembrance',
    summary: 'Keeping the heart connected through dhikr and dua.',
  ),
];

class LearnUnifiedProgressController
    extends StateNotifier<LearnUnifiedProgressState> {
  LearnUnifiedProgressController(this._store, this._oceanDrops)
    : super(
        LearnUnifiedProgressState.fromJson(
          _store.getJsonMap(_learnUnifiedProgressV2Key),
        ),
      );

  final LocalStore _store;
  final OceanDropService _oceanDrops;

  void _persist() {
    _store.setJsonMap(_learnUnifiedProgressV2Key, state.toJson());
  }

  void _touch(String itemId) {
    final nextUpdated = Map<String, String>.from(state.lastUpdatedIsoByItemId)
      ..[itemId] = DateTime.now().toIso8601String();
    state = state.copyWith(lastUpdatedIsoByItemId: nextUpdated);
  }

  void markStarted(String itemId) {
    final next = Set<String>.from(state.startedIds)..add(itemId);
    state = state.copyWith(startedIds: next);
    _touch(itemId);
    _persist();
  }

  void markCompleted(String itemId) {
    final alreadyCompleted = state.completedIds.contains(itemId);
    final started = Set<String>.from(state.startedIds)..add(itemId);
    final completed = Set<String>.from(state.completedIds)..add(itemId);
    state = state.copyWith(startedIds: started, completedIds: completed);
    _touch(itemId);
    _persist();
    if (!alreadyCompleted) {
      final actionType = _oceanActionTypeForItem(itemId);
      if (actionType != null) {
        _oceanDrops.awardDrop(
          actionType: actionType,
          sourceModule: _oceanSourceForItem(itemId),
          referenceId: itemId,
          metadata: {'timestamp': DateTime.now().toIso8601String()},
        );
      }
    }
  }

  void toggleSaved(String itemId) {
    final next = Set<String>.from(state.savedIds);
    if (!next.remove(itemId)) {
      next.add(itemId);
    }
    state = state.copyWith(savedIds: next);
    _touch(itemId);
    _persist();
  }

  void markReflected(String itemId) {
    final next = Set<String>.from(state.reflectedIds)..add(itemId);
    state = state.copyWith(reflectedIds: next);
    _touch(itemId);
    _persist();
  }

  void markPracticed(String itemId) {
    final alreadyPracticed = state.practicedIds.contains(itemId);
    final next = Set<String>.from(state.practicedIds)..add(itemId);
    state = state.copyWith(practicedIds: next);
    _touch(itemId);
    _persist();
    if (!alreadyPracticed && itemId.startsWith('salah:surah:')) {
      _oceanDrops.awardDrop(
        actionType: oceanActionSalahTrainingCompleted,
        sourceModule: oceanSourceSalahTrainer,
        referenceId: itemId,
        metadata: {'timestamp': DateTime.now().toIso8601String()},
      );
    }
  }

  void markReviewed(String itemId) {
    final next = Set<String>.from(state.reviewedIds)..add(itemId);
    state = state.copyWith(reviewedIds: next);
    _touch(itemId);
    _persist();
  }

  void markMemorized(String itemId) {
    final alreadyMemorized = state.memorizedIds.contains(itemId);
    final next = Set<String>.from(state.memorizedIds)..add(itemId);
    state = state.copyWith(memorizedIds: next);
    _touch(itemId);
    _persist();
    if (!alreadyMemorized && itemId.startsWith('salah:surah:')) {
      _oceanDrops.awardDrop(
        actionType: oceanActionSalahTrainingCompleted,
        sourceModule: oceanSourceSalahTrainer,
        referenceId: '$itemId:memorized',
        metadata: {'timestamp': DateTime.now().toIso8601String()},
      );
    }
  }

  void setNote(String itemId, String note) {
    final next = Map<String, String>.from(state.notesByItemId);
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      next.remove(itemId);
    } else {
      next[itemId] = trimmed;
    }
    state = state.copyWith(notesByItemId: next);
    _touch(itemId);
    _persist();
  }

  String? _oceanActionTypeForItem(String itemId) {
    if (itemId.startsWith('salah:prayer:')) {
      return oceanActionSalahTrainingCompleted;
    }
    if (itemId.startsWith('dua:item:')) {
      return oceanActionDuaLessonCompleted;
    }
    if (itemId.startsWith('world_creation:lesson:')) {
      return oceanActionLessonCompleted;
    }
    if (itemId.startsWith('world_creation:challenge:')) {
      return oceanActionLearningSegmentCompleted;
    }
    return null;
  }

  String _oceanSourceForItem(String itemId) {
    if (itemId.startsWith('salah:')) {
      return oceanSourceSalahTrainer;
    }
    if (itemId.startsWith('dua:')) {
      return oceanSourceDua;
    }
    return oceanSourceLearn;
  }
}

class LearnUnifiedSearchController
    extends StateNotifier<LearnSearchFilterState> {
  LearnUnifiedSearchController() : super(const LearnSearchFilterState());

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void setType(LearnItemType? type) {
    if (type == null) {
      state = state.copyWith(clearType: true);
      return;
    }
    state = state.copyWith(type: type);
  }

  void setTheme(String? themeId) {
    if (themeId == null || themeId.isEmpty) {
      state = state.copyWith(clearTheme: true);
      return;
    }
    state = state.copyWith(themeId: themeId);
  }

  void setSavedOnly(bool value) {
    state = state.copyWith(savedOnly: value);
  }

  void setDifficulty(LearnDifficulty? difficulty) {
    if (difficulty == null) {
      state = state.copyWith(clearDifficulty: true);
      return;
    }
    state = state.copyWith(difficulty: difficulty);
  }

  void setPathId(String? pathId) {
    if (pathId == null || pathId.isEmpty) {
      state = state.copyWith(clearPath: true);
      return;
    }
    state = state.copyWith(pathId: pathId);
  }

  void clear() {
    state = const LearnSearchFilterState();
  }
}

final learnUnifiedProgressProvider =
    StateNotifierProvider<
      LearnUnifiedProgressController,
      LearnUnifiedProgressState
    >((ref) {
      return LearnUnifiedProgressController(
        ref.watch(localStoreProvider),
        ref.read(oceanDropServiceProvider),
      );
    });

final learnUnifiedSearchProvider =
    StateNotifierProvider<LearnUnifiedSearchController, LearnSearchFilterState>(
      (ref) => LearnUnifiedSearchController(),
    );

final learnSharedThemesProvider = Provider<List<LearnSharedTheme>>((_) {
  return _sharedThemes;
});

final learnDomainCardsProvider = Provider<List<LearnDomainCard>>((ref) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  LearnCategoryItem pickById(String id) {
    for (final item in LearnCategoryCatalog.items) {
      if (item.id == id) return item;
    }
    return LearnCategoryCatalog.items.first;
  }

  return [
    LearnDomainCard(
      domain: LearnUnifiedDomain.quran,
      title: l10n.quranTitle,
      subtitle: l10n.learnMetadataDomainQuranSubtitle,
      learnCategory: pickById('quran'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.hadith,
      title: l10n.learnCategoryHadithTitle,
      subtitle: l10n.learnMetadataDomainHadithSubtitle,
      learnCategory: pickById('hadith'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.prophets,
      title: l10n.learnCategoryStoriesOfProphetsTitle,
      subtitle: l10n.learnMetadataDomainProphetsSubtitle,
      learnCategory: pickById('prophets'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.lifeLessons,
      title: l10n.learnCategoryDivineLifeLessonsTitle,
      subtitle: l10n.learnMetadataDomainLifeLessonsSubtitle,
      learnCategory: pickById('life-lessons-quran'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.salah,
      title: l10n.learnCategorySalahTrainerTitle,
      subtitle: l10n.learnMetadataDomainSalahSubtitle,
      learnCategory: pickById('salah'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.namesOfAllah,
      title: l10n.quranNamesOfAllahTitle,
      subtitle: l10n.learnMetadataDomainNamesSubtitle,
      learnCategory: pickById('allah-names'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.babyNames,
      title: l10n.learnCategoryBabyNamesTitle,
      subtitle: l10n.learnMetadataDomainBabyNamesSubtitle,
      learnCategory: pickById('baby-names'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.quizzes,
      title: l10n.learnCategoryQuizzesTitle,
      subtitle: l10n.learnMetadataDomainQuizzesSubtitle,
      learnCategory: pickById('quizzes'),
    ),
    LearnDomainCard(
      domain: LearnUnifiedDomain.notes,
      title: l10n.learnCategoryNotesTitle,
      subtitle: l10n.learnMetadataDomainNotesSubtitle,
      learnCategory: pickById('notes'),
    ),
  ];
});

final learnUnifiedItemsProvider = Provider<List<LearnUnifiedContentItem>>((
  ref,
) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final quranVerses = ref.watch(quranLearningVersesProvider);
  final hadithEntries = ref.watch(hadithEntriesProvider);
  final prophetEntries = ref.watch(prophetsProvider);
  final lifeLessons = divineLifeLessons;
  final salahPrayers = salah_data.salahPrayers;
  final salahSurahs = salah_data.salahSurahs;
  final hadithQuizzes = ref.watch(hadithChapterQuizzesProvider);
  final prophetQuizQuestions = ProphetQuizPoolService.buildExpandedPool();
  final quranNotes = ref.watch(quranNotesProvider);
  final List<BabyNameEntry> babyNames = ref
      .watch(babyNamesEntriesProvider)
      .maybeWhen(data: (items) => items, orElse: () => const <BabyNameEntry>[]);

  final items = <LearnUnifiedContentItem>[];

  for (final verse in quranVerses) {
    final id = 'quran:verse:${verse.surah}:${verse.ayah}';
    final themeIds = verse.themeTag == null
        ? <String>['faith']
        : <String>[verse.themeTag!];
    items.add(
      LearnUnifiedContentItem(
        id: id,
        type: LearnItemType.verse,
        domain: LearnUnifiedDomain.quran,
        title: l10n.learnMetadataQuranVerseTitle(verse.surah, verse.ayah),
        subtitle: verse.translation,
        summary: verse.explanation,
        tags: ['quran', 'verse', ...themeIds],
        themeIds: themeIds,
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 3,
        relatedItemIds: verse.relatedHadith
            .map((hadithId) => 'hadith:lesson:$hadithId')
            .toList(growable: false),
        reflectionPrompts: verse.reflectionPrompts,
        practiceActions: const ['Read the full passage with tafakkur.'],
        isFeatured: true,
        isDailyEligible: true,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '${verse.surah}'},
        queryParameters: {'ayah': '${verse.ayah}'},
      ),
    );
  }

  for (final entry in hadithEntries) {
    final themeId = entry.themeTag ?? 'character';
    items.add(
      LearnUnifiedContentItem(
        id: 'hadith:lesson:${entry.id}',
        type: LearnItemType.hadith,
        domain: LearnUnifiedDomain.hadith,
        title: entry.title,
        subtitle: l10n.learnMetadataHadithSubtitle(
          entry.displaySourceCollection,
          entry.grading,
        ),
        summary: entry.excerpt,
        tags: ['hadith', ...entry.tags],
        themeIds: [themeId],
        difficulty: switch (entry.difficultyLevel) {
          HadithDifficultyLevel.beginner => LearnDifficulty.beginner,
          HadithDifficultyLevel.intermediate => LearnDifficulty.intermediate,
        },
        estimatedReadMinutes: 4,
        relatedItemIds: entry.relatedHadithIds
            .map((id) => 'hadith:lesson:$id')
            .toList(growable: false),
        reflectionPrompts: entry.reflectionPrompts,
        practiceActions: [entry.practiceAction],
        isFeatured: entry.isEssential,
        isDailyEligible: entry.isDailyEligible,
        routeName: 'hadithLessonDetail',
        pathParameters: {'lessonId': entry.id},
      ),
    );
  }

  for (final prophet in prophetEntries) {
    items.add(
      LearnUnifiedContentItem(
        id: 'prophet:${prophet.id}',
        type: LearnItemType.prophet,
        domain: LearnUnifiedDomain.prophets,
        title: prophet.name,
        subtitle: prophet.arabicName,
        summary: prophet.shortSummary,
        tags: ['prophets', prophet.eraGroup.name, prophet.regionLabel],
        themeIds: _themeIdsForProphet(prophet),
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 6,
        relatedItemIds: const <String>[],
        reflectionPrompts: const <String>[],
        practiceActions: const ['Read the prophet detail and note one lesson.'],
        isFeatured: prophet.isFeatured,
        isDailyEligible: true,
        routeName: 'learnProphetsHub',
        queryParameters: {'tab': 'stories', 'prophet': prophet.id},
      ),
    );
  }

  for (final lesson in lifeLessons) {
    items.add(
      LearnUnifiedContentItem(
        id: 'life:lesson:${lesson.id}',
        type: LearnItemType.lifeLesson,
        domain: LearnUnifiedDomain.lifeLessons,
        title: lesson.title,
        subtitle: lesson.quranReference,
        summary: lesson.shortSummary,
        tags: ['life', lesson.themeId, ...lesson.situationIds, ...lesson.tags],
        themeIds: _themeIdsForLifeLesson(lesson),
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: lesson.estimatedReadMinutes,
        relatedItemIds: lesson.relatedLessonIds
            .map((id) => 'life:lesson:$id')
            .toList(growable: false),
        reflectionPrompts: lesson.reflectionPrompts,
        practiceActions: [lesson.practicalTakeaway],
        isFeatured: lesson.featuredPriority >= 90,
        isDailyEligible: true,
        routeName: 'lifeLessonDetail',
        pathParameters: {'lessonId': lesson.id},
      ),
    );
  }

  for (final prayer in salahPrayers) {
    items.add(
      LearnUnifiedContentItem(
        id: 'salah:prayer:${prayer.id.name}',
        type: LearnItemType.salahPrayer,
        domain: LearnUnifiedDomain.salah,
        title: prayer.title,
        subtitle: l10n.learnMetadataSalahPrayerSubtitle(
          prayer.fardRakahs,
          prayer.recitationStyle,
        ),
        summary: prayer.shortDescription,
        tags: ['salah', 'prayer', prayer.id.name, prayer.title.toLowerCase()],
        themeIds: const ['prayer', 'knowledge'],
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 5,
        relatedItemIds: const <String>[],
        reflectionPrompts: const [
          'Which part of this prayer structure needs the most repetition this week?',
        ],
        practiceActions: const [
          'Open the guided prayer mode and review one rakah slowly.',
        ],
        isFeatured:
            prayer.id == SalahPrayerId.fajr || prayer.id == SalahPrayerId.isha,
        isDailyEligible: true,
        routeName: 'learnSalahPrayerDetail',
        pathParameters: {'prayerId': prayer.id.name},
      ),
    );
  }

  for (final surah in salahSurahs) {
    items.add(
      LearnUnifiedContentItem(
        id: 'salah:surah:${surah.id}',
        type: LearnItemType.surah,
        domain: LearnUnifiedDomain.salah,
        title: surah.name,
        subtitle: l10n.learnMetadataSurahSubtitle('${surah.surahNumber}'),
        summary: surah.summary,
        tags: ['salah', 'surah', 'memorization', surah.id, surah.name],
        themeIds: const ['prayer', 'knowledge'],
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 4,
        relatedItemIds: const <String>[],
        reflectionPrompts: [surah.reflection],
        practiceActions: const [
          'Play the surah in Learn Ayah and repeat it verse by verse.',
        ],
        isFeatured:
            surah.id == 'al_fatihah' ||
            surah.id == 'al_ikhlas' ||
            surah.id == 'an_nas',
        isDailyEligible: true,
        routeName: 'learnSalahSurahDetail',
        pathParameters: {'surahId': surah.id},
      ),
    );
  }

  for (final name in namesOfAllah) {
    items.add(
      LearnUnifiedContentItem(
        id: 'name:allah:${name.index}',
        type: LearnItemType.name,
        domain: LearnUnifiedDomain.namesOfAllah,
        title: name.transliteration,
        subtitle: name.arabic,
        summary: name.meaning,
        tags: ['names', 'allah', 'dhikr'],
        themeIds: const ['dua_remembrance', 'faith'],
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 2,
        relatedItemIds: const <String>[],
        reflectionPrompts: ['How can I call on Allah through this Name today?'],
        practiceActions: ['Repeat this Name with its meaning after salah.'],
        isFeatured: name.index <= 10,
        isDailyEligible: true,
        routeName: 'quranNamesOfAllah',
      ),
    );
  }

  for (final name in babyNames.take(300)) {
    items.add(
      LearnUnifiedContentItem(
        id: 'baby:name:${name.id}',
        type: LearnItemType.babyName,
        domain: LearnUnifiedDomain.babyNames,
        title: name.name,
        subtitle: name.arabic,
        summary: name.meaning,
        tags: [
          'baby-names',
          ...name.meaningThemes,
          ...name.associatedCategories,
        ],
        themeIds: const ['family'],
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 2,
        relatedItemIds: const <String>[],
        reflectionPrompts: [
          'Which meaning in ${name.name} feels most meaningful for your family?',
        ],
        practiceActions: const [
          'Compare meaning and pronunciation with family.',
        ],
        isFeatured:
            name.isQuranic ||
            name.isProphetAssociated ||
            name.isCompanionAssociated,
        isDailyEligible: false,
        routeName: 'babyNameDetail',
        pathParameters: {'nameId': name.id},
      ),
    );
  }

  for (final quiz in hadithQuizzes) {
    items.add(
      LearnUnifiedContentItem(
        id: 'quiz:hadith:${quiz.id}',
        type: LearnItemType.quiz,
        domain: LearnUnifiedDomain.quizzes,
        title: quiz.title,
        subtitle: l10n.learnMetadataQuestionCount(quiz.questions.length),
        summary: quiz.description,
        tags: const ['quiz', 'hadith'],
        themeIds: const ['knowledge'],
        difficulty: LearnDifficulty.intermediate,
        estimatedReadMinutes: 6,
        relatedItemIds: quiz.questions
            .map((q) => 'hadith:lesson:${q.lessonId}')
            .toSet()
            .toList(growable: false),
        reflectionPrompts: const ['Which answers need lesson revision?'],
        practiceActions: const ['Take the quiz and review explanations.'],
        isFeatured: false,
        isDailyEligible: true,
        routeName: 'hadithChapterQuiz',
        pathParameters: {'pathId': quiz.pathId, 'chapterId': quiz.chapterId},
      ),
    );
  }

  final prophetQuizCount = prophetQuizQuestions.length;
  if (prophetQuizCount > 0) {
    items.add(
      LearnUnifiedContentItem(
        id: 'quiz:prophets:mixed',
        type: LearnItemType.quiz,
        domain: LearnUnifiedDomain.quizzes,
        title: l10n.learnMetadataProphetsReviewQuizTitle,
        subtitle: l10n.learnMetadataQuestionsInPool(prophetQuizCount),
        summary: l10n.learnMetadataProphetsReviewQuizSummary,
        tags: const ['quiz', 'prophets'],
        themeIds: const ['knowledge', 'faith'],
        difficulty: LearnDifficulty.intermediate,
        estimatedReadMinutes: 5,
        relatedItemIds: const ['prophet:adam', 'prophet:muhammad'],
        reflectionPrompts: const [
          'Which prophet stories do I need to revisit this week?',
        ],
        practiceActions: const ['Take a prophets quiz session.'],
        isFeatured: true,
        isDailyEligible: true,
        routeName: 'learnProphetsHub',
        queryParameters: {'tab': 'quiz'},
      ),
    );
  }

  for (final note in quranNotes.take(200)) {
    items.add(
      LearnUnifiedContentItem(
        id: 'notes:quran:${note.id}',
        type: LearnItemType.note,
        domain: LearnUnifiedDomain.notes,
        title: note.text.trim().isEmpty
            ? l10n.learnMetadataQuranNoteTitle(
                '${note.surahNumber}',
                '${note.ayahNumber}',
              )
            : note.text.split('\n').first.trim(),
        subtitle: l10n.learnMetadataQuranNoteSubtitle(
          '${note.surahNumber}',
          '${note.ayahNumber}',
        ),
        summary: note.text,
        tags: ['notes', 'quran', ...note.tags],
        themeIds: const ['knowledge'],
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: 1,
        relatedItemIds: ['quran:verse:${note.surahNumber}:${note.ayahNumber}'],
        reflectionPrompts: const [
          'What insight from this note can I apply today?',
        ],
        practiceActions: const ['Reopen the verse and refine this note.'],
        isFeatured: false,
        isDailyEligible: false,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '${note.surahNumber}'},
        queryParameters: {'ayah': '${note.ayahNumber}'},
      ),
    );
  }

  return items;
});

final learnUnifiedItemByIdProvider =
    Provider.family<LearnUnifiedContentItem?, String>((ref, id) {
      for (final item in ref.watch(learnUnifiedItemsProvider)) {
        if (item.id == id) return item;
      }
      return null;
    });

final learnUnifiedPathsProvider = Provider<List<LearnUnifiedPath>>((ref) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final items = ref.watch(learnUnifiedItemsProvider);
  final itemIds = items.map((item) => item.id).toSet();

  List<LearnUnifiedPathStep> steps(List<(String, String, LearnItemType)> raw) {
    return raw
        .where((entry) => itemIds.contains(entry.$1))
        .map(
          (entry) => LearnUnifiedPathStep(
            id: '${entry.$1}-${entry.$2.replaceAll(' ', '-').toLowerCase()}',
            itemId: entry.$1,
            label: entry.$2,
            type: entry.$3,
          ),
        )
        .toList(growable: false);
  }

  final seeded = <LearnUnifiedPath>[
    LearnUnifiedPath(
      id: 'path_faith_foundations',
      title: l10n.learnMetadataPathFaithFoundationsTitle,
      summary: l10n.learnMetadataPathFaithFoundationsSummary,
      themeIds: const ['faith', 'intention', 'prayer'],
      steps: steps([
        (
          'quran:verse:1:5',
          l10n.learnMetadataPathFaithStep1,
          LearnItemType.verse,
        ),
        (
          'hadith:lesson:intentions_core',
          l10n.learnMetadataPathFaithStep2,
          LearnItemType.hadith,
        ),
        (
          'prophet:adam',
          l10n.learnMetadataPathFaithStep3,
          LearnItemType.prophet,
        ),
        (
          'quran:verse:29:45',
          l10n.learnMetadataPathFaithStep4,
          LearnItemType.verse,
        ),
        (
          'quiz:prophets:mixed',
          l10n.learnMetadataPathFaithStep5,
          LearnItemType.quiz,
        ),
      ]),
    ),
    LearnUnifiedPath(
      id: 'path_character_mercy',
      title: l10n.learnMetadataPathCharacterTitle,
      summary: l10n.learnMetadataPathCharacterSummary,
      themeIds: const ['character', 'mercy', 'justice', 'family'],
      steps: steps([
        (
          'hadith:lesson:sent_to_perfect_character',
          l10n.learnMetadataPathCharacterStep1,
          LearnItemType.hadith,
        ),
        (
          'quran:verse:16:90',
          l10n.learnMetadataPathCharacterStep2,
          LearnItemType.verse,
        ),
        (
          'life:lesson:speak_well_2_83',
          l10n.learnMetadataPathCharacterStep3,
          LearnItemType.lifeLesson,
        ),
        (
          'prophet:muhammad',
          l10n.learnMetadataPathCharacterStep4,
          LearnItemType.prophet,
        ),
        (
          'hadith:lesson:kind_speech',
          l10n.learnMetadataPathCharacterStep5,
          LearnItemType.hadith,
        ),
      ]),
    ),
    LearnUnifiedPath(
      id: 'path_return_hope',
      title: l10n.learnMetadataPathReturnTitle,
      summary: l10n.learnMetadataPathReturnSummary,
      themeIds: const ['repentance', 'trust_allah', 'dua_remembrance'],
      steps: steps([
        (
          'quran:verse:39:53',
          l10n.learnMetadataPathReturnStep1,
          LearnItemType.verse,
        ),
        (
          'hadith:lesson:repentance_joy',
          l10n.learnMetadataPathReturnStep2,
          LearnItemType.hadith,
        ),
        (
          'prophet:yunus',
          l10n.learnMetadataPathReturnStep3,
          LearnItemType.prophet,
        ),
        (
          'name:allah:14',
          l10n.learnMetadataPathReturnStep4,
          LearnItemType.name,
        ),
        (
          'hadith:lesson:prophet_sought_forgiveness_daily',
          l10n.learnMetadataPathReturnStep5,
          LearnItemType.hadith,
        ),
      ]),
    ),
  ];

  return seeded.where((path) => path.steps.isNotEmpty).toList(growable: false);
});

final learnDailyItemProvider = Provider<LearnDailyItemSelection>((ref) {
  final items = ref.watch(learnUnifiedItemsProvider);
  final themes = ref.watch(learnSharedThemesProvider);
  final eligible = items
      .where((item) => item.isDailyEligible)
      .toList(growable: false);
  final pool = eligible.isEmpty ? items : eligible;

  final now = DateTime.now();
  final todayKey = LocalStore.todayKey(now);
  final daySeed = now.year * 372 + now.month * 31 + now.day;
  final theme = themes[daySeed % themes.length];

  final themePool = pool
      .where(
        (item) =>
            item.themeIds.contains(theme.id) || item.tags.contains(theme.id),
      )
      .toList(growable: false);
  final finalPool = themePool.isEmpty ? pool : themePool;
  final item = finalPool[daySeed % finalPool.length];

  return LearnDailyItemSelection(dateKey: todayKey, item: item, theme: theme);
});

final learnUnifiedExternalSavedIdsProvider = Provider<Set<String>>((ref) {
  final hadithSaved = ref.watch(hadithSavedIdsProvider);
  final prophetsSaved = ref.watch(prophetsUiControllerProvider).bookmarkedIds;
  final quranBookmarks = ref.watch(quranBookmarksProvider);
  final babyFavorites = ref.watch(babyNamesControllerProvider).favorites;

  return {
    ...hadithSaved.map((id) => 'hadith:lesson:$id'),
    ...prophetsSaved.map((id) => 'prophet:$id'),
    ...quranBookmarks.map(
      (bookmark) =>
          'quran:verse:${bookmark.surahNumber}:${bookmark.ayahNumber}',
    ),
    ...babyFavorites.map((id) => 'baby:name:$id'),
  };
});

final learnUnifiedSavedItemsProvider = Provider<List<LearnUnifiedContentItem>>((
  ref,
) {
  final items = ref.watch(learnUnifiedItemsProvider);
  final progress = ref.watch(learnUnifiedProgressProvider);
  final externalSaved = ref.watch(learnUnifiedExternalSavedIdsProvider);
  final allSaved = {...progress.savedIds, ...externalSaved};

  return items
      .where((item) => allSaved.contains(item.id))
      .toList(growable: false);
});

final learnUnifiedRelationshipsProvider = Provider<List<LearnUnifiedRelation>>((
  ref,
) {
  final items = ref.watch(learnUnifiedItemsProvider);
  final itemById = {for (final item in items) item.id: item};
  final relations = <LearnUnifiedRelation>[];

  for (final item in items) {
    for (final relatedId in item.relatedItemIds) {
      if (!itemById.containsKey(relatedId)) continue;
      relations.add(
        LearnUnifiedRelation(
          fromItemId: item.id,
          toItemId: relatedId,
          type: item.type == LearnItemType.verse
              ? LearnRelationType.supports
              : LearnRelationType.expands,
        ),
      );
    }
  }

  final byTheme = <String, List<LearnUnifiedContentItem>>{};
  for (final item in items) {
    for (final theme in item.themeIds) {
      byTheme.putIfAbsent(theme, () => <LearnUnifiedContentItem>[]).add(item);
    }
  }

  for (final entries in byTheme.values) {
    if (entries.length < 2) continue;
    final capped = entries.take(10).toList(growable: false);
    for (var i = 0; i < capped.length - 1; i += 1) {
      relations.add(
        LearnUnifiedRelation(
          fromItemId: capped[i].id,
          toItemId: capped[i + 1].id,
          type: LearnRelationType.relatedTheme,
        ),
      );
    }
  }

  return relations;
});

final learnUnifiedSearchResultsProvider =
    Provider<List<LearnUnifiedContentItem>>((ref) {
      final filters = ref.watch(learnUnifiedSearchProvider);
      final items = ref.watch(learnUnifiedItemsProvider);
      final savedIds = ref
          .watch(learnUnifiedSavedItemsProvider)
          .map((e) => e.id)
          .toSet();
      final paths = ref.watch(learnUnifiedPathsProvider);

      Set<String>? pathMembership;
      if (filters.pathId != null && filters.pathId!.isNotEmpty) {
        for (final path in paths) {
          if (path.id == filters.pathId) {
            pathMembership = path.steps.map((step) => step.itemId).toSet();
            break;
          }
        }
      }

      final query = filters.query.trim().toLowerCase();

      return items
          .where((item) {
            if (filters.type != null && item.type != filters.type) return false;
            if (filters.themeId != null &&
                !item.themeIds.contains(filters.themeId)) {
              return false;
            }
            if (filters.savedOnly && !savedIds.contains(item.id)) return false;
            if (filters.difficulty != null &&
                item.difficulty != filters.difficulty) {
              return false;
            }
            if (pathMembership != null && !pathMembership.contains(item.id)) {
              return false;
            }

            if (query.isEmpty) return true;
            final inTitle = item.title.toLowerCase().contains(query);
            final inSubtitle = item.subtitle.toLowerCase().contains(query);
            final inSummary = item.summary.toLowerCase().contains(query);
            final inTags = item.tags.any(
              (tag) => tag.toLowerCase().contains(query),
            );
            return inTitle || inSubtitle || inSummary || inTags;
          })
          .toList(growable: false);
    });

final learnUnifiedSummaryV2Provider = Provider<LearnUnifiedSummaryV2>((ref) {
  final progress = ref.watch(learnUnifiedProgressProvider);
  final items = ref.watch(learnUnifiedItemsProvider);
  final daily = ref.watch(learnDailyItemProvider);
  final saved = ref.watch(learnUnifiedSavedItemsProvider);

  final byId = {for (final item in items) item.id: item};
  final started = progress.startedIds.toList()
    ..sort((a, b) {
      final aIso = progress.lastUpdatedIsoByItemId[a];
      final bIso = progress.lastUpdatedIsoByItemId[b];
      return (bIso ?? '').compareTo(aIso ?? '');
    });

  LearnUnifiedContentItem? continueItem;
  for (final id in started) {
    if (progress.completedIds.contains(id)) continue;
    continueItem = byId[id];
    if (continueItem != null) break;
  }
  continueItem ??= daily.item;

  return LearnUnifiedSummaryV2(
    continueItem: continueItem,
    dailyItem: daily,
    savedCount: saved.length,
    noteCount: progress.notesByItemId.length,
    startedCount: progress.startedIds.length,
    completedCount: progress.completedIds.length,
  );
});

List<String> _themeIdsForLifeLesson(DivineLifeLesson lesson) {
  final lower = <String>[
    lesson.themeId.toLowerCase(),
    ...lesson.situationIds.map((id) => id.toLowerCase()),
    lesson.title.toLowerCase(),
    lesson.shortSummary.toLowerCase(),
    ...lesson.tags.map((tag) => tag.toLowerCase()),
  ];
  if (lower.any(
    (tag) => tag.contains('patience') || tag.contains('hardship'),
  )) {
    return const ['patience', 'trust_allah'];
  }
  if (lower.any((tag) => tag.contains('family'))) return const ['family'];
  if (lower.any((tag) => tag.contains('gratitude'))) {
    return const ['gratitude'];
  }
  if (lower.any((tag) => tag.contains('justice'))) return const ['justice'];
  if (lower.any((tag) => tag.contains('mercy'))) return const ['mercy'];
  if (lower.any((tag) => tag.contains('knowledge'))) return const ['knowledge'];
  if (lower.any((tag) => tag.contains('character'))) return const ['character'];
  return const ['faith'];
}

List<String> _themeIdsForProphet(ProphetEntry prophet) {
  final title = '${prophet.name} ${prophet.shortSummary}'.toLowerCase();
  final output = <String>[];
  if (title.contains('patience') || title.contains('hardship')) {
    output.add('patience');
  }
  if (title.contains('mercy')) output.add('mercy');
  if (title.contains('justice')) output.add('justice');
  if (title.contains('repent')) output.add('repentance');
  if (title.contains('trust') || title.contains('submit')) {
    output.add('trust_allah');
  }
  if (title.contains('worship') || title.contains('tawhid')) {
    output.add('faith');
  }
  if (output.isEmpty) output.add('faith');
  return output;
}
