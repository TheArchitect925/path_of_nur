import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/reminders/adhan_audio_service.dart';
import '../../../core/reminders/adhan_options.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/premium_card.dart';

class AdhanOptionPickerSheet extends ConsumerWidget {
  const AdhanOptionPickerSheet({
    super.key,
    required this.category,
    required this.selectedId,
    required this.settings,
    required this.onSelected,
  });

  final AdhanOptionCategory category;
  final String selectedId;
  final AdhanSettings settings;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(adhanRepositoryProvider);
    final previewState = ref.watch(adhanPreviewControllerProvider);
    final previewController = ref.read(adhanPreviewControllerProvider.notifier);
    final options = category == AdhanOptionCategory.fajr
        ? repository.fajrOptions()
        : repository.regularOptions();
    // The static light-theme brown and gold did not follow the night themes.
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final subtle =
        appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurfaceVariant;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: PremiumCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category == AdhanOptionCategory.fajr
                    ? l10n.settingsAdhanPickerFajrTitle
                    : l10n.settingsAdhanPickerRegularTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                category == AdhanOptionCategory.fajr
                    ? l10n.settingsAdhanPickerFajrSubtitle
                    : l10n.settingsAdhanPickerRegularSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(color: subtle),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xxs + 2),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option.id == selectedId;
                    final isPlaying =
                        previewState.playingOptionId == option.id &&
                        (previewState.isPlaying || previewState.isBuffering);
                    return CompactListTile(
                      title: option.localizedTitle(l10n),
                      subtitle: option.localizedSubtitle(l10n),
                      leading: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? accent : subtle,
                      ),
                      trailing: IconButton(
                        tooltip: isPlaying
                            ? l10n.settingsAdhanPreviewStopTooltip
                            : l10n.settingsAdhanPreviewPlayTooltip,
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline_rounded,
                          color: accent,
                        ),
                        onPressed: () {
                          previewController.playOption(
                            option: option,
                            settings: settings,
                          );
                        },
                      ),
                      onTap: () {
                        onSelected(option.id);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
