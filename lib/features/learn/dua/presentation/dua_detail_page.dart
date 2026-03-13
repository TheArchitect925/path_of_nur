import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../application/dua_progress_provider.dart';
import '../application/dua_repository.dart';
import '../domain/dua_models.dart';

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
    final itemAsync = ref.watch(duaItemByIdProvider(widget.duaId));
    final saved = ref
        .watch(duaLearningProvider)
        .savedIds
        .contains(widget.duaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua'),
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
            return const Center(child: Text('Dua not found.'));
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
        error: (error, _) => Center(child: Text('Unable to load dua. $error')),
      ),
    );
  }

  Widget _heroCard(BuildContext context, DuaItem item) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
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
              _pill(item.isQuran ? 'Qur’an' : 'Sunnah'),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(item.subcategoryLabel),
              _pill(item.difficulty.label),
              if (item.isCore) _pill('Core verified'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _duaTextCard(BuildContext context, DuaItem item) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supplication',
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
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When to say it',
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
                label: const Text('Mark reflected'),
              ),
              if (quranRef != null)
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'quranReader',
                    pathParameters: {'surahNumber': '${quranRef.$1}'},
                    queryParameters: {
                      'ayah': '${quranRef.$2}',
                      if (quranRef.$3 != null) 'endAyah': '${quranRef.$3}',
                      'autoplay': 'true',
                    },
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Open in Quran reader'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagsCard(BuildContext context, DuaItem item) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.tags.map(_pill).toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _plannedState(BuildContext context, DuaItem item) {
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
                'Planned content',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'This entry exists in the dua scaffold, but the source text and verification details have not been completed yet. It stays tracked so the final dua library can expand without changing the architecture.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
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
