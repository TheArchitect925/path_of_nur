import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../../journey/application/journey_progression_provider.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../learn/dua/application/daily_dua_content_service.dart';
import '../../learn/hadith/application/hadith_daily_reflection_service.dart';
import '../../learn/quran/application/quran_daily_reflection_provider.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../worship/application/dhikr_controller.dart';
import '../../worship/application/prayer_controller.dart';
import '../../worship/domain/daily_prayer_record.dart';
import '../../worship/domain/prayer_status.dart';
import 'iphone_home_widget_models.dart';
import 'spiritual_widget_content_engine.dart';

const _iPhoneWidgetAppGroupId = 'group.com.pathofnur.watch';
const _iPhoneWidgetSchemaVersion = 1;

const _nextPrayerWidgetKind = 'PathOfNurNextPrayerWidget';
const _prayerOverviewWidgetKind = 'PathOfNurPrayerOverviewWidget';
const _dhikrWidgetKind = 'PathOfNurDhikrWidget';
const _journeyWidgetKind = 'PathOfNurJourneyWidget';
const _duaWidgetKind = 'PathOfNurDuaWidget';
const _hadithWidgetKind = 'PathOfNurHadithWidget';
const _ayahWidgetKind = 'PathOfNurAyahWidget';
const _reflectionWidgetKind = 'PathOfNurReflectionWidget';
const _nameOfAllahWidgetKind = 'PathOfNurNameOfAllahWidget';

const _nextPrayerStorageKey = 'path_of_nur.iphone_widget.next_prayer.v1';
const _prayerOverviewStorageKey =
    'path_of_nur.iphone_widget.prayer_overview.v1';
const _dhikrStorageKey = 'path_of_nur.iphone_widget.dhikr.v1';
const _journeyStorageKey = 'path_of_nur.iphone_widget.journey.v1';
const _duaStorageKey = 'path_of_nur.iphone_widget.dua.v1';
const _hadithStorageKey = 'path_of_nur.iphone_widget.hadith.v1';
const _ayahStorageKey = 'path_of_nur.iphone_widget.ayah.v1';
const _reflectionStorageKey = 'path_of_nur.iphone_widget.reflection.v1';
const _nameOfAllahStorageKey = 'path_of_nur.iphone_widget.name_of_allah.v1';

final iPhoneHomeWidgetSyncServiceProvider =
    Provider<IPhoneHomeWidgetSyncService>((ref) {
      return IPhoneHomeWidgetSyncService(ref);
    });

final iPhoneHomeWidgetBootstrapProvider = Provider<void>((ref) {
  final controller = IPhoneHomeWidgetSyncController(ref);
  controller.start();
  ref.onDispose(controller.dispose);

  ref.listen(appLocaleProvider, (_, nextLocale) => controller.scheduleSync());
  ref.listen(
    prayerScheduleProvider,
    (_, nextSchedule) => controller.scheduleSync(),
  );
  ref.listen(
    prayerScheduleContextProvider,
    (_, nextContext) => controller.scheduleSync(),
  );
  ref.listen(
    prayerControllerProvider,
    (_, nextRecords) => controller.scheduleSync(),
  );
  ref.listen(
    quranDailyReflectionStateProvider,
    (_, nextState) => controller.scheduleSync(),
  );
  ref.listen(
    hadithDailyReflectionControllerProvider,
    (_, nextState) => controller.scheduleSync(),
  );
  ref.listen(
    quranReaderSettingsProvider,
    (_, nextSettings) => controller.scheduleSync(),
  );
  ref.listen(
    dhikrControllerProvider,
    (_, nextDhikr) => controller.scheduleSync(),
  );
  ref.listen(
    journeyActivitySnapshotProvider,
    (_, nextSnapshot) => controller.scheduleSync(),
  );
  ref.listen(
    journeyComputedProgressProvider,
    (_, nextProgress) => controller.scheduleSync(),
  );
  ref.listen(
    journeyXpSummaryProvider,
    (_, nextXpSummary) => controller.scheduleSync(),
  );
  ref.listen(dailyKeyProvider, (_, nextDayKey) => controller.scheduleSync());
});

class IPhoneHomeWidgetSyncController {
  IPhoneHomeWidgetSyncController(this._ref);

