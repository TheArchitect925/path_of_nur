import 'package:flutter/material.dart';

class LearningRelatedLink {
  const LearningRelatedLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class LearningRelatedContent extends StatelessWidget {
  const LearningRelatedContent({super.key, required this.items});

  final List<LearningRelatedLink> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
