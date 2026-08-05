import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_active_learner_service.dart';
import 'kids_dua_experience_provider.dart';
import 'kids_dua_progress_provider.dart';

final kidsDuaDrawingDirectoryProvider = FutureProvider<Directory>((ref) async {
  final base = await getApplicationDocumentsDirectory();
  final learnerId = ref.watch(
    kidsDuaActiveLearnerProvider.select((value) => value.learnerId),
  );
  final dir = Directory('${base.path}/kids_dua_drawings/$learnerId');
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  return dir;
});

final kidsDuaCreativeProvider =
    StateNotifierProvider<KidsDuaCreativeNotifier, KidsDuaCreativeState>((ref) {
      final controller = KidsDuaCreativeNotifier(ref);
      ref.listen<String>(
        kidsDuaActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => controller.updateActiveLearner(nextLearnerId),
      );
      return controller;
    });

final kidsDuaDrawingsProvider = Provider<List<KidsDuaDrawing>>((ref) {
  return ref.watch(kidsDuaCreativeProvider).drawings;
});

final kidsDuaDrawingsForLessonProvider =
    Provider.family<List<KidsDuaDrawing>, String>((ref, duaId) {
      return ref
          .watch(kidsDuaDrawingsProvider)
          .where((item) => item.duaId == duaId)
          .toList(growable: false);
    });

final kidsDuaParentDashboardProvider = Provider<KidsDuaParentDashboard>((ref) {
  final summary = ref.watch(kidsDuaProgressSummaryProvider);
  final categories = ref.watch(kidsDuaCategoryProgressListProvider);
  final light = ref.watch(kidsDuaLightSummaryProvider);
  final progress = ref.watch(kidsDuaLearningProvider);
  final drawings = ref.watch(kidsDuaDrawingsProvider);
  final todayKey = ref
      .watch(kidsDuaNowProvider)()
      .toIso8601String()
      .split('T')
      .first;
  final recentActivity =
      progress.activityLog
          .where((item) => item.dateKey == todayKey)
          .toList(growable: false)
        ..sort((a, b) => b.timestampIso.compareTo(a.timestampIso));

  return KidsDuaParentDashboard(
    totalDuasLearned: summary.learnedLessons,
    streakDays: light.currentStreakDays,
    lightLevel: light.lightLevel,
    todayCompleted: light.todayCompleted,
    categoryProgress: categories
        .map(
          (item) => KidsDuaParentCategoryProgress(
            categoryId: item.category.id,
            categoryTitle: item.category.title,
            learnedCount: item.learnedCount,
            totalCount: item.totalCount,
          ),
        )
        .toList(growable: false),
    recentActivity: recentActivity,
    drawings: drawings,
  );
});

class KidsDuaCreativeNotifier extends StateNotifier<KidsDuaCreativeState> {
  KidsDuaCreativeNotifier(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(kidsDuaActiveLearnerProvider).learnerId,
      super(
        KidsDuaCreativeState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(
                kidsDuaCreativeStorageKeyForLearner(
                  _ref.read(kidsDuaActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      ) {
    _migrateLegacyStateIfNeeded();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  Future<KidsDuaDrawing> saveDrawing({
    required String duaId,
    required Uint8List pngBytes,
  }) async {
    final now = _ref.read(kidsDuaNowProvider)();
    final nowIso = now.toIso8601String();
    final id = 'drawing_${now.microsecondsSinceEpoch}';
    final directory = await _ref.read(kidsDuaDrawingDirectoryProvider.future);
    final file = File('${directory.path}/$id.png');
    await file.writeAsBytes(pngBytes, flush: true);
    final drawing = KidsDuaDrawing(
      id: id,
      duaId: duaId,
      imagePath: file.path,
      createdAt: nowIso,
      lastEditedAt: nowIso,
    );
    final drawings = <KidsDuaDrawing>[drawing, ...state.drawings];
    state = state.copyWith(drawings: drawings);
    _persist();
    _ref
        .read(kidsDuaLearningProvider.notifier)
        .recordActivity(
          type: KidsDuaActivityLogType.drawingSaved,
          duaId: duaId,
        );
    return drawing;
  }

  Future<void> deleteDrawing(String drawingId) async {
    KidsDuaDrawing? drawing;
    for (final item in state.drawings) {
      if (item.id == drawingId) {
        drawing = item;
        break;
      }
    }
    if (drawing != null) {
      final file = File(drawing.imagePath);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    state = state.copyWith(
      drawings: state.drawings
          .where((item) => item.id != drawingId)
          .toList(growable: false),
    );
    _persist();
  }

  void setParentViewEnabled(bool value) {
    state = state.copyWith(parentViewEnabled: value);
    _persist();
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsDuaCreativeState.fromJson(
      _store.getJsonMap(kidsDuaCreativeStorageKeyForLearner(learnerId)),
    );
    _migrateLegacyStateIfNeeded();
  }

  void _persist() {
    _store.setJsonMap(
      kidsDuaCreativeStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyStateIfNeeded() {
    final scopedKey = kidsDuaCreativeStorageKeyForLearner(_activeLearnerId);
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = KidsDuaCreativeState.fromJson(scoped);
      return;
    }

    final legacyScopedLearnerId = legacyKidsDuaScopedLearnerIdForCurrent(
      _activeLearnerId,
    );
    if (legacyScopedLearnerId != null) {
      final legacyScopedKey = kidsDuaCreativeStorageKeyForLearner(
        legacyScopedLearnerId,
      );
      final legacyScoped = _store.getJsonMap(legacyScopedKey);
      if (legacyScoped != null) {
        state = KidsDuaCreativeState.fromJson(legacyScoped);
        _store.setJsonMap(scopedKey, state.toJson());
        _store.remove(legacyScopedKey);
        return;
      }
    }

    final legacy = _store.getJsonMap(legacyKidsDuaCreativeStateKey);
    if (legacy == null) {
      return;
    }
    state = KidsDuaCreativeState.fromJson(legacy);
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(legacyKidsDuaCreativeStateKey);
  }
}
