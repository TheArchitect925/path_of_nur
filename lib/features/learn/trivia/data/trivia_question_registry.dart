import '../domain/trivia_models.dart';
import 'packs/ethics_character_questions.dart';
import 'packs/dua_questions.dart';
import 'packs/general_knowledge_questions.dart';
import 'packs/hadith_questions.dart';
import 'packs/islamic_history_questions.dart';
import 'packs/prophets_questions.dart';
import 'packs/quran_questions.dart';
import 'packs/ramadan_questions.dart';
import 'packs/salah_questions.dart';
import 'packs/seerah_questions.dart';
import 'packs/women_in_islam_questions.dart';
import 'trivia_category_catalog.dart';

class TriviaQuestionRegistry {
  const TriviaQuestionRegistry._();

  static const List<TriviaCategory> categories = triviaCategoryCatalog;

  static final Map<String, List<TriviaQuestion>> packsById = {
    'quran': quranTriviaQuestions,
    'prophets': prophetsTriviaQuestions,
    'hadith': hadithTriviaQuestions,
    'history': islamicHistoryTriviaQuestions,
    'general': generalKnowledgeTriviaQuestions,
    'salah': salahTriviaQuestions,
    'dua': duaTriviaQuestions,
    'ramadan': ramadanTriviaQuestions,
    'seerah': seerahTriviaQuestions,
    'women_in_islam': womenInIslamTriviaQuestions,
    'akhlaq': ethicsCharacterTriviaQuestions,
  };

  static final List<TriviaQuestion> allQuestions = packsById.values
      .expand((items) => items)
      .toList(growable: false);
}
