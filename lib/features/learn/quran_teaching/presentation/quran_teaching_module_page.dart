import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../arabic/data/arabic_alphabet_catalog.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'quran_teaching_beginner_words_page.dart';
import 'quran_teaching_lesson_page.dart';
import 'quran_teaching_listen_only_page.dart';

class QuranTeachingModulePage extends ConsumerStatefulWidget {
  const QuranTeachingModulePage({super.key, required this.module});

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
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final progress = ref.watch(quranTeachingProgressProvider);
    final lessons = catalog.lessonsForModule(widget.module.id);
    QuranTeachingLesson? nextLesson;
    for (final lesson in lessons) {
      if (!progress.completedLessonIds.contains(lesson.id)) {
        nextLesson = lesson;
        break;
      }
    }
    QuranTeachingAudioPracticePack? pack;
    for (final item in catalog.audioPracticePacks) {
      if (item.moduleId == widget.module.id) {
        pack = item;
        break;
      }
    }

    return AppPageScaffold(
      title: widget.module.title,
      subtitle: widget.module.description,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: widget.module.color.withValues(
                      alpha: 0.18,
                    ),
                    child: Icon(widget.module.icon, color: widget.module.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.module.subtitle,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
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
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    label: l10n.quranTeachingModuleCompletion(
                      (moduleCompletionPercent(
                                module: widget.module,
                                catalog: catalog,
                                progress: progress,
                              ) *
                              100)
                          .round(),
                    ),
                  ),
                  if (widget.module.id == 'foundations')
                    _InfoChip(
                      label: l10n.quranTeachingAlphabetOverviewCount(
                        arabicAlphabetCatalog.length,
                      ),
                    ),
                  if (widget.module.id == 'foundations')
                    _InfoChip(label: l10n.quranTeachingAlphabetOverviewForms),
                ],
              ),
              if (nextLesson != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.surfaceSoft.withValues(alpha: 0.45),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quranTeachingModuleNextLessonTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${nextLesson.title} • ${nextLesson.subtitle}'),
                      const SizedBox(height: 10),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => QuranTeachingLessonPage(
                                lesson: nextLesson!,
                                module: widget.module,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_circle_fill_rounded),
                        label: Text(l10n.quranTeachingModuleNextLessonAction),
                      ),
                    ],
                  ),
                ),
              ],
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
                  label: Text(l10n.quranTeachingModuleListenOnlyAction),
                ),
              ],
            ],
          ),
        ),
        if (widget.module.type == QuranTeachingModuleType.recognizeWords) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranTeachingBeginnerWordsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranTeachingBeginnerWordsModuleSubtitle),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const QuranTeachingBeginnerWordsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chrome_reader_mode_rounded),
                  label: Text(l10n.quranTeachingBeginnerWordsOpenAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment<bool>(
                value: false,
                label: Text(l10n.quranTeachingModuleLearnWords),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(l10n.quranTeachingModuleFoundInQuran),
              ),
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
                        child: InkWell(
                          onTap: word.sharedBeginnerWordId == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          QuranTeachingBeginnerWordsPage(
                                            initialWordId:
                                                word.sharedBeginnerWordId,
                                          ),
                                    ),
                                  );
                                },
                          borderRadius: BorderRadius.circular(16),
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
                                Text(
                                  '${word.transliteration} • ${word.meaning}',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _showFoundInQuran
                                      ? '${word.frequencyLabel}${word.exampleReference == null ? '' : ' • ${word.exampleReference}'}'
                                      : word.frequencyLabel,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceSubtle,
                                      ),
                                ),
                                if (_showFoundInQuran &&
                                    word.commonSurahs.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.quranTeachingModuleOftenSeenIn(
                                      word.commonSurahs.join(', '),
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                                if (_showFoundInQuran &&
                                    word.exampleSnippet != null) ...[
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
                                if (word.sharedBeginnerWordId != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.quranTeachingBeginnerWordsOpenInlineHint,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.onSurfaceSubtle,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ],
                            ),
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
                  l10n.quranTeachingModuleStarterSurahShelfTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  surah.arabicTitle,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'AmiriQuran',
                                  ),
                                ),
                                Text(
                                  '${surah.verseCount} ayat • ${surah.focus}',
                                ),
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
          l10n.quranTeachingModuleLessonsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
                        completed
                            ? Icons.check_rounded
                            : (unlocked
                                  ? Icons.play_arrow_rounded
                                  : Icons.lock_rounded),
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
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(lesson.subtitle),
                          const SizedBox(height: 6),
                          Text(
                            '${lesson.estimatedSeconds}s • ${completed ? 'Completed' : (unlocked ? 'Ready now' : 'Locked for guided path')}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.onSurfaceSubtle),
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
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surfaceSoft.withValues(alpha: 0.75),
      ),
      child: Text(label),
    );
  }
}
