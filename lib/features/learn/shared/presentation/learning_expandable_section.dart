import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';

class LearningExpandableSection extends StatelessWidget {
  const LearningExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.bottomSpacing = 10,
  });

  final String title;
  final Widget child;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: PremiumCard(
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          children: [child],
        ),
      ),
    );
  }
}
