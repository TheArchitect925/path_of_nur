import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../quran/application/quran_reference_graph_provider.dart';
import '../application/divine_life_lessons_provider.dart';
import '../data/divine_life_lessons_data.dart';
import '../domain/divine_life_models.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';

class DivineLifeLessonDetailPage extends ConsumerStatefulWidget {
  const DivineLifeLessonDetailPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<DivineLifeLessonDetailPage> createState() =>
      _DivineLifeLessonDetailPageState();
}

class _DivineLifeLessonDetailPageState
    extends ConsumerState<DivineLifeLessonDetailPage> {
  late final TextEditingController _noteController;
  bool _didOpen = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didOpen) return;
    _didOpen = true;
    Future<void>.microtask(() {
      ref.read(divineLifeProgressProvider.notifier).openLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = divineLifeLessonById(widget.lessonId);
    if (lesson == null) {
      return AppPageScaffold(
        title: AppLocalizations.of(context).learnCategoryDivineLifeLessonsTitle,
        children: [PremiumCard(child: Text('This lesson could not be found.'))],
      );
    }

    final theme = divineLifeThemeById(lesson.themeId);
    final progress = ref.watch(divineLifeProgressProvider);
    final bookmarked = progress.bookmarkedLessonIds.contains(lesson.id);
    final note = progress.notesByLessonId[lesson.id];
    if (_noteController.text != (note?.noteText ?? '')) {
      _noteController.text = note?.noteText ?? '';
    }

    final related = lesson.relatedLessonIds
        .map(divineLifeLessonById)
        .whereType<DivineLifeLesson>()
        .toList(growable: false);
    final referenceIds = ref.watch(
      quranReferenceIdsForLifeLessonProvider(lesson.id),
    );

    return AppPageScaffold(
      title: lesson.title,
      subtitle: lesson.quranReference,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(theme?.title ?? 'Theme'),
                    visualDensity: VisualDensity.compact,
                  ),
                  ActionChip(
                    label: Text(lesson.quranReference),
                    avatar: const Icon(Icons.play_arrow_rounded, size: 18),
                    onPressed: referenceIds.isEmpty
                        ? null
                        : () => openQuranAt(
                            context,
                            surahNumber: lesson.surahNumber,
                            ayahNumber: lesson.ayahStart,
                            endAyahNumber: lesson.ayahEnd,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              QuranReferenceBlock(
                surahNumber: lesson.surahNumber,
                surahName: lesson.surahName,
                ayahStart: lesson.ayahStart,
                ayahEnd: lesson.ayahEnd,
                dense: true,
              ),
              const SizedBox(height: 12),
              OverflowBar(
                alignment: MainAxisAlignment.start,
                spacing: 8,
                overflowSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => ref
                        .read(divineLifeProgressProvider.notifier)
                        .toggleBookmark(lesson.id),
                    icon: Icon(
                      bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                    label: Text(bookmarked ? 'Saved' : 'Save lesson'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      'divineLifeReflection',
                      queryParameters: {'lessonId': lesson.id},
                    ),
                    icon: const Icon(AppIcons.reflection),
                    label: const Text('Reflection mode'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _section(context, title: 'Meaning', child: Text(lesson.shortSummary)),
        const SizedBox(height: 10),
        _section(
          context,
          title: 'Real life application',
          child: Text(lesson.practicalTakeaway),
        ),
        const SizedBox(height: 10),
        _section(
          context,
          title: 'Action steps',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lesson.actionSteps
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $step'),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 10),
        _section(
          context,
          title: 'Reflection prompts',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lesson.reflectionPrompts
                .map(
                  (prompt) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $prompt'),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 10),
        _section(
          context,
          title: 'Personal note',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _noteController,
                maxLines: 5,
                minLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your private reflection...',
                ),
              ),
              const SizedBox(height: 8),
              OverflowBar(
                alignment: MainAxisAlignment.start,
                spacing: 8,
                overflowSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () => ref
                        .read(divineLifeProgressProvider.notifier)
                        .upsertNote(lesson.id, _noteController.text),
                    child: const Text('Save note'),
                  ),
                  if (note != null)
                    TextButton(
                      onPressed: () {
                        _noteController.clear();
                        ref
                            .read(divineLifeProgressProvider.notifier)
                            .deleteNote(lesson.id);
                      },
                      child: const Text('Delete note'),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (related.isNotEmpty) ...[
          const SizedBox(height: 10),
          _section(
            context,
            title: 'Related lessons',
            child: Column(
              children: related
                  .map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.title),
                      subtitle: Text(item.quranReference),
                      onTap: () => context.pushNamed(
                        'lifeLessonDetail',
                        pathParameters: {'lessonId': item.id},
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ],
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
