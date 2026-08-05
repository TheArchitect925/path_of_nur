import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kids_dua_audio_manifest.dart';
import '../domain/kids_dua_learning_models.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_experience_provider.dart';
import 'kids_dua_progress_provider.dart';
import 'kids_dua_repository.dart';

final kidsDuaLearningRepositoryProvider = Provider<KidsDuaLearningRepository>(
  (ref) => KidsDuaLearningRepository(ref),
);

final kidsDuaLearningItemByIdProvider =
    Provider.family<KidsDuaLearningItem?, String>((ref, duaId) {
      return ref
          .watch(kidsDuaLearningRepositoryProvider)
          .learningItemById(duaId);
    });

final kidsDuaRecommendedLearningItemProvider = Provider<KidsDuaLearningItem?>((
  ref,
) {
  final repository = ref.watch(kidsDuaLearningRepositoryProvider);
  return repository.recommendedLearningItem();
});

class KidsDuaLearningRepository {
  KidsDuaLearningRepository(this._ref);

  final Ref _ref;

  KidsDuaLearningItem? learningItemById(String duaId) {
    final lesson = _ref.read(kidsDuaLessonByIdProvider(duaId));
    final category = lesson == null
        ? null
        : _ref.read(kidsDuaCategoryByIdProvider(lesson.categoryId));
    if (lesson == null || category == null) {
      return null;
    }
    final audioVariant = kidsDuaAudioVariantFor(lesson);
    return KidsDuaLearningItem(
      duaId: lesson.id,
      title: lesson.title,
      category: category.title,
      useCase: lesson.whenToSay,
      arabicText: lesson.arabic,
      transliteration: lesson.transliteration,
      translation: lesson.meaning,
      shortMeaning: lesson.miniLesson,
      sourceReference: lesson.sourceReference,
      ageGroupLabel: lesson.level <= 2 ? 'kids' : 'kidsPlus',
      tags: <String>[
        lesson.categoryId,
        lesson.sourceType,
        if (_isBedtimeLesson(lesson)) 'bedtime',
        if (_isEmotionLesson(lesson)) 'emotion',
      ],
      sortOrder: lesson.sortOrder,
      isFeatured: lesson.level <= 2,
      bedtimeRelevance: _isBedtimeLesson(lesson),
      dailyRoutineRelevance: _isDailyRoutineLesson(lesson),
      emotionRelevance: _isEmotionLesson(lesson),
      audioVariants: <KidsDuaAudioVariant>[audioVariant],
      segments: _segmentsForLesson(lesson),
      lesson: lesson,
    );
  }

  KidsDuaLearningItem? recommendedLearningItem() {
    final progress = _ref.read(kidsDuaLearningProvider);
    if (progress.recentLessonIds.isNotEmpty) {
      final recentId = progress.recentLessonIds.first;
      final recentProgress = progress.progressByLessonId[recentId];
      if (recentProgress != null &&
          recentProgress.status != KidsDuaLessonStatus.learned) {
        return learningItemById(recentId);
      }
    }
    final bedtime = learningItemById('before-sleep');
    if (bedtime != null) {
      return bedtime;
    }
    final featured = _ref.read(kidsDuaFeaturedLessonProvider);
    if (featured == null) {
      return null;
    }
    return learningItemById(featured.id);
  }

  List<KidsDuaSegment> _segmentsForLesson(KidsDuaLessonContent lesson) {
    return lesson.phraseChunks
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final chunk = entry.value;
          return KidsDuaSegment(
            segmentId: chunk.id,
            duaId: lesson.id,
            sortOrder: index,
            arabicSegmentText: chunk.arabic,
            transliterationSegmentText: chunk.transliteration,
            translationSegmentText: lesson.phraseChunks.length == 1
                ? lesson.meaning
                : null,
            emphasisType: index == 0 ? 'lead' : null,
          );
        })
        .toList(growable: false);
  }

  bool _isBedtimeLesson(KidsDuaLessonContent lesson) {
    return lesson.categoryId == 'sleep' || lesson.id == 'before-sleep';
  }

  bool _isDailyRoutineLesson(KidsDuaLessonContent lesson) {
    return const <String>{
      'sleep',
      'food_drink',
      'home_daily',
      'daily_basics',
    }.contains(lesson.categoryId);
  }

  bool _isEmotionLesson(KidsDuaLessonContent lesson) {
    return lesson.categoryId == 'feelings_protection';
  }
}
