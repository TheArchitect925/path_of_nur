import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';

enum JournalEntryType { reflection, gratitude, observation, learning, memory }

enum JournalFilter {
  all,
  favorites,
  reflection,
  gratitude,
  observation,
  learning,
  memory,
}

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAtIso,
    required this.favorite,
    required this.tags,
    this.linkedTopic,
    this.linkedQuranRef,
    this.linkedHadithRef,
    this.photoPath,
  });

  final String id;
  final String title;
  final String body;
  final JournalEntryType type;
  final String createdAtIso;
  final bool favorite;
  final List<String> tags;
  final String? linkedTopic;
  final String? linkedQuranRef;
  final String? linkedHadithRef;
  final String? photoPath;

  JournalEntry copyWith({
    String? title,
    String? body,
    JournalEntryType? type,
    bool? favorite,
    List<String>? tags,
    String? linkedTopic,
    String? linkedQuranRef,
    String? linkedHadithRef,
    String? photoPath,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAtIso: createdAtIso,
      favorite: favorite ?? this.favorite,
      tags: tags ?? this.tags,
      linkedTopic: linkedTopic ?? this.linkedTopic,
      linkedQuranRef: linkedQuranRef ?? this.linkedQuranRef,
      linkedHadithRef: linkedHadithRef ?? this.linkedHadithRef,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'createdAtIso': createdAtIso,
        'favorite': favorite,
        'tags': tags,
        'linkedTopic': linkedTopic,
        'linkedQuranRef': linkedQuranRef,
        'linkedHadithRef': linkedHadithRef,
        'photoPath': photoPath,
      };

  static JournalEntry? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final title = raw['title']?.toString() ?? '';
    final body = raw['body']?.toString();
    final typeName = raw['type']?.toString();
    final createdAtIso = raw['createdAtIso']?.toString();
    if (id == null || body == null || typeName == null || createdAtIso == null) {
      return null;
    }

    JournalEntryType? type;
    for (final item in JournalEntryType.values) {
      if (item.name == typeName) {
        type = item;
        break;
      }
    }
    if (type == null) return null;

    final tags = <String>[];
    final rawTags = raw['tags'];
    if (rawTags is List) {
      for (final row in rawTags) {
        tags.add(row.toString());
      }
    }

    return JournalEntry(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAtIso: createdAtIso,
      favorite: raw['favorite'] == true,
      tags: tags,
      linkedTopic: raw['linkedTopic']?.toString(),
      linkedQuranRef: raw['linkedQuranRef']?.toString(),
      linkedHadithRef: raw['linkedHadithRef']?.toString(),
      photoPath: raw['photoPath']?.toString(),
    );
  }
}

class JournalState {
  const JournalState({
    required this.entries,
    required this.selectedFilter,
    required this.searchQuery,
    required this.searchHistory,
  });

  final List<JournalEntry> entries;
  final JournalFilter selectedFilter;
  final String searchQuery;
  final List<String> searchHistory;

  JournalState copyWith({
    List<JournalEntry>? entries,
    JournalFilter? selectedFilter,
    String? searchQuery,
    List<String>? searchHistory,
  }) {
    return JournalState(
      entries: entries ?? this.entries,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'entries': entries.map((e) => e.toJson()).toList(),
        'selectedFilter': selectedFilter.name,
        'searchQuery': searchQuery,
        'searchHistory': searchHistory,
      };

  static JournalState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const JournalState(
        entries: [],
        selectedFilter: JournalFilter.all,
        searchQuery: '',
        searchHistory: [],
      );
    }

    final items = <JournalEntry>[];
    final raw = json['entries'];
    if (raw is List) {
      for (final row in raw) {
        final entry = JournalEntry.fromJson(row);
        if (entry != null) items.add(entry);
      }
    }

    var filter = JournalFilter.all;
    final filterName = json['selectedFilter']?.toString();
    if (filterName != null) {
      for (final item in JournalFilter.values) {
        if (item.name == filterName) {
          filter = item;
          break;
        }
      }
    }

    final history = <String>[];
    final rawHistory = json['searchHistory'];
    if (rawHistory is List) {
      for (final row in rawHistory) {
        final value = row.toString().trim();
        if (value.isNotEmpty) history.add(value);
      }
    }

    return JournalState(
      entries: items,
      selectedFilter: filter,
      searchQuery: json['searchQuery']?.toString() ?? '',
      searchHistory: history,
    );
  }
}

