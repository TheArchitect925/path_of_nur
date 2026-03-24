import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_quick_resume_models.dart';
import 'arabic_learning_quick_resume_provider.dart';

final arabicLearningQuickResumeWidgetBridgeProvider =
    Provider<ArabicLearningQuickResumeWidgetBridge>(
      (ref) => const ArabicLearningQuickResumeWidgetBridge(),
    );

final arabicLearningQuickResumeWidgetBootstrapProvider = Provider<void>((ref) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final kids = ref.watch(
    arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.kids),
  );
  final adult = ref.watch(
    arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.adult),
  );

  Future<void>.microtask(
    () => ref.read(arabicLearningQuickResumeWidgetBridgeProvider).writeSnapshot(
          l10n: l10n,
          kids: kids,
          adult: adult,
        ),
  );
});

class ArabicLearningQuickResumeWidgetBridge {
  const ArabicLearningQuickResumeWidgetBridge();

  static const _androidName = 'PathOfNurArabicResumeWidget';
  static const _iosName = 'PathOfNurArabicResumeWidget';

  Future<void> writeSnapshot({
    required AppLocalizations l10n,
    required ArabicLearningQuickResumeSummary kids,
    required ArabicLearningQuickResumeSummary adult,
  }) async {
    final payload = <String, String>{
      'arabic_resume_widget_title': l10n.arabicQuickResumeWidgetTitle,
      'arabic_resume_widget_subtitle': l10n.arabicQuickResumeWidgetSubtitle,
      'arabic_resume_kids_label': l10n.arabicQuickResumeKidsSectionTitle,
      'arabic_resume_kids_value': kids.primaryTitle,
      'arabic_resume_kids_route': kids.primaryLocation,
      'arabic_resume_adult_label': l10n.arabicQuickResumeAdultSectionTitle,
      'arabic_resume_adult_value': adult.primaryTitle,
      'arabic_resume_adult_route': adult.primaryLocation,
      'arabic_resume_review_label': l10n.arabicQuickResumeReviewAction,
      'arabic_resume_review_route':
          adult.reviewLocation ?? kids.reviewLocation ?? adult.primaryLocation,
    };

    try {
      for (final entry in payload.entries) {
        await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
      }
      await HomeWidget.updateWidget(androidName: _androidName, iOSName: _iosName);
    } catch (error) {
      AppTelemetry.logEvent(
        'arabic_resume_widget_sync_failed',
        metadata: <String, Object?>{'error': error.toString()},
      );
    }
  }
}
