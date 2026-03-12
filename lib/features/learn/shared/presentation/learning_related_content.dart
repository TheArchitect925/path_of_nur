import 'package:flutter/material.dart';

class LearningRelatedLink {
  const LearningRelatedLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class LearningRelatedContent extends StatelessWidget {
  const LearningRelatedContent({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<LearningRelatedLink> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => ActionChip(
                  label: Text(item.label),
                  onPressed: item.onTap,
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

