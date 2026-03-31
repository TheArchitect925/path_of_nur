import 'package:flutter/material.dart';

import '../../core/theme/app_surfaces.dart';
import 'app_page_scaffold.dart';
import 'quran_quote_block.dart';
import 'shortcut_dock.dart';

class SectionShortcutAction {
  const SectionShortcutAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.supportingText,
    this.palette = ShortcutDockPalette.defaultWarm,
    this.statusText,
    this.statusCaption,
    this.badgeIcon,
    this.badgeColor,
    this.badgeTooltip,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? supportingText;
  final ShortcutDockPalette palette;
  final String? statusText;
  final String? statusCaption;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final String? badgeTooltip;
}

class SectionHubAction {
  const SectionHubAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color accentColor;
}

class SectionHubScaffold extends StatefulWidget {
  const SectionHubScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.headerIcon,
    this.quote,
    this.quoteHeader,
    this.onQuoteTap,
    this.headerActions,
    this.shortcutActions = const <SectionShortcutAction>[],
    required this.shortcutOpenLabel,
    required this.shortcutCloseLabel,
    this.backgroundAssetPath,
    this.backgroundOverlayColor,
    this.floatingBottom,
    this.layoutConfig = PageLayoutConfig.standard,
    this.ownsBackground = true,
  });

  final String title;
  final String subtitle;
  final IconData? headerIcon;
  final QuranQuote? quote;
  final Widget? quoteHeader;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final List<Widget>? headerActions;
  final List<Widget> children;
  final List<SectionShortcutAction> shortcutActions;
  final String shortcutOpenLabel;
  final String shortcutCloseLabel;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final Widget? floatingBottom;
  final PageLayoutConfig layoutConfig;
  final bool ownsBackground;

  @override
  State<SectionHubScaffold> createState() => _SectionHubScaffoldState();
}

class _SectionHubScaffoldState extends State<SectionHubScaffold> {
  bool _shortcutsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: widget.headerIcon,
      title: widget.title,
      subtitle: widget.subtitle,
      quote: widget.quote,
      quoteHeader: widget.quoteHeader,
      onQuoteTap: widget.onQuoteTap,
      headerActions: widget.headerActions,
      backgroundAssetPath: widget.backgroundAssetPath,
      backgroundOverlayColor: widget.backgroundOverlayColor,
      layoutConfig: widget.layoutConfig,
      ownsBackground: widget.ownsBackground,
      floatingBottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.floatingBottom != null) widget.floatingBottom!,
          if (widget.floatingBottom != null && widget.shortcutActions.isNotEmpty)
            const SizedBox(height: 10),
          if (widget.shortcutActions.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: _SectionShortcutDock(
                actions: widget.shortcutActions,
                expanded: _shortcutsExpanded,
                openLabel: widget.shortcutOpenLabel,
                closeLabel: widget.shortcutCloseLabel,
                onToggle: () {
                  setState(() => _shortcutsExpanded = !_shortcutsExpanded);
                },
              ),
            ),
        ],
      ),
      children: [
        ...widget.children,
        if (widget.floatingBottom != null) const SizedBox(height: 108),
      ],
    );
  }
}

class SectionHubActionGrid extends StatelessWidget {
  const SectionHubActionGrid({super.key, required this.actions});

  final List<SectionHubAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 720
            ? 3
            : width >= 460
            ? 2
            : 1;
        final itemWidth = columns == 1
            ? width
            : (width - (12 * (columns - 1))) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions
              .map(
                (action) => SizedBox(
                  width: itemWidth,
                  child: SectionHubActionCard(action: action),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class SectionHubActionCard extends StatelessWidget {
  const SectionHubActionCard({super.key, required this.action});

  final SectionHubAction action;

  @override
  Widget build(BuildContext context) {
    final contentColors = AppSurfaceTheme.contentColors(context);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.island,
      tintColor: action.accentColor,
      baseColor: action.color,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: surfaceStyle.splashColor,
        highlightColor: surfaceStyle.highlightColor,
        child: Ink(
          decoration: surfaceStyle.decoration(radius: 20, includeShadow: true),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: surfaceStyle.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: surfaceStyle.borderColor),
                ),
                child: Icon(action.icon, color: action.accentColor),
              ),
              const SizedBox(height: 14),
              Text(
                action.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: action.accentColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: contentColors.subtleForeground,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionShortcutDock extends StatelessWidget {
  const _SectionShortcutDock({
    required this.actions,
    required this.expanded,
    required this.openLabel,
    required this.closeLabel,
    required this.onToggle,
  });

  final List<SectionShortcutAction> actions;
  final bool expanded;
  final String openLabel;
  final String closeLabel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ShortcutDock(
      expanded: expanded,
      openLabel: openLabel,
      closeLabel: closeLabel,
      onToggle: onToggle,
      actions: actions
          .map(
            (action) => ShortcutDockAction(
              label: action.label,
              supportingText: action.supportingText,
              icon: action.icon,
              onTap: action.onTap,
              palette: action.palette,
              statusText: action.statusText,
              statusCaption: action.statusCaption,
              badgeIcon: action.badgeIcon,
              badgeColor: action.badgeColor,
              badgeTooltip: action.badgeTooltip,
            ),
          )
          .toList(growable: false),
    );
  }
}
