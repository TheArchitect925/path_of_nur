import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../../../../../l10n/app_localizations.dart';

class BabyNamesComparePage extends ConsumerWidget {
  const BabyNamesComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(babyNamesFavoritesProvider);

    return AppPageScaffold(
      title: AppLocalizations.of(context).babyNamesCompareTitle,
      subtitle: AppLocalizations.of(context).babyNamesCompareSubtitle,
      children: [
        const PremiumCard(
          child: Text(
            'Save names you like, then open each one to compare meanings, origins, and Qur’an relevance.',
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Row(
            children: [
              Text(
                '${favorites.length} names saved',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.pushNamed('babyNamesFavorites'),
                child: const Text('Open saved'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
