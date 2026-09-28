import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import 'kids_landing_body.dart';
import 'kids_page_scaffold.dart';

/// Kids Learning reached from the category list (an adult browsing, or a
/// deep link). Same room as the child profile's Learn tab.
class KidsLandingPage extends StatelessWidget {
  const KidsLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KidsPageScaffold(
      headerIcon: AppIcons.kids,
      title: l10n.learnHubCategoryKidsLearningTitle,
      subtitle: l10n.learnHubCategoryKidsLearningSubtitle,
      children: const [KidsLandingBody(sourceSurface: 'kids_category')],
    );
  }
}
