import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({
    super.key,
    required this.title,
    this.body,
    this.child,
    this.bottomSpacing = 10,
  });

  final String title;
  final String? body;
  final Widget? child;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: PremiumCard(
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
            if (body != null && body!.trim().isNotEmpty) Text(body!),
            ...(child == null ? const <Widget>[] : <Widget>[child!]),
          ],
        ),
      ),
    );
  }
}
