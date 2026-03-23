import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<LocalStore> makeStore() async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return LocalStore(prefs);
  }

  Future<HttpServer> startServer(void Function() onRequest) {
    return HttpServer.bind(InternetAddress.loopbackIPv4, 0)..then((server) {
      server.listen((request) async {
        onRequest();
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'audio_files': <Object>[
              <String, Object>{
                'segments': <Object>[
                  <Object>[0, 1, 0, 120],
                  <Object>[0, 2, 121, 280],
                ],
              },
            ],
          }),
        );
        await request.response.close();
      });
    });
  }

  test(
    'persists fetched timing metadata and reuses it across repository instances',
    () async {
      final store = await makeStore();
      var requestCount = 0;
      final server = await startServer(() => requestCount += 1);
      addTearDown(server.close);

      Uri endpointBuilder(int recitationId, int surahNumber, int ayahNumber) =>
          Uri.parse('http://${server.address.host}:${server.port}/segments');

      final firstRepository = QuranWordTimingRepository(
        client: HttpClient(),
        store: store,
        endpointBuilder: endpointBuilder,
      );
      final firstFetch = await firstRepository.getAyahWordTimings(
        reciterId: 'husary',
        surahNumber: 1,
        ayahNumber: 2,
      );

      expect(firstFetch, hasLength(2));
      expect(requestCount, 1);

      final secondRepository = QuranWordTimingRepository(
        client: HttpClient(),
        store: store,
        endpointBuilder: endpointBuilder,
      );
      final secondFetch = await secondRepository.getAyahWordTimings(
        reciterId: 'husary',
        surahNumber: 1,
        ayahNumber: 2,
      );

      expect(secondFetch, hasLength(2));
      expect(secondFetch.first.wordIndex, 0);
      expect(requestCount, 1);
    },
  );

  test(
    'returns persisted timing cache when network is unavailable later',
    () async {
      final store = await makeStore();
      var requestCount = 0;
      final server = await startServer(() => requestCount += 1);

      Uri endpointBuilder(int recitationId, int surahNumber, int ayahNumber) =>
          Uri.parse('http://${server.address.host}:${server.port}/segments');

      final onlineRepository = QuranWordTimingRepository(
        client: HttpClient(),
        store: store,
        endpointBuilder: endpointBuilder,
      );
      await onlineRepository.getAyahWordTimings(
        reciterId: 'husary',
        surahNumber: 1,
        ayahNumber: 5,
      );
      expect(requestCount, 1);

      await server.close(force: true);

      final offlineRepository = QuranWordTimingRepository(
        client: HttpClient(),
        store: store,
        endpointBuilder: endpointBuilder,
      );
      final cachedFetch = await offlineRepository.getAyahWordTimings(
        reciterId: 'husary',
        surahNumber: 1,
        ayahNumber: 5,
      );

      expect(cachedFetch, hasLength(2));
      expect(cachedFetch.last.endMs, 280);
      expect(requestCount, 1);
    },
  );
}
