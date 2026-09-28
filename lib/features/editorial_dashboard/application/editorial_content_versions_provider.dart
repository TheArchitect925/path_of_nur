import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../kids/bedtime_stories/data/bedtime_story_seed.dart';
import '../../kids/bedtime_stories/data/books/kids_picture_books.dart';
import '../../kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import '../../kids/bedtime_stories/domain/bedtime_story_models.dart';
import '../../kids/seerah/data/companion_story_seed.dart';
import '../../kids_dua_learning/data/kids_dua_seed_data.dart';
import '../../kids_dua_learning/domain/kids_dua_models.dart';
import '../../learn/hadith/data/generated_hadith_foundation_data.dart';
import '../../learn/hadith/domain/hadith_foundation_models.dart';
import '../../learn/quran/data/seeded_quran_ayah_explanations.dart';
import '../../learn/quran/domain/quran_ayah_explanation_models.dart';
import '../domain/editorial_content_version_models.dart';

const _editorialContentVersionsKey =
    'internal.editorial_dashboard.content_versions.v1';
const _maxEditorialVersionsPerItem = 8;

class EditorialContentVersionsController
    extends StateNotifier<Map<String, EditorialContentRecord>> {
  EditorialContentVersionsController(this._store)
    : super(_load(_store.getJsonMap(_editorialContentVersionsKey)));

  final LocalStore _store;

  static Map<String, EditorialContentRecord> _load(Map<String, dynamic>? json) {
    if (json == null) return <String, EditorialContentRecord>{};
    final records = <String, EditorialContentRecord>{};
    for (final entry in json.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        records[entry.key] = EditorialContentRecord.fromJson(value);
      } else if (value is Map) {
        records[entry.key] = EditorialContentRecord.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
    }
    return records;
  }

  Future<void> _persist() async {
    await _store.setJsonMap(_editorialContentVersionsKey, <String, dynamic>{
      for (final entry in state.entries) entry.key: entry.value.toJson(),
    });
  }

  static String recordKey(EditorialContentType type, String contentId) =>
      '${type.name}:$contentId';

  Future<void> saveEdit({
    required EditorialContentType type,
    required String contentId,
    required Map<String, dynamic> snapshot,
    required String changeSummary,
  }) async {
    final key = recordKey(type, contentId);
    final existing = state[key];
    final nextVersionNumber = (existing?.latestVersion?.versionNumber ?? 0) + 1;
    final version = ContentVersion(
      contentId: contentId,
      contentType: type,
      versionNumber: nextVersionNumber,
      updatedAtIso: DateTime.now().toIso8601String(),
      changeSummary: changeSummary.trim(),
      previousVersionRef: existing?.latestVersion?.versionRef,
      contentSnapshot: snapshot,
    );
    final versions = <ContentVersion>[...?existing?.versions, version];
    final trimmedVersions = versions.length > _maxEditorialVersionsPerItem
        ? versions.sublist(versions.length - _maxEditorialVersionsPerItem)
        : versions;
    final record = EditorialContentRecord(
      contentId: contentId,
      contentType: type,
      currentSnapshot: snapshot,
      versions: trimmedVersions,
    );
    state = <String, EditorialContentRecord>{...state, key: record};
    await _persist();
  }

  Future<void> rollbackToVersion({
    required EditorialContentType type,
    required String contentId,
    required int targetVersionNumber,
    required String changeSummary,
  }) async {
    final key = recordKey(type, contentId);
    final existing = state[key];
    if (existing == null) return;
    final target = existing.versions.where((version) {
      return version.versionNumber == targetVersionNumber;
    }).firstOrNull;
    if (target == null) return;
    await saveEdit(
      type: type,
      contentId: contentId,
      snapshot: target.contentSnapshot,
      changeSummary: changeSummary,
    );
  }
}

final editorialContentVersionsProvider =
    StateNotifierProvider<
      EditorialContentVersionsController,
      Map<String, EditorialContentRecord>
    >((ref) {
      return EditorialContentVersionsController(ref.watch(localStoreProvider));
    });

final editorialContentRecordProvider =
    Provider.family<EditorialContentRecord?, (EditorialContentType, String)>((
      ref,
      input,
    ) {
      final records = ref.watch(editorialContentVersionsProvider);
      return records[EditorialContentVersionsController.recordKey(
        input.$1,
        input.$2,
      )];
    });

final editorialContentVersionsForItemProvider =
    Provider.family<List<ContentVersion>, (EditorialContentType, String)>((
      ref,
      input,
    ) {
      return ref
              .watch(editorialContentRecordProvider(input))
              ?.versions
              .reversed
              .toList(growable: false) ??
          const <ContentVersion>[];
    });

