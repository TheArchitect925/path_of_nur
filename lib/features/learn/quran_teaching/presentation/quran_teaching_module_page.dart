import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'quran_teaching_lesson_page.dart';
import 'quran_teaching_listen_only_page.dart';

class QuranTeachingModulePage extends ConsumerStatefulWidget {
  const QuranTeachingModulePage({
    super.key,
    required this.module,
  });

  final QuranTeachingModule module;

  @override
  ConsumerState<QuranTeachingModulePage> createState() =>
      _QuranTeachingModulePageState();
}

class _QuranTeachingModulePageState
    extends ConsumerState<QuranTeachingModulePage> {
  bool _showFoundInQuran = false;

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final progress = ref.watch(quranTeachingProgressProvider);
    final lessons = catalog.lessonsForModule(widget.module.id);
    QuranTeachingAudioPracticePack? pack;
    for (final item in catalog.audioPracticePacks) {
      if (item.moduleId == widget.module.id) {
        pack = item;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.module.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.module.color.withValues(alpha: 0.18),
                        child: Icon(widget.module.icon, color: widget.module.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.module.subtitle,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(widget.module.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: moduleCompletionPercent(
                      module: widget.module,
                      catalog: catalog,
                      progress: progress,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  if (pack != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        final listenPack = pack;
                        if (listenPack == null) return;
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => QuranTeachingListenOnlyPage(
                              initialPackId: listenPack.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.headphones_rounded),
                      label: const Text('Listen Only'),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.module.type == QuranTeachingModuleType.recognizeWords) ...[
              const SizedBox(height: 12),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(value: false, label: Text('Learn Words')),
                  ButtonSegment<bool>(value: true, label: Text('Found in Qur’an')),
                ],
                selected: <bool>{_showFoundInQuran},
                onSelectionChanged: (selection) {
                  setState(() => _showFoundInQuran = selection.first);
                },
              ),
              const SizedBox(height: 12),
              ...widget.module.wordGroups.map(
                (group) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(group.subtitle),
                        const SizedBox(height: 10),
                        ...group.words.map(
                          (word) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.surfaceSoft),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.arabic,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'AmiriQuran',
                                    ),
                                  ),
                                  Text('${word.transliteration} • ${word.meaning}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    _showFoundInQuran
                                        ? '${word.frequencyLabel}${word.exampleReference == null ? '' : ' • ${word.exampleReference}'}'
                                        : word.frequencyLabel,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceSubtle,
                                    ),
                                  ),
                                  if (_showFoundInQuran && word.commonSurahs.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Often seen in: ${word.commonSurahs.join(', ')}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                  if (_showFoundInQuran && word.exampleSnippet != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      word.exampleSnippet!,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'AmiriQuran',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (widget.module.type == QuranTeachingModuleType.surahPractice) ...[
              const SizedBox(height: 12),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Starter Surah Shelf',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...widget.module.surahPractice.map(
                      (surah) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceSoft),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.title,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      surah.arabicTitle,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'AmiriQuran',
                                      ),
                                    ),
                                    Text('${surah.verseCount} ayat • ${surah.focus}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Lessons',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ...lessons.map((lesson) {
              final unlocked = isLessonUnlocked(
                lesson: lesson,
                module: widget.module,
                catalog: catalog,
                progress: progress,
              );
              final completed = progress.completedLessonIds.contains(lesson.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: unlocked
                        ? () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<bool>(
                                builder: (_) => QuranTeachingLessonPage(
                                  lesson: lesson,
                                  module: widget.module,
                                ),
                              ),
                            );
                            if (!mounted) return;
                            setState(() {});
                          }
                        : null,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: completed
                              ? Colors.green.withValues(alpha: 0.16)
                              : widget.module.color.withValues(alpha: 0.14),
                          child: Icon(
                            completed ? Icons.check_rounded : (unlocked ? Icons.play_arrow_rounded : Icons.lock_rounded),
                            color: completed ? Colors.green : widget.module.color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(lesson.subtitle),
                              const SizedBox(height: 6),
                              Text(
                                '${lesson.estimatedSeconds}s • ${completed ? 'Completed' : (unlocked ? 'Ready now' : 'Locked for guided path')}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceSubtle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
