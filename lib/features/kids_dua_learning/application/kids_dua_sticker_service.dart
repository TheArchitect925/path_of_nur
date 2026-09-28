import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/kids_dua_models.dart';

const kidsDuaCategoryStickers = <KidsDuaSticker>[
  KidsDuaSticker(
    id: 'daily_basics_sticker',
    categoryId: 'daily_basics',
    titleKey: 'kidsDuaStickerDailyBasics',
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFFF3B85A),
  ),
  KidsDuaSticker(
    id: 'food_drink_sticker',
    categoryId: 'food_drink',
    titleKey: 'kidsDuaStickerFoodDrink',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFD98D5A),
  ),
  KidsDuaSticker(
    id: 'sleep_sticker',
    categoryId: 'sleep',
    titleKey: 'kidsDuaStickerSleep',
    icon: Icons.nightlight_round_rounded,
    color: Color(0xFF6B7FD7),
  ),
  KidsDuaSticker(
    id: 'home_daily_sticker',
    categoryId: 'home_daily',
    titleKey: 'kidsDuaStickerHomeDaily',
    icon: Icons.home_rounded,
    color: Color(0xFF7B9F7A),
  ),
  KidsDuaSticker(
    id: 'manners_social_sticker',
    categoryId: 'manners_social',
    titleKey: 'kidsDuaStickerMannersSocial',
    icon: Icons.favorite_outline_rounded,
    color: Color(0xFFE59AA5),
  ),
  KidsDuaSticker(
    id: 'feelings_protection_sticker',
    categoryId: 'feelings_protection',
    titleKey: 'kidsDuaStickerFeelingsProtection',
    icon: Icons.shield_moon_rounded,
    color: Color(0xFF7C8CC9),
  ),
  KidsDuaSticker(
    id: 'learning_family_sticker',
    categoryId: 'learning_family',
    titleKey: 'kidsDuaStickerLearningFamily',
    icon: Icons.menu_book_rounded,
    color: Color(0xFF5AA0A8),
  ),
  KidsDuaSticker(
    id: 'travel_nature_sticker',
    categoryId: 'travel_nature',
    titleKey: 'kidsDuaStickerTravelNature',
    icon: Icons.landscape_rounded,
    color: Color(0xFF79A96B),
  ),
];

class KidsDuaStickerUnlockResult {
  const KidsDuaStickerUnlockResult({
    required this.unlockedAtById,
    required this.newlyUnlockedIds,
  });

  final Map<String, String> unlockedAtById;
  final List<String> newlyUnlockedIds;
}

class KidsDuaStickerService {
  const KidsDuaStickerService();

  List<KidsDuaSticker> getAllStickers() => kidsDuaCategoryStickers;

  KidsDuaSticker? getStickerForCategory(String categoryId) {
    for (final sticker in kidsDuaCategoryStickers) {
      if (sticker.categoryId == categoryId) return sticker;
    }
    return null;
  }

  KidsDuaStickerUnlockResult checkAndUnlock({
    required List<KidsDuaLessonContent> lessons,
    required Map<String, KidsDuaLessonProgress> progressByLessonId,
    required Map<String, String> unlockedAtById,
    required String unlockedAtIso,
  }) {
    final next = Map<String, String>.from(unlockedAtById);
    final newlyUnlocked = <String>[];
    final learnedIds = progressByLessonId.entries
        .where((entry) => entry.value.status == KidsDuaLessonStatus.learned)
        .map((entry) => entry.key)
        .toSet();
    for (final sticker in kidsDuaCategoryStickers) {
      if (next.containsKey(sticker.id)) continue;
      final categoryLessons = lessons
          .where((lesson) => lesson.categoryId == sticker.categoryId)
          .toList(growable: false);
      if (categoryLessons.isEmpty) continue;
      final allLearned = categoryLessons.every(
        (lesson) => learnedIds.contains(lesson.id),
      );
      if (!allLearned) continue;
      next[sticker.id] = unlockedAtIso;
      newlyUnlocked.add(sticker.id);
    }
    return KidsDuaStickerUnlockResult(
      unlockedAtById: next,
      newlyUnlockedIds: newlyUnlocked,
    );
  }
}

final kidsDuaStickerServiceProvider = Provider<KidsDuaStickerService>(
  (ref) => const KidsDuaStickerService(),
);
