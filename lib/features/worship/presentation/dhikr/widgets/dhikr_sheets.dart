import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../application/dhikr_controller.dart';
import '../../../application/dhikr_daily_goal_provider.dart';
import '../../../domain/dhikr_preset.dart';
import 'dhikr_pill_button.dart';

/// Bottom-sheet chrome shared by the dhikr pickers. The floating tab bar
/// overlays sheets above the system inset, so the bottom padding clears it.
Future<T?> showDhikrSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => _DhikrSheetChrome(child: builder(sheetContext)),
  );
}

class _DhikrSheetChrome extends StatelessWidget {
  const _DhikrSheetChrome({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: palette.accent,
    );
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      decoration: style
          .decoration(radius: AppRadii.glassCard)
          .copyWith(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.glassCard),
            ),
          ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.s,
        AppSpacing.l,
        AppSpacing.xl + 96 + viewInsets,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: palette.accentSoft.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          child,
        ],
      ),
    );
  }
}

Widget _sheetTitle(BuildContext context, String title, {String? subtitle}) {
  final palette = context.palette;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyles.titleSerif.copyWith(color: palette.onSurface),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: palette.onSurfaceSubtle),
        ),
      ],
      const SizedBox(height: AppSpacing.m),
    ],
  );
}

/// Selectable pill used for phrases and targets.
class DhikrChoicePill extends StatelessWidget {
  const DhikrChoicePill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: palette.accent,
    );
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: style
                .decoration(radius: AppRadii.pill, includeShadow: false)
                .copyWith(
                  color: isSelected
                      ? AppSurfaceTheme.adaptiveColor(
                          context,
                          palette.accent,
                          alpha: 0.2,
                          solidAlphaWhenDisabled: 0.3,
                        )
                      : style.backgroundColor,
                  gradient: isSelected ? null : style.gradient,
                  border: Border.all(
                    color: isSelected
                        ? palette.accent
                        : AppSurfaceTheme.adaptiveColor(
                            context,
                            palette.accentSoft,
                            alpha: 0.45,
                            solidAlphaWhenDisabled: 0.55,
                          ),
                  ),
                ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? palette.onSurface : palette.onSurfaceSubtle,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showDhikrTargetSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(dhikrControllerProvider).target;
  final controller = TextEditingController();
  return showDhikrSheet<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sheetTitle(
          sheetContext,
          l10n.dhikrSessionTargetTitle,
          subtitle: l10n.dhikrSessionTargetSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in const <int>[33, 99, 100, 500])
              DhikrChoicePill(
                label: '$value',
                isSelected: current == value,
                onTap: () {
                  ref.read(dhikrControllerProvider.notifier).setTarget(value);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.dhikrCustomTargetChip,
            hintText: l10n.dhikrCustomTargetHint,
            isDense: true,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        DhikrPillButton(
          label: l10n.dhikrApplyAction,
          emphasized: true,
          expand: true,
          onTap: () {
            final value = int.tryParse(controller.text.trim());
            if (value != null && value > 0) {
              ref.read(dhikrControllerProvider.notifier).setTarget(value);
            }
            Navigator.of(sheetContext).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showDhikrPhraseSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final selectedId = ref.read(dhikrControllerProvider).selectedPreset.id;
  return showDhikrSheet<void>(
    context,
    builder: (sheetContext) {
      final palette = sheetContext.palette;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(
            sheetContext,
            l10n.dhikrChoosePhraseTitle,
            subtitle: l10n.dhikrChoosePhraseSubtitle,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.5,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final preset in DhikrPreset.defaults)
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.glassTile),
                      onTap: () {
                        ref
                            .read(dhikrControllerProvider.notifier)
                            .selectPreset(preset);
                        Navigator.of(sheetContext).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.label,
                                    style: Theme.of(sheetContext)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: preset.id == selectedId
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          color: palette.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    preset.translation,
                                    style: Theme.of(sheetContext)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: palette.onSurfaceSubtle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                preset.phrase,
                                style: AppTextStyles.quranVerse(
                                  size: 22,
                                  color: palette.onSurface,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (preset.id == selectedId) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: palette.accentSoft,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showDhikrAddManualSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController();
  return showDhikrSheet<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sheetTitle(sheetContext, l10n.dhikrAddManualTitle),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: l10n.dhikrAddManualHint,
            isDense: true,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        DhikrPillButton(
          label: l10n.dhikrAddAction,
          emphasized: true,
          expand: true,
          onTap: () {
            final value = int.tryParse(controller.text.trim());
            if (value != null && value > 0) {
              ref.read(dhikrControllerProvider.notifier).addManualCount(value);
            }
            Navigator.of(sheetContext).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showDhikrDailyGoalSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(dhikrDailyGoalProvider);
  final controller = TextEditingController(text: '$current');
  return showDhikrSheet<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sheetTitle(
          sheetContext,
          l10n.dhikrDailyGoalEditTitle,
          subtitle: l10n.dhikrDailyGoalSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in const <int>[100, 300, 500, 1000])
              DhikrChoicePill(
                label: '$preset',
                isSelected: current == preset,
                onTap: () {
                  ref.read(dhikrDailyGoalProvider.notifier).setGoal(preset);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.dhikrDailyGoalEditCustomLabel,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        DhikrPillButton(
          label: l10n.quranSave,
          emphasized: true,
          expand: true,
          onTap: () {
            final value = int.tryParse(controller.text.trim());
            if (value != null && value > 0) {
              ref.read(dhikrDailyGoalProvider.notifier).setGoal(value);
            }
            Navigator.of(sheetContext).pop();
          },
        ),
      ],
    ),
  );
}

/// One entry in the counter's "more" sheet.
class DhikrMenuEntry {
  const DhikrMenuEntry({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

Future<void> showDhikrMenuSheet(
  BuildContext context, {
  required String title,
  required List<DhikrMenuEntry> entries,
}) {
  return showDhikrSheet<void>(
    context,
    builder: (sheetContext) {
      final palette = sheetContext.palette;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(sheetContext, title),
          for (final entry in entries)
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadii.glassTile),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  entry.onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(entry.icon, size: 20, color: palette.accentSoft),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          entry.label,
                          style: Theme.of(sheetContext).textTheme.titleSmall
                              ?.copyWith(color: palette.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

/// The sheet shown when a session or routine finishes. Returns true when the
/// user chose Done (leave the counter), false to keep counting.
Future<bool> showDhikrCompletionSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  required int count,
  required Duration duration,
  required int streak,
  required int todayCount,
  required int dailyGoal,
  bool allowKeepCounting = true,
}) async {
  final l10n = AppLocalizations.of(context);
  final numberFormat = intl.NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  );
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  final durationLabel = '$minutes:${seconds.toString().padLeft(2, '0')}';
  final result = await showDhikrSheet<bool>(
    context,
    builder: (sheetContext) {
      final palette = sheetContext.palette;
      final theme = Theme.of(sheetContext);
      Widget stat(String value, String caption) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.glassTile),
              color: AppSurfaceTheme.adaptiveColor(
                sheetContext,
                palette.accent,
                alpha: 0.12,
                solidAlphaWhenDisabled: 0.2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: palette.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppSurfaceTheme.adaptiveColor(
                  sheetContext,
                  palette.accent,
                  alpha: 0.9,
                  solidAlphaWhenDisabled: 1,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 34,
                color: DhikrPillButton.foregroundOnAccent(sheetContext),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'ٱلْحَمْدُ لِلَّهِ',
              textAlign: TextAlign.center,
              style: AppTextStyles.quranVerse(
                size: 30,
                color: palette.onSurface,
                weight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSerif.copyWith(
              fontSize: 24,
              color: palette.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.onSurfaceSubtle,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              stat(numberFormat.format(count), l10n.dhikrCompleteRemembrances),
              const SizedBox(width: AppSpacing.xs),
              stat(durationLabel, l10n.dhikrCompleteUnhurried),
              const SizedBox(width: AppSpacing.xs),
              stat(numberFormat.format(streak), l10n.dhikrStreakCaption),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.glassTile),
              color: palette.success.withValues(alpha: 0.22),
              border: Border.all(color: palette.success.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Icon(Icons.water_drop_rounded, color: palette.onSurfaceSubtle),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    l10n.dhikrCompleteTodayLine(
                      numberFormat.format(todayCount),
                      numberFormat.format(dailyGoal),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: DhikrPillButton(
                  label: l10n.dhikrDoneAction,
                  emphasized: true,
                  expand: true,
                  onTap: () => Navigator.of(sheetContext).pop(true),
                ),
              ),
              if (allowKeepCounting) ...[
                const SizedBox(width: AppSpacing.xs),
                DhikrPillButton(
                  label: l10n.dhikrKeepCountingAction,
                  onTap: () => Navigator.of(sheetContext).pop(false),
                ),
              ],
            ],
          ),
        ],
      );
    },
  );
  return result ?? true;
}

/// Asks for a whole number (a repeat count). Returns null when dismissed.
Future<int?> showDhikrNumberSheet(
  BuildContext context, {
  required String title,
  required int initial,
  String? confirmLabel,
}) {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: '$initial');
  return showDhikrSheet<int>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sheetTitle(sheetContext, title),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in const <int>[1, 3, 7, 10, 33, 100])
              DhikrChoicePill(
                label: '$value',
                isSelected: initial == value,
                onTap: () => Navigator.of(sheetContext).pop(value),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        DhikrPillButton(
          label: confirmLabel ?? l10n.dhikrApplyAction,
          emphasized: true,
          expand: true,
          onTap: () {
            final value = int.tryParse(controller.text.trim());
            Navigator.of(
              sheetContext,
            ).pop(value != null && value > 0 ? value : null);
          },
        ),
      ],
    ),
  );
}
