import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_focus_recitation_mode.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_focus_recitation_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeFocusRecitationController extends QuranPlayerController {
  _FakeFocusRecitationController(super.ref, super.player);

  bool paused = false;
  bool resumed = false;
  final List<int> relativeAyahOffsets = <int>[];
  final List<bool> repeatCurrentAyahStates = <bool>[];

  @override
  Future<void> pause() async {
    paused = true;
  }

  @override
  Future<bool> resumeCurrentPlayback() async {
    resumed = true;
    return true;
  }

  @override
  Future<bool> playRelativeAyah(int offset) async {
    relativeAyahOffsets.add(offset);
    return true;
  }

  @override
  Future<void> setRepeatCurrentAyahEnabled(bool enabled) async {
    repeatCurrentAyahStates.add(enabled);
  }
}

class _FakeFocusWakeLock implements QuranFocusRecitationWakeLock {
  final List<bool> enabledStates = <bool>[];

  @override
  Future<void> setEnabled(bool enabled) async {
    enabledStates.add(enabled);
  }
}

void main() {
  const ayahs = <QuranAyah>[
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 1,
      arabic: 'بِسْمِ اللَّهِ',
      translation: 'In the name of Allah',
      transliteration: 'Bismillah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic: 'الْحَمْدُ لِلَّهِ',
      translation: 'All praise is for Allah',
      transliteration: 'Alhamdu lillah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 3,
      arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'The Most Merciful, the Especially Merciful',
      transliteration: 'Ar-Rahman ir-Raheem',
    ),
  ];

  const longAyahs = <QuranAyah>[
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic:
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ '
          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      translation:
          'All praise is for Allah, Lord of all worlds, the Entirely Merciful, the Especially Merciful, '
          'Master of the Day of Judgment. You alone we worship and You alone we ask for help. '
          'Guide us to the straight path.',
      transliteration:
          'Alhamdu lillahi rabbil alamin. Ar-Rahman ir-Raheem. Maliki yawm id-deen. '
          'Iyyaka nabudu wa iyyaka nastaeen. Ihdinas-siratal-mustaqeem.',
    ),
  ];

  Future<void> pumpFocusPage(
    WidgetTester tester, {
    required SharedPreferences prefs,
    required ProviderBase<QuranReaderPlaybackState> playbackOverride,
    _FakeFocusRecitationController? controller,
    _FakeFocusWakeLock? wakeLock,
    List<QuranAyah> overrideAyahs = ayahs,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          quranGlobalPlaybackStateProvider.overrideWith((ref) {
            return ref.watch(playbackOverride);
          }),
          quranPlayerControllerProvider.overrideWith(
            (ref) =>
                controller ??
                _FakeFocusRecitationController(ref, AudioPlayer()),
          ),
          quranFocusRecitationWakeLockProvider.overrideWithValue(
            wakeLock ?? _FakeFocusWakeLock(),
          ),
          quranSurahAyahsProvider(1).overrideWith((ref) async => overrideAyahs),
        ],
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: QuranFocusRecitationPage(
            initialSurahNumber: 1,
            initialAyahNumber: 2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'focus recitation mode shows the current ayah and reacts to playback updates',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final playbackStateProvider = StateProvider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
          canGoPreviousAyah: true,
          canGoNextAyah: true,
        ),
      );
      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
      );

      expect(
        find.byKey(const ValueKey('quran-focus-recitation-page')),
        findsOneWidget,
      );
      expect(find.text('الْحَمْدُ لِلَّهِ'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsOneWidget,
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      container
          .read(playbackStateProvider.notifier)
          .state = const QuranReaderPlaybackState(
        pageSurahNumber: 1,
        reciterId: 'husary',
        reciterName: 'Husary',
        activeSurahNumber: 1,
        activeAyahKey: '1:3',
        activeAyahNumber: 3,
        hasPlayback: true,
        isPlaying: true,
        status: QuranReaderPlaybackStatus.playing,
        canPause: true,
        canPlay: false,
        canGoPreviousAyah: true,
        canGoNextAyah: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);
    },
  );

  testWidgets(
    'focus recitation mode toggles translation and transliteration combinations and persists them',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
        ),
      );

      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
      );

      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('quran-focus-settings')));
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationShowTranslation(false);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsOneWidget,
      );

      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationShowTransliteration(false);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsNothing,
      );

      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationShowTranslation(true);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsNothing,
      );

      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationShowTransliteration(true);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsOneWidget,
      );

      Navigator.of(tester.element(find.byType(SwitchListTile).first)).pop();
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await prefs.setBool('learn.quran.focusRecitationShowTranslation', false);
      await prefs.setBool(
        'learn.quran.focusRecitationShowTransliteration',
        false,
      );

      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
      );

      expect(
        find.byKey(const ValueKey('quran-focus-translation')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('quran-focus-transliteration')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'focus recitation mode dispatches previous next and pause through the canonical controller',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final controllerProvider = Provider<_FakeFocusRecitationController>((
        ref,
      ) {
        return _FakeFocusRecitationController(ref, AudioPlayer());
      });
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
          canGoPreviousAyah: true,
          canGoNextAyah: true,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            quranGlobalPlaybackStateProvider.overrideWith((ref) {
              return ref.watch(playbackStateProvider);
            }),
            quranPlayerControllerProvider.overrideWith(
              (ref) => ref.watch(controllerProvider),
            ),
            quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
          ],
          child: const MaterialApp(
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: QuranFocusRecitationPage(
              initialSurahNumber: 1,
              initialAyahNumber: 2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      final controller = container.read(controllerProvider);

      await tester.tap(find.byKey(const ValueKey('quran-focus-previous-ayah')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('quran-focus-next-ayah')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('quran-focus-play-pause')));
      await tester.pump();

      expect(controller.relativeAyahOffsets, <int>[-1, 1]);
      expect(controller.paused, isTrue);
    },
  );

  testWidgets(
    'focus recitation mode applies repeat current ayah through the canonical controller and clears on exit',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final controllerProvider = Provider<_FakeFocusRecitationController>((
        ref,
      ) {
        return _FakeFocusRecitationController(ref, AudioPlayer());
      });
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            quranGlobalPlaybackStateProvider.overrideWith((ref) {
              return ref.watch(playbackStateProvider);
            }),
            quranPlayerControllerProvider.overrideWith(
              (ref) => ref.watch(controllerProvider),
            ),
            quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
          ],
          child: const MaterialApp(
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: QuranFocusRecitationPage(
              initialSurahNumber: 1,
              initialAyahNumber: 2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      final controller = container.read(controllerProvider);

      await tester.tap(find.byKey(const ValueKey('quran-focus-settings')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('quran-focus-toggle-repeat-current-ayah')),
      );
      await tester.pumpAndSettle();

      expect(controller.repeatCurrentAyahStates, contains(true));
      expect(
        find.byKey(const ValueKey('quran-focus-repeat-chip')),
        findsOneWidget,
      );
      expect(find.text('الْحَمْدُ لِلَّهِ'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('quran-focus-exit')));
      await tester.pumpAndSettle();

      expect(controller.repeatCurrentAyahStates.last, isFalse);
    },
  );

  testWidgets(
    'focus recitation sleep timer pauses playback and can be cancelled',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final controllerProvider = Provider<_FakeFocusRecitationController>((
        ref,
      ) {
        return _FakeFocusRecitationController(ref, AudioPlayer());
      });
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            quranGlobalPlaybackStateProvider.overrideWith((ref) {
              return ref.watch(playbackStateProvider);
            }),
            quranPlayerControllerProvider.overrideWith(
              (ref) => ref.watch(controllerProvider),
            ),
            quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
          ],
          child: const MaterialApp(
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: QuranFocusRecitationPage(
              initialSurahNumber: 1,
              initialAyahNumber: 2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      final controller = container.read(controllerProvider);
      container
          .read(quranFocusRecitationSleepTimerProvider.notifier)
          .setDuration(const Duration(seconds: 2));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('quran-focus-sleep-timer-chip')),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 1));
      expect(controller.paused, isFalse);

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(controller.paused, isTrue);
      expect(
        container.read(quranFocusRecitationSleepTimerProvider).isActive,
        isFalse,
      );

      controller.paused = false;
      container
          .read(quranFocusRecitationSleepTimerProvider.notifier)
          .setDuration(const Duration(seconds: 5));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('quran-focus-settings')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('quran-focus-cancel-sleep-timer')),
      );
      await tester.pumpAndSettle();

      expect(
        container.read(quranFocusRecitationSleepTimerProvider).isActive,
        isFalse,
      );
      expect(controller.paused, isFalse);
    },
  );

  testWidgets(
    'focus recitation keep screen awake toggle is applied and persisted in focus mode',
    (tester) async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final wakeLock = _FakeFocusWakeLock();
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
        ),
      );

      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
        wakeLock: wakeLock,
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranFocusRecitationPage)),
      );
      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationKeepScreenAwake(true);
      await tester.pump();
      expect(wakeLock.enabledStates, contains(true));

      container
          .read(quranReaderSettingsProvider.notifier)
          .setFocusRecitationKeepScreenAwake(false);
      await tester.pump();
      expect(wakeLock.enabledStates.last, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await prefs.setBool('learn.quran.focusRecitationKeepScreenAwake', true);
      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
        wakeLock: wakeLock,
      );

      expect(
        ProviderScope.containerOf(
          tester.element(find.byType(QuranFocusRecitationPage)),
        ).read(quranReaderSettingsProvider).focusRecitationKeepScreenAwake,
        isTrue,
      );
    },
  );

  testWidgets(
    'focus recitation layout stays stable for long ayahs on smaller screens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final playbackStateProvider = Provider<QuranReaderPlaybackState>(
        (ref) => const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          activeSurahNumber: 1,
          activeAyahKey: '1:2',
          activeAyahNumber: 2,
          hasPlayback: true,
          isPlaying: true,
          status: QuranReaderPlaybackStatus.playing,
          canPause: true,
          canPlay: false,
        ),
      );

      await pumpFocusPage(
        tester,
        prefs: prefs,
        playbackOverride: playbackStateProvider,
        overrideAyahs: longAyahs,
      );

      expect(
        find.byKey(const ValueKey('quran-focus-recitation-scroll')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
