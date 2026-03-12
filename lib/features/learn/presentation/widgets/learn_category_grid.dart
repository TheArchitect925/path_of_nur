import 'package:flutter/material.dart';

import '../models/learn_category_item.dart';
import 'learn_category_card.dart';

class LearnCategoryGrid extends StatelessWidget {
  const LearnCategoryGrid({
    super.key,
    required this.items,
    required this.onTap,
    this.cardHeight = 162,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
  });

  final List<LearnCategoryItem> items;
  final ValueChanged<LearnCategoryItem> onTap;
  final double cardHeight;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final rows = <Widget>[];
    var index = 0;

    while (index < items.length) {
      final remaining = items.length - index;
      if (remaining == 1) {
        rows.add(
          LearnCategoryCard(
            item: items[index],
            height: cardHeight,
            onTap: () => onTap(items[index]),
          ),
        );
        index += 1;
      } else {
        final left = items[index];
        final right = items[index + 1];
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LearnCategoryCard(
                  item: left,
                  height: cardHeight,
                  onTap: () => onTap(left),
                ),
              ),
              SizedBox(width: crossAxisSpacing),
              Expanded(
                child: LearnCategoryCard(
                  item: right,
                  height: cardHeight,
                  onTap: () => onTap(right),
                ),
              ),
            ],
          ),
        );
        index += 2;
      }

      if (index < items.length) {
        rows.add(SizedBox(height: mainAxisSpacing));
      }
    }

    return Column(children: rows);
  }
}
