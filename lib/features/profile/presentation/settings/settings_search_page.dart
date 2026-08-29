import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/premium_card.dart';
import 'settings_catalog.dart';

/// Finds one control among the ~60 spread across the settings pages, then
/// sends you to the page that holds it. Reached from the search icon in the
/// Settings header, mirroring the search action on every other hub.
class SettingsSearchPage extends StatefulWidget {
  const SettingsSearchPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SettingsSearchPage> createState() => _SettingsSearchPageState();
}

class _SettingsSearchPageState extends State<SettingsSearchPage> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );
  late String _query = widget.initialQuery;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trimmed = _query.trim();
    final results = searchSettings(trimmed, l10n);

    // Results stay grouped by the page they live on, so the answer to "where
    // is this?" comes with the result rather than after tapping it.
    final grouped = <SettingsCategory, List<SettingsSearchEntry>>{};
    for (final entry in results) {
      grouped.putIfAbsent(entry.category, () => []).add(entry);
    }

    return AppPageScaffold(
      headerIcon: Icons.search_rounded,
      title: l10n.settingsSearchTitle,
      subtitle: l10n.settingsSearchSubtitle,
      children: [
        PremiumCard(
          density: PremiumCardDensity.compact,
          child: TextField(
            autofocus: true,
            controller: _controller,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.settingsSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: trimmed.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).deleteButtonTooltip,
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (trimmed.isEmpty)
          _SettingsSearchHint(l10n: l10n)
        else if (results.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsSearchEmptyTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.settingsSearchEmptySubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        else
          for (final category in grouped.keys) ...[
            HubListGroup(
              title: settingsCategoryTitle(category, l10n),
              children: [
                for (final entry in grouped[category]!)
                  // No subtitle: the group header above already names the
                  // page, and repeating its description on every row buries
                  // the setting you were looking for.
                  CompactListTile(
                    title: entry.title,
                    leading: HubLeadingIcon(settingsCategoryIcon(category)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () =>
                        context.pushNamed(settingsCategoryRouteName(category)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.cardGap),
          ],
      ],
    );
  }
}

class _SettingsSearchHint extends StatelessWidget {
  const _SettingsSearchHint({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsSearchPromptTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.settingsSearchPromptSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
