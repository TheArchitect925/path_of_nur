import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_backgrounds.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../application/quran_guided_learning_paths_provider.dart';
import '../application/quran_theme_discovery_provider.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reflection_entry.dart';
import '../domain/quran_guided_learning_path_models.dart';
import 'quran_learning_path_copy.dart';
import 'quran_summary_theme.dart';
import 'widgets/quran_feature_components.dart';
import 'widgets/quran_feature_header.dart';
import 'widgets/quran_reflection_capture.dart';

class QuranLearningPathsPage extends ConsumerStatefulWidget {
  const QuranLearningPathsPage({super.key});

  @override
  ConsumerState<QuranLearningPathsPage> createState() =>
      _QuranLearningPathsPageState();
}

class _QuranLearningPathsPageState
    extends ConsumerState<QuranLearningPathsPage> {
  QuranGuidedLearningPathCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final allPaths = ref.watch(quranGuidedLearningPathsProvider);
    final featuredPaths = ref.watch(quranGuidedFeaturedLearningPathsProvider);
    final continuePath = ref.watch(quranGuidedContinuePathProvider);
    final filteredPaths = allPaths
        .where((path) {
          if (_selectedCategory == null) return true;
          return path.category == _selectedCategory;
        })
        .toList(growable: false);

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.quranLearningPathsTitle,
      subtitle: l10n.quranLearningPathsSubtitle,
      backgroundOverlayColor: palette.pageOverlay,
      backgroundAtmosphere: AppBackgroundAtmosphere.quran,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranPathwaysHeroEyebrow,
          primaryTitle: l10n.quranPathwaysHeroTitle,
          subtitle: l10n.quranPathwaysHeroSubtitle,
        ),
        const SizedBox(height: 12),
        if (continuePath != null) ...[
          _ContinuePathCard(path: continuePath, palette: palette),
          const SizedBox(height: 12),
        ],
        QuranFeatureSectionCard(
          title: l10n.quranThemeDiscoveryBrowseByCategoryTitle,
          palette: palette,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              QuranFeatureFilterChip(
                label: l10n.quranSummaryFilterAll,
                selected: _selectedCategory == null,
                palette: palette,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              for (final category in QuranGuidedLearningPathCategory.values)
                QuranFeatureFilterChip(
                  label: localizedQuranLearningPathCategoryLabel(
                    l10n,
                    category,
                  ),
                  selected: _selectedCategory == category,
                  palette: palette,
                  onTap: () => setState(() => _selectedCategory = category),
                ),
            ],
          ),
        ),
        if (_selectedCategory == null && featuredPaths.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranPathwaysFeaturedTitle,
            palette: palette,
            child: Column(
              children: [
                for (final path in featuredPaths)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PathwayCard(path: path, palette: palette),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (filteredPaths.isEmpty)
          QuranFeatureEmptyState(
            title: l10n.quranPathwaysEmptyTitle,
            subtitle: l10n.quranPathwaysEmptySubtitle,
            palette: palette,
            icon: Icons.route_outlined,
          )
        else
          QuranFeatureSectionCard(
            title: l10n.quranPathwaysAllTitle,
            subtitle: l10n.quranPathwaysCountLabel(filteredPaths.length),
            palette: palette,
            child: Column(
              children: [
                for (final path in filteredPaths)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PathwayCard(path: path, palette: palette),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class QuranLearningPathDetailPage extends ConsumerWidget {
  const QuranLearningPathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final path = ref.watch(quranGuidedLearningPathByIdProvider(pathId));
    if (path == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.quranLearningPathsTitle,
        subtitle: l10n.quranLearningPathsSubtitle,
        backgroundOverlayColor: palette.pageOverlay,
        children: [
          QuranFeatureEmptyState(
            title: l10n.quranPathwaysMissingTitle,
            subtitle: l10n.quranPathwaysMissingSubtitle,
            palette: palette,
            icon: Icons.route_outlined,
          ),
        ],
      );
    }

    final progress = ref.watch(quranGuidedPathProgressByIdProvider(path.id));
    final nextStep = ref.watch(quranGuidedNextStepForPathProvider(path.id));
    final isStarted = progress?.isStarted ?? false;
    final isCompleted = progress?.isCompleted ?? false;
    final completedCount = progress?.completedStopIds.length ?? 0;
    final completion = progress?.completionRatio(path.steps.length) ?? 0;
    final primaryAyah = path.steps
        .expand((step) => step.ayahReferences)
        .cast<QuranGuidedLearningAyahReference?>()
        .firstWhere((item) => item != null, orElse: () => null);

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: localizedQuranLearningPathTitle(l10n, path.id),
      subtitle: localizedQuranLearningPathSubtitle(l10n, path.id),
      backgroundOverlayColor: palette.pageOverlay,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: localizedQuranLearningPathCategoryLabel(
            l10n,
            path.category,
          ),
          primaryTitle: localizedQuranLearningPathTitle(l10n, path.id),
          subtitle: localizedQuranLearningPathSubtitle(l10n, path.id),
          metadata: buildQuranFeatureMetadata(
            palette: palette,
            items: [
              (
                label: localizedQuranLearningPathCategoryLabel(
                  l10n,
                  path.category,
                ),
                tone: QuranFeatureRevelationTone.neutral,
              ),
              (
                label: localizedQuranLearningPathIntensityLabel(
                  l10n,
                  path.intensity,
                ),
                tone: QuranFeatureRevelationTone.neutral,
              ),
              (
                label: l10n.quranPathwaysEstimatedLengthLabel(
                  path.estimatedMinutes,
                ),
                tone: QuranFeatureRevelationTone.neutral,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryOverviewTitle,
          subtitle: localizedQuranLearningPathStatusLabel(
            l10n,
            isStarted,
            isCompleted,
          ),
          palette: palette,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedQuranLearningPathDescription(l10n, path.id),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.secondaryText,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              _ProgressStrip(
                palette: palette,
                progress: completion,
                label: l10n.quranPathwaysProgressLabel(
                  completedCount,
                  path.steps.length,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _openPathStop(
                      context,
                      ref,
                      path,
                      nextStep ?? path.steps.first,
                    ),
                    icon: Icon(
                      isStarted
                          ? Icons.play_circle_outline_rounded
                          : Icons.route_rounded,
                    ),
                    label: Text(
                      isStarted
                          ? l10n.quranPathwaysResumeAction
                          : l10n.quranPathwaysStartAction,
                    ),
                  ),
                  if (path.relatedPathIds.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed('quranLearningPaths'),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: Text(l10n.quranLearningPathsBrowseAllAction),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => captureQuranReflection(
                      context,
                      ref,
                      sourceType: QuranReflectionSourceType.pathway,
                      title: localizedQuranLearningPathTitle(l10n, path.id),
                      summary: localizedQuranLearningPathDescription(
                        l10n,
                        path.id,
                      ),
                      sourceId: 'path:${path.id}',
                      sourceLabel: localizedQuranLearningPathTitle(
                        l10n,
                        path.id,
                      ),
                      quoteRef: primaryAyah == null
                          ? null
                          : QuranQuoteRef(
                              surah: primaryAyah.surahNumber,
                              ayah: primaryAyah.ayahNumber,
                              ayahEnd: primaryAyah.endAyahNumber,
                            ),
                      pathwayId: path.id,
                      routeName: 'quranLearningPathDetail',
                      pathParameters: {'pathId': path.id},
                      helperText: l10n.quranReflectionsPathwayHelper(
                        localizedQuranLearningPathTitle(l10n, path.id),
                      ),
                    ),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Text(l10n.quranReflectionsSaveReflectionAction),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranPathwaysStopsTitle,
          subtitle: l10n.quranLearningPathsStepCountLabel(path.steps.length),
          palette: palette,
          child: Column(
            children: [
              for (final entry in path.steps.asMap().entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PathwayStopCard(
                    path: path,
                    step: entry.value,
                    stepNumber: entry.key + 1,
                    palette: palette,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuranLearningPathStopDetailPage extends ConsumerStatefulWidget {
  const QuranLearningPathStopDetailPage({
    super.key,
    required this.pathId,
    required this.stopId,
  });

  final String pathId;
  final String stopId;

  @override
  ConsumerState<QuranLearningPathStopDetailPage> createState() =>
      _QuranLearningPathStopDetailPageState();
}

class _QuranLearningPathStopDetailPageState
    extends ConsumerState<QuranLearningPathStopDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final path = ref.read(quranGuidedLearningPathByIdProvider(widget.pathId));
      if (path == null) return;
      final stop = _findStop(path, widget.stopId);
      if (stop == null) return;
      ref
          .read(quranGuidedLearningContinuityProvider.notifier)
          .markStepOpened(pathId: path.id, stepId: stop.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final path = ref.watch(quranGuidedLearningPathByIdProvider(widget.pathId));
    if (path == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.quranLearningPathsTitle,
        subtitle: l10n.quranLearningPathsSubtitle,
        backgroundOverlayColor: palette.pageOverlay,
        children: [
          QuranFeatureEmptyState(
            title: l10n.quranPathwaysMissingTitle,
            subtitle: l10n.quranPathwaysMissingSubtitle,
            palette: palette,
            icon: Icons.route_outlined,
          ),
        ],
      );
    }

    final stop = _findStop(path, widget.stopId);
    if (stop == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: localizedQuranLearningPathTitle(l10n, path.id),
        subtitle: localizedQuranLearningPathSubtitle(l10n, path.id),
        backgroundOverlayColor: palette.pageOverlay,
        children: [
          QuranFeatureEmptyState(
            title: l10n.quranPathwaysStopMissingTitle,
            subtitle: l10n.quranPathwaysStopMissingSubtitle,
            palette: palette,
            icon: Icons.route_outlined,
          ),
        ],
      );
    }

    final stepIndex = path.steps.indexWhere((item) => item.id == stop.id);
    final progress = ref.watch(quranGuidedPathProgressByIdProvider(path.id));
    final isCompleted = progress?.completedStopIds.contains(stop.id) ?? false;
    final nextStep = _nextStep(path, stop.id);
    final reflectionPrompt = localizedQuranLearningPathStepReflectionPrompt(
      l10n,
      stop.id,
    );
    final primaryAyah = stop.ayahReferences.isEmpty
        ? null
        : stop.ayahReferences.first;

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: localizedQuranLearningPathTitle(l10n, path.id),
      subtitle: localizedQuranLearningPathStepTitle(l10n, stop.id),
      backgroundOverlayColor: palette.pageOverlay,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranPathwaysStopNumberLabel(stepIndex + 1),
          primaryTitle: localizedQuranLearningPathStepTitle(l10n, stop.id),
          subtitle: localizedQuranLearningPathStepSubtitle(l10n, stop.id),
          metadata: buildQuranFeatureMetadata(
            palette: palette,
            items: [
              (
                label: localizedQuranLearningPathStatusLabel(
                  l10n,
                  true,
                  isCompleted,
                ),
                tone: QuranFeatureRevelationTone.neutral,
              ),
              (
                label: l10n.quranPathwaysEstimatedLengthLabel(
                  stop.estimatedMinutes,
                ),
                tone: QuranFeatureRevelationTone.neutral,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (stop.ayahReferences.isNotEmpty)
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryKeyAyahReferencesTitle,
            palette: palette,
            child: Column(
              children: [
                for (final reference in stop.ayahReferences)
                  QuranReferenceLinkTile(
                    referenceLabel: reference.label,
                    subtitle: reference.subtitle,
                    surahNumber: reference.surahNumber,
                    fallbackStartAyah: reference.ayahNumber,
                    endAyahNumber: reference.endAyahNumber,
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
              ],
            ),
          ),
        if (stop.ayahReferences.isNotEmpty) const SizedBox(height: 12),
        if (reflectionPrompt.trim().isNotEmpty)
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryReflectionTitle,
            palette: palette,
            child: Text(
              reflectionPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.secondaryText,
                height: 1.45,
              ),
            ),
          ),
        if (reflectionPrompt.trim().isNotEmpty) const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryActionsTitle,
          palette: palette,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _openLinkedDestination(context, stop),
                icon: Icon(_iconForStepKind(stop.kind)),
                label: Text(_primaryActionLabel(l10n, stop.kind)),
              ),
              if (!isCompleted)
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(quranGuidedLearningContinuityProvider.notifier)
                        .markStepCompleted(path: path, stepId: stop.id);
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(l10n.quranPathwaysMarkCompleteAction),
                )
              else
                QuranFeatureMetadataChip(
                  label: l10n.quranPathwaysCompleteLabel,
                  palette: palette,
                ),
              if (nextStep != null)
                TextButton.icon(
                  onPressed: () => _openPathStop(context, ref, path, nextStep),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.quranPathwaysNextStopAction),
                ),
              OutlinedButton.icon(
                onPressed: () => captureQuranReflection(
                  context,
                  ref,
                  sourceType: QuranReflectionSourceType.pathwayStop,
                  title: localizedQuranLearningPathStepTitle(l10n, stop.id),
                  summary: localizedQuranLearningPathStepSubtitle(
                    l10n,
                    stop.id,
                  ),
                  sourceId: 'path-stop:${path.id}:${stop.id}',
                  sourceLabel: localizedQuranLearningPathStepTitle(
                    l10n,
                    stop.id,
                  ),
                  quoteRef: primaryAyah == null
                      ? null
                      : QuranQuoteRef(
                          surah: primaryAyah.surahNumber,
                          ayah: primaryAyah.ayahNumber,
                          ayahEnd: primaryAyah.endAyahNumber,
                        ),
                  surahNumber: stop.relatedSurahNumber,
                  themeId: stop.relatedThemeId,
                  pathwayId: path.id,
                  pathwayStopId: stop.id,
                  promptLabel: reflectionPrompt.trim().isEmpty
                      ? null
                      : reflectionPrompt,
                  routeName: 'quranLearningPathStopDetail',
                  pathParameters: {'pathId': path.id, 'stopId': stop.id},
                  helperText: l10n.quranReflectionsPathwayStopHelper(
                    localizedQuranLearningPathStepTitle(l10n, stop.id),
                  ),
                ),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l10n.quranReflectionsSaveReflectionAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContinuePathCard extends ConsumerWidget {
  const _ContinuePathCard({required this.path, required this.palette});

  final QuranGuidedLearningPath path;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(quranGuidedPathProgressByIdProvider(path.id));
    final nextStep = ref.watch(quranGuidedNextStepForPathProvider(path.id));
    final completedCount = progress?.completedStopIds.length ?? 0;
    final completion = progress?.completionRatio(path.steps.length) ?? 0;

    return QuranFeatureSectionCard(
      title: l10n.quranPathwaysContinueTitle,
      subtitle: nextStep == null
          ? localizedQuranLearningPathTitle(l10n, path.id)
          : l10n.quranLearningPathsContinueSubtitle(
              localizedQuranLearningPathTitle(l10n, path.id),
              localizedQuranLearningPathStepTitle(l10n, nextStep.id),
            ),
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressStrip(
            palette: palette,
            progress: completion,
            label: l10n.quranPathwaysProgressLabel(
              completedCount,
              path.steps.length,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () =>
                _openPathStop(context, ref, path, nextStep ?? path.steps.first),
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: Text(l10n.quranPathwaysResumeAction),
          ),
        ],
      ),
    );
  }
}

class _PathwayCard extends ConsumerWidget {
  const _PathwayCard({required this.path, required this.palette});

  final QuranGuidedLearningPath path;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(quranGuidedPathProgressByIdProvider(path.id));
    final isStarted = progress?.isStarted ?? false;
    final isCompleted = progress?.isCompleted ?? false;
    final completion = progress?.completionRatio(path.steps.length) ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          'quranLearningPathDetail',
          pathParameters: {'pathId': path.id},
        ),
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: palette.elevatedSurfaceDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedQuranLearningPathTitle(l10n, path.id),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  localizedQuranLearningPathSubtitle(l10n, path.id),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.supportText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  localizedQuranLearningPathDescription(l10n, path.id),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.supportText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    QuranFeatureMetadataChip(
                      label: localizedQuranLearningPathCategoryLabel(
                        l10n,
                        path.category,
                      ),
                      palette: palette,
                    ),
                    QuranFeatureMetadataChip(
                      label: localizedQuranLearningPathIntensityLabel(
                        l10n,
                        path.intensity,
                      ),
                      palette: palette,
                    ),
                    QuranFeatureMetadataChip(
                      label: l10n.quranLearningPathsStepCountLabel(
                        path.steps.length,
                      ),
                      palette: palette,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ProgressStrip(
                  palette: palette,
                  progress: completion,
                  label: localizedQuranLearningPathStatusLabel(
                    l10n,
                    isStarted,
                    isCompleted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PathwayStopCard extends ConsumerWidget {
  const _PathwayStopCard({
    required this.path,
    required this.step,
    required this.stepNumber,
    required this.palette,
  });

  final QuranGuidedLearningPath path;
  final QuranGuidedLearningPathStep step;
  final int stepNumber;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(quranGuidedPathProgressByIdProvider(path.id));
    final isCompleted = progress?.completedStopIds.contains(step.id) ?? false;
    final isCurrent =
        ref.watch(quranGuidedNextStepForPathProvider(path.id))?.id == step.id;
    final themeTitle = step.relatedThemeId == null
        ? null
        : ref.watch(quranThemeByIdProvider(step.relatedThemeId!))?.title;

    return Container(
      width: double.infinity,
      decoration: palette.subtlePanelDecoration(
        radius: 20,
        emphasize: isCurrent || isCompleted,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openPathStop(context, ref, path, step),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: palette.numberFill,
                    child: Text(
                      '$stepNumber',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.goldAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      localizedQuranLearningPathStepTitle(l10n, step.id),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: palette.primaryText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                localizedQuranLearningPathStepSubtitle(l10n, step.id),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.secondaryText,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  QuranFeatureMetadataChip(
                    label: isCompleted
                        ? l10n.quranPathwaysCompleteLabel
                        : (isCurrent
                              ? l10n.quranPathwaysCurrentStopLabel
                              : l10n.quranPathwaysOpenStopAction),
                    palette: palette,
                    tone: isCompleted
                        ? QuranFeatureRevelationTone.makki
                        : (isCurrent
                              ? QuranFeatureRevelationTone.madani
                              : QuranFeatureRevelationTone.neutral),
                  ),
                  if (step.relatedSurahNumber != null)
                    QuranFeatureMetadataChip(
                      label: l10n.quranPathwaysSurahLabel(
                        step.relatedSurahNumber!,
                      ),
                      palette: palette,
                    ),
                  if (step.relatedThemeId != null)
                    QuranFeatureMetadataChip(
                      label: themeTitle ?? step.relatedThemeId!,
                      palette: palette,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({
    required this.palette,
    required this.progress,
    required this.label,
  });

  final QuranSummaryThemePalette palette;
  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: palette.supportText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 8,
            backgroundColor: palette.progressTrack,
            valueColor: AlwaysStoppedAnimation<Color>(palette.progressFill),
          ),
        ),
      ],
    );
  }
}

QuranGuidedLearningPathStep? _findStop(
  QuranGuidedLearningPath path,
  String stopId,
) {
  for (final step in path.steps) {
    if (step.id == stopId) return step;
  }
  return null;
}

QuranGuidedLearningPathStep? _nextStep(
  QuranGuidedLearningPath path,
  String stopId,
) {
  final index = path.steps.indexWhere((step) => step.id == stopId);
  if (index == -1 || index + 1 >= path.steps.length) return null;
  return path.steps[index + 1];
}

void _openPathStop(
  BuildContext context,
  WidgetRef ref,
  QuranGuidedLearningPath path,
  QuranGuidedLearningPathStep step,
) {
  ref
      .read(quranGuidedLearningContinuityProvider.notifier)
      .markStepOpened(pathId: path.id, stepId: step.id);
  context.pushNamed(
    'quranLearningPathStopDetail',
    pathParameters: {'pathId': path.id, 'stopId': step.id},
  );
}

void _openLinkedDestination(
  BuildContext context,
  QuranGuidedLearningPathStep step,
) {
  context.pushNamed(
    step.routeName,
    pathParameters: step.pathParameters,
    queryParameters: step.queryParameters,
  );
}

IconData _iconForStepKind(QuranGuidedLearningStepKind kind) {
  return switch (kind) {
    QuranGuidedLearningStepKind.surahSummary => Icons.auto_stories_rounded,
    QuranGuidedLearningStepKind.themeDetail => Icons.account_tree_outlined,
    QuranGuidedLearningStepKind.ayahReflection => Icons.menu_book_outlined,
    QuranGuidedLearningStepKind.guidedReflection =>
      Icons.self_improvement_rounded,
    QuranGuidedLearningStepKind.readerEntry => Icons.menu_book_rounded,
    QuranGuidedLearningStepKind.prophetStoryAnchor =>
      Icons.travel_explore_rounded,
  };
}

String _primaryActionLabel(
  AppLocalizations l10n,
  QuranGuidedLearningStepKind kind,
) {
  return switch (kind) {
    QuranGuidedLearningStepKind.surahSummary =>
      l10n.quranSummaryViewDetailsAction,
    QuranGuidedLearningStepKind.themeDetail =>
      l10n.quranThemeDiscoveryExploreThemeAction,
    QuranGuidedLearningStepKind.ayahReflection =>
      l10n.quranSummaryOpenReaderAction,
    QuranGuidedLearningStepKind.guidedReflection =>
      l10n.quranPathwaysReflectAction,
    QuranGuidedLearningStepKind.readerEntry =>
      l10n.quranSummaryOpenReaderAction,
    QuranGuidedLearningStepKind.prophetStoryAnchor =>
      l10n.quranPathwaysOpenStopAction,
  };
}
