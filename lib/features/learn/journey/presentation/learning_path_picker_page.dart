import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../shared/learn_art_assets.dart';
import '../application/learning_path_provider.dart';
import '../data/learning_path_registry.dart';
import '../domain/learning_path_models.dart';

/// The level picker: four scenic cards with the friendly level names.
/// Switching is honest — journey and stage progress is never touched, only
/// which path frames it — and the confirm copy says exactly that.
class LearningPathPickerPage extends ConsumerWidget {
  const LearningPathPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selection = ref.watch(learningPathSelectionProvider);
    final selectedLevel = selection?.selectedLevel;

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      headerAlignment: AppPageHeaderAlignment.center,
      title: l10n.learnPathPickerTitle,
      subtitle: l10n.learnPathPickerSubtitle,
      children: [
        for (final path in LearningPathRegistry.paths) ...[
          ArtHeaderCard(
            imageAsset: levelArtAsset(path.level),
            title: LearningPathRegistry.localizedPathTitle(l10n, path),
            subtitle: LearningPathRegistry.localizedPathDescription(l10n, path),
            eyebrow: path.level == selectedLevel
                ? l10n.learnPathPickerCurrentBadge
                : null,
            fallbackIcon: Icons.route_rounded,
            fallbackColor: Theme.of(context).colorScheme.primary,
            aspectRatio: 21 / 9,
            trailing: path.level == selectedLevel
                ? const Icon(Icons.check_circle_rounded, color: Colors.white)
                : null,
            onTap: () => _select(context, ref, path.level, selectedLevel),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    LearningPathLevel level,
    LearningPathLevel? selectedLevel,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (level == selectedLevel) {
      context.pop();
      return;
    }
    if (selectedLevel != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.learningPathSwitchConfirmTitle),
          content: Text(l10n.learningPathSwitchConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.learningPathSwitchCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.learningPathSwitchConfirm),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    if (!context.mounted) return;
    ref.read(learningPathSelectionProvider.notifier).setLevel(level);
    context.pop();
  }
}
