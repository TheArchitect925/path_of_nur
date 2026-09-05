import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_backgrounds.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_providers.dart';
import '../application/quran_reflections_provider.dart';
import '../application/quran_theme_discovery_provider.dart';
import '../domain/quran_reflection_entry.dart';
import 'quran_learning_path_copy.dart';
import 'quran_summary_theme.dart';
import 'widgets/quran_feature_components.dart';
import 'widgets/quran_feature_header.dart';
import 'widgets/quran_reflection_note_dialog.dart';

enum QuranReflectionFilter { all, favorites, surahs, themes, pathways, recent }

class QuranReflectionsPage extends ConsumerStatefulWidget {
  const QuranReflectionsPage({super.key});

  @override
  ConsumerState<QuranReflectionsPage> createState() =>
      _QuranReflectionsPageState();
}

class _QuranReflectionsPageState extends ConsumerState<QuranReflectionsPage> {
  late final TextEditingController _searchController;
  QuranReflectionFilter _filter = QuranReflectionFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final items = ref.watch(quranReflectionsProvider);
    final query = _searchController.text.trim().toLowerCase();
    final filtered = items
        .where((item) {
          if (!_matchesFilter(item)) {
            return false;
          }
          if (query.isEmpty) {
            return true;
          }
          return _matchesQuery(item, query);
        })
        .toList(growable: false);

