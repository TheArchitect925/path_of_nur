import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'quran_quote_block.dart';

void openQuranQuoteLocation(
  BuildContext context,
  QuranQuote quote, {
  String routeName = 'quranVerse',
}) {
  if (quote.surah != null) {
    context.pushNamed(
      'quranReader',
      pathParameters: {'surahNumber': quote.surah.toString()},
      queryParameters: {
        if (quote.verse != null) 'ayah': quote.verse.toString(),
        if (quote.verse != null) 'autoplay': '1',
      },
    );
    return;
  }
  context.pushNamed(
    routeName,
    queryParameters: {
      'arabic': quote.arabic,
      'transliteration': quote.transliteration,
      'translation': quote.translation,
      if (quote.surah != null) 'surah': quote.surah.toString(),
      if (quote.verse != null) 'ayah': quote.verse.toString(),
      if (quote.locationLabel != null) 'locationLabel': quote.locationLabel!,
    },
  );
}