final editorialQuranAyahExplanationEntriesProvider =
    Provider<List<QuranAyahExplanationEntry>>((ref) {
      final records = ref.watch(editorialContentVersionsProvider);
      final byKey = <String, QuranAyahExplanationEntry>{
        for (final entry in seededQuranAyahExplanations) entry.ayahKey: entry,
      };
      for (final record in records.values) {
        if (record.contentType != EditorialContentType.quranExplanation) {
          continue;
        }
        final base = byKey[record.contentId];
        if (base == null) continue;
        byKey[record.contentId] = _applyQuranExplanationSnapshot(
          base,
          record.currentSnapshot,
        );
      }
      final result = byKey.values.toList(growable: false)
        ..sort((a, b) {
          final surahCompare = a.surahNumber.compareTo(b.surahNumber);
          if (surahCompare != 0) return surahCompare;
          return a.ayahNumber.compareTo(b.ayahNumber);
        });
      return result;
    });

final editorialHadithEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final records = ref.watch(editorialContentVersionsProvider);
  final byId = <String, HadithEntry>{
    for (final entry in generatedHadithEntries) entry.id: entry,
  };
  for (final record in records.values) {
    if (record.contentType != EditorialContentType.hadithEntry) continue;
    final base = byId[record.contentId];
    if (base == null) continue;
    byId[record.contentId] = _applyHadithSnapshot(base, record.currentSnapshot);
  }
  return byId.values.toList(growable: false);
});

final editorialKidsDuaLessonsProvider = Provider<List<KidsDuaLessonContent>>((
  ref,
) {
  final records = ref.watch(editorialContentVersionsProvider);
  final byId = <String, KidsDuaLessonContent>{
    for (final lesson in kidsDuaStarterLessons) lesson.id: lesson,
  };
  for (final record in records.values) {
    if (record.contentType != EditorialContentType.kidsDuaLesson) continue;
    final base = byId[record.contentId];
    if (base == null) continue;
    byId[record.contentId] = _applyKidsDuaSnapshot(
      base,
      record.currentSnapshot,
    );
  }
  final lessons = byId.values.toList(growable: false)
    ..sort((a, b) {
      final levelCompare = a.level.compareTo(b.level);
      if (levelCompare != 0) return levelCompare;
      return a.sortOrder.compareTo(b.sortOrder);
    });
  return lessons;
});

final editorialBedtimeStorySeedsProvider = Provider<List<BedtimeStorySeed>>((
  ref,
) {
  final records = ref.watch(editorialContentVersionsProvider);
  final baseStories = <BedtimeStorySeed>[
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
    ...kKidsSeerahCompanionStories,
    ...kKidsPictureBooks,
  ];
  final byId = <String, BedtimeStorySeed>{
    for (final story in baseStories) story.id: story,
  };
  for (final record in records.values) {
    if (record.contentType != EditorialContentType.bedtimeStory) continue;
    final base = byId[record.contentId];
    if (base == null) continue;
    byId[record.contentId] = _applyBedtimeStorySnapshot(
      base,
      record.currentSnapshot,
    );
  }
  final stories = byId.values.toList(growable: false)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return stories;
});

