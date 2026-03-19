import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/quran/domain/quran_content_refs.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_quote_block.dart';

class QuranVersePage extends StatelessWidget {
  const QuranVersePage({
    super.key,
    required this.surah,
    required this.ayah,
    this.ayahEnd,
  });

  final int surah;
  final int ayah;
  final int? ayahEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quote = QuranQuote(
      ref: QuranQuoteRef(surah: surah, ayah: ayah, ayahEnd: ayahEnd),
    );

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.quranHubTitle,
      subtitle: quote.locationText,
      quote: quote,
      children: const [],
    );
  }
}
