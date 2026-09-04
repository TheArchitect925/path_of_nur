import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_backgrounds.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../application/quran_surah_summary_provider.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reflection_entry.dart';
import '../domain/quran_surah_summary_models.dart';
import 'quran_summary_theme.dart';
import 'widgets/quran_feature_components.dart';
import 'widgets/quran_feature_header.dart';
import 'widgets/quran_reflection_capture.dart';

class QuranSurahSummaryDetailPage extends ConsumerWidget {
  const QuranSurahSummaryDetailPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = QuranSummaryThemePalette.resolve(context);
    final entry = ref.watch(quranSurahSummaryEntryProvider(surahNumber));

    if (entry == null) {
      return AppPageScaffold(
        title: l10n.quranSummaryPageTitle,
        subtitle: l10n.quranSummaryDetailMissingSubtitle,
        backgroundOverlayColor: palette.pageOverlay,
        backgroundAtmosphere: AppBackgroundAtmosphere.quran,
        children: [
          QuranFeatureEmptyState(
            title: l10n.quranSummaryDetailMissingTitle,
            subtitle: l10n.quranSummaryDetailMissingSubtitle,
            palette: palette,
          ),
        ],
      );
    }

    final resumeState = ref.watch(
      quranSurahSummaryResumeStateProvider(entry.surahNumber),
    );

