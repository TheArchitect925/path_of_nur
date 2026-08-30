import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_reference_link.dart';
import '../../../../../shared/widgets/quran_verse_content.dart';
import '../../application/quran_words_provider.dart';

class QuranWordExampleAyahSection extends StatelessWidget {
  const QuranWordExampleAyahSection({
    super.key,
    required this.usageSummary,
    required this.arabicScale,
    required this.transliterationScale,
    required this.translationScale,
    this.padding = const EdgeInsets.all(12),
  });

  final QuranWordUsageSummary usageSummary;
  final double arabicScale;
  final double transliterationScale;
  final double translationScale;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final exampleRef = usageSummary.exampleRef;
    if (exampleRef == null) {
      return Text(
        AppLocalizations.of(context).batch9QuranWordsNoUsageAvailable,
        style: TextStyle(color: context.palette.onSurfaceSubtle, height: 1.3),
      );
    }

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuranVerseContent(
            source: QuranVerseSource(ref: exampleRef),
            center: false,
            dense: true,
            showReference: false,
            arabicBaseSize: 22 * arabicScale,
            transliterationBaseSize: 13.5 * transliterationScale,
            translationBaseSize: 12.8 * translationScale,
          ),
          const SizedBox(height: 10),
          QuranReferenceLinkTile.forRef(
            referenceLabel: exampleRef.locationLabel,
            ref: exampleRef,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ],
      ),
    );
  }
}

Future<void> showQuranWordUsageSheet(
  BuildContext context, {
  required QuranWordUsageSummary summary,
  required double arabicScale,
  required double transliterationScale,
  required double translationScale,
}) async {
  if (summary.occurrenceRefs.isEmpty) return;
  final l10n = AppLocalizations.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9QuranWordsAyahListTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.batch9QuranWordsAyahListSubtitle(
                  summary.word.transliteration,
                  summary.ayahCount,
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: summary.occurrenceRefs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final ref = summary.occurrenceRefs[index];
                    return PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuranVerseContent(
                            source: QuranVerseSource(ref: ref),
                            center: false,
                            dense: true,
                            showReference: false,
                            arabicBaseSize: 22 * arabicScale,
                            transliterationBaseSize:
                                13.5 * transliterationScale,
                            translationBaseSize: 12.8 * translationScale,
                          ),
                          const SizedBox(height: 10),
                          QuranReferenceLinkTile.forRef(
                            referenceLabel: ref.locationLabel,
                            ref: ref,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
