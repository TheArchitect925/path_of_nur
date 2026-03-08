import 'package:flutter/material.dart';

import '../../../shared/widgets/app_page_scaffold.dart';

class KhusuFocusPage extends StatelessWidget {
  const KhusuFocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: 'Khusū',
      subtitle: 'Calm focus space',
      children: [
        const SizedBox(height: 52),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Khusū',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 14),
              Text(
                'A silent and sacred space for focused presence.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6A5A4A), fontSize: 16),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Breathe slowly. Choose intention over momentum. Keep one sentence, one invocation, one pause at a time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6A5A4A), height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

