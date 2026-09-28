import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the parents area is open. A grown-up opens it by holding a
/// button; it stays open for a while so a parent can move between the
/// dashboards without holding again, and closes on its own after that.
class KidsParentGateState {
  const KidsParentGateState({this.unlockedUntil});

  final DateTime? unlockedUntil;

  bool isOpenAt(DateTime now) => unlockedUntil?.isAfter(now) ?? false;
}

class KidsParentGateController extends StateNotifier<KidsParentGateState> {
  KidsParentGateController() : super(const KidsParentGateState());

  static const Duration openFor = Duration(minutes: 10);

  void unlock(DateTime now) {
    state = KidsParentGateState(unlockedUntil: now.add(openFor));
  }

  void lock() {
    state = const KidsParentGateState();
  }
}

/// Session state only: the gate is closed again on every launch.
final kidsParentGateProvider =
    StateNotifierProvider<KidsParentGateController, KidsParentGateState>(
      (ref) => KidsParentGateController(),
    );
