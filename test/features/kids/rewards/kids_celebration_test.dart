import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/rewards/domain/kids_sticker_models.dart';
import 'package:path_of_nur/features/kids/rewards/presentation/kids_celebration.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K4: the moment a child finishes something. The overlay names the sticker,
/// plays the chime once, and goes away on "Yay!" or by itself.
void main() {
  const sticker = KidsSticker(
    id: 'letter:alif',
    kind: KidsStickerKind.letter,
    title: 'Alif',
    glyph: 'ا',
  );

  Future<_CountingSound> pumpHost(WidgetTester tester) async {
    final sound = _CountingSound();
    final container = await makeTestContainer(
      overrides: [kidsCelebrationSoundProvider.overrideWithValue(sound)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () =>
                    showKidsCelebration(context, ref, sticker: sticker),
                child: const Text('finish'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return sound;
  }

  testWidgets('shows the sticker, plays the chime once, dismisses on Yay', (
    tester,
  ) async {
    final sound = await pumpHost(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.tap(find.text('finish'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(l10n.kidsCelebrationTitle), findsOneWidget);
    expect(find.text('Alif'), findsOneWidget);
    expect(sound.plays, 1);

    await tester.tap(find.text(l10n.kidsCelebrationDismissAction));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l10n.kidsCelebrationTitle), findsNothing);
    // Let the confetti clock run out so no timer is left pending.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('goes away by itself after a few seconds', (tester) async {
    await pumpHost(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.tap(find.text('finish'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l10n.kidsCelebrationTitle), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l10n.kidsCelebrationTitle), findsNothing);
  });
}

class _CountingSound implements KidsCelebrationSound {
  int plays = 0;

  @override
  Future<void> play() async {
    plays += 1;
  }
}
