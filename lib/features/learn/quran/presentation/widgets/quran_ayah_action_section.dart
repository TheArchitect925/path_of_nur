import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../application/quran_ayah_action_provider.dart';
import '../../application/quran_learning_progression_provider.dart';
import '../../application/quran_reflections_provider.dart';
import '../../domain/quran_ayah_action_models.dart';
import '../../domain/quran_reflection_entry.dart';
import 'quran_reflection_note_dialog.dart';

enum QuranAyahActionSectionStyle { reader, kids, daily }

class QuranAyahActionSection extends ConsumerWidget {
  const QuranAyahActionSection({
    super.key,
    required this.recommendation,
    required this.style,
    this.showExplanationPreview = false,
  });

  final QuranAyahActionRecommendation recommendation;
  final QuranAyahActionSectionStyle style;
  final bool showExplanationPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final action = recommendation.action;
    final languageCode = Localizations.localeOf(context).languageCode;
    final localizedActionText = action.localizedActionText(languageCode);
    final localizedPrompt = action.localizedReflectionPrompt(languageCode);
    final noteEntry = ref.watch(
      quranReflectionsProvider.select((items) {
        for (final item in items) {
          if (item.ref != action.ref) continue;
          if (item.sourceType != QuranReflectionSourceType.readerContext) {
            continue;
          }
          if (item.sourceId != action.actionId) continue;
          return item;
        }
        return null;
      }),
    );

    final title = switch (style) {
      QuranAyahActionSectionStyle.reader => l10n.quranAyahActionTitle,
      QuranAyahActionSectionStyle.kids => l10n.kidsQuranAyahActionTitle,
      QuranAyahActionSectionStyle.daily => l10n.quranAyahActionTodayTitle,
    };

    final previewText = switch (style) {
      QuranAyahActionSectionStyle.reader => l10n.quranAyahActionReaderSubtitle,
      QuranAyahActionSectionStyle.kids => l10n.kidsQuranAyahActionSubtitle,
      QuranAyahActionSectionStyle.daily => l10n.quranAyahActionDailySubtitle,
    };

    final surfaceVariant = switch (style) {
      QuranAyahActionSectionStyle.reader => AppSurfaceVariant.panel,
      QuranAyahActionSectionStyle.kids => AppSurfaceVariant.card,
      QuranAyahActionSectionStyle.daily => AppSurfaceVariant.card,
    };
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: surfaceVariant,
      treatment: AppSurfaceTreatment.standard,
    );
    final contentColors = AppSurfaceTheme.contentColors(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: surfaceStyle.decoration(radius: 18, includeShadow: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: contentColors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            previewText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: contentColors.captionForeground,
            ),
          ),
          if (showExplanationPreview &&
              recommendation.explanationPreview.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              recommendation.explanationPreview,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: contentColors.subtleForeground,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            localizedActionText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: contentColors.foreground,
            ),
          ),
          if (localizedPrompt != null && localizedPrompt.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              style == QuranAyahActionSectionStyle.kids
                  ? l10n.kidsQuranExplanationReflectionTitle
                  : l10n.quranAyahActionReflectionTitle,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: contentColors.foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localizedPrompt,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.45,
                fontStyle: FontStyle.italic,
                color: contentColors.subtleForeground,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              recommendation.isCompletedToday
                  ? FilledButton.tonalIcon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Text(l10n.quranAyahActionCompletedAction),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        ref
                            .read(quranAyahActionStateProvider.notifier)
                            .completeAction(action);
                      },
                      icon: const Icon(Icons.done_rounded),
                      label: Text(l10n.quranAyahActionCompleteAction),
                    ),
              if (style != QuranAyahActionSectionStyle.kids)
                OutlinedButton.icon(
                  onPressed: () async {
                    final note = await showQuranReflectionNoteDialog(
                      context,
                      title: noteEntry?.note?.trim().isNotEmpty ?? false
                          ? l10n.quranReflectionsEditNoteAction
                          : l10n.quranAyahActionReflectAction,
                      initialNote: noteEntry?.note,
                    );
                    if (note == null) return;
                    ref
                        .read(quranReflectionsProvider.notifier)
                        .upsertNote(
                          ref: action.ref,
                          sourceType: QuranReflectionSourceType.readerContext,
                          sourceId: action.actionId,
                          title: localizedActionText,
                          summary: recommendation.explanationPreview,
                          note: note,
                        );
                    if (note.trim().isNotEmpty) {
                      ref
                          .read(quranLearningProgressStateProvider.notifier)
                          .rewardFirstReflectionNote(
                            ref: action.ref,
                            sourceEnrichmentId: action.actionId,
                            sourceSurface: 'ayah_action',
                          );
                    }
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                  label: Text(
                    noteEntry?.note?.trim().isNotEmpty ?? false
                        ? l10n.quranReflectionsEditNoteAction
                        : l10n.quranAyahActionReflectAction,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
