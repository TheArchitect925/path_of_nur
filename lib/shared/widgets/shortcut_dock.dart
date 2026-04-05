import 'package:flutter/material.dart';

import 'app_layered_glass_pill_button.dart';

class ShortcutDockPalette {
  const ShortcutDockPalette({
    required this.textColor,
    required this.borderColor,
    required this.shadowColor,
    required this.gradient,
    this.detailFillColor,
  });

  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
  final List<Color> gradient;
  final Color? detailFillColor;

  static const ShortcutDockPalette defaultWarm = ShortcutDockPalette(
    textColor: Color(0xFF4E4034),
    borderColor: Color(0xFF8C775D),
    shadowColor: Color(0xFF8C775D),
    gradient: [Color(0xFFF7F0E1), Color(0xFFE3D2B4)],
  );
}

class ShortcutDockAction {
  const ShortcutDockAction({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.palette,
    this.supportingText,
    this.statusText,
    this.statusCaption,
    this.badgeIcon,
    this.badgeColor,
    this.badgeTooltip,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ShortcutDockPalette palette;
  final String? supportingText;
  final String? statusText;
  final String? statusCaption;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final String? badgeTooltip;
}

class ShortcutDock extends StatelessWidget {
  const ShortcutDock({
    super.key,
    required this.actions,
    required this.expanded,
    required this.openLabel,
    required this.closeLabel,
    required this.onToggle,
    this.togglePalette = ShortcutDockPalette.defaultWarm,
  });

  final List<ShortcutDockAction> actions;
  final bool expanded;
  final String openLabel;
  final String closeLabel;
  final VoidCallback onToggle;
  final ShortcutDockPalette togglePalette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 1,
                child: child,
              ),
            );
          },
          child: !expanded
              ? const SizedBox.shrink()
              : Column(
                  key: const ValueKey('shortcut-dock-expanded'),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final action in actions) ...[
                      _ShortcutDockChip(action: action),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
        ),
        _ShortcutDockToggleChip(
          expanded: expanded,
          openLabel: openLabel,
          closeLabel: closeLabel,
          onTap: onToggle,
          palette: togglePalette,
        ),
      ],
    );
  }
}

class _ShortcutDockChip extends StatelessWidget {
  const _ShortcutDockChip({required this.action});

  final ShortcutDockAction action;

  @override
  Widget build(BuildContext context) {
    final textColor = action.palette.textColor;
    return AppLayeredGlassPill(
      onTap: action.onTap,
      tintColor: action.palette.borderColor,
      fillColor: action.palette.gradient.first.withValues(alpha: 0.88),
      borderColor: action.palette.borderColor.withValues(alpha: 0.24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 196),
            child: _ShortcutDockLabelBlock(action: action),
          ),
          if (action.statusText case final statusText?
              when statusText.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color:
                    action.palette.detailFillColor ??
                    Colors.white.withValues(alpha: 0.34),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (action.statusCaption case final statusCaption?
                      when statusCaption.isNotEmpty) ...[
                    Text(
                      statusCaption,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: textColor.withValues(alpha: 0.78),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (action.badgeIcon != null) ...[
            const SizedBox(width: 6),
            Tooltip(
              message: action.badgeTooltip ?? '',
              child: Icon(
                action.badgeIcon,
                size: 16,
                color: action.badgeColor ?? textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShortcutDockLabelBlock extends StatelessWidget {
  const _ShortcutDockLabelBlock({required this.action});

  final ShortcutDockAction action;

  @override
  Widget build(BuildContext context) {
    final textColor = action.palette.textColor;
    if (action.supportingText case final supporting?
        when supporting.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            action.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            supporting,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.8,
              color: textColor.withValues(alpha: 0.78),
              height: 1.15,
            ),
          ),
        ],
      );
    }

    return Text(
      action.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _ShortcutDockToggleChip extends StatelessWidget {
  const _ShortcutDockToggleChip({
    required this.expanded,
    required this.openLabel,
    required this.closeLabel,
    required this.onTap,
    required this.palette,
  });

  final bool expanded;
  final String openLabel;
  final String closeLabel;
  final VoidCallback onTap;
  final ShortcutDockPalette palette;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPillButton(
      onPressed: onTap,
      tintColor: palette.borderColor,
      fillColor: palette.gradient.first.withValues(alpha: 0.9),
      borderColor: palette.borderColor.withValues(alpha: 0.24),
      foregroundColor: palette.textColor,
      leading: Icon(
        expanded ? Icons.close_rounded : Icons.apps_rounded,
        size: 18,
        color: palette.textColor,
      ),
      label: expanded ? closeLabel : openLabel,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}
