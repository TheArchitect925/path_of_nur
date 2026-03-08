import 'fasting_status.dart';
import 'fasting_type.dart';

class DailyFastingRecord {
  const DailyFastingRecord({
    required this.dateLabel,
    required this.type,
    required this.status,
    this.note,
  });

  final String dateLabel;
  final FastingType type;
  final FastingStatus status;
  final String? note;
}

