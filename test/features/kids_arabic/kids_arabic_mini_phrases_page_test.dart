import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_mini_phrases_data.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_mini_phrases_page.dart';
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

  Future<ProviderContainer> pumpMiniPhrases(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
    String? initialPhraseId,
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
            body: KidsArabicMiniPhrasesPage(initialPhraseId: initialPhraseId),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets(
    'mini phrases page renders phrase meaning and tap-to-hear audio',
    (tester) async {
      final audio = _FakeKidsArabicAudioService();
      await pumpMiniPhrases(
        tester,
        overrides: <Override>[
          kidsArabicAudioServiceProvider.overrideWithValue(audio),
        ],
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicMiniPhrasesPage)),
      );
      final bismillah = kidsArabicMiniPhraseById('bismillah')!;

      expect(find.text(l10n.kidsArabicMiniPhrasesTitle), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(bismillah.phraseAr),
        400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      expect(find.text(bismillah.phraseAr), findsOneWidget);
      expect(find.text('bismillah'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicMiniPhraseBismillahMeaning),
        400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      expect(
        find.text(l10n.kidsArabicMiniPhraseBismillahMeaning),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text(bismillah.phraseAr),
        -400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      await tester.tap(find.text(bismillah.phraseAr));
      await tester.pump();

      expect(audio.spokenTexts, contains(bismillah.phraseAr));
      expect(find.text(l10n.kidsArabicRepeatAfterMePrompt), findsOneWidget);
    },
  );

  testWidgets(
    'mini phrases page moves between phrases with next and previous buttons',
    (tester) async {
      await pumpMiniPhrases(tester);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicMiniPhrasesPage)),
      );
      final bismillah = kidsArabicMiniPhraseById('bismillah')!;
      final alhamdulillah = kidsArabicMiniPhraseById('alhamdulillah')!;

      await tester.scrollUntilVisible(
        find.text(bismillah.phraseAr),
        400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      expect(find.text(bismillah.phraseAr), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicMiniPhrasesNextAction),
        300,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      await tester.tap(find.text(l10n.kidsArabicMiniPhrasesNextAction));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text(alhamdulillah.phraseAr), findsWidgets);
      expect(find.text('alhamdulillah'), findsOneWidget);

      await tester.tap(find.text(l10n.kidsArabicMiniPhrasesPreviousAction));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text(bismillah.phraseAr), findsWidgets);
    },
  );
}
