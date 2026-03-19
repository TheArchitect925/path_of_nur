import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'quran_quote_block.dart';

void openQuranQuoteLocation(BuildContext context, QuranQuote quote) {
  context.pushNamed(
    'quranReader',
    pathParameters: {'surahNumber': quote.ref.surah.toString()},
    queryParameters: {'ayah': quote.ref.ayah.toString(), 'autoplay': '1'},
  );
}
