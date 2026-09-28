import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../features/profile/application/profile_settings_provider.dart';
import '../premium_card.dart';

/// Glass-native expand/collapse card replacing Material's [ExpansionTile],
/// which draws its own dividers and opaque highlight and fights the glass
/// aesthetic. Honors the reduce-motion setting.
class ExpandableTile extends ConsumerStatefulWidget {
  const ExpandableTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.child,
    this.initiallyExpanded = false,
    this.density = PremiumCardDensity.compact,
    this.surfaceTintColor,
    this.onExpansionChanged,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget child;
  final bool initiallyExpanded;
  final PremiumCardDensity density;
  final Color? surfaceTintColor;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  ConsumerState<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends ConsumerState<ExpandableTile> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final duration = Duration(milliseconds: reduceMotion ? 0 : 200);

    return PremiumCard(
      density: widget.density,
      surfaceTintColor: widget.surfaceTintColor,
      onTap: _toggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: AppSpacing.s),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextStyle.merge(
                      style: Theme.of(context).textTheme.titleSmall,
                      child: widget.title,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      DefaultTextStyle.merge(
                        style: Theme.of(context).textTheme.bodySmall,
                        child: widget.subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: duration,
                curve: Curves.easeOutCubic,
                child: const Icon(Icons.expand_more_rounded),
              ),
            ],
          ),
          AnimatedSize(
            duration: duration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.s),
                    child: widget.child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
