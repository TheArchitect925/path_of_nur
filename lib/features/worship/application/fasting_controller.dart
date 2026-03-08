import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/daily_fasting_record.dart';
import '../domain/fasting_status.dart';
import '../domain/fasting_type.dart';

class FastingState {
  const FastingState({
    required this.selectedType,
    required this.todayStatus,
    required this.history,
  });

  final FastingType selectedType;
  final FastingStatus todayStatus;
  final List<DailyFastingRecord> history;

  FastingState copyWith({
    FastingType? selectedType,
    FastingStatus? todayStatus,
    List<DailyFastingRecord>? history,
  }) {
    return FastingState(
      selectedType: selectedType ?? this.selectedType,
      todayStatus: todayStatus ?? this.todayStatus,
      history: history ?? this.history,
    );
  }

  factory FastingState.initial() {
    return FastingState(
      selectedType: FastingType.ramadan,
      todayStatus: FastingStatus.intending,
      history: const [
        DailyFastingRecord(
          dateLabel: 'Mon',
          type: FastingType.ramadan,
          status: FastingStatus.completed,
        ),
        DailyFastingRecord(
          dateLabel: 'Tue',
          type: FastingType.ramadan,
          status: FastingStatus.completed,
        ),
        DailyFastingRecord(
          dateLabel: 'Wed',
          type: FastingType.sunnah,
          status: FastingStatus.broken,
        ),
      ],
    );
  }
}

class FastingController extends StateNotifier<FastingState> {
  FastingController(this._store) : super(FastingState.initial()) {
    _load();
  }

  final LocalStore _store;

  void setType(FastingType type) {
    state = state.copyWith(selectedType: type);
    _save();
  }

  void setStatus(FastingStatus status) {
    state = state.copyWith(todayStatus: status);
    _save();
  }

  void _load() {
    final dayKey = LocalStore.todayKey();
    final today = _store.getJsonMap('worship.fasting.$dayKey');
    final historyRaw = _store.getJsonList('worship.fasting.history');

    var type = state.selectedType;
    var status = state.todayStatus;

    if (today != null) {
      final typeName = today['selectedType'] as String?;
      final statusName = today['todayStatus'] as String?;

      for (final item in FastingType.values) {
        if (item.name == typeName) {
          type = item;
          break;
        }
      }
      for (final item in FastingStatus.values) {
        if (item.name == statusName) {
          status = item;
          break;
        }
      }
    }

    final history = <DailyFastingRecord>[];
    if (historyRaw != null) {
      for (final row in historyRaw) {
        if (row is! Map) continue;
        final dateLabel = row['dateLabel']?.toString();
        final typeName = row['type']?.toString();
        final statusName = row['status']?.toString();
        if (dateLabel == null) continue;

        FastingType rowType = FastingType.ramadan;
        FastingStatus rowStatus = FastingStatus.notFasting;
        for (final item in FastingType.values) {
          if (item.name == typeName) {
            rowType = item;
            break;
          }
        }
        for (final item in FastingStatus.values) {
          if (item.name == statusName) {
            rowStatus = item;
            break;
          }
        }
        history.add(
          DailyFastingRecord(
            dateLabel: dateLabel,
            type: rowType,
            status: rowStatus,
          ),
        );
      }
    }

    state = state.copyWith(
      selectedType: type,
      todayStatus: status,
      history: history.isEmpty ? state.history : history,
    );
  }

  void _save() {
    final dayKey = LocalStore.todayKey();
    _store.setJsonMap('worship.fasting.$dayKey', {
      'selectedType': state.selectedType.name,
      'todayStatus': state.todayStatus.name,
    });

    _store.setJsonList(
      'worship.fasting.history',
      state.history
          .take(21)
          .map((record) => {
                'dateLabel': record.dateLabel,
                'type': record.type.name,
                'status': record.status.name,
              })
          .toList(),
    );
  }
}

final fastingControllerProvider =
    StateNotifierProvider<FastingController, FastingState>(
      (ref) => FastingController(ref.watch(localStoreProvider)),
    );
