import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';

class BabyNamesFavoritesPage extends ConsumerWidget {
  const BabyNamesFavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(babyNamesFavoritesProvider);
    final shortlist = ref.watch(babyNamesShortlistProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    final notes = ref.watch(babyNamesControllerProvider).notesById;

    return AppPageScaffold(
      headerIcon: Icons.favorite_outline_rounded,
      title: l10n.babyNamesFavoritesTitle,
      subtitle: l10n.babyNamesFavoritesSubtitle,
      children: [
        PremiumCard(
          child: Row(
            children: [
              Text(
                '${favorites.length} ${l10n.babyNamesSavedCountLabel}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${shortlist.length} ${l10n.babyNamesShortlistCountLabel}',
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (favorites.isEmpty && shortlist.isEmpty)
          PremiumCard(child: Text(l10n.babyNamesFavoritesEmpty)),
        if (shortlist.isNotEmpty)
          _Section(
            title: l10n.babyNamesShortlistTitle,
            children: shortlist
                .map(
                  (name) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(name.english),
                    subtitle: Text('${name.arabic} • ${name.meaning}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove_outlined),
                      onPressed: () => notifier.toggleShortlist(name.id),
                    ),
                    onTap: () => context.pushNamed(
                      'babyNameDetail',
                      pathParameters: {'nameId': name.id},
                    ),
                  ),
                )
                .toList(),
          ),
        if (shortlist.isNotEmpty && favorites.isNotEmpty) const SizedBox(height: 10),
        if (favorites.isNotEmpty)
          _Section(
            title: l10n.babyNamesFavoritesTitle,
            children: favorites
                .map(
                  (name) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(name.english),
                    subtitle: Text(
                      '${name.arabic} • ${name.meaning}${notes[name.id] == null ? '' : '\n${notes[name.id]}'}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () => notifier.toggleFavorite(name.id),
                    ),
                    onTap: () => context.pushNamed(
                      'babyNameDetail',
                      pathParameters: {'nameId': name.id},
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

