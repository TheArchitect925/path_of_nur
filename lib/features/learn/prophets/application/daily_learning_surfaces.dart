import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import 'daily_learning_service.dart';

@immutable
class ProphetDailySurfaceSnapshot {
  const ProphetDailySurfaceSnapshot({
    required this.dateKey,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.quizQuestionId,
    required this.quizCompleted,
    required this.cardOpened,
    required this.deepLinkLearn,
    required this.deepLinkProphet,
    required this.deepLinkQuiz,
    required this.updatedAtIso,
  });

  final String dateKey;
  final String title;
  final String? subtitle;
  final String body;
  final String quizQuestionId;
  final bool quizCompleted;
  final bool cardOpened;
  final String deepLinkLearn;
  final String? deepLinkProphet;
  final String deepLinkQuiz;
  final String updatedAtIso;

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'quizQuestionId': quizQuestionId,
      'quizCompleted': quizCompleted,
      'cardOpened': cardOpened,
      'deepLinkLearn': deepLinkLearn,
      'deepLinkProphet': deepLinkProphet,
      'deepLinkQuiz': deepLinkQuiz,
      'updatedAtIso': updatedAtIso,
    };
  }
}

abstract class ProphetDailyWidgetSyncAdapter {
  Future<void> syncSnapshot(ProphetDailySurfaceSnapshot snapshot);
}

abstract class ProphetDailyLockSurfaceSyncAdapter {
  Future<void> syncSnapshot(ProphetDailySurfaceSnapshot snapshot);
}

abstract class ProphetDailyNotificationHookAdapter {
  Future<void> syncDailyNotificationDraft(ProphetDailySurfaceSnapshot snapshot);
}

class LocalStoreProphetDailyWidgetSyncAdapter
    implements ProphetDailyWidgetSyncAdapter {
  const LocalStoreProphetDailyWidgetSyncAdapter(this._store);

  final LocalStore _store;

  @override
  Future<void> syncSnapshot(ProphetDailySurfaceSnapshot snapshot) async {
    await _store.setJsonMap(
      'learn.prophets.daily.widget.snapshot.v1',
      snapshot.toJson(),
    );
  }
}

class LocalStoreProphetDailyLockSurfaceSyncAdapter
    implements ProphetDailyLockSurfaceSyncAdapter {
  const LocalStoreProphetDailyLockSurfaceSyncAdapter(this._store);

  final LocalStore _store;

  @override
  Future<void> syncSnapshot(ProphetDailySurfaceSnapshot snapshot) async {
    await _store.setJsonMap('learn.prophets.daily.lock.snapshot.v1', {
      'dateKey': snapshot.dateKey,
      'title': snapshot.title,
      'subtitle': snapshot.subtitle,
      'quizCompleted': snapshot.quizCompleted,
      'deepLink': snapshot.deepLinkLearn,
      'updatedAtIso': snapshot.updatedAtIso,
    });
  }
}

class LocalStoreProphetDailyNotificationHookAdapter
    implements ProphetDailyNotificationHookAdapter {
  const LocalStoreProphetDailyNotificationHookAdapter(this._store);

  final LocalStore _store;

  @override
  Future<void> syncDailyNotificationDraft(
    ProphetDailySurfaceSnapshot snapshot,
  ) async {
    await _store.setJsonMap('learn.prophets.daily.notification.draft.v1', {
      'id': 'prophets.daily.${snapshot.dateKey}',
      'title': snapshot.title,
      'body': snapshot.subtitle ?? 'A small reminder for the heart',
      'quietDelivery': true,
      'deepLink': snapshot.deepLinkLearn,
      'dateKey': snapshot.dateKey,
      'updatedAtIso': snapshot.updatedAtIso,
    });
  }
}

final prophetDailyWidgetSyncAdapterProvider =
    Provider<ProphetDailyWidgetSyncAdapter>((ref) {
      return LocalStoreProphetDailyWidgetSyncAdapter(
        ref.watch(localStoreProvider),
      );
    });

final prophetDailyLockSurfaceSyncAdapterProvider =
    Provider<ProphetDailyLockSurfaceSyncAdapter>((ref) {
      return LocalStoreProphetDailyLockSurfaceSyncAdapter(
        ref.watch(localStoreProvider),
      );
    });

final prophetDailyNotificationHookAdapterProvider =
    Provider<ProphetDailyNotificationHookAdapter>((ref) {
      return LocalStoreProphetDailyNotificationHookAdapter(
        ref.watch(localStoreProvider),
      );
    });

final prophetDailySurfaceSnapshotProvider =
    Provider<ProphetDailySurfaceSnapshot>((ref) {
      final bundle = ref.watch(todayDailyLearningBundleProvider);
      final item = bundle.item;
      final prophetPath = item.linkedProphetId == null
          ? null
          : '/learn/prophets?prophet=${item.linkedProphetId}';

      return ProphetDailySurfaceSnapshot(
        dateKey: bundle.dateKey,
        title: item.title,
        subtitle: item.subtitle,
        body: item.body,
        quizQuestionId: bundle.quizQuestion.id,
        quizCompleted: bundle.status.quizAnswered,
        cardOpened: bundle.status.cardOpened,
        deepLinkLearn: '/learn/prophets',
        deepLinkProphet: prophetPath,
        deepLinkQuiz: '/learn/prophets?tab=quiz',
        updatedAtIso: DateTime.now().toIso8601String(),
      );
    });

final prophetDailySurfacesBootstrapProvider = Provider<void>((ref) {
  final store = ref.read(localStoreProvider);
  final widgetAdapter = ref.read(prophetDailyWidgetSyncAdapterProvider);
  final lockAdapter = ref.read(prophetDailyLockSurfaceSyncAdapterProvider);
  final notificationAdapter = ref.read(
    prophetDailyNotificationHookAdapterProvider,
  );

  ref.listen<ProphetDailySurfaceSnapshot>(prophetDailySurfaceSnapshotProvider, (
    _,
    snapshot,
  ) {
    Future<void>.microtask(() async {
      await store.setJsonMap('learn.prophets.daily.deeplinks.v1', {
        'learn': snapshot.deepLinkLearn,
        'quiz': snapshot.deepLinkQuiz,
        'prophet': snapshot.deepLinkProphet,
      });
      await widgetAdapter.syncSnapshot(snapshot);
      await lockAdapter.syncSnapshot(snapshot);
      await notificationAdapter.syncDailyNotificationDraft(snapshot);
    });
  }, fireImmediately: true);
});
