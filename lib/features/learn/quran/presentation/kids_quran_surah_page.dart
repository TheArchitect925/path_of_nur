import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import 'kids_quran_labels.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../application/quran_ayah_action_provider.dart';
import '../application/quran_ayah_explanation_provider.dart';
import '../application/quran_personalization_provider.dart';
import '../application/quran_providers.dart';
import '../application/quran_spiritual_moment_provider.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_ayah_action_models.dart';
import '../domain/quran_ayah_explanation_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_personalization_models.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_spiritual_moment_models.dart';
import '../domain/quran_surah.dart';
import 'widgets/quran_ayah_action_section.dart';
import 'widgets/quran_ayah_explanation_section.dart';
import 'widgets/quran_personalized_recommendation_card.dart';
import 'widgets/quran_spiritual_moment_card.dart';

class KidsQuranSurahPage extends ConsumerWidget {
  const KidsQuranSurahPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranRepositoryProvider).getSurahs();
    final settings = ref.watch(quranReaderSettingsProvider);
    final kidsExplanationSettings = ref.watch(
      kidsQuranExplanationSettingsProvider,
    );
    final kidsExplanationSettingsNotifier = ref.read(
      kidsQuranExplanationSettingsProvider.notifier,
    );
    final repository = ref.watch(quranRepositoryProvider);
    final spiritualMoment = kidsExplanationSettings.enabled
        ? ref.watch(
            quranSpiritualMomentBundleProvider((
              QuranSpiritualMomentSurface.kidsReader,
              true,
              Localizations.localeOf(context).languageCode,
            )),
          )
        : null;

    QuranSurah? surah;
    for (final item in surahs) {
      if (item.number == surahNumber) {
        surah = item;
        break;
      }
    }

    if (surah == null) {
      return AppPageScaffold(
        title: l10n.kidsQuranPageTitleText,
        subtitle: l10n.kidsQuranPageSubtitleText,
        children: [Center(child: Text(l10n.kidsQuranSurahMissingText))],
      );
    }

    final ayahs = repository.getAyahsForSurah(
      surahNumber,
      translationCode: settings.translationCode,
    );
    final resolvedExplanationsByAyah = kidsExplanationSettings.enabled
        ? ref.watch(
            quranResolvedAyahExplanationsForSurahProvider((
              surahNumber,
              QuranExplanationDetailLevel.kids,
              Localizations.localeOf(context).languageCode,
            )),
          )
        : const <int, QuranAyahResolvedExplanation>{};
    final actionRecommendationsByAyah = kidsExplanationSettings.enabled
        ? ref.watch(
            quranAyahActionRecommendationsForSurahProvider((
              surahNumber,
              Localizations.localeOf(context).languageCode,
              true,
            )),
          )
        : const <int, QuranAyahActionRecommendation>{};
    final personalizedRecommendationsByAyah = kidsExplanationSettings.enabled
        ? ref.watch(
            quranReaderPersonalizedRecommendationsForSurahProvider((
              surahNumber,
              true,
            )),
          )
        : const <int, QuranRecommendedAyah>{};

    return AppPageScaffold(
      title: surah.arabicName,
      subtitle: l10n.kidsQuranSurahSubtitleText(
        surah.transliteratedName,
        surah.englishName,
      ),
      children: [
        PremiumCard(
          child: Text(
            l10n.kidsQuranSurahMetaText(
              surah.verseCount,
              kidsQuranRevelationPlaceLabel(l10n, surah),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: kidsExplanationSettings.enabled,
            title: Text(l10n.kidsQuranExplanationShowTitle),
            subtitle: Text(l10n.kidsQuranExplanationToggleSubtitle),
            onChanged: kidsExplanationSettingsNotifier.setEnabled,
          ),
        ),
        const SizedBox(height: 12),
        if (spiritualMoment != null) ...[
          QuranSpiritualMomentCard(
            bundle: spiritualMoment,
            surface: QuranSpiritualMomentSurface.kidsReader,
          ),
          const SizedBox(height: 12),
        ],
        ...ayahs.map(
          (ayah) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _KidsQuranAyahCard(
              ayah: ayah,
              explanationEnabled: kidsExplanationSettings.enabled,
              resolvedExplanation: resolvedExplanationsByAyah[ayah.ayahNumber],
              actionRecommendation:
                  actionRecommendationsByAyah[ayah.ayahNumber],
              personalizedRecommendation:
                  personalizedRecommendationsByAyah[ayah.ayahNumber],
            ),
          ),
        ),
      ],
    );
  }
}

class _KidsQuranAyahCard extends StatelessWidget {
  const _KidsQuranAyahCard({
    required this.ayah,
    required this.explanationEnabled,
    required this.resolvedExplanation,
    required this.actionRecommendation,
    required this.personalizedRecommendation,
  });

  final QuranAyah ayah;
  final bool explanationEnabled;
  final QuranAyahResolvedExplanation? resolvedExplanation;
  final QuranAyahActionRecommendation? actionRecommendation;
  final QuranRecommendedAyah? personalizedRecommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quoteRef = QuranQuoteRef(
      surah: ayah.surahNumber,
      ayah: ayah.ayahNumber,
    );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ayah.arabic,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(height: 1.8),
          ),
          const SizedBox(height: 10),
          Text(
            ayah.translation,
            style: QuranPresentationStyle.quranSupportTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            ),
          ),
          if ((ayah.transliteration ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              ayah.transliteration!,
              style: QuranPresentationStyle.quranSupportTextStyle(
                context,
                Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
                italic: true,
              ),
            ),
          ],
          if (explanationEnabled && resolvedExplanation != null) ...[
            const SizedBox(height: 12),
            QuranAyahExplanationSection(
              explanation: resolvedExplanation!,
              style: QuranAyahExplanationSectionStyle.kids,
              trimBodyLines:
                  resolvedExplanation!.resolvedDetail ==
                      QuranExplanationDetailLevel.standard
                  ? 3
                  : 4,
            ),
          ],
          if (explanationEnabled &&
              resolvedExplanation != null &&
              actionRecommendation != null) ...[
            const SizedBox(height: 12),
            QuranAyahActionSection(
              recommendation: actionRecommendation!,
              style: QuranAyahActionSectionStyle.kids,
              showExplanationPreview: false,
            ),
          ],
          if (explanationEnabled &&
              resolvedExplanation != null &&
              personalizedRecommendation != null) ...[
            const SizedBox(height: 12),
            QuranPersonalizedRecommendationCard(
              bundle: QuranRecommendationBundle(
                surface: QuranPersonalizationSurface.kidsReader,
                preferKids: true,
                generatedDateKey: DateTime.now().toIso8601String(),
                primary: personalizedRecommendation!,
                suggestedJourney: personalizedRecommendation!.suggestedJourney,
              ),
              surface: QuranPersonalizationSurface.kidsReader,
            ),
          ],
          const SizedBox(height: 12),
          QuranReferenceLinkTile.forRef(
            referenceLabel: quoteRef.locationLabel,
            ref: quoteRef,
            subtitle: l10n.kidsQuranOpenAyahHintText,
            margin: EdgeInsets.zero,
            showTrailingIcon: true,
          ),
        ],
      ),
    );
  }
}
