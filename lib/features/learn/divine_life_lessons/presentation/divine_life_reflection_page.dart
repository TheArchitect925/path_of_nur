import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../application/divine_life_lessons_provider.dart';
import '../data/divine_life_lessons_data.dart';

class DivineLifeReflectionPage extends ConsumerStatefulWidget {
  const DivineLifeReflectionPage({super.key, this.initialLessonId});

  final String? initialLessonId;

  @override
  ConsumerState<DivineLifeReflectionPage> createState() =>
      _DivineLifeReflectionPageState();
}

class _DivineLifeReflectionPageState
    extends ConsumerState<DivineLifeReflectionPage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialLessonId;
    if (initial != null) {
      final found = divineLifeLessons.indexWhere(
        (lesson) => lesson.id == initial,
      );
      _index = found >= 0 ? found : 0;
    } else {
      final daily = divineLifeLessonById(
        ref.read(divineLifeDailyLessonProvider).id,
      );
      final found = daily == null
          ? -1
          : divineLifeLessons.indexWhere((lesson) => lesson.id == daily.id);
      _index = found >= 0 ? found : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = divineLifeLessons[_index];

    return AppPageScaffold(
      headerIcon: Icons.nights_stay_rounded,
      title: 'Reflection Mode',
      subtitle: 'Quiet, focused reading',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              QuranReferenceBlock(
                surahNumber: lesson.surahNumber,
                surahName: lesson.surahName,
                ayahStart: lesson.ayahStart,
                ayahEnd: lesson.ayahEnd,
                dense: true,
              ),
              const SizedBox(height: 12),
              Text(lesson.reflection),
              const SizedBox(height: 12),
              Text(
                lesson.reflectionPrompts.first,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _index > 0
                        ? () => setState(() => _index -= 1)
                        : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                    label: const Text('Previous'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: _index < divineLifeLessons.length - 1
                        ? () => setState(() => _index += 1)
                        : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                    label: const Text('Next'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      'lifeLessonDetail',
                      pathParameters: {'lessonId': lesson.id},
                    ),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open lesson'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
