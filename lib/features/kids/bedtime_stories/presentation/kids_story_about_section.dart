import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../domain/bedtime_story_models.dart';

/// The scholarship behind a story: its lesson, the Qur'an it rests on, a
/// hadith where there is one, and the source note. This is for the parent
/// and the older reader, so it sits behind the story, never in front of it:
/// an expandable section on the story page and a sheet from the reader.
class KidsStoryAboutSection extends StatelessWidget {
  const KidsStoryAboutSection({
    super.key,
    required this.story,
    this.narratorLabel,
  });

  final BedtimeStorySeed story;

  /// Shown only once there is narration to credit.
  final String? narratorLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final heading = textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.bedtimeEligible
                    ? l10n.bedtimeStoriesLessonSectionTitle
                    : l10n.kidsStoryLessonSectionTitle,
                style: heading,
              ),
              const SizedBox(height: 8),
              if (story.summary.isNotEmpty) ...[
                Text(story.summary),
                const SizedBox(height: 10),
              ],
              Text(story.lesson),
              if (narratorLabel != null) ...[
                const SizedBox(height: 10),
                Text(narratorLabel!, style: textTheme.bodySmall),
              ],
            ],
          ),
        ),
        if (story.hasQuranReference) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.bedtimeStoriesQuranQuoteSectionTitle, style: heading),
                const SizedBox(height: 8),
                Text(
                  story.quranQuote!,
                  style: textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 10),
                QuranReferenceLinkTile.forRef(
                  referenceLabel: story.quranReference!,
                  ref: story.quranQuoteRef!,
                  subtitle: l10n.bedtimeStoriesQuranTapSubtitle,
                ),
              ],
            ),
          ),
        ],
        if (story.hasHadithReference) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.kidsStoryHadithSectionTitle, style: heading),
                const SizedBox(height: 8),
                Text(
                  story.hadithQuote!,
                  style: textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 10),
                Text(story.hadithReference!, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
        if ((story.sourceNote ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.kidsStorySourceNoteSectionTitle, style: heading),
                const SizedBox(height: 8),
                Text(story.sourceNote!),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The same section as a sheet, for the reader.
Future<void> showKidsStoryAboutSheet(
  BuildContext context,
  BedtimeStorySeed story,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.kidsStoryReaderAboutAction,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              KidsStoryAboutSection(story: story),
            ],
          ),
        ),
      );
    },
  );
}
