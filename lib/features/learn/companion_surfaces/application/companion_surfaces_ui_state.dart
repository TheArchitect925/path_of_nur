import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';

class CompanionSurfacesUiState {
  const CompanionSurfacesUiState({
    this.lastSeerahFocus,
    this.selectedCharacterTraitId,
    this.savedDailyWisdomEntryIds = const <String>{},
    this.recentDailyWisdomEntryIds = const <String>[],
  });

  final String? lastSeerahFocus;
  final String? selectedCharacterTraitId;
  final Set<String> savedDailyWisdomEntryIds;
  final List<String> recentDailyWisdomEntryIds;

  CompanionSurfacesUiState copyWith({
    String? lastSeerahFocus,
    bool clearLastSeerahFocus = false,
    String? selectedCharacterTraitId,
    bool clearSelectedCharacterTrait = false,
    Set<String>? savedDailyWisdomEntryIds,
    List<String>? recentDailyWisdomEntryIds,
  }) {
    return CompanionSurfacesUiState(
      lastSeerahFocus: clearLastSeerahFocus
          ? null
          : (lastSeerahFocus ?? this.lastSeerahFocus),
      selectedCharacterTraitId: clearSelectedCharacterTrait
          ? null
          : (selectedCharacterTraitId ?? this.selectedCharacterTraitId),
      savedDailyWisdomEntryIds:
          savedDailyWisdomEntryIds ?? this.savedDailyWisdomEntryIds,
      recentDailyWisdomEntryIds:
          recentDailyWisdomEntryIds ?? this.recentDailyWisdomEntryIds,
    );
  }
}

class CompanionSurfacesUiController
    extends StateNotifier<CompanionSurfacesUiState> {
  CompanionSurfacesUiController(this._store)
    : super(const CompanionSurfacesUiState()) {
    _load();
  }

  final LocalStore _store;

  static const _keySeerahFocus = 'learn.companion.seerah.lastFocus';
  static const _keyCharacterTrait = 'learn.companion.character.selectedTrait';
  static const _keySavedWisdom = 'learn.companion.dailyWisdom.saved';
  static const _keyRecentWisdom = 'learn.companion.dailyWisdom.recent';
  static const _recentWisdomLimit = 6;

  void _load() {
    final savedRaw = _store.getJsonList(_keySavedWisdom) ?? const <dynamic>[];
    final recentRaw = _store.getJsonList(_keyRecentWisdom) ?? const <dynamic>[];

    state = CompanionSurfacesUiState(
      lastSeerahFocus: _readString(_keySeerahFocus),
      selectedCharacterTraitId: _readString(_keyCharacterTrait),
      savedDailyWisdomEntryIds: {
        for (final item in savedRaw)
          if (item is String && item.trim().isNotEmpty) item,
      },
      recentDailyWisdomEntryIds: [
        for (final item in recentRaw)
          if (item is String && item.trim().isNotEmpty) item,
      ],
    );
  }

  String? _readString(String key) {
    final value = _store.getString(key);
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }

  void setSeerahFocus(String? focusId) {
    if (focusId == null || focusId.trim().isEmpty) {
      state = state.copyWith(clearLastSeerahFocus: true);
      _store.remove(_keySeerahFocus);
      return;
    }

    state = state.copyWith(lastSeerahFocus: focusId);
    _store.setString(_keySeerahFocus, focusId);
  }

  void setCharacterTrait(String? traitId) {
    if (traitId == null || traitId.trim().isEmpty) {
      state = state.copyWith(clearSelectedCharacterTrait: true);
      _store.remove(_keyCharacterTrait);
      return;
    }

    state = state.copyWith(selectedCharacterTraitId: traitId);
    _store.setString(_keyCharacterTrait, traitId);
  }

  void toggleSavedDailyWisdom(String entryId) {
    final updated = <String>{...state.savedDailyWisdomEntryIds};
    if (!updated.remove(entryId)) {
      updated.add(entryId);
    }
    state = state.copyWith(savedDailyWisdomEntryIds: updated);
    _store.setJsonList(_keySavedWisdom, updated.toList()..sort());
  }

  bool isDailyWisdomSaved(String entryId) {
    return state.savedDailyWisdomEntryIds.contains(entryId);
  }

  void recordDailyWisdomViewed(String entryId) {
    final updated = [
      entryId,
      for (final existing in state.recentDailyWisdomEntryIds)
        if (existing != entryId) existing,
    ].take(_recentWisdomLimit).toList(growable: false);

    state = state.copyWith(recentDailyWisdomEntryIds: updated);
    _store.setJsonList(_keyRecentWisdom, updated);
  }
}

final companionSurfacesUiControllerProvider =
    StateNotifierProvider<
      CompanionSurfacesUiController,
      CompanionSurfacesUiState
    >((ref) {
      return CompanionSurfacesUiController(ref.watch(localStoreProvider));
    });
