import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as q;

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.baseUrl,
  });

  final String id;
  final String name;
  final String arabicName;
  final String baseUrl;
}

class QuranAudioRepository {
  QuranAudioRepository({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;

  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'husary',
      name: 'Mahmoud Khalil Al-Husary',
      arabicName: 'محمود خليل الحصري',
      baseUrl: 'https://everyayah.com/data/Husary_128kbps',
    ),
    QuranReciter(
      id: 'alafasy',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
      baseUrl: 'https://everyayah.com/data/Alafasy_128kbps',
    ),
    QuranReciter(
      id: 'abdulbasit',
      name: 'Abdul Basit Murattal',
      arabicName: 'عبد الباسط عبد الصمد',
      baseUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_192kbps',
    ),
  ];

  QuranReciter reciterById(String id) {
    return reciters.firstWhere(
      (item) => item.id == id,
      orElse: () => reciters.first,
    );
  }

  Uri sampleUri(String reciterId) {
    final reciter = reciterById(reciterId);
    return Uri.parse('${reciter.baseUrl}/001001.mp3');
  }

  Uri verseUri({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    final reciter = reciterById(reciterId);
    final code =
        '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
    return Uri.parse('${reciter.baseUrl}/$code.mp3');
  }

  Future<String?> localAyahPath({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final file = await _audioFile(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    return file.existsSync() ? file.path : null;
  }

  Future<String> resolveAyahSource({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final local = await localAyahPath(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (local != null) return local;
    return verseUri(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    ).toString();
  }

  Future<void> downloadSurah({
    required String reciterId,
    required int surahNumber,
    required void Function(int downloaded, int total) onProgress,
  }) async {
    final total = q.getVerseCount(surahNumber);
    var downloaded = 0;
    onProgress(downloaded, total);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final existing = await localAyahPath(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (existing != null) {
        downloaded += 1;
        onProgress(downloaded, total);
        continue;
      }
      final target = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      await target.parent.create(recursive: true);
      final source = verseUri(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      final request = await _client.getUrl(source);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Failed to download $source (${response.statusCode})',
          uri: source,
        );
      }
      final sink = target.openWrite();
      await response.pipe(sink);
      downloaded += 1;
      onProgress(downloaded, total);
    }
  }

  Future<void> clearSurahDownloads({
    required String reciterId,
    required int surahNumber,
  }) async {
    final total = q.getVerseCount(surahNumber);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final file = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (file.existsSync()) {
        await file.delete();
      }
    }
  }

  Future<bool> isSurahDownloaded({
    required String reciterId,
    required int surahNumber,
  }) async {
    final total = q.getVerseCount(surahNumber);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final file = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (!file.existsSync()) return false;
    }
    return true;
  }

  Future<File> _audioFile({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final base = await getApplicationSupportDirectory();
    final folder = Directory('${base.path}/quran_audio/$reciterId/$surahNumber');
    final name =
        '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}.mp3';
    return File('${folder.path}/$name');
  }
}
