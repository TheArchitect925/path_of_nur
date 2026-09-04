import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/expandable_tile.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_guided_settings_provider.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';
import '../widgets/prayer_posture_animator.dart';
import '../widgets/salah_trainer_widgets.dart';

class SalahPrayerDetailPage extends ConsumerWidget {
  const SalahPrayerDetailPage({
    super.key,
    required this.prayerId,
    this.focusSteps = false,
  });

  final SalahPrayerId prayerId;

  /// Opens with every rakah expanded and the structure ahead of the notes.
  final bool focusSteps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayer = ref.watch(salahTrainerPrayerByIdProvider(prayerId));
    final settings = ref.watch(prayerSettingsProvider);
    final tasbihRepeats = ref.watch(
      salahGuidedSettingsProvider.select((value) => value.tasbihRepeats),
    );
    final madhhab = ref.watch(salahTrainerMadhhabProvider);
    final rakahs = ref.watch(salahPrayerRakahsProvider(prayerId));
    if (prayer == null) {
      return LearnHubPageScaffold(
        title: l10n.salahPrayerDetailNotFound,
        subtitle: l10n.learnContentNotFound,
        children: [
          PremiumCard(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.salahCloseAction),
              ),
            ),
          ),
        ],
      );
    }
    final textTheme = Theme.of(context).textTheme;
    final madhhabLabel = settings.preferences.madhab.localizedLabel(l10n);
    final madhhabNote = prayer.madhhabGuidance[settings.preferences.madhab];
    final hasNotes = madhhabNote != null || prayer.specialNotes.isNotEmpty;

    final overview = PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prayer.arabicTitle,
            textDirection: TextDirection.rtl,
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              AppTextStyles.quranVerse(size: 26),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SalahPill(
                label: prayer.sunnahRakahs,
                icon: Icons.wb_twilight_rounded,
              ),
              SalahPill(label: prayer.fardRakahs, icon: Icons.star_rounded),
              SalahPill(
                label: prayer.recitationStyle,
                icon: Icons.volume_up_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(prayer.overview),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnSalahGuidedPrayer',
              pathParameters: {'prayerId': prayer.id.name},
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.learnSalahHubStartGuidedSalahAction),
          ),
        ],
      ),
    );

    final notes = !hasNotes
        ? null
        : PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.salahTrainerGuidanceNotesTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (madhhabNote != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.salahTrainerMadhhabGuidanceTitle(madhhabLabel),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(madhhabNote),
                ],
                if (prayer.specialNotes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  for (final note in prayer.specialNotes)
                    SalahBulletRow(text: note),
                ],
              ],
            ),
          );

    final structure = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.salahTrainerStructureTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (focusSteps) ...[
              const SizedBox(height: 4),
              Text(
                l10n.salahTrainerStepsFocusHint,
                style: textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            ],
          ],
        ),
      ),
      for (final rakah in rakahs)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ExpandableTile(
            leading: CompactTileBadge(label: '${rakah.index}'),
            title: Text(l10n.salahTrainerRakahTitle(rakah.index)),
            subtitle: Text(l10n.salahTrainerRakahStepCount(rakah.steps.length)),
            initiallyExpanded: focusSteps || rakah.index == 1,
            child: Column(
              children: [
                for (final step in rakah.steps)
                  _StepRow(
                    step: step,
                    tasbihRepeats: tasbihRepeats,
                    madhhabNote: step.madhhabNotes[madhhab],
                    madhhabLabel: l10n.salahTrainerMadhhabGuidanceTitle(
                      madhhabLabel,
                    ),
                  ),
              ],
            ),
          ),
        ),
    ];

    return LearnHubPageScaffold(
      title: prayer.title,
      subtitle: prayer.shortDescription,
      children: [
        overview,
        const SizedBox(height: 10),
        if (focusSteps) ...[
          ...structure,
          ?notes,
        ] else ...[
          if (notes != null) ...[notes, const SizedBox(height: 10)],
          ...structure,
        ],
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.tasbihRepeats,
    required this.madhhabNote,
    required this.madhhabLabel,
  });

  final PrayerStepModel step;
  final int tasbihRepeats;
  final String? madhhabNote;
  final String madhhabLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrayerPostureAnimator(
            posture: step.posture,
            size: 34,
            showMat: false,
            duration: Duration.zero,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      step.title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (step.isOptional)
                      SalahPill(
                        label: l10n.salahTrainerOptionalBadge,
                        compact: true,
                      ),
                    if (step.entryTakbir)
                      SalahPill(
                        label: l10n.salahTrainerTakbirBadge,
                        icon: Icons.south_rounded,
                        compact: true,
                      ),
                    if (step.isTasbih)
                      SalahPill(
                        label: l10n.salahTrainerTasbihBadge(tasbihRepeats),
                        icon: Icons.repeat_rounded,
                        compact: true,
                      ),
                  ],
                ),
                if (step.helperText != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    step.helperText!,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                ],
                if (!step.isSilent || step.isDynamicSurah) ...[
                  const SizedBox(height: 4),
                  Text(step.translation, style: textTheme.bodySmall),
                ],
                if (madhhabNote case final note?) ...[
                  const SizedBox(height: 6),
                  SalahMadhhabNote(label: madhhabLabel, note: note),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