  final Ref _ref;
  Timer? _timer;
  bool _disposed = false;
  bool _isSyncing = false;

  void start() {
    scheduleSync(immediate: true);
  }

  void scheduleSync({bool immediate = false}) {
    if (_disposed) return;
    _timer?.cancel();
    if (immediate) {
      unawaited(_syncNow());
      return;
    }
    _timer = Timer(const Duration(milliseconds: 600), () {
      unawaited(_syncNow());
    });
  }

  Future<void> _syncNow() async {
    if (_disposed || _isSyncing) return;
    _isSyncing = true;
    try {
      await _ref.read(iPhoneHomeWidgetSyncServiceProvider).updateAllWidgets();
    } catch (error, stackTrace) {
      AppTelemetry.logError(
        'iphone_home_widget_sync_failed',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
  }
}

class IPhoneHomeWidgetSyncService {
  const IPhoneHomeWidgetSyncService(this._ref);

  final Ref _ref;

  Future<void> updateAllWidgets() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    await HomeWidget.setAppGroupId(_iPhoneWidgetAppGroupId);
    await updateNextPrayerWidget();
    await updatePrayerOverviewWidget();
    await updateDhikrWidget();
    await updateJourneyWidget();
    await updateDuaWidget();
    await updateHadithWidget();
    await updateAyahWidget();
    await updateReflectionWidget();
    await updateNameOfAllahWidget();
    await updateLockScreenWidgets();
  }

  Future<void> updateNextPrayerWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final nextPrayer = _buildNextPrayerPayload(
      l10n: l10n,
      locale: locale,
      now: now,
    );
    await HomeWidget.saveWidgetData<String>(
      _nextPrayerStorageKey,
      nextPrayer.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _nextPrayerWidgetKind);
  }

