import '../../arabic/data/arabic_beginner_content_catalog.dart';
import '../domain/kids_arabic_phrase_models.dart';

const kidsArabicMiniPhraseOrderIds = <String>[
  'bismillah',
  'alhamdulillah',
  'subhanallah',
  'allahu-akbar',
  'assalamu-alaikum',
  'inshaallah',
];

final kidsArabicMiniPhrases = <KidsArabicMiniPhrase>[
  KidsArabicMiniPhrase(
    id: 'bismillah',
    phraseAr: arabicSharedMiniPhraseById('bismillah')!.arabicText,
    transliteration: arabicSharedMiniPhraseById('bismillah')!.transliteration,
  ),
  KidsArabicMiniPhrase(
    id: 'alhamdulillah',
    phraseAr: arabicSharedMiniPhraseById('alhamdulillah')!.arabicText,
    transliteration: arabicSharedMiniPhraseById(
      'alhamdulillah',
    )!.transliteration,
  ),
  KidsArabicMiniPhrase(
    id: 'subhanallah',
    phraseAr: arabicSharedMiniPhraseById('subhanallah')!.arabicText,
    transliteration: arabicSharedMiniPhraseById('subhanallah')!.transliteration,
  ),
  KidsArabicMiniPhrase(
    id: 'allahu-akbar',
    phraseAr: arabicSharedMiniPhraseById('allahu-akbar')!.arabicText,
    transliteration: arabicSharedMiniPhraseById(
      'allahu-akbar',
    )!.transliteration,
  ),
  KidsArabicMiniPhrase(
    id: 'assalamu-alaikum',
    phraseAr: arabicSharedMiniPhraseById('assalamu-alaikum')!.arabicText,
    transliteration: arabicSharedMiniPhraseById(
      'assalamu-alaikum',
    )!.transliteration,
  ),
  KidsArabicMiniPhrase(
    id: 'inshaallah',
    phraseAr: arabicSharedMiniPhraseById('inshaallah')!.arabicText,
    transliteration: arabicSharedMiniPhraseById('inshaallah')!.transliteration,
  ),
];

KidsArabicMiniPhrase? kidsArabicMiniPhraseById(String id) {
  for (final phrase in kidsArabicMiniPhrases) {
    if (phrase.id == id) {
      return phrase;
    }
  }
  return null;
}
