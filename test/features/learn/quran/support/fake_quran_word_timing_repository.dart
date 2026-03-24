import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';

class FakeQuranWordTimingRepository extends QuranWordTimingRepository {
  FakeQuranWordTimingRepository({
    Map<String, List<QuranWordTimingSegment>> timings = const <String, List<QuranWordTimingSegment>>{},
  }) : _timings = Map<String, List<QuranWordTimingSegment>>.from(timings),
       super();

  final Map<String, List<QuranWordTimingSegment>> _timings;
  final List<String> requests = <String>[];

  @override
  Future<List<QuranWordTimingSegment>> getAyahWordTimings({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final key = '$reciterId:$surahNumber:$ayahNumber';
    requests.add(key);
    return _timings[key] ?? const <QuranWordTimingSegment>[];
  }
}
