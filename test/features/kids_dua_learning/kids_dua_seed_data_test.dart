import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_seed_data.dart';

void main() {
  test('kids dua seed data contains canonical V1 categories and 23 duas', () {
    expect(kidsDuaCategories.map((item) => item.id), <String>[
      'daily_basics',
      'food_drink',
      'sleep',
      'home_daily',
      'manners_social',
      'feelings_protection',
      'learning_family',
      'travel_nature',
    ]);
    expect(kidsDuaStarterLessons, hasLength(23));
  });

  test('kids dua records keep required content fields populated', () {
    for (final lesson in kidsDuaStarterLessons) {
      expect(lesson.id, isNotEmpty);
      expect(lesson.slug, isNotEmpty);
      expect(lesson.categoryId, isNotEmpty);
      expect(lesson.title, isNotEmpty);
      expect(lesson.arabic, isNotEmpty);
      expect(lesson.transliteration, isNotEmpty);
      expect(lesson.meaning, isNotEmpty);
      expect(lesson.miniLesson, isNotEmpty);
      expect(lesson.whenToSay, isNotEmpty);
      expect(lesson.sourceType, isNotEmpty);
      expect(lesson.sourceReference, isNotEmpty);
      expect(lesson.phraseChunks, isNotEmpty);
    }
  });
}
