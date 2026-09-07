import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/theme/app_icons.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_home_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

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

  Future<ProviderContainer> pumpHome(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
  }) async {
    final container = await makeTestContainer(
      overrides: [
        dailyNowProvider.overrideWith((ref) async* {
          yield DateTime(2026, 3, 18, 9);
        }),
        ...overrides,
      ],
    );
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
          home: const Scaffold(body: KidsArabicHomePage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    await tester.pump();
  }

  testWidgets('a first-time child sees one invitation, then the alphabet', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('Letters'), findsWidgets);
    expect(find.text('Trace your first letter'), findsOneWidget);
    // The adult Arabic track no longer sits on a child's page (L2).
    expect(find.text('Find Arabic practice'), findsNothing);
    expect(find.text('Lesson packs'), findsNothing);
    expect(find.text('Quick continue'), findsNothing);
    expect(find.text('Arabic progress'), findsNothing);

    await scrollTo(tester, find.text('All letters'));
    expect(find.text('All letters'), findsOneWidget);
    // Twenty-eight tiles; only Alif is open, the rest wear a lock.
    expect(find.byIcon(AppIcons.locked), findsNWidgets(27));

    await scrollTo(tester, find.text('Coloring Pages'));
    expect(find.text('Arabic Words'), findsOneWidget);
    expect(find.text('Letter Review'), findsOneWidget);
    expect(find.text('Coloring Pages'), findsOneWidget);
  });

  testWidgets('a locked tile speaks its letter instead of opening', (
    tester,
  ) async {
    final audio = _FakeKidsArabicAudioService();
    await pumpHome(
      tester,
      overrides: [kidsArabicAudioServiceProvider.overrideWithValue(audio)],
    );

    await scrollTo(tester, find.text('ب'));
    await tester.tap(find.text('ب'));
    await tester.pump();

    expect(audio.spoken, ['ba']);
    expect(find.byType(KidsArabicHomePage), findsOneWidget);
  });

  testWidgets('after the first letter the page names the next one', (
    tester,
  ) async {
    final container = await pumpHome(tester);
    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(
          letter: letter,
          traceResult: KidsArabicTraceResult.good,
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Trace your first letter'), findsNothing);
    expect(find.text('Next up: Ba'), findsOneWidget);
    await scrollTo(tester, find.text('All letters'));
    expect(find.byIcon(AppIcons.locked), findsNWidgets(26));
  });
}
