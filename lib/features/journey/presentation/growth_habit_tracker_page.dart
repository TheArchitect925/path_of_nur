import 'package:flutter/material.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import 'growth_habits_page.dart';

class GrowthHabitTrackerPage extends StatelessWidget {
  const GrowthHabitTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(
      headerIcon: Icons.checklist_rtl_rounded,
      title: 'Habit Tracker',
      subtitle:
          'Choose only the habits you want to track, start small, and build steadily.',
      children: [GrowthHabitsPage()],
    );
  }
}
