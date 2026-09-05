import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/widgets/learn_contained_state_page.dart';

class IslamicGuidesPage extends StatelessWidget {
  const IslamicGuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LearnContainedStatePage(
      title: l10n.homeSearchGuidanceHubTitle,
      subtitle: l10n.learnContainedStateGuidesSubtitle,
      body: l10n.learnContainedStateBody,
      primaryActionLabel: l10n.learnContainedStateBackToLearnAction,
      onPrimaryAction: () => context.go('/learn'),
      secondaryActionLabel: l10n.learnContainedStateOpenQuranLearningAction,
      onSecondaryAction: () => context.pushNamed('quranLearningHub'),
    );
  }
}