    return AppPageScaffold(
      title: l10n.quranReflectionsTitle,
      subtitle: l10n.quranReflectionsSubtitle,
      backgroundOverlayColor: palette.pageOverlay,
      backgroundAtmosphere: AppBackgroundAtmosphere.quran,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranReflectionsLibraryEyebrow,
          primaryTitle: l10n.quranReflectionsLibraryTitle,
          subtitle: l10n.quranReflectionsLibrarySubtitle,
        ),
        const SizedBox(height: 12),
        QuranFeatureSearchCard(
          controller: _searchController,
          hintText: l10n.quranReflectionsSearchHint,
          palette: palette,
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final filter in QuranReflectionFilter.values)
              QuranFeatureFilterChip(
                label: _filterLabel(l10n, filter),
                selected: _filter == filter,
                palette: palette,
                onTap: () => setState(() => _filter = filter),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          QuranFeatureEmptyState(
            title: items.isEmpty
                ? l10n.quranReflectionsEmptyTitle
                : l10n.quranReflectionsNoMatchesTitle,
            subtitle: items.isEmpty
                ? l10n.quranReflectionsEmptySubtitle
                : l10n.quranReflectionsNoMatchesSubtitle,
            palette: palette,
            icon: Icons.menu_book_rounded,
          )
        else
          ...filtered.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReflectionCard(
                entry: item,
                palette: palette,
                onTap: () => context.pushNamed(
                  'quranReflectionDetail',
                  pathParameters: {'reflectionId': item.id},
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _matchesFilter(QuranReflectionEntry item) {
    return switch (_filter) {
      QuranReflectionFilter.all => true,
      QuranReflectionFilter.favorites => item.isFavorite,
      QuranReflectionFilter.surahs => _isSurahReflection(item),
      QuranReflectionFilter.themes => _isThemeReflection(item),
      QuranReflectionFilter.pathways => _isPathwayReflection(item),
      QuranReflectionFilter.recent => _isRecent(item),
    };
  }

  bool _matchesQuery(QuranReflectionEntry item, String query) {
    final l10n = AppLocalizations.of(context);
    final sourceLabel = resolveQuranReflectionSourceLabel(
      context,
      ref,
      item,
      fallbackL10n: l10n,
    );
    final surahName = _surahName(item);
    final haystack = <String>[
      item.title,
      item.summary,
      item.note ?? '',
      sourceLabel,
      surahName,
      item.sourceId ?? '',
      item.themeId ?? '',
      item.pathwayId ?? '',
      item.pathwayStopId ?? '',
      if (item.ref != null) item.ref!.locationLabel,
      if (item.surahNumber != null) item.surahNumber.toString(),
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  String _surahName(QuranReflectionEntry item) {
    final surahNumber = item.surahNumber ?? item.ref?.surah;
    if (surahNumber == null) {
      return '';
    }
    final surah = ref.read(quranSurahMapProvider)[surahNumber];
    if (surah == null) {
      return surahNumber.toString();
    }
    return '${surah.transliteratedName} ${surah.englishName} ${surah.arabicName}';
  }

  bool _isRecent(QuranReflectionEntry item) {
    final updatedAt = DateTime.tryParse(item.updatedAtIso);
    if (updatedAt == null) {
      return false;
    }
    return DateTime.now().difference(updatedAt).inDays <= 14;
  }
}

class QuranReflectionDetailPage extends ConsumerWidget {
  const QuranReflectionDetailPage({super.key, required this.reflectionId});

  final String reflectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final item = ref.watch(quranReflectionByIdProvider(reflectionId));

    if (item == null) {
      return AppPageScaffold(
        title: l10n.quranReflectionsTitle,
        subtitle: l10n.quranReflectionsSubtitle,
        backgroundOverlayColor: palette.pageOverlay,
        children: [
          QuranFeatureEmptyState(
            title: l10n.quranReflectionsMissingTitle,
            subtitle: l10n.quranReflectionsMissingSubtitle,
            palette: palette,
            icon: Icons.search_off_rounded,
          ),
        ],
      );
    }

    final sourceLabel = resolveQuranReflectionSourceLabel(
      context,
      ref,
      item,
      fallbackL10n: l10n,
    );

    return AppPageScaffold(
      title: l10n.quranReflectionsTitle,
      subtitle: sourceLabel,
      backgroundOverlayColor: palette.pageOverlay,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: sourceLabel,
          primaryTitle: item.title,
          subtitle: item.note?.trim().isNotEmpty ?? false
              ? l10n.quranReflectionsSavedInsightSubtitle
              : item.summary,
          metadata: buildQuranFeatureMetadata(
            palette: palette,
            items: [
              (
                label: _formatDate(context, item.updatedAtIso),
                tone: QuranFeatureRevelationTone.neutral,
              ),
              if (item.isFavorite)
                (
                  label: l10n.quranReflectionsFavoritesFilter,
                  tone: QuranFeatureRevelationTone.neutral,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryOverviewTitle,
          palette: palette,
          child: Text(
            item.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.secondaryText,
              height: 1.45,
            ),
          ),
        ),
        if (item.note?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranReflectionsYourReflectionTitle,
            palette: palette,
            child: Text(
              item.note!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.secondaryText,
                height: 1.5,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryActionsTitle,
          palette: palette,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _editReflection(context, ref, item),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l10n.quranReflectionsEditReflectionAction),
              ),
              OutlinedButton.icon(
                onPressed: () => ref
                    .read(quranReflectionsProvider.notifier)
                    .toggleFavorite(item.id),
                icon: Icon(
                  item.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                label: Text(
                  item.isFavorite
                      ? l10n.quranReflectionsRemoveFavoriteAction
                      : l10n.quranReflectionsMarkFavoriteAction,
                ),
              ),
              if (_canOpenSource(item))
                OutlinedButton.icon(
                  onPressed: () => _openSource(context, item),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l10n.quranReflectionsOpenSourceAction),
                ),
              if (item.ref != null)
                TextButton.icon(
                  onPressed: () =>
                      openQuranReferenceLocation(context, ref: item.ref!),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(l10n.quranReflectionsOpenAyahAction),
                ),
              TextButton.icon(
                onPressed: () {
                  ref
                      .read(quranReflectionsProvider.notifier)
                      .removeById(item.id);
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(l10n.quranReflectionsDeleteReflectionAction),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editReflection(
    BuildContext context,
    WidgetRef ref,
    QuranReflectionEntry item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final result = await showQuranReflectionComposerDialog(
      context,
      title: l10n.quranReflectionsEditReflectionAction,
      helperText: l10n.quranReflectionsComposerHelper,
      saveLabel: l10n.quranReflectionsUpdateReflectionAction,
      sourceContextLabel: resolveQuranReflectionSourceLabel(
        context,
        ref,
        item,
        fallbackL10n: l10n,
      ),
      initialNote: item.note,
      initialFavorite: item.isFavorite,
    );
    if (result == null) {
      return;
    }
    ref
        .read(quranReflectionsProvider.notifier)
        .updateEntry(
          id: item.id,
          note: result.note,
          isFavorite: result.isFavorite,
        );
  }
}

class _ReflectionCard extends ConsumerWidget {
  const _ReflectionCard({
    required this.entry,
    required this.palette,
    required this.onTap,
  });

  final QuranReflectionEntry entry;
  final QuranSummaryThemePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sourceLabel = resolveQuranReflectionSourceLabel(
      context,
      ref,
      entry,
      fallbackL10n: l10n,
    );
    final preview = (entry.note?.trim().isNotEmpty ?? false)
        ? entry.note!.trim()
        : entry.summary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: palette.elevatedSurfaceDecoration(
            emphasize: entry.isFavorite,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    QuranFeatureMetadataChip(
                      label: sourceLabel,
                      palette: palette,
                    ),
                    QuranFeatureMetadataChip(
                      label: _formatDate(context, entry.updatedAtIso),
                      palette: palette,
                    ),
                    if (entry.isFavorite)
                      QuranFeatureMetadataChip(
                        label: l10n.quranReflectionsFavoritesFilter,
                        palette: palette,
                        tone: QuranFeatureRevelationTone.makki,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  entry.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  preview,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.secondaryText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        palette.sectionDivider,
                        palette.sectionDivider.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (_canOpenSource(entry))
                      TextButton.icon(
                        onPressed: () => _openSource(context, entry),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: Text(l10n.quranReflectionsOpenSourceAction),
                      ),
                    if (entry.ref != null)
                      TextButton.icon(
                        onPressed: () => openQuranReferenceLocation(
                          context,
                          ref: entry.ref!,
                        ),
                        icon: const Icon(Icons.menu_book_rounded),
                        label: Text(l10n.quranReflectionsOpenAyahAction),
                      ),
                    TextButton.icon(
                      onPressed: () => ref
                          .read(quranReflectionsProvider.notifier)
                          .toggleFavorite(entry.id),
                      icon: Icon(
                        entry.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                      ),
                      label: Text(
                        entry.isFavorite
                            ? l10n.quranReflectionsRemoveFavoriteAction
                            : l10n.quranReflectionsMarkFavoriteAction,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String resolveQuranReflectionSourceLabel(
  BuildContext context,
  WidgetRef ref,
  QuranReflectionEntry entry, {
  required AppLocalizations fallbackL10n,
}) {
  if (entry.sourceLabel?.trim().isNotEmpty ?? false) {
    return entry.sourceLabel!;
  }

  if (_isSurahReflection(entry)) {
    final surahNumber = entry.surahNumber ?? entry.ref?.surah;
    if (surahNumber != null) {
      final surah = ref.watch(quranSurahMapProvider)[surahNumber];
      if (surah != null) {
        return surah.transliteratedName;
      }
    }
  }

  if (_isThemeReflection(entry) && entry.themeId != null) {
    final theme = ref.watch(quranThemeByIdProvider(entry.themeId!));
    if (theme != null) {
      return theme.title;
    }
  }

  if (entry.pathwayId != null) {
    return localizedQuranLearningPathTitle(fallbackL10n, entry.pathwayId!);
  }

  return switch (entry.sourceType) {
    QuranReflectionSourceType.dailyAyah =>
      fallbackL10n.quranReflectionsSourceDailyAyah,
    QuranReflectionSourceType.ayahInsight =>
      fallbackL10n.quranReflectionsSourceAyahInsight,
    QuranReflectionSourceType.relatedAyah =>
      fallbackL10n.quranReflectionsSourceRelatedAyah,
    QuranReflectionSourceType.pathItem =>
      fallbackL10n.quranReflectionsSourcePathItem,
    QuranReflectionSourceType.surahDetail =>
      fallbackL10n.quranReflectionsSourceSurah,
    QuranReflectionSourceType.themeDetail =>
      fallbackL10n.quranReflectionsSourceTheme,
    QuranReflectionSourceType.pathway =>
      fallbackL10n.quranReflectionsSourcePathway,
    QuranReflectionSourceType.pathwayStop =>
      fallbackL10n.quranReflectionsSourcePathwayStop,
    QuranReflectionSourceType.ayahReflection =>
      fallbackL10n.quranReflectionsSourceAyahReflection,
    QuranReflectionSourceType.quranCompanionPrompt =>
      fallbackL10n.quranReflectionsSourceCompanion,
    QuranReflectionSourceType.readerContext =>
      fallbackL10n.quranReflectionsSourceReader,
  };
}

String _filterLabel(AppLocalizations l10n, QuranReflectionFilter filter) {
  return switch (filter) {
    QuranReflectionFilter.all => l10n.quranSummaryFilterAll,
    QuranReflectionFilter.favorites => l10n.quranReflectionsFavoritesFilter,
    QuranReflectionFilter.surahs => l10n.quranReflectionsFilterSurahs,
    QuranReflectionFilter.themes => l10n.quranReflectionsFilterThemes,
    QuranReflectionFilter.pathways => l10n.quranReflectionsFilterPathways,
    QuranReflectionFilter.recent => l10n.quranReflectionsFilterRecent,
  };
}

String _formatDate(BuildContext context, String iso) {
  final date = DateTime.tryParse(iso)?.toLocal();
  if (date == null) {
    return '';
  }
  final localizations = MaterialLocalizations.of(context);
  return localizations.formatShortDate(date);
}

bool _canOpenSource(QuranReflectionEntry item) {
  return (item.routeName?.trim().isNotEmpty ?? false) || item.ref != null;
}

void _openSource(BuildContext context, QuranReflectionEntry item) {
  final routeName = item.routeName;
  if (routeName?.trim().isNotEmpty ?? false) {
    context.pushNamed(
      routeName!,
      pathParameters: item.pathParameters,
      queryParameters: item.queryParameters,
    );
    return;
  }
  if (item.ref != null) {
    openQuranReferenceLocation(context, ref: item.ref!);
  }
}

bool _isSurahReflection(QuranReflectionEntry item) {
  return switch (item.sourceType) {
    QuranReflectionSourceType.dailyAyah ||
    QuranReflectionSourceType.ayahInsight ||
    QuranReflectionSourceType.relatedAyah ||
    QuranReflectionSourceType.surahDetail ||
    QuranReflectionSourceType.ayahReflection ||
    QuranReflectionSourceType.readerContext => true,
    _ => false,
  };
}

bool _isThemeReflection(QuranReflectionEntry item) {
  return item.sourceType == QuranReflectionSourceType.themeDetail;
}

bool _isPathwayReflection(QuranReflectionEntry item) {
  return item.sourceType == QuranReflectionSourceType.pathway ||
      item.sourceType == QuranReflectionSourceType.pathwayStop ||
      item.sourceType == QuranReflectionSourceType.pathItem;
}
