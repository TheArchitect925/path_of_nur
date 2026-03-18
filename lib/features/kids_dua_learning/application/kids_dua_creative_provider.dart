import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_experience_provider.dart';
import 'kids_dua_progress_provider.dart';

const _kidsDuaCreativeStateKey = 'kids.dua.creative.v1';

final kidsDuaDrawingDirectoryProvider = FutureProvider<Directory>((ref) async {
  final base = await getApplicationDocumentsDirectory();
  final dir = Directory('${base.path}/kids_dua_drawings');
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  return dir;
});

final kidsDuaCreativeProvider =
    StateNotifierProvider<KidsDuaCreativeNotifier, KidsDuaCreativeState>((ref) {
      return KidsDuaCreativeNotifier(ref);
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
      super(
        KidsDuaCreativeState.fromJson(
          _ref.read(localStoreProvider).getJsonMap(_kidsDuaCreativeStateKey),
        ),
      );

  final Ref _ref;
  final LocalStore _store;

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

  void _persist() {
    _store.setJsonMap(_kidsDuaCreativeStateKey, state.toJson());
  }
}
