import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_asset_resolver.dart';
import '../application/quran_teaching_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'widgets/quran_teaching_asset_widgets.dart';

class QuranTeachingListenOnlyPage extends ConsumerStatefulWidget {
  const QuranTeachingListenOnlyPage({super.key, this.initialPackId});

  final String? initialPackId;

  @override
  ConsumerState<QuranTeachingListenOnlyPage> createState() =>
      _QuranTeachingListenOnlyPageState();
}

class _QuranTeachingListenOnlyPageState
    extends ConsumerState<QuranTeachingListenOnlyPage> {
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialPackId != null) {
        ref
            .read(quranTeachingListenOnlyProvider.notifier)
            .selectPack(widget.initialPackId!);
      }
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final state = ref.watch(quranTeachingListenOnlyProvider);
    final controller = ref.read(quranTeachingListenOnlyProvider.notifier);
    final packs = catalog.audioPracticePacks;
    final selectedPack = state.selectedPackId == null
        ? (packs.isEmpty ? null : packs.first)
        : catalog.audioPackById(state.selectedPackId!);
    final items =
        selectedPack?.items ?? const <QuranTeachingAudioPracticeItem>[];
    final safeIndex = items.isEmpty
        ? 0
        : state.currentIndex.clamp(0, items.length - 1);
    final currentItem = items.isEmpty ? null : items[safeIndex];

    if (selectedPack != null && state.selectedPackId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.selectPack(selectedPack.id);
      });
    }

    return AppPageScaffold(
      title: l10n.batch9ListenOnlyTitle,
      subtitle: l10n.quranTeachingListenOnlySubtitle,
      children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.batch9AudioPracticeTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.quranTeachingListenOnlySubtitle),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPack?.id,
                    items: packs
                        .map(
                          (pack) => DropdownMenuItem<String>(
                            value: pack.id,
                            child: Text(pack.title),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) return;
                      controller.selectPack(value);
                    },
                    decoration: InputDecoration(
                      labelText: l10n.quranTeachingListenOnlyContentSetLabel,
                    ),
                  ),
                  if (selectedPack != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      selectedPack.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<int>(
                      future: QuranTeachingAssetResolver.availableAudioCount(
                        selectedPack.items,
                      ),
                      builder: (context, snapshot) {
                        final available = snapshot.data;
                        if (available == null) {
                          return Text(
                            l10n.quranTeachingListenOnlyCheckingLocalAudio,
                          );
                        }
                        return Text(
                          l10n.quranTeachingListenOnlyAudioAvailability(
                            '$available',
                            '${selectedPack.items.length}',
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    selectedPack?.title ??
                        l10n.quranTeachingListenOnlyChoosePack,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.surfaceSoft.withValues(alpha: 0.6),
                    ),
                    child: currentItem == null
                        ? Text(
                            l10n.quranTeachingListenOnlySelectPackToBegin,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : _ListenOnlyContent(
                            item: currentItem,
                            visibility: state.textVisibility,
                            showVisualAnchor: state.visualModeEnabled,
                          ),
                  ),
                  const SizedBox(height: 14),
                  if (selectedPack != null)
                    Text(
                      l10n.quranTeachingListenOnlyProgress(
                        '${safeIndex + 1}',
                        '${items.length}',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: items.isEmpty ? 0 : (safeIndex + 1) / items.length,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  if (selectedPack != null) ...[
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final meta =
                            QuranTeachingAssetResolver.listenOnlyPackMeta(
                              selectedPack.id,
                            );
                        if (meta?.estimatedDurationMs == null) {
                          return const SizedBox.shrink();
                        }
                        final seconds = (meta!.estimatedDurationMs! / 1000)
                            .round();
                        return Text(
                          l10n.quranTeachingListenOnlyEstimatedPackLength(
                            '$seconds',
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  FutureBuilder<bool>(
                    future: QuranTeachingAssetResolver.hasAudio(
                      currentItem?.audio,
                    ),
                    builder: (context, snapshot) {
                      final audioAvailable = snapshot.data == true;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: IconButton.filledTonal(
                                  onPressed: items.isEmpty
                                      ? null
                                      : () => controller.previous(items.length),
                                  icon: const Icon(Icons.skip_previous_rounded),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: IconButton.filled(
                                  onPressed: !audioAvailable || items.isEmpty
                                      ? null
                                      : () {
                                          final next = !state.isPlaying;
                                          controller.setPlaying(next);
                                          if (next) {
                                            _startPlaybackSimulation(
                                              items.length,
                                            );
                                          } else {
                                            _autoAdvanceTimer?.cancel();
                                          }
                                          _showAudioCue(
                                            currentItem?.audio.label ??
                                                l10n.quranTeachingListenOnlyDefaultAudioLabel,
                                            selectedPack?.title ??
                                                l10n.quranTeachingListenOnlyDefaultContextLabel,
                                          );
                                        },
                                  icon: Icon(
                                    state.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: IconButton.filledTonal(
                                  onPressed: items.isEmpty
                                      ? null
                                      : () => controller.next(items.length),
                                  icon: const Icon(Icons.skip_next_rounded),
                                ),
                              ),
                            ],
                          ),
                          if (!audioAvailable && currentItem != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.quranTeachingListenOnlyAudioUnavailable,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.onSurfaceSubtle),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: QuranTeachingAudioIconButton(
                          audio: currentItem?.audio,
                          availableIcon: Icons.replay_rounded,
                          label: l10n.quranTeachingListenOnlyReplayAction,
                          onAvailablePressed: items.isEmpty
                              ? null
                              : () {
                                  controller.replay();
                                  _showAudioCue(
                                    currentItem?.audio.label ??
                                        l10n.quranTeachingListenOnlyReplayAction,
                                    l10n.quranTeachingListenOnlyReplayCurrentItem,
                                  );
                                },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<double>(
                          initialValue: state.playbackSpeed,
                          items: const <double>[0.75, 1.0, 1.25]
                              .map(
                                (speed) => DropdownMenuItem<double>(
                                  value: speed,
                                  child: Text('${speed}x'),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) return;
                            controller.setPlaybackSpeed(value);
                          },
                          decoration: InputDecoration(
                            labelText: l10n.quranTeachingListenOnlySpeedLabel,
                          ),
                        ),
                      ),
                    ],
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
                    l10n.quranTeachingListenOnlyModeOptionsTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: state.autoAdvance,
                    onChanged: controller.toggleAutoAdvance,
                    title: Text(l10n.quranTeachingListenOnlyAutoPlayNextItem),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: state.repeatCurrent,
                    onChanged: controller.toggleRepeatCurrent,
                    title: Text(l10n.quranTeachingListenOnlyRepeatCurrentItem),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: state.shuffle,
                    onChanged: controller.toggleShuffle,
                    title: Text(l10n.quranTeachingListenOnlyShuffleOrder),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: state.visualModeEnabled,
                    onChanged: controller.toggleVisualMode,
                    title: Text(l10n.quranTeachingListenOnlyVisualMode),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<QuranTeachingTextVisibility>(
                    segments: [
                      ButtonSegment(
                        value: QuranTeachingTextVisibility.arabicOnly,
                        label: Text(l10n.quranTeachingListenOnlyArabic),
                      ),
                      ButtonSegment(
                        value: QuranTeachingTextVisibility
                            .arabicWithTransliteration,
                        label: Text(
                          l10n.quranTeachingListenOnlyArabicTransliteration,
                        ),
                      ),
                      ButtonSegment(
                        value: QuranTeachingTextVisibility.hidden,
                        label: Text(l10n.quranTeachingListenOnlyAudioOnly),
                      ),
                    ],
                    selected: <QuranTeachingTextVisibility>{
                      state.textVisibility,
                    },
                    onSelectionChanged: (selection) {
                      controller.setTextVisibility(selection.first);
                    },
                  ),
                ],
              ),
            ),
          ],
    );
  }

  void _showAudioCue(String label, String contextLabel) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.batch9AudioCue(contextLabel, label))),
    );
  }

  void _startPlaybackSimulation(int itemCount) {
    _autoAdvanceTimer?.cancel();
    final state = ref.read(quranTeachingListenOnlyProvider);
    if (!state.autoAdvance || itemCount <= 0) return;
    _autoAdvanceTimer = Timer(
      Duration(milliseconds: (2400 / state.playbackSpeed).round()),
      () {
        if (!mounted) return;
        final current = ref.read(quranTeachingListenOnlyProvider);
        if (!current.isPlaying) return;
        final controller = ref.read(quranTeachingListenOnlyProvider.notifier);
        if (current.repeatCurrent) {
          controller.replay();
        } else {
          controller.next(itemCount);
        }
        _startPlaybackSimulation(itemCount);
      },
    );
  }
}

