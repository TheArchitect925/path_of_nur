import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophets_tab.dart';

enum ProphetFilterScope { all, featured }

class ProphetsUiState {
  const ProphetsUiState({
    this.selectedTab = ProphetsTab.stories,
    this.searchQuery = '',
    this.filterScope = ProphetFilterScope.all,
    this.eraFilter,
    this.regionFilter,
    this.bookmarkedIds = const <String>{},
    this.lastOpenedProphetId,
  });

  final ProphetsTab selectedTab;
  final String searchQuery;
  final ProphetFilterScope filterScope;
  final ProphetEraGroup? eraFilter;
  final String? regionFilter;
  final Set<String> bookmarkedIds;
  final String? lastOpenedProphetId;

  ProphetsUiState copyWith({
    ProphetsTab? selectedTab,
    String? searchQuery,
    ProphetFilterScope? filterScope,
    ProphetEraGroup? eraFilter,
    bool clearEraFilter = false,
    String? regionFilter,
    bool clearRegionFilter = false,
    Set<String>? bookmarkedIds,
    String? lastOpenedProphetId,
    bool clearLastOpenedProphet = false,
  }) {
    return ProphetsUiState(
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      filterScope: filterScope ?? this.filterScope,
      eraFilter: clearEraFilter ? null : (eraFilter ?? this.eraFilter),
      regionFilter: clearRegionFilter
          ? null
          : (regionFilter ?? this.regionFilter),
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      lastOpenedProphetId: clearLastOpenedProphet
          ? null
          : (lastOpenedProphetId ?? this.lastOpenedProphetId),
    );
  }
}

class ProphetsUiController extends StateNotifier<ProphetsUiState> {
  ProphetsUiController(this._store) : super(const ProphetsUiState()) {
    _load();
  }

  final LocalStore _store;

  static const _keyTab = 'learn.prophets.selectedTab';
  static const _keyQuery = 'learn.prophets.searchQuery';
  static const _keyScope = 'learn.prophets.filterScope';
  static const _keyEra = 'learn.prophets.filterEra';
  static const _keyRegion = 'learn.prophets.filterRegion';
  static const _keyBookmarks = 'learn.prophets.bookmarks';
  static const _keyLastOpened = 'learn.prophets.lastOpened';

  void _load() {
    final tabName = _store.getString(_keyTab);
    final query = _store.getString(_keyQuery) ?? '';
    final scopeName = _store.getString(_keyScope);
    final eraName = _store.getString(_keyEra);
    final region = _store.getString(_keyRegion);
    final bookmarksRaw = _store.getJsonList(_keyBookmarks) ?? const [];
    final bookmarks = <String>{
      for (final item in bookmarksRaw)
        if (item is String && item.trim().isNotEmpty) item,
    };
    final lastOpened = _store.getString(_keyLastOpened);

    state = ProphetsUiState(
      selectedTab: _tabFromName(tabName),
      searchQuery: query,
      filterScope: _scopeFromName(scopeName),
      eraFilter: _eraFromName(eraName),
      regionFilter: (region == null || region.isEmpty) ? null : region,
      bookmarkedIds: bookmarks,
      lastOpenedProphetId: (lastOpened == null || lastOpened.isEmpty)
          ? null
          : lastOpened,
    );
  }

  void setSelectedTab(ProphetsTab tab) {
    state = state.copyWith(selectedTab: tab);
    _store.setString(_keyTab, tab.name);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _store.setString(_keyQuery, query);
  }

  void setFilterScope(ProphetFilterScope scope) {
    state = state.copyWith(filterScope: scope);
    _store.setString(_keyScope, scope.name);
  }

  void setEraFilter(ProphetEraGroup? era) {
    if (era == null) {
      state = state.copyWith(clearEraFilter: true);
      _store.remove(_keyEra);
      return;
    }
    state = state.copyWith(eraFilter: era);
    _store.setString(_keyEra, era.name);
  }

  void setRegionFilter(String? region) {
    if (region == null || region.isEmpty) {
      state = state.copyWith(clearRegionFilter: true);
      _store.remove(_keyRegion);
      return;
    }
    state = state.copyWith(regionFilter: region);
    _store.setString(_keyRegion, region);
  }

  void clearFilters() {
    state = state.copyWith(
      filterScope: ProphetFilterScope.all,
      clearEraFilter: true,
      clearRegionFilter: true,
    );
    _store.setString(_keyScope, ProphetFilterScope.all.name);
    _store.remove(_keyEra);
    _store.remove(_keyRegion);
  }

  void toggleBookmark(String prophetId) {
    final updated = <String>{...state.bookmarkedIds};
    if (!updated.remove(prophetId)) {
      updated.add(prophetId);
    }
    state = state.copyWith(bookmarkedIds: updated);
    _store.setJsonList(_keyBookmarks, updated.toList()..sort());
  }

  bool isBookmarked(String prophetId) {
    return state.bookmarkedIds.contains(prophetId);
  }

  void setLastOpened(String prophetId) {
    state = state.copyWith(lastOpenedProphetId: prophetId);
    _store.setString(_keyLastOpened, prophetId);
  }

  ProphetsTab _tabFromName(String? name) {
    if (name == null) return ProphetsTab.stories;
    for (final tab in ProphetsTab.values) {
      if (tab.name == name) return tab;
    }
    return ProphetsTab.stories;
  }

  ProphetFilterScope _scopeFromName(String? name) {
    if (name == null) return ProphetFilterScope.all;
    for (final scope in ProphetFilterScope.values) {
      if (scope.name == name) return scope;
    }
    return ProphetFilterScope.all;
  }

  ProphetEraGroup? _eraFromName(String? name) {
    if (name == null) return null;
    for (final era in ProphetEraGroup.values) {
      if (era.name == name) return era;
    }
    return null;
  }
}

final prophetsUiControllerProvider =
    StateNotifierProvider<ProphetsUiController, ProphetsUiState>((ref) {
      return ProphetsUiController(ref.watch(localStoreProvider));
    });
