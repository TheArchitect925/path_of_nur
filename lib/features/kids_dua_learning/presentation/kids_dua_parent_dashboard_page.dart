import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_experience_provider.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaParentDashboardPage extends ConsumerWidget {
  const KidsDuaParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashboard = ref.watch(kidsDuaParentDashboardProvider);
    final creative = ref.watch(kidsDuaCreativeProvider);
    final light = ref.watch(kidsDuaLightSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaParentTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: Text(l10n.kidsDuaParentViewToggleTitle),
            subtitle: Text(l10n.kidsDuaParentViewToggleBody),
            value: creative.parentViewEnabled,
            onChanged: (value) => ref
                .read(kidsDuaCreativeProvider.notifier)
                .setParentViewEnabled(value),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaParentOverviewTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _Pill(
                      label: l10n.kidsDuaLearnedCountValue(
                        dashboard.totalDuasLearned,
                      ),
                    ),
                    _Pill(label: l10n.kidsDuaStreakValue(dashboard.streakDays)),
                    _Pill(
                      label: l10n.kidsDuaLightValue(
                        _lightLabel(l10n, light.lightLabelKey),
                      ),
                    ),
                    _Pill(
                      label: dashboard.todayCompleted
                          ? l10n.kidsDuaParentTodayDone
                          : l10n.kidsDuaParentTodayPending,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaParentLearningTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ...dashboard.categoryProgress.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.categoryTitle)),
                        Text(
                          l10n.kidsDuaParentCategoryProgress(
                            item.learnedCount,
                            item.totalCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaParentActivityTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                if (dashboard.recentActivity.isEmpty)
                  Text(l10n.kidsDuaParentActivityEmpty)
                else
                  ...dashboard.recentActivity
                      .take(6)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(_activityLabel(l10n, item)),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.kidsDuaParentDrawingsTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed('kidsDuaDrawings'),
                      child: Text(l10n.kidsDuaParentOpenGalleryAction),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (dashboard.drawings.isEmpty)
                  Text(l10n.kidsDuaParentDrawingsEmpty)
                else
                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: dashboard.drawings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final drawing = dashboard.drawings[index];
                        return InkWell(
                          onTap: () => context.pushNamed(
                            'kidsDuaDrawingViewer',
                            pathParameters: {'drawingId': drawing.id},
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(drawing.imagePath),
                              width: 108,
                              height: 108,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                    color: Color(0xFFFFF8EF),
                                    child: SizedBox(
                                      width: 108,
                                      height: 108,
                                      child: Icon(Icons.brush_rounded),
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

String _lightLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'kidsDuaLightSeedLabel':
      return l10n.kidsDuaLightSeedLabel;
    case 'kidsDuaLightGlowLabel':
      return l10n.kidsDuaLightGlowLabel;
    case 'kidsDuaLightLanternLabel':
      return l10n.kidsDuaLightLanternLabel;
    case 'kidsDuaLightMoonLabel':
      return l10n.kidsDuaLightMoonLabel;
    case 'kidsDuaLightStarLabel':
      return l10n.kidsDuaLightStarLabel;
    default:
      return l10n.kidsDuaLightRadiantLabel;
  }
}

String _activityLabel(AppLocalizations l10n, KidsDuaActivityLogEntry item) {
  switch (item.type) {
    case KidsDuaActivityLogType.lessonCompleted:
      return l10n.kidsDuaParentActivityLessonDone;
    case KidsDuaActivityLogType.myDayCompleted:
      return l10n.kidsDuaParentActivityMyDayDone;
    case KidsDuaActivityLogType.myDayStepCompleted:
      return l10n.kidsDuaParentActivityStepDone;
    case KidsDuaActivityLogType.practiceCorrect:
      return l10n.kidsDuaParentActivityPracticeDone;
    case KidsDuaActivityLogType.drawingSaved:
      return l10n.kidsDuaParentActivityDrawingSaved;
    case KidsDuaActivityLogType.storyCompleted:
      return l10n.kidsDuaParentActivityStoryDone;
  }
}
