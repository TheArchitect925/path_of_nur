import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as q;

class QuranTransliterationRepository {
  QuranTransliterationRepository({HttpClient? client})
    : _client = client ?? HttpClient();

  final HttpClient _client;
  final Map<int, List<String>> _memoryCache = {};

  // Trusted source: AlQuran.cloud (edition: en.transliteration)
  static const String _baseUrl = 'https://api.alquran.cloud/v1/surah';
  static const String _edition = 'en.transliteration';

  Future<List<String>> getSurahTransliteration(int surahNumber) async {
    final expectedCount = q.getVerseCount(surahNumber);
    final memory = _memoryCache[surahNumber];
    if (memory != null && memory.length == expectedCount) {
      return memory;
    }

    final fromDisk = await _readFromDisk(surahNumber);
    if (fromDisk != null && fromDisk.length == expectedCount) {
      _memoryCache[surahNumber] = fromDisk;
      return fromDisk;
    }

    try {
      final fetched = await _fetchFromApi(surahNumber);
      final normalized = _normalizeLength(fetched, expectedCount);
      _memoryCache[surahNumber] = normalized;
      await _writeToDisk(surahNumber, normalized);
      return normalized;
    } catch (_) {
      // Fall back to stale disk cache if available.
      if (fromDisk != null && fromDisk.isNotEmpty) {
        final normalized = _normalizeLength(fromDisk, expectedCount);
        _memoryCache[surahNumber] = normalized;
        return normalized;
      }
      return List<String>.filled(expectedCount, '', growable: false);
    }
  }

  Future<List<String>> _fetchFromApi(int surahNumber) async {
    final url = Uri.parse('$_baseUrl/$surahNumber/$_edition');
    final request = await _client.getUrl(url).timeout(const Duration(seconds: 12));
    final response = await request.close().timeout(const Duration(seconds: 12));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Transliteration request failed (${response.statusCode})',
        uri: url,
      );
    }
    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected transliteration payload');
    }
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Missing transliteration data');
    }
    final ayahs = data['ayahs'];
    if (ayahs is! List) {
      throw const FormatException('Missing transliteration ayahs');
    }
    return ayahs
        .map((row) {
          if (row is! Map<String, dynamic>) return '';
          return (row['text']?.toString() ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
        })
        .toList(growable: false);
  }

  Future<List<String>?> _readFromDisk(int surahNumber) async {
    final file = await _cacheFile(surahNumber);
    if (!file.existsSync()) return null;
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.map((e) => e.toString()).toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeToDisk(int surahNumber, List<String> rows) async {
    final file = await _cacheFile(surahNumber);
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(rows));
  }

  Future<File> _cacheFile(int surahNumber) async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/quran_transliteration');
    return File('${dir.path}/surah_$surahNumber.json');
  }

  List<String> _normalizeLength(List<String> rows, int expectedCount) {
    if (rows.length == expectedCount) return rows;
    if (rows.length > expectedCount) {
      return rows.take(expectedCount).toList(growable: false);
    }
    return [
      ...rows,
      ...List<String>.filled(expectedCount - rows.length, ''),
    ];
  }
}
