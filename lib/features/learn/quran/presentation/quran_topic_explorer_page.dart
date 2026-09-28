import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_backgrounds.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../application/quran_theme_discovery_provider.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reflection_entry.dart';
import '../domain/quran_surah_summary_models.dart';
import '../domain/quran_theme_discovery_models.dart';
import 'quran_summary_theme.dart';
import 'widgets/quran_feature_components.dart';
import 'widgets/quran_feature_header.dart';
import 'widgets/quran_reflection_capture.dart';
import '../../../../core/theme/app_icons.dart';

class QuranTopicExplorerPage extends ConsumerStatefulWidget {
  const QuranTopicExplorerPage({super.key, this.topicId});

  final String? topicId;

  @override
  ConsumerState<QuranTopicExplorerPage> createState() =>
      _QuranTopicExplorerPageState();
}

class _QuranTopicExplorerPageState
    extends ConsumerState<QuranTopicExplorerPage> {
  late final TextEditingController _searchController;
  QuranThemeCategory? _selectedCategory;

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

    if (widget.topicId != null) {
      final resolved = ref.watch(
        quranResolvedThemeByIdProvider(widget.topicId!),
      );
      return AppPageScaffold(
        headerIcon: AppIcons.topics,
        title: l10n.quranThemeDiscoveryPageTitle,
        subtitle: l10n.quranThemeDiscoveryPageSubtitle,
        backgroundOverlayColor: palette.pageOverlay,
        backgroundAtmosphere: AppBackgroundAtmosphere.quran,
        children: [
          if (resolved == null)
            QuranFeatureEmptyState(
              title: l10n.quranThemeDiscoveryMissingThemeTitle,
              subtitle: l10n.quranThemeDiscoveryMissingThemeSubtitle,
              palette: palette,
              icon: Icons.search_off_rounded,
            )
          else
            _ThemeDetailView(theme: resolved, palette: palette),
        ],
      );
    }

    final themes = ref.watch(quranResolvedThemesProvider);
    final query = _searchController.text.trim().toLowerCase();
    final filtered = themes
        .where((theme) {
          if (_selectedCategory != null &&
              theme.definition.category != _selectedCategory) {
            return false;
          }
          if (query.isEmpty) return true;
          return _matchesThemeQuery(theme, query);
        })
        .toList(growable: false);
    final featured = filtered
        .where((theme) => theme.definition.featured)
        .toList(growable: false);
    final grouped = <QuranThemeCategory, List<QuranThemeResolvedTopic>>{};
    for (final theme in filtered) {
      grouped
          .putIfAbsent(
            theme.definition.category,
            () => <QuranThemeResolvedTopic>[],
          )
          .add(theme);
    }

    return AppPageScaffold(
      headerIcon: AppIcons.topics,
      title: l10n.quranThemeDiscoveryPageTitle,
      subtitle: l10n.quranThemeDiscoveryPageSubtitle,
      backgroundOverlayColor: palette.pageOverlay,
      backgroundAtmosphere: AppBackgroundAtmosphere.quran,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranThemeDiscoveryHeroEyebrow,
          primaryTitle: l10n.quranThemeDiscoveryHeroTitle,
          subtitle: l10n.quranThemeDiscoveryHeroSubtitle,
        ),
        const SizedBox(height: 12),
        QuranFeatureSearchCard(
          controller: _searchController,
          hintText: l10n.quranThemeDiscoverySearchHint,
          palette: palette,
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
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
              for (final category in QuranThemeCategory.values)
                QuranFeatureFilterChip(
                  label: _categoryLabel(l10n, category),
                  selected: _selectedCategory == category,
                  palette: palette,
                  onTap: () => setState(() => _selectedCategory = category),
                ),
            ],
          ),
        ),
        if (featured.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryFeaturedThemesTitle,
            palette: palette,
            child: Column(
              children: [
                for (final theme in featured)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ThemeCard(
                      theme: theme,
                      palette: palette,
                      onTap: () => context.pushNamed(
                        'quranTopicDetail',
                        pathParameters: {'topicId': theme.definition.id},
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          QuranFeatureEmptyState(
            title: l10n.quranThemeDiscoveryNoResultsTitle,
            subtitle: l10n.quranThemeDiscoveryNoResultsSubtitle,
            palette: palette,
            icon: Icons.search_off_rounded,
          )
        else ...[
          for (final category in QuranThemeCategory.values)
            if ((grouped[category]?.isNotEmpty ?? false)) ...[
              QuranFeatureSectionCard(
                title: _categoryLabel(l10n, category),
                subtitle: l10n.quranThemeDiscoveryThemeCountLabel(
                  grouped[category]!.length,
                ),
                palette: palette,
                child: Column(
                  children: [
                    for (final theme in grouped[category]!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ThemeCard(
                          theme: theme,
                          palette: palette,
                          onTap: () => context.pushNamed(
                            'quranTopicDetail',
                            pathParameters: {'topicId': theme.definition.id},
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ],
    );
  }

  bool _matchesThemeQuery(QuranThemeResolvedTopic theme, String query) {
    final haystack = <String>[
      theme.definition.id,
      theme.definition.title,
      theme.definition.subtitle,
      theme.definition.overview,
      ...theme.definition.searchAliases,
      ...theme.relatedProphets.map((item) => item.label),
      ...theme.relatedEvents.map((item) => item.label),
      ...theme.relatedSurahs.map((item) => item.transliteratedName),
      ...theme.relatedSurahs.map((item) => item.englishName),
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }
}

class _ThemeDetailView extends ConsumerWidget {
  const _ThemeDetailView({required this.theme, required this.palette});

  final QuranThemeResolvedTopic theme;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final primaryRef = theme.notableAyat.isNotEmpty
        ? QuranQuoteRef(
            surah: theme.notableAyat.first.surahNumber,
            ayah: theme.notableAyat.first.ayahNumber,
            ayahEnd: theme.notableAyat.first.endAyahNumber,
          )
        : theme.relatedSurahs.isNotEmpty
        ? QuranQuoteRef(surah: theme.relatedSurahs.first.surahNumber, ayah: 1)
        : null;

    return Column(
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: _categoryLabel(l10n, theme.definition.category),
          primaryTitle: theme.definition.title,
          subtitle: theme.definition.subtitle,
          metadata: buildQuranFeatureMetadata(
            palette: palette,
            items: [
              (
                label: _categoryLabel(l10n, theme.definition.category),
                tone: QuranFeatureRevelationTone.neutral,
              ),
              (
                label: l10n.quranThemeDiscoverySurahCountLabel(
                  theme.relatedSurahs.length,
                ),
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
            theme.definition.overview,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.secondaryText,
              height: 1.5,
            ),
          ),
        ),
        if (theme.notableAyat.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryKeyAyahReferencesTitle,
            palette: palette,
            child: Column(
              children: [
                for (final ayah in theme.notableAyat)
                  QuranReferenceLinkTile(
                    referenceLabel:
                        '${ayah.label} (${_ayahReferenceLabel(ayah)})',
                    surahNumber: ayah.surahNumber,
                    fallbackStartAyah: ayah.ayahNumber,
                    endAyahNumber: ayah.endAyahNumber,
                    subtitle: ayah.whyItMatters,
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
              ],
            ),
          ),
        ],
        if (theme.relatedProphets.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryRelatedProphetsTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final prophet in theme.relatedProphets)
                  QuranFeatureThemeChip(label: prophet.label, palette: palette),
              ],
            ),
          ),
        ],
        if (theme.relatedEvents.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryRelatedEventsTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final event in theme.relatedEvents)
                  QuranFeatureThemeChip(label: event.label, palette: palette),
              ],
            ),
          ),
        ],
        if (theme.definition.reflectionPrompt?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryReflectionTitle,
            palette: palette,
            child: Text(
              theme.definition.reflectionPrompt!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.secondaryText,
                height: 1.45,
              ),
            ),
          ),
        ],
        if (theme.relatedSurahs.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryRelatedSurahsTitle,
            subtitle: l10n.quranThemeDiscoverySurahCountLabel(
              theme.relatedSurahs.length,
            ),
            palette: palette,
            child: Column(
              children: [
                for (final surah in theme.relatedSurahs.take(8))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ThemeSurahCard(surah: surah, palette: palette),
                  ),
              ],
            ),
          ),
        ],
        if (theme.relatedThemes.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranThemeDiscoveryMoreThemesTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final related in theme.relatedThemes)
                  ActionChip(
                    label: Text(related.title),
                    onPressed: () => context.pushNamed(
                      'quranTopicDetail',
                      pathParameters: {'topicId': related.id},
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () => captureQuranReflection(
                context,
                ref,
                sourceType: QuranReflectionSourceType.themeDetail,
                title: theme.definition.title,
                summary: theme.definition.overview,
                sourceId: 'theme:${theme.definition.id}',
                sourceLabel: theme.definition.title,
                quoteRef: primaryRef,
                themeId: theme.definition.id,
                surahNumber: theme.relatedSurahs.isEmpty
                    ? null
                    : theme.relatedSurahs.first.surahNumber,
                routeName: 'quranTopicDetail',
                pathParameters: {'topicId': theme.definition.id},
                promptLabel: theme.definition.reflectionPrompt,
                helperText: l10n.quranReflectionsThemeHelper(
                  theme.definition.title,
                ),
              ),
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(l10n.quranReflectionsSaveReflectionAction),
            ),
            TextButton.icon(
              onPressed: () => context.goNamed('quranTopicExplorer'),
              icon: const Icon(Icons.grid_view_rounded),
              label: Text(l10n.quranThemeDiscoveryBrowseMoreThemesAction),
            ),
          ],
        ),
      ],
    );
  }

  String _ayahReferenceLabel(QuranSurahNotableAyah ayah) {
    if (ayah.endAyahNumber != null && ayah.endAyahNumber != ayah.ayahNumber) {
      return '${ayah.surahNumber}:${ayah.ayahNumber}-${ayah.endAyahNumber}';
    }
    return '${ayah.surahNumber}:${ayah.ayahNumber}';
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.palette,
    required this.onTap,
  });

  final QuranThemeResolvedTopic theme;
  final QuranSummaryThemePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: palette.elevatedSurfaceDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theme.definition.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  theme.definition.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      label: _categoryLabel(l10n, theme.definition.category),
                      palette: palette,
                    ),
                    QuranFeatureMetadataChip(
                      label: l10n.quranThemeDiscoverySurahCountLabel(
                        theme.relatedSurahs.length,
                      ),
                      palette: palette,
                    ),
                  ],
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
                Row(
                  children: [
                    Text(
                      l10n.quranThemeDiscoveryExploreThemeAction,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.goldAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: palette.goldAccent,
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

class _ThemeSurahCard extends StatelessWidget {
  const _ThemeSurahCard({required this.surah, required this.palette});

  final QuranSurahSummaryEntry surah;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tone = switch (surah.revelationType) {
      QuranSurahSummaryRevelationType.makki => QuranFeatureRevelationTone.makki,
      QuranSurahSummaryRevelationType.madani =>
        QuranFeatureRevelationTone.madani,
      QuranSurahSummaryRevelationType.mixed =>
        QuranFeatureRevelationTone.neutral,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.cardBottom.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuranFeatureHeader(
            palette: palette,
            arabicTitle: surah.arabicName,
            primaryTitle: surah.transliteratedName,
            subtitle: surah.meaning,
            numberBadge: surah.surahNumber,
            density: QuranFeatureHeaderDensity.compact,
            metadata: buildQuranFeatureMetadata(
              palette: palette,
              items: [
                (
                  label: l10n.quranSummaryVerseCountLabel(surah.verseCount),
                  tone: QuranFeatureRevelationTone.neutral,
                ),
                (label: quranSummaryRevelationLabel(l10n, tone), tone: tone),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            surah.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.secondaryText,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranSummaryDetailPage',
                  pathParameters: {'surahNumber': surah.surahNumber.toString()},
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: Text(l10n.quranSummaryViewDetailsAction),
              ),
              OutlinedButton.icon(
                onPressed: () => openQuranReaderLocation(
                  context,
                  surahNumber: surah.surahNumber,
                ),
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.quranSummaryOpenReaderAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _categoryLabel(AppLocalizations l10n, QuranThemeCategory category) {
  return switch (category) {
    QuranThemeCategory.beliefCore => l10n.quranThemeDiscoveryCategoryBelief,
    QuranThemeCategory.worshipSpiritualLife =>
      l10n.quranThemeDiscoveryCategoryWorship,
    QuranThemeCategory.characterInnerLife =>
      l10n.quranThemeDiscoveryCategoryCharacter,
    QuranThemeCategory.storiesAndProphets =>
      l10n.quranThemeDiscoveryCategoryStoriesProphets,
    QuranThemeCategory.akhirahAccountability =>
      l10n.quranThemeDiscoveryCategoryAkhirah,
    QuranThemeCategory.societyEthics =>
      l10n.quranThemeDiscoveryCategorySocietyEthics,
    QuranThemeCategory.signsAndReflection =>
      l10n.quranThemeDiscoveryCategorySignsReflection,
  };
}
