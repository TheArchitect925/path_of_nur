import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorshipTab {
  prayer,
  dhikr,
  fasting,
  khusu,
}

extension WorshipTabX on WorshipTab {
  String get label {
    switch (this) {
      case WorshipTab.prayer:
        return 'Prayer';
      case WorshipTab.dhikr:
        return 'Dhikr';
      case WorshipTab.fasting:
        return 'Fasting';
      case WorshipTab.khusu:
        return 'Khusū';
    }
  }
}

final worshipTabProvider = StateProvider<WorshipTab>((_) => WorshipTab.prayer);

