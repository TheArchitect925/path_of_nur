import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/drops/application/garden_unlock_service.dart';
import 'package:path_of_nur/features/journey/drops/application/journey_drops_providers.dart';
import 'package:path_of_nur/features/journey/drops/domain/garden_milestones.dart';
import 'package:path_of_nur/features/journey/drops/presentation/widgets/garden_gallery.dart';
import 'package:path_of_nur/features/journey/drops/presentation/widgets/garden_cards.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  testWidgets(
    'garden gallery renders locked and unlocked milestone states',
    (tester) async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final controller = container.read(journeyDropSummaryProvider.notifier);
      controller.awardPrayerDrop(
        prayerId: 'fajr',
        dayKey: '2026-03-18',
        occurredAt: DateTime(2026, 3, 18, 5, 15),
      );
      controller.awardLearningDrop(
        sourceRef: 'learning:lesson-card',
        occurredAt: DateTime(2026, 3, 18, 9),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(child: GardenGallery()),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Garden Gallery'), findsOneWidget);
      expect(find.text('First Seed'), findsOneWidget);
      expect(find.text('Unlocked'), findsOneWidget);
      expect(find.text('2 / 10 Drops'), findsOneWidget);
    },
  );

  testWidgets('next unlock card renders milestone progress summary', (
    tester,
  ) async {
    const service = GardenUnlockService();
    final summary = service.buildProgressSummary(gardenMilestones, totalDrops: 75);
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GardenNextUnlockCard(
              summary: summary,
              nextMilestone: gardenMilestones[4],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Next unlock'), findsOneWidget);
    expect(find.text('Quiet Fountain'), findsOneWidget);
    expect(find.text('Unlocks at 100 drops'), findsOneWidget);
    expect(find.text('25 drops remaining'), findsOneWidget);
  });

  testWidgets('gallery tile exposes locked copy without tap affordance', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GardenGalleryTile(
            milestone: gardenMilestones[3],
            unlocked: false,
            title: 'Morning Path',
            requiredDropsLabel: '50',
            progressLabel: '30 / 50 Drops',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Morning Path'), findsOneWidget);
    expect(find.text('Unlocks at 50 drops'), findsOneWidget);
    expect(find.text('30 / 50 Drops'), findsOneWidget);
    },
  );
}
