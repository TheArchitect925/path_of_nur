import 'package:flutter/material.dart';

class LearningReflection extends StatelessWidget {
  const LearningReflection({super.key, required this.prompts});

  final List<String> prompts;

  @override
  Widget build(BuildContext context) {
    if (prompts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prompts
          .map(
            (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('• $prompt'),
            ),
          )
          .toList(growable: false),
    );
  }
}
