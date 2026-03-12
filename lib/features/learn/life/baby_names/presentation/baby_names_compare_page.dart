import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';

class BabyNamesComparePage extends ConsumerWidget {
  const BabyNamesComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(babyNamesFavoritesProvider);

    return AppPageScaffold(
      headerIcon: Icons.compare_arrows_rounded,
      title: 'Name Comparison',
      subtitle: 'Use your saved names to compare meaning and style',
      children: [
        const PremiumCard(
          child: Text(
            'This page is reserved for deeper side-by-side comparison. '
            'For now, save names you like and open each detail page to review meanings, origins, and Qur’an relevance.',
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