    return AppPageScaffold(
      title: entry.transliteratedName,
      subtitle: l10n.quranSummaryDetailPageSubtitle(entry.surahNumber),
      backgroundOverlayColor: palette.pageOverlay,
      backgroundAtmosphere: AppBackgroundAtmosphere.quran,
      children: [
        QuranFeatureHeader(
          palette: palette,
          overline: l10n.quranSummaryHeroEyebrow,
          arabicTitle: entry.arabicName,
          primaryTitle: '${entry.transliteratedName} • ${entry.englishName}',
          subtitle: entry.meaning,
          numberBadge: entry.surahNumber,
          metadata: buildQuranFeatureMetadata(
            palette: palette,
            items: [
              (
                label: _revelationLabel(l10n, entry.revelationType),
                tone: _revelationTone(entry.revelationType),
              ),
              (
                label: l10n.quranSummaryVerseCountLabel(entry.verseCount),
                tone: QuranFeatureRevelationTone.neutral,
              ),
            ],
          ),
        ),
        if (entry.detailIntro != null &&
            entry.detailIntro!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryOverviewTitle,
            palette: palette,
            child: Text(
              entry.detailIntro!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.secondaryText,
                height: 1.5,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryOverviewTitle,
          palette: palette,
          child: Text(
            entry.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.secondaryText,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryMetadataTitle,
          palette: palette,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              QuranFeatureMetadataChip(
                label: l10n.quranSummaryRevelationLabel(
                  _revelationLabel(l10n, entry.revelationType),
                ),
                palette: palette,
                tone: _revelationTone(entry.revelationType),
              ),
              QuranFeatureMetadataChip(
                label: l10n.quranSummaryVerseCountLabel(entry.verseCount),
                palette: palette,
              ),
              QuranFeatureMetadataChip(
                label: l10n.quranSummaryRevelationOrderLabel(
                  entry.surah.revelationOrder,
                ),
                palette: palette,
              ),
              QuranFeatureMetadataChip(
                label: entry.surah.revelationPeriod,
                palette: palette,
              ),
            ],
          ),
        ),
        if (entry.themeTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryKeyThemesTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in entry.themeTags)
                  QuranFeatureThemeChip(
                    label: quranSummaryThemeLabel(l10n, tag),
                    palette: palette,
                  ),
              ],
            ),
          ),
        ],
        if (entry.notableAyat.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryNotableAyatTitle,
            palette: palette,
            child: Column(
              children: [
                for (final ayah in entry.notableAyat)
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
        if (entry.relatedProphets.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryRelatedProphetsTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final prophet in entry.relatedProphets)
                  QuranFeatureThemeChip(label: prophet.label, palette: palette),
              ],
            ),
          ),
        ],
        if (entry.relatedEvents.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryRelatedEventsTitle,
            palette: palette,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final event in entry.relatedEvents)
                  QuranFeatureThemeChip(label: event.label, palette: palette),
              ],
            ),
          ),
        ],
        if (entry.virtues.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryVirtuesTitle,
            palette: palette,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final virtue in entry.virtues) ...[
                  Text(
                    virtue.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: palette.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    virtue.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.secondaryText,
                      height: 1.45,
                    ),
                  ),
                  if (virtue != entry.virtues.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
        if (entry.reflections.isNotEmpty) ...[
          const SizedBox(height: 12),
          QuranFeatureSectionCard(
            title: l10n.quranSummaryReflectionPromptsTitle,
            palette: palette,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final prompt in entry.reflections) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: palette.goldAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prompt.prompt,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: palette.secondaryText,
                                height: 1.45,
                              ),
                        ),
                      ),
                    ],
                  ),
                  if (prompt != entry.reflections.last)
                    const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        QuranFeatureSectionCard(
          title: l10n.quranSummaryActionsTitle,
          palette: palette,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resumeState == null
                    ? l10n.quranSummaryNoReadingProgress
                    : l10n.quranSummaryResumeHint(resumeState.ayahNumber),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => openQuranReaderLocation(
                      context,
                      surahNumber: entry.surahNumber,
                    ),
                    icon: const Icon(Icons.menu_book_rounded),
                    label: Text(l10n.quranSummaryOpenReaderAction),
                    style: FilledButton.styleFrom(
                      foregroundColor: palette.goldAccent,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => openQuranReaderLocation(
                      context,
                      surahNumber: entry.surahNumber,
                      ayahNumber: 1,
                    ),
                    icon: const Icon(Icons.first_page_rounded),
                    label: Text(l10n.quranSummaryStartReadingAction),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.secondaryText,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => captureQuranReflection(
                      context,
                      ref,
                      sourceType: QuranReflectionSourceType.surahDetail,
                      title: entry.transliteratedName,
                      summary: entry.summary,
                      sourceId: 'surah:${entry.surahNumber}',
                      sourceLabel: entry.transliteratedName,
                      quoteRef: QuranQuoteRef(
                        surah: entry.surahNumber,
                        ayah: 1,
                      ),
                      surahNumber: entry.surahNumber,
                      routeName: 'quranSummaryDetailPage',
                      pathParameters: {
                        'surahNumber': entry.surahNumber.toString(),
                      },
                      helperText: l10n.quranReflectionsSurahHelper(
                        entry.transliteratedName,
                      ),
                    ),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Text(l10n.quranReflectionsSaveReflectionAction),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.secondaryText,
                    ),
                  ),
                  if (resumeState != null)
                    FilledButton.icon(
                      onPressed: () => openQuranReaderLocation(
                        context,
                        surahNumber: entry.surahNumber,
                        ayahNumber: resumeState.ayahNumber,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(l10n.quranSummaryResumeReadingAction),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _revelationLabel(
    AppLocalizations l10n,
    QuranSurahSummaryRevelationType revelationType,
  ) {
    return switch (revelationType) {
      QuranSurahSummaryRevelationType.makki => l10n.quranSummaryFilterMakki,
      QuranSurahSummaryRevelationType.madani => l10n.quranSummaryFilterMadani,
      QuranSurahSummaryRevelationType.mixed => l10n.quranSummaryRevelationMixed,
    };
  }

  QuranFeatureRevelationTone _revelationTone(
    QuranSurahSummaryRevelationType revelationType,
  ) {
    return switch (revelationType) {
      QuranSurahSummaryRevelationType.makki => QuranFeatureRevelationTone.makki,
      QuranSurahSummaryRevelationType.madani =>
        QuranFeatureRevelationTone.madani,
      QuranSurahSummaryRevelationType.mixed =>
        QuranFeatureRevelationTone.neutral,
    };
  }

  String _ayahReferenceLabel(QuranSurahNotableAyah ayah) {
    if (ayah.endAyahNumber != null && ayah.endAyahNumber != ayah.ayahNumber) {
      return '${ayah.surahNumber}:${ayah.ayahNumber}-${ayah.endAyahNumber}';
    }
    return '${ayah.surahNumber}:${ayah.ayahNumber}';
  }
}
