import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../arabic/application/arabic_learning_audio_controller.dart';
import '../../arabic/data/arabic_beginner_content_catalog.dart';
import '../domain/kids_arabic_models.dart';
import '../domain/kids_arabic_phrase_models.dart';
import '../domain/kids_arabic_word_models.dart';

class KidsArabicAudioService {
  KidsArabicAudioService([this._ref]);

  final Ref? _ref;

  Future<void> configure() async {
    // Shared Arabic audio is configured centrally.
  }

  Future<void> speakLetter(KidsArabicLetter letter) async {
    if (_ref == null) {
      await speakText(letter.nameAr);
      return;
    }
    await _ref
        .read(arabicLearningAudioControllerProvider.notifier)
        .playLetterByCanonicalId(letter.id);
  }

  Future<void> speakWord(KidsArabicBeginnerWord word) async {
    if (_ref == null) {
      await speakText(word.wordAr);
      return;
    }
    final sharedWord = arabicSharedBeginnerWordById(word.id);
    if (sharedWord != null) {
      await _ref
          .read(arabicLearningAudioControllerProvider.notifier)
          .playBeginnerWord(sharedWord);
      return;
    }
    await speakText(word.wordAr);
  }

  Future<void> speakPhrase(KidsArabicMiniPhrase phrase) async {
    if (_ref == null) {
      await speakText(phrase.phraseAr);
      return;
    }
    final sharedPhrase = arabicSharedMiniPhraseById(phrase.id);
    if (sharedPhrase != null) {
      await _ref
          .read(arabicLearningAudioControllerProvider.notifier)
          .playBeginnerPhrase(sharedPhrase);
      return;
    }
    await speakText(phrase.phraseAr);
  }

  Future<void> speakText(String text) async {
    if (_ref == null) {
      return;
    }
    await _ref
        .read(arabicLearningAudioControllerProvider.notifier)
        .playText(playbackId: 'kids:text:$text', text: text);
  }

  Future<void> dispose() async {}
}

final kidsArabicAudioServiceProvider = Provider<KidsArabicAudioService>((ref) {
  return KidsArabicAudioService(ref);
});
