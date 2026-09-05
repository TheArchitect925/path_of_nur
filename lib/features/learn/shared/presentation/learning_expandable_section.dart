import 'package:flutter/material.dart';

import '../../../../shared/widgets/display/expandable_tile.dart';

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
      child: ExpandableTile(
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        child: child,
      ),
    );
  }
}
