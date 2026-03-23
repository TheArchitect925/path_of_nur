import 'dart:convert';
import 'dart:io';

import '../../../../shared/persistence/local_store.dart';

class QuranWordTimingSegment {
  const QuranWordTimingSegment({
    required this.wordIndex,
    required this.startMs,
    required this.endMs,
  });

  final int wordIndex;
  final int startMs;
  final int endMs;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wordIndex': wordIndex,
    'startMs': startMs,
    'endMs': endMs,
  };

  static QuranWordTimingSegment? fromJson(Object? json) {
    if (json is! Map) return null;
    final wordIndex = (json['wordIndex'] as num?)?.toInt();
    final startMs = (json['startMs'] as num?)?.toInt();
    final endMs = (json['endMs'] as num?)?.toInt();
    if (wordIndex == null || startMs == null || endMs == null) return null;
    return QuranWordTimingSegment(
      wordIndex: wordIndex,
      startMs: startMs,
      endMs: endMs,
    );
  }
}

class QuranWordTimingRepository {
  QuranWordTimingRepository({
    HttpClient? client,
    LocalStore? store,
    Uri Function(int recitationId, int surahNumber, int ayahNumber)?
    endpointBuilder,
  }) : _client = client ?? HttpClient(),
       _store = store,
       _endpointBuilder = endpointBuilder ?? _defaultEndpointBuilder;

  final HttpClient _client;
  final LocalStore? _store;
  final Uri Function(int recitationId, int surahNumber, int ayahNumber)
  _endpointBuilder;
  final Map<String, List<QuranWordTimingSegment>> _cache = {};
  static const _cacheKeyPrefix = 'learn.quran.wordTimingSegments';

  static const Map<String, int> _quranComRecitationByReciterId = {
    'husary': 6,
    'alafasy': 7,
    'abdulbasit': 2,
  };

  Future<List<QuranWordTimingSegment>> getAyahWordTimings({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final key = _memoryCacheKey(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    final cached = _cache[key];
    if (cached != null) return cached;

    final persisted = _readPersistedSegments(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (persisted != null) {
      _cache[key] = persisted;
      return persisted;
    }

    final recitationId = _quranComRecitationByReciterId[reciterId];
    if (recitationId == null) return const [];

    final url = _endpointBuilder(recitationId, surahNumber, ayahNumber);

    try {
      final request = await _client
          .getUrl(url)
          .timeout(const Duration(seconds: 10));
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != HttpStatus.ok) return const [];
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return const [];
      final files = decoded['audio_files'];
      if (files is! List || files.isEmpty) return const [];
      final first = files.first;
      if (first is! Map<String, dynamic>) return const [];
      final rawSegments = first['segments'];
      if (rawSegments is! List) return const [];

      final segments = <QuranWordTimingSegment>[];
      for (final row in rawSegments) {
        if (row is! List || row.length < 4) continue;
        final wordPosition = (row[1] as num?)?.toInt();
        final startMs = (row[2] as num?)?.toInt();
        final endMs = (row[3] as num?)?.toInt();
        if (wordPosition == null || startMs == null || endMs == null) continue;
        segments.add(
          QuranWordTimingSegment(
            wordIndex: wordPosition - 1,
            startMs: startMs,
            endMs: endMs,
          ),
        );
      }
      segments.sort((a, b) => a.startMs.compareTo(b.startMs));
      _cache[key] = segments;
      _persistSegments(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        segments: segments,
      );
      return segments;
    } catch (_) {
      return const [];
    }
  }

  static Uri _defaultEndpointBuilder(
    int recitationId,
    int surahNumber,
    int ayahNumber,
  ) {
    return Uri.parse(
      'https://api.quran.com/api/v4/recitations/$recitationId/by_ayah/$surahNumber:$ayahNumber?fields=segments',
    );
  }

  String _memoryCacheKey({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    return '$reciterId:$surahNumber:$ayahNumber';
  }

  String _persistedCacheKey({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    return '$_cacheKeyPrefix.$reciterId.$surahNumber.$ayahNumber';
  }

  List<QuranWordTimingSegment>? _readPersistedSegments({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    final store = _store;
    if (store == null) return null;
    final rows = store.getJsonList(
      _persistedCacheKey(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      ),
    );
    if (rows == null || rows.isEmpty) return null;
    final segments = rows
        .map(QuranWordTimingSegment.fromJson)
        .whereType<QuranWordTimingSegment>()
        .toList(growable: false);
    return segments.isEmpty ? null : segments;
  }

  void _persistSegments({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
    required List<QuranWordTimingSegment> segments,
  }) {
    final store = _store;
    if (store == null) return;
    store.setJsonList(
      _persistedCacheKey(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      ),
      segments.map((segment) => segment.toJson()).toList(growable: false),
    );
  }
}
