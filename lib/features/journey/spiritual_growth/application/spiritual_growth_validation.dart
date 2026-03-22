import 'package:flutter/foundation.dart';

import '../data/spiritual_growth_seed_data.dart';
import '../domain/spiritual_growth_models.dart';

class SpiritualGrowthValidation {
  const SpiritualGrowthValidation._();

  static SpiritualGrowthValidationReport validateCatalog(
    SpiritualGrowthCatalog catalog,
  ) {
    final issues = <SpiritualGrowthValidationIssue>[];
    final intentionIds = <String>{};
    for (final intention in catalog.intentions) {
      if (!intentionIds.add(intention.id)) {
        issues.add(
          SpiritualGrowthValidationIssue(
            'Duplicate intention id: ${intention.id}',
          ),
        );
      }
      if (intention.theme.isEmpty ||
          intention.titleKey.isEmpty ||
          intention.descriptionKey.isEmpty) {
        issues.add(
          SpiritualGrowthValidationIssue(
            'Invalid intention metadata: ${intention.id}',
          ),
        );
      }
    }

    final actionIds = <String>{};
    for (final action in catalog.actions) {
      if (!actionIds.add(action.id)) {
        issues.add(
          SpiritualGrowthValidationIssue('Duplicate action id: ${action.id}'),
        );
      }
      if (action.theme.isEmpty ||
          action.titleKey.isEmpty ||
          action.descriptionKey.isEmpty) {
        issues.add(
          SpiritualGrowthValidationIssue('Invalid action metadata: ${action.id}'),
        );
      }
      if (action.xpValue < 0 || action.dropValue < 0) {
        issues.add(
          SpiritualGrowthValidationIssue('Invalid reward metadata: ${action.id}'),
        );
      }
    }

    final promptIds = <String>{};
    for (final prompt in catalog.reflectionPrompts) {
      if (!promptIds.add(prompt.id)) {
        issues.add(
          SpiritualGrowthValidationIssue('Duplicate prompt id: ${prompt.id}'),
        );
      }
      if (prompt.theme.isEmpty ||
          prompt.titleKey.isEmpty ||
          prompt.descriptionKey.isEmpty ||
          prompt.responseOptions.isEmpty) {
        issues.add(
          SpiritualGrowthValidationIssue('Invalid prompt metadata: ${prompt.id}'),
        );
      }
      final optionIds = <String>{};
      for (final option in prompt.responseOptions) {
        if (!optionIds.add(option.id) || option.labelKey.isEmpty) {
          issues.add(
            SpiritualGrowthValidationIssue(
              'Invalid prompt option metadata: ${prompt.id}/${option.id}',
            ),
          );
        }
      }
    }
    return SpiritualGrowthValidationReport(issues);
  }

  static void debugReport(SpiritualGrowthValidationReport report) {
    assert(() {
      for (final issue in report.issues) {
        debugPrint('SpiritualGrowthValidation: ${issue.message}');
      }
      return true;
    }());
  }
}

final spiritualGrowthSeedCatalog = SpiritualGrowthCatalog(
  intentions: spiritualGrowthIntentions,
  actions: spiritualGrowthActions,
  reflectionPrompts: spiritualGrowthReflectionPrompts,
);
