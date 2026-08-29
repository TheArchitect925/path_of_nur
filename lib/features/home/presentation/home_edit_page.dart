import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/home_module_prefs_provider.dart';
import '../domain/home_modules.dart';

/// "Customize Home": reorder and toggle the Mihrab Home's modules. The salah
/// hero is pinned; hidden modules park at the bottom, one switch from
/// returning.
class HomeEditPage extends ConsumerWidget {
  const HomeEditPage({super.key});

  String _moduleTitle(AppLocalizations l10n, HomeModule module) {
    switch (module) {
      case HomeModule.prayerStrip:
        return l10n.homeModulePrayerStripTitle;
      case HomeModule.today:
        return l10n.homeTodayContentTitle;
      case HomeModule.garden:
        return l10n.homeModuleGardenTitle;
      case HomeModule.duasNow:
        return l10n.homeRightNowTitle;
      case HomeModule.onThisDay:
        return l10n.historyOnThisDayTitle;
      case HomeModule.celestial:
        return l10n.celestialHomeCardTitle;
    }
  }

  String _moduleSubtitle(AppLocalizations l10n, HomeModule module) {
    switch (module) {
      case HomeModule.prayerStrip:
        return l10n.homeModulePrayerStripSubtitle;
      case HomeModule.today:
        return l10n.homeTodayContentSubtitle;
      case HomeModule.garden:
        return l10n.homeModuleGardenSubtitle;
      case HomeModule.duasNow:
        return l10n.homeRightNowSubtitle;
      case HomeModule.onThisDay:
        return l10n.historyOnThisDaySubtitle;
      case HomeModule.celestial:
        return l10n.homeModuleCelestialSubtitle;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(homeModulePrefsProvider);
    final notifier = ref.read(homeModulePrefsProvider.notifier);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final subtle =
        appearance?.onSurfaceSubtle ?? Theme.of(context).colorScheme.onSurface;
    final visible = prefs.visible;
    final hidden = prefs.order
        .where((module) => prefs.hidden.contains(module))
        .toList(growable: false);

    return AppPageScaffold(
      title: l10n.homeEditTitle,
      subtitle: l10n.homeEditSubtitle,
      children: [
        PremiumCard(
          density: PremiumCardDensity.compact,
          child: Row(
            children: [
              Icon(Icons.push_pin_outlined, size: 20, color: subtle),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  l10n.homeModuleSalahHeroTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                l10n.homeEditAlwaysOnLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: subtle),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: visible.length,
          onReorderItem: notifier.reorderVisible,
          itemBuilder: (context, index) {
            final module = visible[index];
            return Padding(
              key: ValueKey(module.storageId),
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ModuleRow(
                title: _moduleTitle(l10n, module),
                subtitle: _moduleSubtitle(l10n, module),
                value: true,
                dragIndex: index,
                onChanged: (value) => notifier.setVisible(module, value),
              ),
            );
          },
        ),
        if (hidden.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          SectionTitle(title: l10n.homeEditHiddenTitle),
          for (final module in hidden)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ModuleRow(
                title: _moduleTitle(l10n, module),
                subtitle: _moduleSubtitle(l10n, module),
                value: false,
                onChanged: (value) => notifier.setVisible(module, value),
              ),
            ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: subtle),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                l10n.homeEditTrackerFootnote,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: subtle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.dragIndex,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;

    return PremiumCard(
      density: PremiumCardDensity.compact,
      child: Row(
        children: [
          if (dragIndex != null)
            ReorderableDragStartListener(
              index: dragIndex!,
              child: Icon(Icons.drag_indicator_rounded, size: 20, color: subtle),
            )
          else
            Icon(Icons.visibility_off_outlined, size: 18, color: subtle),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: value ? null : subtle,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: subtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
