import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shortcut_pill.dart';

class MainPageShortcutStyle {
  const MainPageShortcutStyle({
    required this.tintColor,
    required this.fillColor,
    required this.borderColor,
    required this.foregroundColor,
  });

  final Color tintColor;
  final Color fillColor;
  final Color borderColor;
  final Color foregroundColor;
}

class MainPageShortcutItem {
  const MainPageShortcutItem({
    required this.label,
    required this.icon,
    required this.routeName,
    required this.style,
    this.progressText,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String label;
  final IconData icon;
  final String routeName;
  final MainPageShortcutStyle style;
  final String? progressText;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class MainPageShortcutStack extends StatefulWidget {
  const MainPageShortcutStack({
    super.key,
    required this.items,
    required this.openLabel,
    required this.closeLabel,
    this.openIcon = Icons.apps_rounded,
    this.closeIcon = Icons.close_rounded,
  });

  final List<MainPageShortcutItem> items;
  final String openLabel;
  final String closeLabel;
  final IconData openIcon;
  final IconData closeIcon;

  @override
  State<MainPageShortcutStack> createState() => _MainPageShortcutStackState();
}

class _MainPageShortcutStackState extends State<MainPageShortcutStack> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_expanded) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < widget.items.length; index++) ...[
                  _ShortcutStackItemPill(
                    item: widget.items[index],
                    onPressed: () {
                      setState(() => _expanded = false);
                      context.pushNamed(
                        widget.items[index].routeName,
                        pathParameters: widget.items[index].pathParameters,
                        queryParameters: widget.items[index].queryParameters,
                      );
                    },
                  ),
                  if (index + 1 < widget.items.length)
                    const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        AppShortcutPill(
          label: _expanded ? widget.closeLabel : widget.openLabel,
          icon: _expanded ? widget.closeIcon : widget.openIcon,
          onPressed: () => setState(() => _expanded = !_expanded),
        ),
      ],
    );
  }
}

class _ShortcutStackItemPill extends StatelessWidget {
  const _ShortcutStackItemPill({required this.item, required this.onPressed});

  final MainPageShortcutItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppShortcutPill(
      label: item.label,
      icon: item.icon,
      onPressed: onPressed,
      trailingText: item.progressText,
      tintColor: item.style.tintColor,
      fillColor: item.style.fillColor,
      borderColor: item.style.borderColor,
      foregroundColor: item.style.foregroundColor,
    );
  }
}
