import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/build_flavor.dart';
import '../../../shared/persistence/local_store.dart';

const _editorialDashboardPinHashKey =
    'internal.editorial_dashboard.pin_hash.v1';
const _defaultEditorialDashboardPin = '0786';

class EditorialDashboardAccessState {
  const EditorialDashboardAccessState({
    required this.isSessionUnlocked,
    required this.hasSeededPin,
  });

  const EditorialDashboardAccessState.initial()
    : isSessionUnlocked = false,
      hasSeededPin = false;

  final bool isSessionUnlocked;
  final bool hasSeededPin;

  EditorialDashboardAccessState copyWith({
    bool? isSessionUnlocked,
    bool? hasSeededPin,
  }) {
    return EditorialDashboardAccessState(
      isSessionUnlocked: isSessionUnlocked ?? this.isSessionUnlocked,
      hasSeededPin: hasSeededPin ?? this.hasSeededPin,
    );
  }
}

class EditorialDashboardAccessController
    extends StateNotifier<EditorialDashboardAccessState> {
  EditorialDashboardAccessController(this._store)
    : super(const EditorialDashboardAccessState.initial()) {
    _ensureSeededPin();
  }

  final LocalStore _store;

  static String hashPin(String pin) {
    return sha256
        .convert(utf8.encode('path_of_nur_editorial_dashboard::$pin'))
        .toString();
  }

  void _ensureSeededPin() {
    final existing = _store.getString(_editorialDashboardPinHashKey);
    if (existing == null || existing.isEmpty) {
      unawaited(
        _store.setString(
          _editorialDashboardPinHashKey,
          hashPin(_defaultEditorialDashboardPin),
        ),
      );
    }
    state = state.copyWith(hasSeededPin: true);
  }

  bool verifyPin(String pin) {
    final normalized = pin.trim();
    if (normalized.isEmpty) return false;
    final expected =
        _store.getString(_editorialDashboardPinHashKey) ??
        hashPin(_defaultEditorialDashboardPin);
    final matches = hashPin(normalized) == expected;
    if (matches) {
      state = state.copyWith(isSessionUnlocked: true, hasSeededPin: true);
    }
    return matches;
  }

  Future<void> updatePin(String pin) async {
    final normalized = pin.trim();
    if (normalized.isEmpty) return;
    await _store.setString(_editorialDashboardPinHashKey, hashPin(normalized));
    state = state.copyWith(hasSeededPin: true);
  }

  void lock() {
    state = state.copyWith(isSessionUnlocked: false);
  }
}

final editorialDashboardFeatureEnabledProvider = Provider<bool>((ref) {
  return BuildFlavorConfig.current != BuildFlavor.prod ||
      const bool.fromEnvironment(
        'ENABLE_EDITORIAL_DASHBOARD',
        defaultValue: false,
      );
});

final editorialDashboardAccessProvider =
    StateNotifierProvider<
      EditorialDashboardAccessController,
      EditorialDashboardAccessState
    >((ref) {
      return EditorialDashboardAccessController(ref.watch(localStoreProvider));
    });
