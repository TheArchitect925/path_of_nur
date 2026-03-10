import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/local_store.dart';

final dailyNowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 30));
    yield DateTime.now();
  }
});

final dailyKeyProvider = Provider<String>((ref) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return LocalStore.todayKey(now);
});
