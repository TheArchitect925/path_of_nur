import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../learn/dua/application/daily_dua_content_service.dart';
import '../../learn/dua/application/dua_repository.dart';
import '../../learn/hadith/application/hadith_daily_reflection_service.dart';
import '../../learn/hadith/application/hadith_foundation_repository.dart';
import '../../learn/quran/application/quran_daily_reflection_provider.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../learn/quran/data/names_of_allah_data.dart';
import '../../worship/application/dhikr_controller.dart';

enum SpiritualTimeOfDay { morning, afternoon, evening, night }

class WidgetDuaContent {
  const WidgetDuaContent({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.translation,
    required this.transliteration,
    required this.whenToSay,
    required this.shortLabel,
  });

  final String id;
  final String title;
  final String arabicText;
  final String translation;
  final String transliteration;
  final String whenToSay;
  final String shortLabel;
}

class WidgetHadithContent {
  const WidgetHadithContent({
    required this.id,
    required this.title,
    required this.shortText,
    required this.sourceLabel,
    required this.narrator,
  });

  final String id;
  final String title;
  final String shortText;
  final String sourceLabel;
  final String? narrator;
}

class WidgetAyahContent {
  const WidgetAyahContent({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
    required this.locationLabel,
    required this.shortSnippet,
  });

  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String translation;
  final String locationLabel;
  final String shortSnippet;
}

class WidgetDhikrContent {
  const WidgetDhikrContent({
    required this.phrase,
    required this.arabicPhrase,
    required this.translation,
    required this.currentCount,
    required this.targetCount,
    required this.shortLabel,
  });

  final String phrase;
  final String arabicPhrase;
  final String translation;
  final int currentCount;
  final int targetCount;
  final String shortLabel;
}

class WidgetReflectionContent {
  const WidgetReflectionContent({
    required this.title,
    required this.shortText,
    this.longerText,
  });

  final String title;
  final String shortText;
  final String? longerText;
}

class WidgetNameOfAllahContent {
  const WidgetNameOfAllahContent({
    required this.nameArabic,
    required this.transliteration,
    required this.meaning,
    required this.shortMeaning,
  });

  final String nameArabic;
  final String transliteration;
  final String meaning;
  final String shortMeaning;
}

class WatchSpiritualPromptContent {
  const WatchSpiritualPromptContent({
    required this.kind,
    required this.sourceTitle,
    required this.sourceShortText,
  });

  final String kind;
  final String sourceTitle;
  final String sourceShortText;
}

class SpiritualWidgetContentBundle {
  const SpiritualWidgetContentBundle({
    required this.timeOfDay,
    required this.dua,
    required this.hadith,
    required this.ayah,
    required this.dhikr,
    required this.reflection,
    required this.nameOfAllah,
    required this.watchPrompt,
  });

  final SpiritualTimeOfDay timeOfDay;
  final WidgetDuaContent? dua;
  final WidgetHadithContent? hadith;
  final WidgetAyahContent ayah;
  final WidgetDhikrContent dhikr;
  final WidgetReflectionContent reflection;
  final WidgetNameOfAllahContent nameOfAllah;
  final WatchSpiritualPromptContent watchPrompt;
}

final spiritualWidgetContentEngineProvider =
    Provider<SpiritualWidgetContentEngine>((ref) {
      return SpiritualWidgetContentEngine(ref);
    });

class SpiritualWidgetContentEngine {
  const SpiritualWidgetContentEngine(this._ref);

  final Ref _ref;

  SpiritualWidgetContentBundle build({
    DateTime? now,
    String duaSurface = duaSurfaceHomeWidget,
  }) {
    final current = now ?? _ref.read(dailyNowProvider).value ?? DateTime.now();
    final timeOfDay = _resolveTimeOfDay(current);
    final ayah = _buildAyahContent();
    final dua = _buildDuaContent(current, duaSurface: duaSurface);
    final hadith = _buildHadithContent(current);
    final dhikr = _buildDhikrContent();
    final reflection = _buildReflectionContent();
    final name = _buildNameOfAllahContent(current, timeOfDay);

    return SpiritualWidgetContentBundle(
      timeOfDay: timeOfDay,
      dua: dua,
      hadith: hadith,
      ayah: ayah,
      dhikr: dhikr,
      reflection: reflection,
      nameOfAllah: name,
      watchPrompt: _buildWatchPrompt(
        timeOfDay: timeOfDay,
        dua: dua,
        hadith: hadith,
        ayah: ayah,
        reflection: reflection,
      ),
    );
  }

  SpiritualTimeOfDay _resolveTimeOfDay(DateTime now) {
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return SpiritualTimeOfDay.morning;
    if (hour >= 12 && hour < 17) return SpiritualTimeOfDay.afternoon;
    if (hour >= 17 && hour < 21) return SpiritualTimeOfDay.evening;
    return SpiritualTimeOfDay.night;
  }

  WidgetAyahContent _buildAyahContent() {
    final verse = _ref.read(quranDailyVerseProvider);
    return WidgetAyahContent(
      surahNumber: verse.surahNumber,
      ayahNumber: verse.ayahNumber,
      arabicText: verse.arabic,
      translation: verse.translation,
      locationLabel: verse.locationLabel,
      shortSnippet: _truncate(verse.translation, 120),
    );
  }