final editorialEditableContentSummariesProvider =
    Provider.family<
      List<EditorialEditableContentSummary>,
      EditorialContentType
    >((ref, type) {
      final records = ref.watch(editorialContentVersionsProvider);
      switch (type) {
        case EditorialContentType.quranExplanation:
          return ref
              .watch(editorialQuranAyahExplanationEntriesProvider)
              .map((entry) {
                final record =
                    records[EditorialContentVersionsController.recordKey(
                      type,
                      entry.ayahKey,
                    )];
                return EditorialEditableContentSummary(
                  contentId: entry.ayahKey,
                  contentType: type,
                  title:
                      'Surah ${entry.surahNumber} · Ayah ${entry.ayahNumber}',
                  subtitle: entry.simpleSummary,
                  searchText:
                      '${entry.ayahKey} ${entry.simpleSummary} ${entry.standardExplanation}'
                          .toLowerCase(),
                  versionCount: record?.versions.length ?? 0,
                  lastUpdatedIso: record?.latestVersion?.updatedAtIso,
                  changeSummary: record?.latestVersion?.changeSummary,
                );
              })
              .toList(growable: false);
        case EditorialContentType.hadithEntry:
          return ref
              .watch(editorialHadithEntriesProvider)
              .map((entry) {
                final record =
                    records[EditorialContentVersionsController.recordKey(
                      type,
                      entry.id,
                    )];
                return EditorialEditableContentSummary(
                  contentId: entry.id,
                  contentType: type,
                  title: entry.title,
                  subtitle: entry.meaning,
                  searchText:
                      '${entry.id} ${entry.title} ${entry.meaning} ${entry.excerpt} ${entry.tags.join(' ')}'
                          .toLowerCase(),
                  versionCount: record?.versions.length ?? 0,
                  lastUpdatedIso: record?.latestVersion?.updatedAtIso,
                  changeSummary: record?.latestVersion?.changeSummary,
                );
              })
              .toList(growable: false);
        case EditorialContentType.bedtimeStory:
          return ref
              .watch(editorialBedtimeStorySeedsProvider)
              .map((story) {
                final record =
                    records[EditorialContentVersionsController.recordKey(
                      type,
                      story.id,
                    )];
                return EditorialEditableContentSummary(
                  contentId: story.id,
                  contentType: type,
                  title: story.title,
                  subtitle: story.lesson,
                  searchText:
                      '${story.id} ${story.title} ${story.shortTitle} ${story.summary} ${story.lesson} ${story.tags.join(' ')}'
                          .toLowerCase(),
                  versionCount: record?.versions.length ?? 0,
                  lastUpdatedIso: record?.latestVersion?.updatedAtIso,
                  changeSummary: record?.latestVersion?.changeSummary,
                );
              })
              .toList(growable: false);
        case EditorialContentType.kidsDuaLesson:
          return ref
              .watch(editorialKidsDuaLessonsProvider)
              .map((lesson) {
                final record =
                    records[EditorialContentVersionsController.recordKey(
                      type,
                      lesson.id,
                    )];
                return EditorialEditableContentSummary(
                  contentId: lesson.id,
                  contentType: type,
                  title: lesson.title,
                  subtitle: lesson.meaning,
                  searchText:
                      '${lesson.id} ${lesson.title} ${lesson.transliteration} ${lesson.meaning} ${lesson.miniLesson} ${lesson.whenToSay}'
                          .toLowerCase(),
                  versionCount: record?.versions.length ?? 0,
                  lastUpdatedIso: record?.latestVersion?.updatedAtIso,
                  changeSummary: record?.latestVersion?.changeSummary,
                );
              })
              .toList(growable: false);
      }
    });

final editorialCurrentContentSnapshotProvider =
    Provider.family<Map<String, dynamic>?, (EditorialContentType, String)>((
      ref,
      input,
    ) {
      final type = input.$1;
      final contentId = input.$2;
      return switch (type) {
        EditorialContentType.quranExplanation =>
          ref
              .watch(editorialQuranAyahExplanationEntriesProvider)
              .where((entry) => entry.ayahKey == contentId)
              .map(_quranExplanationSnapshot)
              .firstOrNull,
        EditorialContentType.hadithEntry =>
          ref
              .watch(editorialHadithEntriesProvider)
              .where((entry) => entry.id == contentId)
              .map(_hadithSnapshot)
              .firstOrNull,
        EditorialContentType.bedtimeStory =>
          ref
              .watch(editorialBedtimeStorySeedsProvider)
              .where((story) => story.id == contentId)
              .map(_bedtimeStorySnapshot)
              .firstOrNull,
        EditorialContentType.kidsDuaLesson =>
          ref
              .watch(editorialKidsDuaLessonsProvider)
              .where((lesson) => lesson.id == contentId)
              .map(_kidsDuaSnapshot)
              .firstOrNull,
      };
    });

QuranAyahExplanationEntry _applyQuranExplanationSnapshot(
  QuranAyahExplanationEntry base,
  Map<String, dynamic> snapshot,
) {
  final keyLessons = _stringList(snapshot['keyLessons']);
  final reviewStatusName = snapshot['reviewStatus']?.toString();
  final reviewStatus = QuranAyahExplanationReviewStatus.values.firstWhere(
    (value) => value.name == reviewStatusName,
    orElse: () => base.reviewStatus,
  );
  final deepText = snapshot['deepExplanation']?.toString().trim() ?? '';
  final kidsText = snapshot['kidsExplanation']?.toString().trim() ?? '';
  final reflectionPrompt =
      snapshot['reflectionPrompt']?.toString().trim() ?? '';
  return base.copyWith(
    simpleSummary: snapshot['simpleSummary']?.toString() ?? base.simpleSummary,
    standardExplanation:
        snapshot['standardExplanation']?.toString() ?? base.standardExplanation,
    deepExplanation: deepText.isEmpty ? null : deepText,
    clearDeepExplanation: deepText.isEmpty,
    kidsExplanation: kidsText.isEmpty ? null : kidsText,
    clearKidsExplanation: kidsText.isEmpty,
    keyLessons: keyLessons,
    reflectionPrompt: reflectionPrompt.isEmpty ? null : reflectionPrompt,
    clearReflectionPrompt: reflectionPrompt.isEmpty,
    reviewStatus: reviewStatus,
  );
}

