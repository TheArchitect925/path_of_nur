import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import 'dhikr_controller.dart';
import '../data/prayer_log_repository.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';
import '../domain/prayer_tracker_fields.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController(
    this._repository,
    this._dropController,
    this._xpController,
    this._dhikrController,
  ) : super(const [
        DailyPrayerRecord(prayer: PrayerName.fajr),
        DailyPrayerRecord(prayer: PrayerName.dhuhr),
        DailyPrayerRecord(prayer: PrayerName.asr),
        DailyPrayerRecord(prayer: PrayerName.maghrib),
        DailyPrayerRecord(prayer: PrayerName.isha),
      ]) {
    _activeDayKey = LocalStore.todayKey();
    _loadForDay(_activeDayKey);
  }

  final PrayerLogRepository _repository;
  final JourneyDropController _dropController;
  final JourneyXpController _xpController;
  final DhikrController _dhikrController;
  late String _activeDayKey;

  void cycleStatus(PrayerName prayer) {
    _syncDayIfNeeded();
    PrayerStatus? nextStatus;
    final changedAt = DateTime.now();
    state = state
        .map(
          (record) => record.prayer == prayer
              ? (() {
                  nextStatus = record.status.next;
                  return record.copyWith(
                    status: nextStatus,
                    completedAtIso: nextStatus == PrayerStatus.completed
                        ? changedAt.toIso8601String()
                        : null,
                    clearCompletedAtIso: nextStatus != PrayerStatus.completed,
                  );
                })()
              : record,
        )
        .toList();
    _saveForDay(_activeDayKey);
    if (nextStatus == PrayerStatus.completed) {
      _dropController.awardPrayerDrop(
        prayerId: prayer.name,
        dayKey: _activeDayKey,
        occurredAt: changedAt,
        metadata: <String, Object?>{'timestamp': changedAt.toIso8601String()},
      );
      _xpController.awardPrayerXp(
        prayerId: prayer.name,
        occurredAt: changedAt,
        sourceRef: 'prayer:$_activeDayKey:${prayer.name}',
        dayKey: _activeDayKey,
        allFiveCompleted: state.every(
          (record) => record.status == PrayerStatus.completed,
        ),
      );
    }
  }

  void markCompleted(PrayerName prayer) {
    _syncDayIfNeeded();
    final alreadyCompleted = state.any(
      (record) =>
          record.prayer == prayer && record.status == PrayerStatus.completed,
    );
    if (alreadyCompleted) return;

    final changedAt = DateTime.now();
    state = state
        .map(
          (record) => record.prayer == prayer
              ? record.copyWith(
                  status: PrayerStatus.completed,
                  completedAtIso: changedAt.toIso8601String(),
                )
              : record,
        )
        .toList();
    _saveForDay(_activeDayKey);
    _awardPrayerCompletionXpAndDrops(prayer: prayer, occurredAt: changedAt);
  }

  void toggleCompleted(PrayerName prayer) {
    _syncDayIfNeeded();
    final current = state
        .where((record) => record.prayer == prayer)
        .firstOrNull;
    if (current == null) return;
    if (current.status == PrayerStatus.completed) {
      state = state
          .map(
            (record) => record.prayer == prayer
                ? record.copyWith(
                    status: PrayerStatus.pending,
                    clearCompletedAtIso: true,
                  )
                : record,
          )
          .toList();
      _saveForDay(_activeDayKey);
      return;
    }
    markCompleted(prayer);
  }

  void onDayChanged(String dayKey, {bool force = false}) {
    if (!force && dayKey == _activeDayKey) return;
    _activeDayKey = dayKey;
    _loadForDay(dayKey);
  }

  void _syncDayIfNeeded() {
    final today = LocalStore.todayKey();
    if (today != _activeDayKey) {
      onDayChanged(today);
    }
  }

  void _loadForDay(String dayKey) {
    state = _repository.readDailyRecords(dayKey);
  }

  void _saveForDay(String dayKey) {
    final existing = _repository.readDayEntries(dayKey);
    _repository.saveDayEntries(dayKey, <PrayerName, PrayerLogDayEntry>{
      for (final record in state)
        record.prayer: PrayerLogDayEntry(
          status: record.status,
          completedAtIso: record.status == PrayerStatus.completed
              ? record.completedAtIso
              : null,
          postSalahAdhkarCompletedAtIso: record.status == PrayerStatus.completed
              ? record.postSalahAdhkarCompletedAtIso
              : null,
          timing: record.status == PrayerStatus.completed
              ? existing[record.prayer]?.timing
              : null,
          place: record.status == PrayerStatus.completed
              ? existing[record.prayer]?.place
              : null,
          notes: record.status == PrayerStatus.completed
              ? existing[record.prayer]?.notes
              : null,
        ),
    });
  }

  PrayerLogDayEntry? readActiveDayEntry(PrayerName prayer) {
    _syncDayIfNeeded();
    return _repository.readDayEntries(_activeDayKey)[prayer];
  }

  void saveCompletionDetails(
    PrayerName prayer, {
    required PrayerOfferTiming timing,
    required PrayerOfferPlace place,
    String? notes,
  }) {
    _syncDayIfNeeded();
    final record = state.firstWhere((item) => item.prayer == prayer);
    if (record.status != PrayerStatus.completed) return;

    final existing = _repository.readDayEntries(_activeDayKey);
    final currentEntry =
        existing[prayer] ??
        const PrayerLogDayEntry(status: PrayerStatus.completed);
    final sanitizedNotes = notes == null || notes.trim().isEmpty
        ? null
        : notes.trim();

    existing[prayer] = currentEntry.copyWith(
      status: PrayerStatus.completed,
      completedAtIso: record.completedAtIso ?? DateTime.now().toIso8601String(),
      timing: timing,
      place: place,
      notes: sanitizedNotes,
    );
    _repository.saveDayEntries(_activeDayKey, existing);
    state = [...state];
    _awardPrayerContextXp(
      prayer: prayer,
      occurredAt: record.completedAt ?? DateTime.now(),
      timing: timing,
      place: place,
    );
  }

  bool logPostSalahDhikr(PrayerName prayer) {
    _syncDayIfNeeded();
    final record = state.firstWhere((item) => item.prayer == prayer);
    if (record.status != PrayerStatus.completed ||
        record.postSalahAdhkarCompletedAtIso != null) {
      return false;
    }

    final now = DateTime.now();
    final sourceRef = 'post_salah_dhikr:$_activeDayKey:${prayer.name}';
    final logged = _dhikrController.logPostSalahDhikrBundle(
      sourceRef: sourceRef,
      occurredAt: now,
    );
    if (!logged) return false;

    final existing = _repository.readDayEntries(_activeDayKey);
    final currentEntry =
        existing[prayer] ??
        const PrayerLogDayEntry(status: PrayerStatus.completed);
    existing[prayer] = currentEntry.copyWith(
      status: PrayerStatus.completed,
      completedAtIso:
          record.completedAtIso ??
          currentEntry.completedAtIso ??
          now.toIso8601String(),
      postSalahAdhkarCompletedAtIso: now.toIso8601String(),
    );
    _repository.saveDayEntries(_activeDayKey, existing);
    state = [
      for (final item in state)
        item.prayer == prayer
            ? item.copyWith(
                postSalahAdhkarCompletedAtIso: now.toIso8601String(),
              )
            : item,
    ];
    return true;
  }

  void _awardPrayerCompletionXpAndDrops({
    required PrayerName prayer,
    required DateTime occurredAt,
  }) {
    _dropController.awardPrayerDrop(
      prayerId: prayer.name,
      dayKey: _activeDayKey,
      occurredAt: occurredAt,
      metadata: <String, Object?>{'timestamp': occurredAt.toIso8601String()},
    );
    _xpController.awardPrayerXp(
      prayerId: prayer.name,
      occurredAt: occurredAt,
      sourceRef: 'prayer:$_activeDayKey:${prayer.name}',
      dayKey: _activeDayKey,
      allFiveCompleted: state.every(
        (record) => record.status == PrayerStatus.completed,
      ),
    );
  }

  void _awardPrayerContextXp({
    required PrayerName prayer,
    required DateTime occurredAt,
    required PrayerOfferTiming timing,
    required PrayerOfferPlace place,
  }) {
    _xpController.awardPrayerXp(
      prayerId: prayer.name,
      occurredAt: occurredAt,
      sourceRef: 'prayer:$_activeDayKey:${prayer.name}',
      dayKey: _activeDayKey,
      onTime: timing == PrayerOfferTiming.onTime,
      allFiveCompleted: state.every(
        (record) => record.status == PrayerStatus.completed,
      ),
      inCongregation:
          place == PrayerOfferPlace.congregation ||
          place == PrayerOfferPlace.masjid,
      inMasjid: place == PrayerOfferPlace.masjid,
      isJumuah:
          prayer == PrayerName.dhuhr &&
          DateTime.now().weekday == DateTime.friday,
    );
  }
}

final prayerControllerProvider =
    StateNotifierProvider<PrayerController, List<DailyPrayerRecord>>((ref) {
      final notifier = PrayerController(
        ref.watch(prayerLogRepositoryProvider),
        ref.read(journeyDropSummaryProvider.notifier),
        ref.read(journeyXpSummaryProvider.notifier),
        ref.read(dhikrControllerProvider.notifier),
      );
      ref.listen<String>(dailyKeyProvider, (_, next) {
        notifier.onDayChanged(next);
      });
      return notifier;
    });

final prayerSummaryProvider = Provider<PrayerSummary>((ref) {
  final records = ref.watch(prayerControllerProvider);
  return buildPrayerSummary(records);
});
