import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_backgrounds.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../application/quran_surah_summary_provider.dart';
import '../domain/quran_surah_summary_models.dart';
import 'quran_summary_theme.dart';
import 'widgets/quran_feature_components.dart';
import 'widgets/quran_feature_header.dart';
import 'widgets/quran_surah_summary_card_background.dart';
import '../../../../core/theme/app_icons.dart';

class QuranSummaryPage extends ConsumerStatefulWidget {
  const QuranSummaryPage({super.key});

  @override
  ConsumerState<QuranSummaryPage> createState() => _QuranSummaryPageState();
}

class _QuranSummaryPageState extends ConsumerState<QuranSummaryPage> {
  late final TextEditingController _searchController;
  QuranSurahSummaryFilter _filter = QuranSurahSummaryFilter.all;

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
    final summaries = ref.watch(quranSurahSummaryListProvider);
    final query = _searchController.text.trim();
    final filtered = summaries
        .where((entry) {
          if (!entry.matchesFilter(_filter)) return false;
          if (query.isEmpty) return true;
          return _matchesQuery(entry, query);
        })
        .toList(growable: false);

    return AppPageScaffold(
      headerIcon: AppIcons.summary,
      title: l10n.quranSummaryPageTitle,
      subtitle: l10n.quranSummaryPageSubtitle,
      backgroundOverlayColor: palette.pageOverlay,
      backgroundAtmosphere: AppBackgroundAtmosphere.quran,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranSummaryHeroEyebrow,
          primaryTitle: l10n.quranSummaryHeroTitle,
          subtitle: l10n.quranSummaryHeroSubtitle,
        ),
        const SizedBox(height: 12),
        QuranFeatureSearchCard(
          controller: _searchController,
          hintText: l10n.quranSummarySearchHint,
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
            QuranFeatureFilterChip(
              palette: palette,
              label: l10n.quranSummaryFilterAll,
              selected: _filter == QuranSurahSummaryFilter.all,
              onTap: () =>
                  setState(() => _filter = QuranSurahSummaryFilter.all),
            ),
            QuranFeatureFilterChip(
              palette: palette,
              label: l10n.quranSummaryFilterMakki,
              selected: _filter == QuranSurahSummaryFilter.makki,
              onTap: () =>
                  setState(() => _filter = QuranSurahSummaryFilter.makki),
            ),
            QuranFeatureFilterChip(
              palette: palette,
              label: l10n.quranSummaryFilterMadani,
              selected: _filter == QuranSurahSummaryFilter.madani,
              onTap: () =>
                  setState(() => _filter = QuranSurahSummaryFilter.madani),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          QuranFeatureEmptyState(
            title: l10n.quranSummaryNoResultsTitle,
            subtitle: l10n.quranSummaryNoResultsSubtitle,
            palette: palette,
          )
        else
          ...filtered.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuranSurahSummaryCard(
                entry: entry,
                palette: palette,
                onTap: () => context.pushNamed(
                  'quranSummaryDetailPage',
                  pathParameters: {'surahNumber': entry.surahNumber.toString()},
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _matchesQuery(QuranSurahSummaryEntry entry, String query) {
    final normalized = query.trim().toLowerCase();
    final normalizedArabic = _normalizeArabic(query);
    final queryDigits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    final haystacks = <String>[
      entry.surahNumber.toString(),
      entry.transliteratedName.toLowerCase(),
      entry.englishName.toLowerCase(),
      entry.meaning.toLowerCase(),
      entry.summary.toLowerCase(),
      ...entry.keywords.map((item) => item.toLowerCase()),
      ...entry.searchAliases.map((item) => item.toLowerCase()),
    ];

    final hasTextMatch = haystacks.any((value) => value.contains(normalized));
    if (hasTextMatch) return true;
    if (queryDigits.isNotEmpty && entry.surahNumber.toString() == queryDigits) {
      return true;
    }
    return normalizedArabic.isNotEmpty &&
        _normalizeArabic(entry.arabicName).contains(normalizedArabic);
  }

  String _normalizeArabic(String text) =>
      text.replaceAll(RegExp(r'[\s\u0640]'), '').trim();
}

class _QuranSurahSummaryCard extends StatelessWidget {
  const _QuranSurahSummaryCard({
    required this.entry,
    required this.palette,
    required this.onTap,
  });

  final QuranSurahSummaryEntry entry;
  final QuranSummaryThemePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tone = switch (entry.revelationType) {
      QuranSurahSummaryRevelationType.makki => QuranFeatureRevelationTone.makki,
      QuranSurahSummaryRevelationType.madani =>
        QuranFeatureRevelationTone.madani,
      QuranSurahSummaryRevelationType.mixed =>
        QuranFeatureRevelationTone.neutral,
    };
    final revelationLabel = quranSummaryRevelationLabel(l10n, tone);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: palette.elevatedSurfaceDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned.fill(
                  child: QuranSurahSummaryCardBackground(
                    surahNumber: entry.surahNumber,
                    palette: palette,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuranFeatureHeader(
                        palette: palette,
                        arabicTitle: entry.arabicName,
                        primaryTitle: entry.transliteratedName,
                        subtitle: entry.meaning,
                        numberBadge: entry.surahNumber,
                        density: QuranFeatureHeaderDensity.compact,
                        trailing: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: palette.goldAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          QuranFeatureMetadataChip(
                            label:
                                '${entry.verseCount} ${l10n.quranSummaryVersesLabel}',
                            palette: palette,
                          ),
                          QuranFeatureMetadataChip(
                            label: revelationLabel,
                            palette: palette,
                            tone: tone,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
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
                      const SizedBox(height: 14),
                      Text(
                        entry.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.secondaryText,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            l10n.quranSummaryViewDetailsAction,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: palette.goldAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 18,
                            color: palette.goldAccent,
                          ),
                        ],
                      ),
                    ],
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
