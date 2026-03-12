import 'dart:convert';
import 'dart:io';

class QuranWordTimingSegment {
  const QuranWordTimingSegment({
    required this.wordIndex,
    required this.startMs,
    required this.endMs,
  });

  final int wordIndex;
  final int startMs;
  final int endMs;
}

class QuranWordTimingRepository {
  QuranWordTimingRepository({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;
  final Map<String, List<QuranWordTimingSegment>> _cache = {};

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
    final key = '$reciterId:$surahNumber:$ayahNumber';
    final cached = _cache[key];
    if (cached != null) return cached;

    final recitationId = _quranComRecitationByReciterId[reciterId];
    if (recitationId == null) return const [];

    final url = Uri.parse(
      'https://api.quran.com/api/v4/recitations/$recitationId/by_ayah/$surahNumber:$ayahNumber?fields=segments',
    );

    try {
      final request = await _client.getUrl(url).timeout(const Duration(seconds: 10));
      final response = await request.close().timeout(const Duration(seconds: 10));
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
      return segments;
    } catch (_) {
      return const [];
    }
  }
}
