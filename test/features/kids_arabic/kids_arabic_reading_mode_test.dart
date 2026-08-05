import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_parent_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_beginner_words_data.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeKidsArabicAudioService extends KidsArabicAudioService {
  final List<String> spokenTexts = <String>[];

  @override
  Future<void> configure() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> speakText(String text) async {
    spokenTexts.add(text);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpReadingMode(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
    String? initialWordId,
  }) async {
    final container = await makeTestContainer(overrides: overrides);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: KidsArabicReadingModePage(initialWordId: initialWordId),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets(
    'reading mode uses unlocked words and supports tap-to-hear with navigation',
    (tester) async {
      final audio = _FakeKidsArabicAudioService();
      final container = await pumpReadingMode(
        tester,
        overrides: <Override>[
          kidsArabicAudioServiceProvider.overrideWithValue(audio),
        ],
      );
      final letterNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      for (final id in const ['alif', 'ba', 'noon']) {
        letterNotifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }
      container
          .read(kidsArabicParentPreferencesProvider.notifier)
          .setAudioAutoplay(true);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicReadingModePage)),
      );
      final bab = kidsArabicBeginnerWordById('bab')!;
      final noor = kidsArabicBeginnerWordById('noor')!;

      expect(find.text(l10n.kidsArabicReadingModeTitle), findsOneWidget);
      expect(find.text(bab.wordAr), findsOneWidget);
      expect(find.text('baab'), findsOneWidget);
      expect(audio.spokenTexts, contains(bab.wordAr));

      await tester.tap(find.text(bab.wordAr));
      await tester.pump();
      expect(audio.spokenTexts, contains(bab.wordAr));
      expect(find.text(l10n.kidsArabicRepeatAfterMePrompt), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicReadingModeNextAction),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      final nextButton = tester.widget<FilledButton>(
        find.byKey(const Key('kidsArabicReadingModeNextButton')),
      );
      nextButton.onPressed!.call();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text(noor.wordAr), findsOneWidget);
      expect(find.text('noor'), findsOneWidget);

      final previousButton = tester.widget<FilledButton>(
        find.byKey(const Key('kidsArabicReadingModePreviousButton')),
      );
      previousButton.onPressed!.call();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text(bab.wordAr), findsOneWidget);
    },
  );

  testWidgets(
    'reading mode shows a calm locked state before any words unlock',
    (tester) async {
      await pumpReadingMode(tester);

      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicReadingModePage)),
      );

      expect(find.text(l10n.kidsArabicReadingModeTitle), findsOneWidget);
      expect(find.text(l10n.kidsArabicReadingModeLockedTitle), findsOneWidget);
      expect(find.text(l10n.kidsArabicReadingModeLockedBody), findsOneWidget);
    },
  );
}
