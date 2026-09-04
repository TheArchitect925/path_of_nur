import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../../shared/widgets/display/index_rail.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../data/names_of_allah_data.dart';
import '../../../../core/theme/app_icons.dart';

class NamesOfAllahPage extends ConsumerStatefulWidget {
  const NamesOfAllahPage({super.key});

  @override
  ConsumerState<NamesOfAllahPage> createState() => _NamesOfAllahPageState();
}

class _NamesOfAllahPageState extends ConsumerState<NamesOfAllahPage> {
  static const _gridColumns = 2;
  static const _railLabels = <String>[
    '1',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '99',
  ];

  final ScrollController _scrollController = ScrollController();
  String _query = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpToRailIndex(int railIndex, int totalNames) {
    if (!_scrollController.hasClients) return;
    final nameNumber = int.tryParse(_railLabels[railIndex]) ?? 1;
    final fraction = ((nameNumber - 1) / totalNames).clamp(0.0, 1.0);
    final target = _scrollController.position.maxScrollExtent * fraction;
    _scrollController.jumpTo(target);
  }

  void _openDetail(BuildContext context, NameOfAllah name) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final surface = appearance?.surface ?? theme.colorScheme.surface;
        final foreground = appearance?.onSurface ?? theme.colorScheme.onSurface;
        final subtle =
            appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurfaceVariant;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24 + MediaQuery.viewPaddingOf(sheetContext).bottom,
          ),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.cardLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CompactTileBadge(label: '${name.index}'),
              const SizedBox(height: AppSpacing.m),
              Text(
                name.arabic,
                style: AppTextStyles.quranVerse(size: 40, color: foreground),
                textAlign: TextAlign.center,
                textDirection: textDirectionForContent(name.arabic),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                name.transliteration,
                style: theme.textTheme.titleMedium?.copyWith(color: foreground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                name.meaning,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subtle,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final normalized = _query.trim().toLowerCase();
    final filtered = namesOfAllah.where((name) {
      if (normalized.isEmpty) return true;
      return name.transliteration.toLowerCase().contains(normalized) ||
          name.meaning.toLowerCase().contains(normalized) ||
          name.arabic.contains(normalized);
    }).toList();
    final isFiltering = normalized.isNotEmpty;

    return Stack(
      children: [
        AppPageScaffold(
          headerIcon: AppIcons.namesOfAllah,
          title: l10n.quranNamesOfAllahTitle,
          subtitle: l10n.batch9NamesOfAllahSubtitle,
          scrollController: _scrollController,
          bodySlivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                isFiltering ? 16 : 16 + 26,
                0,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridColumns,
                  mainAxisExtent: 160,
                  crossAxisSpacing: AppSpacing.gridGutter,
                  mainAxisSpacing: AppSpacing.gridGutter,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _NameGridTile(
                    name: filtered[index],
                    onTap: () => _openDetail(context, filtered[index]),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
          ],
          children: [
            PremiumCard(
              density: PremiumCardDensity.compact,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: l10n.batch9NamesOfAllahSearchHint,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.batch9NamesOfAllahCount(
                  '${filtered.length}',
                  '${namesOfAllah.length}',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: appearance?.backgroundForegroundSubtle,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
        ),
        if (!isFiltering)
          Positioned(
            right: 2,
            top: 180,
            bottom: 160,
            child: SafeArea(
              child: IndexRail(
                labels: _railLabels,
                onSelected: (railIndex) =>
                    _jumpToRailIndex(railIndex, namesOfAllah.length),
              ),
            ),
          ),
      ],
    );
  }
}

class _NameGridTile extends StatelessWidget {
  const _NameGridTile({required this.name, required this.onTap});

  final NameOfAllah name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      density: PremiumCardDensity.tile,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompactTileBadge(label: '${name.index}', size: 30),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Text(
                  name.arabic,
                  style: AppTextStyles.arabicLearning(
                    size: 24,
                    color:
                        theme.textTheme.titleSmall?.color ??
                        theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.end,
                  textDirection: textDirectionForContent(name.arabic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name.transliteration,
            style: theme.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              name.meaning,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
