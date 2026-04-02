import 'package:flutter/material.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/quran_ayah_explanation_models.dart';
import '../../domain/quran_reference_models.dart';

enum QuranAyahExplanationSectionStyle { reader, kids }

class QuranAyahExplanationSection extends StatelessWidget {
  const QuranAyahExplanationSection({
    super.key,
    required this.explanation,
    required this.style,
    this.studyMode,
    this.initiallyExpanded = false,
    this.trimBodyLines,
  });

  final QuranAyahResolvedExplanation explanation;
  final QuranAyahExplanationSectionStyle style;
  final QuranReaderStudyMode? studyMode;
  final bool initiallyExpanded;
  final int? trimBodyLines;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final treatment = AppSurfaceTreatment.denseSanctuary;
    final variant = style == QuranAyahExplanationSectionStyle.kids
        ? AppSurfaceVariant.card
        : AppSurfaceVariant.panel;
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: variant,
      treatment: treatment,
    );
    final contentColors = AppSurfaceTheme.contentColors(
      context,
      treatment: treatment,
    );
    final showKeyLessons =
        explanation.keyLessons.isNotEmpty &&
        (style == QuranAyahExplanationSectionStyle.kids ||
            studyMode == QuranReaderStudyMode.study ||
            studyMode == QuranReaderStudyMode.reflection);
    final showReflectionPrompt =
        explanation.reflectionPrompt != null &&
        studyMode == QuranReaderStudyMode.reflection;
    final showSources =
        style == QuranAyahExplanationSectionStyle.reader &&
        explanation.sourceRefs.isNotEmpty &&
        (studyMode == QuranReaderStudyMode.study ||
            studyMode == QuranReaderStudyMode.theme);

    if (style == QuranAyahExplanationSectionStyle.kids) {
      final compactTakeaway = explanation.keyLessons.isEmpty
          ? const <String>[]
          : <String>[explanation.keyLessons.first];
      final gentlePrompt = explanation.reflectionPrompt == null
          ? null
          : l10n.kidsQuranExplanationReflectionPrompt(
              explanation.reflectionPrompt!,
            );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: surfaceStyle.decoration(radius: 18, includeShadow: true),
        child: _ExplanationBody(
          title: l10n.kidsQuranExplanationTitle,
          body: explanation.body,
          foreground: contentColors.foreground,
          subtleForeground: contentColors.subtleForeground,
          captionForeground: contentColors.captionForeground,
          bodyMaxLines: trimBodyLines,
          detailLabel: null,
          keyLessons: showKeyLessons ? compactTakeaway : const <String>[],
          keyLessonsTitle: l10n.kidsQuranExplanationTakeawayTitle,
          renderKeyLessonsAsChips: false,
          reflectionPrompt: gentlePrompt,
          reflectionPromptTitle: l10n.kidsQuranExplanationReflectionTitle,
          sourceLine: null,
        ),
      );
    }

    return Container(
      decoration: surfaceStyle.decoration(radius: 18, includeShadow: true),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(
            'quran-ayah-explanation-${explanation.surahNumber}:${explanation.ayahNumber}-${explanation.requestedDetail.name}-${studyMode?.name ?? 'none'}',
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          initiallyExpanded: initiallyExpanded,
          title: Text(
            l10n.quranAyahExplanationTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              explanation.previewText,
              maxLines: initiallyExpanded ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.45,
                color: contentColors.subtleForeground,
              ),
            ),
          ),
          trailing: _DetailChip(
            label: _detailLabel(l10n, explanation.resolvedDetail),
          ),
          children: [
            _ExplanationBody(
              title: null,
              body: explanation.body,
              foreground: contentColors.foreground,
              subtleForeground: contentColors.subtleForeground,
              captionForeground: contentColors.captionForeground,
              bodyMaxLines: null,
              detailLabel: null,
              keyLessons: showKeyLessons
                  ? explanation.keyLessons
                  : const <String>[],
              keyLessonsTitle: l10n.quranAyahExplanationKeyLessonsTitle,
              renderKeyLessonsAsChips: true,
              reflectionPrompt: showReflectionPrompt
                  ? explanation.reflectionPrompt
                  : null,
              reflectionPromptTitle:
                  l10n.quranAyahExplanationReflectionPromptTitle,
              sourceLine: showSources
                  ? explanation.usedFallback
                        ? l10n.quranAyahExplanationFallbackSourceLine
                        : l10n.quranAyahExplanationTrustedSourceLine
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationBody extends StatelessWidget {
  const _ExplanationBody({
    required this.title,
    required this.body,
    required this.foreground,
    required this.subtleForeground,
    required this.captionForeground,
    required this.bodyMaxLines,
    required this.detailLabel,
    required this.keyLessons,
    required this.keyLessonsTitle,
    required this.renderKeyLessonsAsChips,
    required this.reflectionPrompt,
    required this.reflectionPromptTitle,
    required this.sourceLine,
  });

  final String? title;
  final String body;
  final Color foreground;
  final Color subtleForeground;
  final Color captionForeground;
  final int? bodyMaxLines;
  final String? detailLabel;
  final List<String> keyLessons;
  final String keyLessonsTitle;
  final bool renderKeyLessonsAsChips;
  final String? reflectionPrompt;
  final String reflectionPromptTitle;
  final String? sourceLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
              if (detailLabel != null) _DetailChip(label: detailLabel!),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Text(
          body,
          maxLines: bodyMaxLines,
          overflow: bodyMaxLines == null ? null : TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: subtleForeground,
          ),
        ),
        if (keyLessons.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            keyLessonsTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
          const SizedBox(height: 6),
          if (renderKeyLessonsAsChips)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keyLessons
                  .map(
                    (lesson) => Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(lesson),
                    ),
                  )
                  .toList(growable: false),
            )
          else
            Text(
              keyLessons.first,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
        ],
        if (reflectionPrompt != null) ...[
          const SizedBox(height: 10),
          Text(
            reflectionPromptTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reflectionPrompt!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.45,
              fontStyle: FontStyle.italic,
              color: subtleForeground,
            ),
          ),
        ],
        if (sourceLine != null) ...[
          const SizedBox(height: 10),
          Text(
            sourceLine!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: captionForeground),
          ),
        ],
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final contentColors = AppSurfaceTheme.contentColors(
      context,
      treatment: AppSurfaceTreatment.denseSanctuary,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: contentColors.iconColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: contentColors.foreground,
        ),
      ),
    );
  }
}

String _detailLabel(AppLocalizations l10n, QuranExplanationDetailLevel detail) {
  return switch (detail) {
    QuranExplanationDetailLevel.off => l10n.quranAyahExplanationDetailOff,
    QuranExplanationDetailLevel.simple => l10n.quranAyahExplanationDetailSimple,
    QuranExplanationDetailLevel.standard =>
      l10n.quranAyahExplanationDetailStandard,
    QuranExplanationDetailLevel.deep => l10n.quranAyahExplanationDetailDeep,
    QuranExplanationDetailLevel.kids => l10n.quranAyahExplanationDetailKids,
  };
}
