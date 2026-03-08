import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LearnTab {
  quran,
  life,
  world,
  hadith,
  notes,
}

final learnTabProvider = StateProvider<LearnTab>((_) => LearnTab.quran);

