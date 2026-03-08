import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  FastingController() : super(FastingState.initial());

  void setType(FastingType type) {
    state = state.copyWith(selectedType: type);
  }

  void setStatus(FastingStatus status) {
    state = state.copyWith(todayStatus: status);
  }
}

final fastingControllerProvider =
    StateNotifierProvider<FastingController, FastingState>(
      (ref) => FastingController(),
    );

