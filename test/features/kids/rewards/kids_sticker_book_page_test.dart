import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/kids/rewards/presentation/kids_sticker_book_page.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K4: the sticker book opens as an invitation when it is empty and shows a
/// letter sticker on its Letters page once a letter is finished.
void main() {
  Future<void> pumpFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> openBook(WidgetTester tester) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildRouterTestApp(container));
    container.read(appRouterProvider).go('/learn/kids/stickers');
    await pumpFrames(tester);
    return container;
  }

  testWidgets('an empty book invites the child to a first story', (
    tester,
  ) async {
    await openBook(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.byType(KidsStickerBookPage), findsOneWidget);
    expect(find.text(l10n.kidsInvitationFirstStoryTitle), findsOneWidget);
    expect(find.text(l10n.kidsRewardStickersCountValue(0)), findsOneWidget);
  });

  testWidgets('a finished letter appears on the Letters page', (tester) async {
    final container = await openBook(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final alif = kidsArabicLetters.firstWhere((letter) => letter.id == 'alif');
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(letter: alif, traceResult: KidsArabicTraceResult.good);
    await pumpFrames(tester);

    expect(find.text(l10n.kidsDoorLettersTitle), findsWidgets);
    expect(find.text(alif.nameEn), findsOneWidget);
    expect(find.text(l10n.kidsInvitationFirstStoryTitle), findsNothing);
  });
}