  Future<void> updatePrayerOverviewWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final overview = _buildPrayerOverviewPayload(
      l10n: l10n,
      locale: locale,
      now: now,
    );
    await HomeWidget.saveWidgetData<String>(
      _prayerOverviewStorageKey,
      overview.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _prayerOverviewWidgetKind);
  }

  Future<void> updateDhikrWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final dhikr = _buildDhikrPayload(l10n: l10n, locale: locale, now: now);
    await HomeWidget.saveWidgetData<String>(
      _dhikrStorageKey,
      dhikr.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _dhikrWidgetKind);
  }

  Future<void> updateJourneyWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final journey = _buildJourneyPayload(l10n: l10n, locale: locale, now: now);
    await HomeWidget.saveWidgetData<String>(
      _journeyStorageKey,
      journey.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _journeyWidgetKind);
  }

  Future<void> updateDuaWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final payload = _buildDuaPayload(l10n: l10n, locale: locale, now: now);
    await HomeWidget.saveWidgetData<String>(
      _duaStorageKey,
      payload.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _duaWidgetKind);
  }

  Future<void> updateHadithWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final payload = _buildHadithPayload(l10n: l10n, locale: locale, now: now);
    await HomeWidget.saveWidgetData<String>(
      _hadithStorageKey,
      payload.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _hadithWidgetKind);
  }

  Future<void> updateAyahWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final payload = _buildAyahPayload(l10n: l10n, locale: locale, now: now);
    await HomeWidget.saveWidgetData<String>(
      _ayahStorageKey,
      payload.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _ayahWidgetKind);
  }

  Future<void> updateReflectionWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final payload = _buildReflectionPayload(
      l10n: l10n,
      locale: locale,
      now: now,
    );
    await HomeWidget.saveWidgetData<String>(
      _reflectionStorageKey,
      payload.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _reflectionWidgetKind);
  }

  Future<void> updateNameOfAllahWidget() async {
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final payload = _buildNameOfAllahPayload(
      l10n: l10n,
      locale: locale,
      now: now,
    );
    await HomeWidget.saveWidgetData<String>(
      _nameOfAllahStorageKey,
      payload.toEncodedJson(),
    );
    await HomeWidget.updateWidget(iOSName: _nameOfAllahWidgetKind);
  }

  Future<void> updateLockScreenWidgets() async {
    await HomeWidget.updateWidget(iOSName: _nextPrayerWidgetKind);
    await HomeWidget.updateWidget(iOSName: _dhikrWidgetKind);
    await HomeWidget.updateWidget(iOSName: _duaWidgetKind);
    await HomeWidget.updateWidget(iOSName: _hadithWidgetKind);
    await HomeWidget.updateWidget(iOSName: _ayahWidgetKind);
    await HomeWidget.updateWidget(iOSName: _reflectionWidgetKind);
    await HomeWidget.updateWidget(iOSName: _nameOfAllahWidgetKind);
  }

  IPhoneNextPrayerWidgetPayload _buildNextPrayerPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final schedule = _ref.read(prayerScheduleProvider);
    final context = _ref.read(prayerScheduleContextProvider);
    final current = _itemById(schedule, context.currentPrayerId);
    final next = _itemById(schedule, context.nextPrayerId);

    return IPhoneNextPrayerWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsNextPrayerTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      currentPrayerName: current?.name,
      currentPrayerArabicName: current?.arabicName,
      currentPrayerLabel: l10n.homeWidgetsCurrentPrayerLabel,
      nextPrayerName: next?.name,
      nextPrayerArabicName: next?.arabicName,
      nextPrayerTimeIso: next?.offerDateTime.toIso8601String(),
      nextPrayerTimeLabel: next?.offerTime,
      nextPrayerCountdownLabel: _countdownLabel(
        l10n: l10n,
        remaining: context.remainingToNext,
      ),
      nextPrayerLabel: l10n.homeWidgetsNextPrayerLabel,
      deepLinkUrl: 'pathofnur://worship/prayer',
      fallbackTitle: l10n.homeWidgetsNoPrayerTimesTitle,
      fallbackBody: l10n.homeWidgetsNoPrayerTimesBody,
    );
  }

  IPhonePrayerOverviewWidgetPayload _buildPrayerOverviewPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final schedule = _ref.read(prayerScheduleProvider);
    final context = _ref.read(prayerScheduleContextProvider);
    final records = _ref.read(prayerControllerProvider);
    final items = schedule
        .where((item) => _trackedPrayerIds.contains(item.id))
        .map(
          (item) => IPhoneHomeWidgetPrayerItemPayload(
            id: item.id,
            name: item.name,
            arabicName: item.arabicName,
            timeIso: item.offerDateTime.toIso8601String(),
            timeLabel: item.offerTime,
            isCompleted: _isPrayerCompleted(records, item.id),
            isCurrent: context.currentPrayerId == item.id,
            isNext: context.nextPrayerId == item.id,
          ),
        )
        .toList(growable: false);

    return IPhonePrayerOverviewWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsPrayerOverviewTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      completedPrayerCount: items.where((item) => item.isCompleted).length,
      totalPrayerCount: items.length,
      phaseProgressPercent:
          (_ref
                      .read(prayerScheduleContextProvider)
                      .progressToNext
                      .clamp(0.0, 1.0) *
                  100)
              .round(),
      deepLinkUrl: 'pathofnur://worship/prayer',
      items: items,
    );
  }

  IPhoneDhikrWidgetPayload _buildDhikrPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final dhikr = _ref.read(dhikrControllerProvider);
    final snapshot = _ref.read(journeyActivitySnapshotProvider);
    final target = dhikr.target <= 0 ? 33 : dhikr.target;
    final progress = target <= 0
        ? 0
        : ((snapshot.dhikrCountToday / target).clamp(0.0, 1.0) * 100).round();

    return IPhoneDhikrWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsDhikrTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      todayCount: snapshot.dhikrCountToday,
      targetCount: target,
      progressPercent: progress,
      todayLabel: l10n.homeWidgetsDhikrTodayLabel,
      targetLabel: l10n.homeWidgetsTargetLabel,
      deepLinkUrl: 'pathofnur://worship/dhikr',
    );
  }

  IPhoneJourneyWidgetPayload _buildJourneyPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final progress = _ref.read(journeyComputedProgressProvider);
    final xp = _ref.read(journeyXpSummaryProvider);

    return IPhoneJourneyWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsJourneyTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      currentStreakDays: progress.currentStreakDays,
      currentLevel: xp.currentLevel,
      totalXp: progress.xp,
      todayXp: xp.todayXp,
      xpProgressPercent: (progress.xpProgress.clamp(0.0, 1.0) * 100).round(),
      streakLabel: l10n.homeWidgetsStreakLabel,
      levelLabel: l10n.homeWidgetsLevelLabel,
      todayXpLabel: l10n.homeWidgetsTodayXpLabel,
      deepLinkUrl: 'pathofnur://journey/progress',
    );
  }

  IPhoneSpiritualWidgetPayload _buildDuaPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final bundle = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceHomeWidget);
    final dua = bundle.dua;
    final fallbackTitle = l10n.homeWidgetsNoSpiritualContentTitle;
    final fallbackBody = l10n.homeWidgetsNoSpiritualContentBody;
    if (dua == null) {
      return _fallbackSpiritualPayload(
        title: l10n.homeWidgetsDuaTitle,
        l10n: l10n,
        locale: locale,
        now: now,
        fallbackTitle: fallbackTitle,
        fallbackBody: fallbackBody,
        deepLinkUrl: 'pathofnur://worship/duas',
      );
    }
    final inline = switch (bundle.timeOfDay) {
      SpiritualTimeOfDay.morning => l10n.homeWidgetsMorningDuaReady,
      SpiritualTimeOfDay.afternoon => l10n.homeWidgetsDailyDuaReady,
      SpiritualTimeOfDay.evening => l10n.homeWidgetsEveningDuaReady,
      SpiritualTimeOfDay.night => l10n.homeWidgetsNightDuaReady,
    };
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsDuaTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: dua.title,
      supportingText: dua.translation,
      footerText: dua.whenToSay,
      arabicText: dua.arabicText,
      transliterationText: dua.transliteration,
      accentText: null,
      deepLinkUrl: 'pathofnur://worship/duas',
      accessoryInlineText: inline,
      accessoryCircularText: 'D',
      accessoryRectangularTitle: l10n.homeWidgetsDuaTitle,
      accessoryRectangularBody: dua.title,
      fallbackTitle: fallbackTitle,
      fallbackBody: fallbackBody,
    );
  }

  IPhoneSpiritualWidgetPayload _buildHadithPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final bundle = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceHomeWidget);
    final hadith = bundle.hadith;
    final fallbackTitle = l10n.homeWidgetsNoSpiritualContentTitle;
    final fallbackBody = l10n.homeWidgetsNoSpiritualContentBody;
    if (hadith == null) {
      return _fallbackSpiritualPayload(
        title: l10n.homeWidgetsHadithTitle,
        l10n: l10n,
        locale: locale,
        now: now,
        fallbackTitle: fallbackTitle,
        fallbackBody: fallbackBody,
        deepLinkUrl: 'pathofnur://learn/hadith',
      );
    }
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsHadithTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: hadith.title,
      supportingText: hadith.shortText,
      footerText: hadith.sourceLabel,
      arabicText: null,
      transliterationText: hadith.narrator,
      accentText: null,
      deepLinkUrl: 'pathofnur://learn/hadith',
      accessoryInlineText: l10n.homeWidgetsHadithTodayInline,
      accessoryCircularText: 'H',
      accessoryRectangularTitle: l10n.homeWidgetsHadithTitle,
      accessoryRectangularBody: hadith.title,
      fallbackTitle: fallbackTitle,
      fallbackBody: fallbackBody,
    );
  }

  IPhoneSpiritualWidgetPayload _buildAyahPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final ayah = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceHomeWidget)
        .ayah;
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsAyahTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: ayah.locationLabel,
      supportingText: ayah.shortSnippet,
      footerText: ayah.locationLabel,
      arabicText: ayah.arabicText,
      transliterationText: null,
      accentText: null,
      deepLinkUrl:
          'pathofnur://quran/surah/${ayah.surahNumber}?ayah=${ayah.ayahNumber}',
      accessoryInlineText: l10n.homeWidgetsAyahTodayInline,
      accessoryCircularText: 'A',
      accessoryRectangularTitle: l10n.homeWidgetsAyahTitle,
      accessoryRectangularBody: ayah.locationLabel,
      fallbackTitle: l10n.homeWidgetsNoSpiritualContentTitle,
      fallbackBody: l10n.homeWidgetsNoSpiritualContentBody,
    );
  }

  IPhoneSpiritualWidgetPayload _buildReflectionPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final reflection = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceHomeWidget)
        .reflection;
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsReflectionTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: reflection.title,
      supportingText: reflection.shortText,
      footerText: reflection.longerText ?? reflection.shortText,
      arabicText: null,
      transliterationText: null,
      accentText: null,
      deepLinkUrl: 'pathofnur://quran/daily',
      accessoryInlineText: l10n.homeWidgetsReflectionInline,
      accessoryCircularText: 'R',
      accessoryRectangularTitle: l10n.homeWidgetsReflectionTitle,
      accessoryRectangularBody: reflection.shortText,
      fallbackTitle: l10n.homeWidgetsNoSpiritualContentTitle,
      fallbackBody: l10n.homeWidgetsNoSpiritualContentBody,
    );
  }

  IPhoneSpiritualWidgetPayload _buildNameOfAllahPayload({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final name = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceHomeWidget)
        .nameOfAllah;
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: l10n.homeWidgetsNameOfAllahTitle,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: name.transliteration,
      supportingText: name.meaning,
      footerText: name.shortMeaning,
      arabicText: name.nameArabic,
      transliterationText: null,
      accentText: null,
      deepLinkUrl: 'pathofnur://quran/names-of-allah',
      accessoryInlineText: l10n.homeWidgetsNameOfAllahInline,
      accessoryCircularText: '99',
      accessoryRectangularTitle: l10n.homeWidgetsNameOfAllahTitle,
      accessoryRectangularBody: name.transliteration,
      fallbackTitle: l10n.homeWidgetsNoSpiritualContentTitle,
      fallbackBody: l10n.homeWidgetsNoSpiritualContentBody,
    );
  }

  IPhoneSpiritualWidgetPayload _fallbackSpiritualPayload({
    required String title,
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
    required String fallbackTitle,
    required String fallbackBody,
    required String deepLinkUrl,
  }) {
    return IPhoneSpiritualWidgetPayload(
      schemaVersion: _iPhoneWidgetSchemaVersion,
      updatedAtIso: now.toIso8601String(),
      title: title,
      dateLine: _dateLine(l10n: l10n, locale: locale, now: now),
      headline: fallbackTitle,
      supportingText: fallbackBody,
      footerText: fallbackBody,
      arabicText: null,
      transliterationText: null,
      accentText: null,
      deepLinkUrl: deepLinkUrl,
      accessoryInlineText: title,
      accessoryCircularText: '•',
      accessoryRectangularTitle: title,
      accessoryRectangularBody: fallbackTitle,
      fallbackTitle: fallbackTitle,
      fallbackBody: fallbackBody,
    );
  }

  String _dateLine({
    required AppLocalizations l10n,
    required Locale locale,
    required DateTime now,
  }) {
    final localeTag = locale.toLanguageTag();
    final gregorian = DateFormat('EEE, MMM d', localeTag).format(now);
    final hijri = toHijriDate(now);
    final hijriMonth = hijriMonthName(l10n, hijri.month);
    return '$gregorian • ${hijri.day} $hijriMonth';
  }

  String _countdownLabel({
    required AppLocalizations l10n,
    required Duration remaining,
  }) {
    final totalMinutes = remaining.inMinutes;
    if (totalMinutes <= 1) {
      return l10n.homeWidgetsPrayerCountdownSoon;
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours <= 0) {
      return l10n.homeWidgetsPrayerCountdownInMinutes(minutes);
    }
    return l10n.homeWidgetsPrayerCountdownInHoursMinutes(hours, minutes);
  }

  PrayerScheduleItem? _itemById(List<PrayerScheduleItem> items, String? id) {
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  bool _isPrayerCompleted(List<DailyPrayerRecord> records, String prayerId) {
    for (final record in records) {
      if (record.prayer.name == prayerId &&
          record.status == PrayerStatus.completed) {
        return true;
      }
    }
    return false;
  }
}

const Set<String> _trackedPrayerIds = <String>{
  'fajr',
  'dhuhr',
  'asr',
  'maghrib',
  'isha',
};
