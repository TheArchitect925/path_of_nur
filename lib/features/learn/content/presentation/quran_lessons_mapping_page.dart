import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/widgets/learn_contained_state_page.dart';

class QuranLessonsMappingPage extends StatelessWidget {
  const QuranLessonsMappingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LearnContainedStatePage(
      headerIcon: Icons.fact_check_outlined,
      title: l10n.learnContainedStateQuranMappingTitle,
      subtitle: l10n.learnContainedStateQuranMappingSubtitle,
      body: l10n.learnContainedStateBody,
      primaryActionLabel: l10n.learnContainedStateBackToLearnAction,
      onPrimaryAction: () => context.go('/learn'),
      secondaryActionLabel: l10n.learnContainedStateOpenQuranLearningAction,
      onSecondaryAction: () => context.pushNamed('quranLearningHub'),
    );
  }
}
