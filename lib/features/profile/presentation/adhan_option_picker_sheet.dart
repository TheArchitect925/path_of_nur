import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/reminders/adhan_audio_service.dart';
import '../../../core/reminders/adhan_options.dart';
import '../../../core/theme/app_colors.dart';
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
    final repository = ref.watch(adhanRepositoryProvider);
    final previewState = ref.watch(adhanPreviewControllerProvider);
    final previewController = ref.read(adhanPreviewControllerProvider.notifier);
    final options = category == AdhanOptionCategory.fajr
        ? repository.fajrOptions()
        : repository.regularOptions();

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
                    ? 'Choose Fajr Adhan'
                    : 'Choose Regular Adhan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                category == AdhanOptionCategory.fajr
                    ? 'Used only for Fajr prayer-time playback.'
                    : 'Used for Dhuhr, Asr, Maghrib, and Isha.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option.id == selectedId;
                    final isPlaying =
                        previewState.playingOptionId == option.id &&
                        (previewState.isPlaying || previewState.isBuffering);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(option.title),
                      subtitle: Text(
                        option.subtitle ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected
                            ? AppColors.accentGold
                            : AppColors.onSurfaceSubtle,
                      ),
                      trailing: IconButton(
                        tooltip: isPlaying ? 'Stop preview' : 'Play preview',
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline_rounded,
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