HadithEntry _applyHadithSnapshot(
  HadithEntry base,
  Map<String, dynamic> snapshot,
) {
  return base.copyWith(
    title: snapshot['title']?.toString() ?? base.title,
    excerpt: snapshot['excerpt']?.toString() ?? base.excerpt,
    meaning: snapshot['meaning']?.toString() ?? base.meaning,
    lessons: _stringList(snapshot['lessons']),
    reflectionPrompts: _stringList(snapshot['reflectionPrompts']),
    practiceAction:
        snapshot['practiceAction']?.toString() ?? base.practiceAction,
    tags: _stringList(snapshot['tags']),
    sourceProvenance: HadithSourceProvenance.editorialOverride,
    sourceImportSource: 'editorial_hadith_override',
  );
}

KidsDuaLessonContent _applyKidsDuaSnapshot(
  KidsDuaLessonContent base,
  Map<String, dynamic> snapshot,
) {
  final practicePrompt = snapshot['practicePrompt']?.toString().trim() ?? '';
  return base.copyWith(
    title: snapshot['title']?.toString() ?? base.title,
    transliteration:
        snapshot['transliteration']?.toString() ?? base.transliteration,
    meaning: snapshot['meaning']?.toString() ?? base.meaning,
    miniLesson: snapshot['miniLesson']?.toString() ?? base.miniLesson,
    whenToSay: snapshot['whenToSay']?.toString() ?? base.whenToSay,
    practicePrompt: practicePrompt.isEmpty ? null : practicePrompt,
    clearPracticePrompt: practicePrompt.isEmpty,
  );
}

BedtimeStorySeed _applyBedtimeStorySnapshot(
  BedtimeStorySeed base,
  Map<String, dynamic> snapshot,
) {
  final sourceNote = snapshot['sourceNote']?.toString().trim() ?? '';
  return base.copyWith(
    title: snapshot['title']?.toString() ?? base.title,
    shortTitle: snapshot['shortTitle']?.toString() ?? base.shortTitle,
    summary: snapshot['summary']?.toString() ?? base.summary,
    lesson: snapshot['lesson']?.toString() ?? base.lesson,
    sourceNote: sourceNote.isEmpty ? null : sourceNote,
    clearSourceNote: sourceNote.isEmpty,
    tags: _stringList(snapshot['tags']),
  );
}

Map<String, dynamic> _quranExplanationSnapshot(
  QuranAyahExplanationEntry entry,
) => <String, dynamic>{
  'surahNumber': entry.surahNumber,
  'ayahNumber': entry.ayahNumber,
  'ayahKey': entry.ayahKey,
  'simpleSummary': entry.simpleSummary,
  'standardExplanation': entry.standardExplanation,
  'deepExplanation': entry.deepExplanation ?? '',
  'kidsExplanation': entry.kidsExplanation ?? '',
  'keyLessons': entry.keyLessons,
  'reflectionPrompt': entry.reflectionPrompt ?? '',
  'reviewStatus': entry.reviewStatus.name,
};

Map<String, dynamic> _hadithSnapshot(HadithEntry entry) => <String, dynamic>{
  'id': entry.id,
  'title': entry.title,
  'excerpt': entry.excerpt,
  'meaning': entry.meaning,
  'lessons': entry.lessons,
  'reflectionPrompts': entry.reflectionPrompts,
  'practiceAction': entry.practiceAction,
  'tags': entry.tags,
};

Map<String, dynamic> _kidsDuaSnapshot(KidsDuaLessonContent lesson) =>
    <String, dynamic>{
      'id': lesson.id,
      'title': lesson.title,
      'transliteration': lesson.transliteration,
      'meaning': lesson.meaning,
      'miniLesson': lesson.miniLesson,
      'whenToSay': lesson.whenToSay,
      'practicePrompt': lesson.practicePrompt ?? '',
    };

Map<String, dynamic> _bedtimeStorySnapshot(BedtimeStorySeed story) =>
    <String, dynamic>{
      'id': story.id,
      'title': story.title,
      'shortTitle': story.shortTitle,
      'summary': story.summary,
      'lesson': story.lesson,
      'sourceNote': story.sourceNote ?? '',
      'tags': story.tags,
    };

List<String> _stringList(Object? value) {
  final raw = value as List?;
  if (raw == null) return const <String>[];
  return raw
      .map((entry) => entry.toString().trim())
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
}