class _ListenOnlyContent extends StatelessWidget {
  const _ListenOnlyContent({
    required this.item,
    required this.visibility,
    required this.showVisualAnchor,
  });

  final QuranTeachingAudioPracticeItem item;
  final QuranTeachingTextVisibility visibility;
  final bool showVisualAnchor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hidden = visibility == QuranTeachingTextVisibility.hidden;
    return Column(
      children: [
        if (hidden)
          Text(
            l10n.quranTeachingListenOnlyListeningFocus,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        if (!hidden && item.arabic != null)
          Text(
            item.arabic!,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 42,
              fontFamily: 'AmiriQuran',
              height: 1.5,
            ),
          ),
        if (!hidden &&
            visibility ==
                QuranTeachingTextVisibility.arabicWithTransliteration &&
            item.transliteration != null) ...[
          const SizedBox(height: 8),
          Text(
            item.transliteration!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
        if (!hidden && item.meaning != null) ...[
          const SizedBox(height: 8),
          Text(
            item.meaning!,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
        ],
        if (showVisualAnchor && item.visualAnchor != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuranTeachingVisualAssetTile(
                label: item.visualAnchor!.label,
                hint: item.visualAnchor!.hint,
                icon: item.visualAnchor!.icon,
                imageAssetPath:
                    item.imageAssetPath ?? item.visualAnchor!.imageAssetPath,
                compact: true,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
