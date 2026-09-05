import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/world_creation_provider.dart';
import '../../domain/world_creation_models.dart';
import '../../../../../l10n/app_localizations.dart';

class WorldSignsExplorerPage extends ConsumerWidget {
  const WorldSignsExplorerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domains = ref.watch(worldCreationExploreDomainsProvider);

    return AppPageScaffold(
      title: AppLocalizations.of(context).worldLandingSignsExplorerAction,
      subtitle: AppLocalizations.of(context).worldSignsExplorerSubtitle,
      children: [
        ...domains.map(
          (domain) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(domain.$1),
                subtitle: const Text(
                  'Explore relevant lessons, reflections, and observation prompts.',
                ),
                onTap: () {
                  final category = WorldCreationCategoryId.values.firstWhere(
                    (item) => item.name == domain.$2,
                    orElse: () => WorldCreationCategoryId.reflectionSigns,
                  );
                  context.pushNamed(
                    'worldCreationCategory',
                    pathParameters: {'categoryName': category.name},
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
