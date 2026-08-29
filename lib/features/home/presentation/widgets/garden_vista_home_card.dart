import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../garden/application/garden_scene_provider.dart';
import '../../../garden/application/garden_service.dart';
import '../../../garden/presentation/widgets/garden_vista/garden_element_strings.dart';
import '../../../garden/presentation/widgets/garden_vista/garden_vista_view.dart';

/// A live snapshot of the growing garden on Home. Deliberately still: no
/// ticker, no celebration, no tap targets inside the scene — the whole card
/// is one tap through to the garden itself, where the moment belongs.
class GardenVistaHomeCard extends ConsumerWidget {
  const GardenVistaHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final garden = ref.watch(activeGardenStateProvider);
    // Only the composition signature matters here; unrelated Home rebuilds
    // must not repaint the scene.
    final scene = ref.watch(activeGardenSceneSpecProvider);

    return PremiumCard(
      onTap: () => context.pushNamed('gardenPage'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: RepaintBoundary(
              child: GardenVistaView(
                spec: scene,
                crop: GardenVistaCrop.homeCard,
                enableMotion: false,
                semanticLabel: l10n.homeModuleGardenTitle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GardenElementStrings.stageTitle(
                        l10n,
                        garden.currentVisualStage.stageId,
                      ),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.gardenPageMaturityValue('${garden.maturityPercent}'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.textTheme.bodySmall?.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
