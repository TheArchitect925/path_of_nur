import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_playback_presentation.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  testWidgets('builds localized now-playing label from semantic playback state', (
    tester,
  ) async {
    late String? label;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            label = buildQuranReaderNowPlayingLabel(
              l10n: AppLocalizations.of(context),
              playbackState: const QuranReaderPlaybackState(
                pageSurahNumber: 1,
                reciterId: 'husary',
                reciterName: 'Mahmoud Khalil Al-Husary',
                activeSurahNumber: 1,
                activeAyahKey: '1:2',
                activeAyahNumber: 2,
              ),
              surahMap: <int, dynamic>{
                1: _FakeSurah(arabicName: 'الفاتحة'),
              },
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(label, 'Recitation الفاتحة • Verse 1:2');
  });
}

class _FakeSurah {
  const _FakeSurah({required this.arabicName});

  final String arabicName;
}