  WidgetDuaContent? _buildDuaContent(
    DateTime now, {
    required String duaSurface,
  }) {
    final dataset = _ref.read(duaDatasetProvider).valueOrNull;
    if (dataset == null) return null;
    final specialMode = _ref.read(specialModeProvider);
    final prayerContext = _ref.read(prayerScheduleContextProvider);
    final context = buildDefaultDailyDuaSelectionContext(
      now: now,
      surface: duaSurface,
      ramadanContextActive:
          specialMode.isRamadan || specialMode.ramadanDateWindowActive,
      currentPrayerId: prayerContext.currentPrayerId,
      nextPrayerId: prayerContext.nextPrayerId,
      maxItems: 6,
      allowGeneralVerified: false,
      excludeRecentlySeen: false,
    );
    final selected = _ref
        .read(dailyDuaContentServiceProvider)
        .getCompactDuaPrompt(dataset: dataset, context: context)
        ?.item;
    if (selected == null) return null;

    return WidgetDuaContent(
      id: selected.id,
      title: selected.title,
      arabicText: selected.arabic,
      translation: selected.translation,
      transliteration: selected.transliteration,
      whenToSay: selected.whenToSay,
      shortLabel: selected.title,
    );
  }

  WidgetHadithContent? _buildHadithContent(DateTime now) {
    final dailyBundle = _ref.read(hadithDailyReflectionBundleProvider);
    final entries = _ref.read(hadithEntriesProvider);
    final fallbackPool = entries
        .where((entry) => entry.isDailyEligible)
        .toList(growable: false);
    final selected =
        dailyBundle.entry ??
        _pick(
          fallbackPool.isEmpty ? entries : fallbackPool,
          seed: _dailySeed(now, salt: 'hadith'),
          idOf: (entry) => entry.id,
        );
    if (selected == null) return null;

    return WidgetHadithContent(
      id: selected.id,
      title: selected.title,
      shortText: _truncate(
        selected.excerpt.trim().isNotEmpty
            ? selected.excerpt
            : selected.meaning,
        150,
      ),
      sourceLabel: selected.sourceLabel,
      narrator: selected.narrator,
    );
  }

  WidgetDhikrContent _buildDhikrContent() {
    final state = _ref.read(dhikrControllerProvider);
    return WidgetDhikrContent(
      phrase: state.selectedPreset.label,
      arabicPhrase: state.selectedPreset.phrase,
      translation: state.selectedPreset.translation,
      currentCount: state.currentCount,
      targetCount: state.target,
      shortLabel: state.selectedPreset.transliteration,
    );
  }

  WidgetReflectionContent _buildReflectionContent() {
    final summary = _ref.read(quranDailyCompanionSummaryProvider);
    final ayahLabel =
        '${summary.reflection.assignment.entry.ref.surah}:${summary.reflection.assignment.entry.ref.ayah}';
    return WidgetReflectionContent(
      title: ayahLabel,
      shortText: _truncate(summary.practicalTakeaway, 140),
      longerText: summary.reflection.primaryPrompt,
    );
  }

  WidgetNameOfAllahContent _buildNameOfAllahContent(
    DateTime now,
    SpiritualTimeOfDay timeOfDay,
  ) {
    final selected =
        namesOfAllah[_dailySeed(now, salt: 'names-${timeOfDay.name}') %
            namesOfAllah.length];
    return WidgetNameOfAllahContent(
      nameArabic: selected.arabic,
      transliteration: selected.transliteration,
      meaning: selected.meaning,
      shortMeaning: _truncate(selected.meaning, 30),
    );
  }

  WatchSpiritualPromptContent _buildWatchPrompt({
    required SpiritualTimeOfDay timeOfDay,
    required WidgetDuaContent? dua,
    required WidgetHadithContent? hadith,
    required WidgetAyahContent ayah,
    required WidgetReflectionContent reflection,
  }) {
    switch (timeOfDay) {
      case SpiritualTimeOfDay.morning:
        return WatchSpiritualPromptContent(
          kind: 'dua',
          sourceTitle: dua?.title ?? 'morning',
          sourceShortText: dua?.title ?? 'morning',
        );
      case SpiritualTimeOfDay.evening:
        return WatchSpiritualPromptContent(
          kind: 'dua',
          sourceTitle: dua?.title ?? 'evening',
          sourceShortText: dua?.title ?? 'evening',
        );
      case SpiritualTimeOfDay.night:
        return WatchSpiritualPromptContent(
          kind: 'dua',
          sourceTitle: dua?.title ?? 'night',
          sourceShortText: dua?.title ?? 'night',
        );
      case SpiritualTimeOfDay.afternoon:
        if (hadith != null) {
          return WatchSpiritualPromptContent(
            kind: 'hadith',
            sourceTitle: hadith.title,
            sourceShortText: hadith.title,
          );
        }
        return WatchSpiritualPromptContent(
          kind: 'ayah',
          sourceTitle: ayah.locationLabel,
          sourceShortText: _truncate(ayah.locationLabel, 24),
        );
    }
  }

  int _dailySeed(DateTime now, {String salt = ''}) {
    final saltCode = salt.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return (now.year * 372) + (now.month * 31) + now.day + saltCode;
  }

  T? _pick<T>(
    List<T> items, {
    required int seed,
    required String Function(T item) idOf,
  }) {
    if (items.isEmpty) return null;
    final sorted = [...items]..sort((a, b) => idOf(a).compareTo(idOf(b)));
    return sorted[seed % sorted.length];
  }

  String _truncate(String value, int maxLength) {
    final trimmed = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.length <= maxLength) return trimmed;
    return '${trimmed.substring(0, maxLength - 1).trimRight()}…';
  }
}
