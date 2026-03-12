import 'package:flutter/material.dart';

import '../../../../../shared/widgets/premium_card.dart';

class RevelationReflectionCard extends StatelessWidget {
  const RevelationReflectionCard({super.key, required this.prompts});

  final List<String> prompts;

  @override
  Widget build(BuildContext context) {
    if (prompts.isEmpty) return const SizedBox.shrink();
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Era Reflection',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ...prompts.map(
            (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $prompt'),
            ),
          ),
        ],
      ),
    );
  }
}
