import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../presentation/kids_learning_localizations.dart';
import '../application/quran_providers.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_surah.dart';

class KidsQuranSurahPage extends ConsumerWidget {
  const KidsQuranSurahPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranRepositoryProvider).getSurahs();
    final settings = ref.watch(quranReaderSettingsProvider);
    final repository = ref.watch(quranRepositoryProvider);

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

    return AppPageScaffold(
      title: surah.arabicName,
      subtitle: l10n.kidsQuranSurahSubtitleText(surah),
      children: [
        PremiumCard(child: Text(l10n.kidsQuranSurahMetaText(surah))),
        const SizedBox(height: 12),
        ...ayahs.map(
          (ayah) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _KidsQuranAyahCard(ayah: ayah),
          ),
        ),
      ],
    );
  }
}

class _KidsQuranAyahCard extends StatelessWidget {
  const _KidsQuranAyahCard({required this.ayah});

  final QuranAyah ayah;

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
