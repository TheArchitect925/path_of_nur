import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_review_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeKidsArabicAudioService extends KidsArabicAudioService {
  final List<String> spoken = <String>[];

  @override
  Future<void> configure() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> speakLetter(dynamic letter) async {
    spoken.add((letter as KidsArabicLetter).id);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(ProviderContainer, _FakeKidsArabicAudioService)> pumpReview(
    WidgetTester tester, {
    List<String> completedLetterIds = const <String>[],
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final audio = _FakeKidsArabicAudioService();
    final container = await makeTestContainer(
      overrides: [kidsArabicAudioServiceProvider.overrideWithValue(audio)],
    );
    addTearDown(container.dispose);
    for (final id in completedLetterIds) {
      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: kidsArabicLetters.firstWhere((item) => item.id == id),
            traceResult: KidsArabicTraceResult.good,
          );
    }
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
          home: const Scaffold(body: KidsArabicReviewPage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    return (container, audio);
  }

  testWidgets(
    'with fewer than two letters the review invites the next lesson',
    (tester) async {
      final (_, audio) = await pumpReview(tester, completedLetterIds: ['alif']);

      expect(find.text('Learn one more letter first'), findsOneWidget);
      expect(find.text('Open Ba'), findsOneWidget);
      expect(find.text('Question 1 of 5'), findsNothing);
      expect(audio.spoken, isEmpty);
    },
  );

  testWidgets('hear it, tap it speaks the letter and takes a tapped glyph', (
    tester,
  ) async {
    final (container, audio) = await pumpReview(
      tester,
      completedLetterIds: ['alif', 'ba', 'meem'],
    );

    // The first question is Alif, spoken as the card opens (autoplay).
    expect(find.text('Which letter did you hear?'), findsOneWidget);
    expect(audio.spoken, ['alif']);
    expect(find.text('aa'), findsNothing, reason: 'no transliteration to read');

    await tester.tap(find.text('ب'));
    await tester.pump();
    expect(find.text('Let’s try again together.'), findsOneWidget);
    expect(find.text('Question 2 of 5'), findsOneWidget);

    // The next question's letter is spoken once, and only once.
    await tester.pump(const Duration(milliseconds: 50));
    expect(audio.spoken.length, 2);
    final progress = container.read(kidsArabicProgressProvider);
    expect(progress.progressByLetterId['alif']!.incorrectReviews, 1);
  });

  testWidgets('a right answer names the letter', (tester) async {
    final (_, _) = await pumpReview(
      tester,
      completedLetterIds: ['alif', 'ba', 'meem'],
    );

    await tester.tap(find.text('ا'));
    await tester.pump();
    expect(find.text('Yes, that’s Alif!'), findsOneWidget);
  });

  testWidgets('see it, hear it plays each sound and checks the chosen one', (
    tester,
  ) async {
    final (_, audio) = await pumpReview(
      tester,
      completedLetterIds: ['alif', 'ba', 'meem'],
    );

    await tester.tap(find.text('See it, hear it'));
    await tester.pump();
    expect(find.text('Which sound does this letter make?'), findsOneWidget);
    expect(find.text('Check'), findsOneWidget);
    final check = find.widgetWithText(FilledButton, 'Check');
    expect(tester.widget<FilledButton>(check).enabled, isFalse);

    // The glyph on show is Alif; hearing a chip selects it without answering.
    await tester.tap(find.text('ba'));
    await tester.pump();
    expect(audio.spoken.last, 'ba');
    expect(find.text('Question 1 of 5'), findsOneWidget);
    expect(tester.widget<FilledButton>(check).enabled, isTrue);

    await tester.tap(find.text('aa'));
    await tester.pump();
    expect(audio.spoken.last, 'alif');
    await tester.tap(check);
    await tester.pump();
    expect(find.text('Yes, that’s Alif!'), findsOneWidget);
    expect(find.text('Question 2 of 5'), findsOneWidget);
  });
}
