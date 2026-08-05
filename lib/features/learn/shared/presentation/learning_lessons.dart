import 'package:flutter/material.dart';

class LearningLessonItem {
  const LearningLessonItem({required this.title, this.description});

  final String title;
  final String? description;
}

class LearningLessons extends StatelessWidget {
  const LearningLessons({super.key, required this.items});

  final List<LearningLessonItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(Icons.star_rounded, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (item.description != null &&
                            item.description!.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(item.description!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
