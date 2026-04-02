import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../application/dua_progress_provider.dart';
import '../application/dua_repository.dart';
import '../domain/dua_models.dart';
import 'dua_category_theme.dart';

class DuaDetailPage extends ConsumerStatefulWidget {
  const DuaDetailPage({super.key, required this.duaId});

  final String duaId;

  @override
  ConsumerState<DuaDetailPage> createState() => _DuaDetailPageState();
}

class _DuaDetailPageState extends ConsumerState<DuaDetailPage> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(duaLearningProvider.notifier).open(widget.duaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemAsync = ref.watch(duaItemByIdProvider(widget.duaId));
    final saved = ref
        .watch(duaLearningProvider)
        .savedIds
        .contains(widget.duaId);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.duaDetailAppBarTitle),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(duaLearningProvider.notifier)
                .toggleSaved(widget.duaId),
            icon: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            ),
          ),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text(l10n.duaDetailNotFound));
          }
          if (item.completionStatus == DuaCompletionStatus.stub ||
              !item.hasContent) {
            return _plannedState(context, item);
          }
          final quranRef = item.isQuran ? _quranRef(item.sourceRef) : null;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _heroCard(context, item),
              const SizedBox(height: 12),
              if (quranRef != null) ...[
                QuranReferenceBlock(
                  surahNumber: quranRef.$1,
                  ayahStart: quranRef.$2,
                  ayahEnd: quranRef.$3,
                  title: item.title,
                ),
              ] else ...[
                _duaTextCard(context, item),
              ],
              const SizedBox(height: 12),
              _guidanceCard(context, item, quranRef),
              const SizedBox(height: 12),
              _tagsCard(context, item),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.duaDetailLoadError(error.toString()))),
      ),
    );
  }

  Widget _heroCard(BuildContext context, DuaItem item) {
    final l10n = AppLocalizations.of(context);
    final colors = DuaCategoryTheme.resolve(context, item.category);
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.iconBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(colors.icon, color: colors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.accent,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.sourceRef,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                _pill(
                  item.isQuran ? l10n.duaSourceQuran : l10n.duaSourceSunnah,
                  colors,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(item.subcategoryLabel, colors),
              _pill(_difficultyLabel(l10n, item.difficulty), colors),
              if (item.isCore) _pill(l10n.duaCoreVerified, colors),
            ],
          ),
        ],
      ),
    );
  }

  Widget _duaTextCard(BuildContext context, DuaItem item) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duaDetailSupplicationTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text.rich(
            buildQuranTextWithColoredHarakat(
              item.arabic,
              AppTextStyles.quranVerse(size: 31).copyWith(height: 1.75),
            ),
            textAlign: textAlignForContent(item.arabic),
            textDirection: textDirectionForContent(item.arabic),
          ),
          if (item.transliteration.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.transliteration,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          if (item.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(item.translation),
          ],
        ],
      ),
    );
  }

  Widget _guidanceCard(
    BuildContext context,
    DuaItem item,
    (int, int, int?)? quranRef,
  ) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duaDetailWhenToSayTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(item.whenToSay),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => ref
                    .read(duaLearningProvider.notifier)
                    .markReflected(item.id),
                icon: const Icon(Icons.favorite_border_rounded),
                label: Text(l10n.duaDetailMarkReflected),
              ),
              if (quranRef != null)
                FilledButton.tonalIcon(
                  onPressed: () => openQuranReaderLocation(
                    context,
                    surahNumber: quranRef.$1,
                    ayahNumber: quranRef.$2,
                    endAyahNumber: quranRef.$3,
                    autoplay: true,
                    loopFocusedSelection: true,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.duaDetailOpenInQuranReader),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagsCard(BuildContext context, DuaItem item) {
    final l10n = AppLocalizations.of(context);
    final colors = DuaCategoryTheme.resolve(context, item.category);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duaDetailTagsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.tags
                .map((tag) => _pill(tag, colors))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _plannedState(BuildContext context, DuaItem item) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _heroCard(context, item),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.duaDetailPlannedTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.duaDetailPlannedBody),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill(String label, DuaCategoryThemeData colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.iconBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: colors.accent)),
    );
  }

  String _difficultyLabel(AppLocalizations l10n, DuaDifficulty difficulty) {
    switch (difficulty) {
      case DuaDifficulty.beginner:
        return l10n.learnTrackBeginner;
      case DuaDifficulty.intermediate:
        return l10n.learnHubDifficultyIntermediate;
      case DuaDifficulty.advanced:
        return l10n.learnHubDifficultyAdvanced;
    }
  }

  (int, int, int?)? _quranRef(String sourceRef) {
    final match = RegExp(r'(\d+):(\d+)(?:-(\d+))?').firstMatch(sourceRef);
    if (match == null) return null;
    final surah = int.tryParse(match.group(1) ?? '');
    final ayahStart = int.tryParse(match.group(2) ?? '');
    final ayahEnd = int.tryParse(match.group(3) ?? '');
    if (surah == null || ayahStart == null) return null;
    return (surah, ayahStart, ayahEnd);
  }
}
