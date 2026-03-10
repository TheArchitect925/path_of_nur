import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../domain/baby_name_models.dart';

class BabyNamesHomePage extends ConsumerWidget {
  const BabyNamesHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(babyNamesAllProvider);
    final favorites = ref.watch(babyNamesFavoritesProvider);
    final shortlist = ref.watch(babyNamesShortlistProvider);
    final compare = ref.watch(babyNamesCompareProvider);
    final collections = ref.watch(babyNamesCollectionsProvider);
    final ofDay = ref.watch(babyNamesNameOfDayProvider);

    return AppPageScaffold(
      headerIcon: Icons.child_friendly_rounded,
      title: l10n.babyNamesTitle,
      subtitle: l10n.babyNamesSubtitle,
      children: [
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.babyNamesNameOfDay,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text('${ofDay.english} • ${ofDay.arabic}\n${ofDay.meaning}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(
              'babyNameDetail',
              pathParameters: {'nameId': ofDay.id},
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: l10n.babyNamesBrowseSearchTitle,
                subtitle: l10n.babyNamesBrowseSearchSubtitle,
                icon: Icons.search_rounded,
                onTap: () => context.pushNamed('babyNamesBrowse'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                title: l10n.babyNamesSmartFinderTitle,
                subtitle: l10n.babyNamesSmartFinderSubtitle,
                icon: Icons.auto_awesome_rounded,
                onTap: () => context.pushNamed('babyNamesFinder'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: l10n.babyNamesFavoritesTitle,
                subtitle: '${favorites.length} ${l10n.babyNamesSavedCountLabel}',
                icon: Icons.favorite_border_rounded,
                onTap: () => context.pushNamed('babyNamesFavorites'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                title: l10n.babyNamesCompareTitle,
                subtitle: '${compare.length}/4 ${l10n.babyNamesSelectedCountLabel}',
                icon: Icons.compare_arrows_rounded,
                onTap: () => context.pushNamed('babyNamesCompare'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.babyNamesOverviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatChip(
                    label: l10n.babyNamesBoysLabel,
                    value: all.where((n) => n.gender == BabyNameGender.boy).length,
                  ),
                  _StatChip(
                    label: l10n.babyNamesGirlsLabel,
                    value: all.where((n) => n.gender == BabyNameGender.girl).length,
                  ),
                  _StatChip(
                    label: l10n.babyNamesUnisexLabel,
                    value: all.where((n) => n.gender == BabyNameGender.unisex).length,
                  ),
                  _StatChip(
                    label: l10n.babyNamesQuranicLabel,
                    value: all.where((n) => n.isQuranic).length,
                  ),
                  _StatChip(
                    label: l10n.babyNamesCompanionLabel,
                    value: all.where((n) => n.isCompanionName).length,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${shortlist.length} ${l10n.babyNamesShortlistCountLabel}',
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.babyNamesCollectionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...collections.map(
                (collection) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(collection.title),
                  subtitle: Text(collection.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    'babyNamesBrowse',
                    queryParameters: {'collection': collection.id},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF7EFD9),
        border: Border.all(color: const Color(0xFFD9C79A)),
      ),
      child: Text('$label: $value'),
    );
  }
}