class JournalNotifier extends StateNotifier<JournalState> {
  JournalNotifier(this._store)
      : super(JournalState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'journal.entries';
  final LocalStore _store;

  void addEntry({
    required String title,
    required String body,
    required JournalEntryType type,
    String? linkedTopic,
    String? linkedQuranRef,
    String? linkedHadithRef,
    String? photoPath,
    List<String> tags = const [],
  }) {
    final cleanBody = body.trim();
    if (cleanBody.isEmpty) return;

    final entry = JournalEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      body: cleanBody,
      type: type,
      createdAtIso: DateTime.now().toIso8601String(),
      favorite: false,
      tags: tags.where((item) => item.trim().isNotEmpty).map((e) => e.trim()).toList(),
      linkedTopic: linkedTopic,
      linkedQuranRef: linkedQuranRef,
      linkedHadithRef: linkedHadithRef,
      photoPath: photoPath,
    );

    state = state.copyWith(entries: [entry, ...state.entries]);
    _save();
  }

  void toggleFavorite(String entryId) {
    final next = state.entries
        .map((item) => item.id == entryId ? item.copyWith(favorite: !item.favorite) : item)
        .toList();
    state = state.copyWith(entries: next);
    _save();
  }

  void setFilter(JournalFilter filter) {
    state = state.copyWith(selectedFilter: filter);
    _save();
  }

  void setSearchQuery(String query) {
    final trimmed = query.trim();
    final history = List<String>.from(state.searchHistory);
    if (trimmed.isNotEmpty) {
      history.remove(trimmed);
      history.insert(0, trimmed);
      if (history.length > 10) {
        history.removeRange(10, history.length);
      }
    }
    state = state.copyWith(searchQuery: query, searchHistory: history);
    _save();
  }

  void clearSearchHistory() {
    state = state.copyWith(searchHistory: []);
    _save();
  }

  JournalEntry? memoryFromLastYear() {
    final now = DateTime.now();
    for (final entry in state.entries) {
      final date = DateTime.tryParse(entry.createdAtIso);
      if (date == null) continue;
      if (date.month == now.month && date.day == now.day && date.year <= now.year - 1) {
        return entry;
      }
    }
    return null;
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, JournalState>(
  (ref) => JournalNotifier(ref.watch(localStoreProvider)),
);

final journalFilteredEntriesProvider = Provider<List<JournalEntry>>((ref) {
  final state = ref.watch(journalProvider);
  final query = state.searchQuery.trim().toLowerCase();

  bool matchesFilter(JournalEntry entry) {
    switch (state.selectedFilter) {
      case JournalFilter.all:
        return true;
      case JournalFilter.favorites:
        return entry.favorite;
      case JournalFilter.reflection:
        return entry.type == JournalEntryType.reflection;
      case JournalFilter.gratitude:
        return entry.type == JournalEntryType.gratitude;
      case JournalFilter.observation:
        return entry.type == JournalEntryType.observation;
      case JournalFilter.learning:
        return entry.type == JournalEntryType.learning;
      case JournalFilter.memory:
        return entry.type == JournalEntryType.memory;
    }
  }

  bool matchesQuery(JournalEntry entry) {
    if (query.isEmpty) return true;
    final haystack = [
      entry.title,
      entry.body,
      entry.linkedTopic ?? '',
      entry.linkedQuranRef ?? '',
      entry.linkedHadithRef ?? '',
      ...entry.tags,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  return state.entries.where((entry) => matchesFilter(entry) && matchesQuery(entry)).toList();
});

final journalTimelineGroupedProvider = Provider<Map<String, List<JournalEntry>>>((ref) {
  final items = ref.watch(journalFilteredEntriesProvider);
  final out = <String, List<JournalEntry>>{};
  for (final entry in items) {
    final date = DateTime.tryParse(entry.createdAtIso) ?? DateTime.now();
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    out.putIfAbsent(key, () => []).add(entry);
  }
  return out;
});

final journalMemoryPreviewProvider = Provider<JournalEntry?>((ref) {
  final entries = ref.watch(journalProvider).entries;
  final now = DateTime.now();
  for (final entry in entries) {
    final date = DateTime.tryParse(entry.createdAtIso);
    if (date == null) continue;
    if (date.month == now.month && date.day == now.day && date.year <= now.year - 1) {
      return entry;
    }
  }
  return null;
});

final journalRecentMemoryListProvider = Provider<List<JournalEntry>>((ref) {
  final entries = ref.watch(journalProvider).entries;
  final now = DateTime.now();
  return entries.where((entry) {
    final date = DateTime.tryParse(entry.createdAtIso);
    if (date == null) return false;
    return date.month == now.month && date.year <= now.year - 1;
  }).take(5).toList();
});
