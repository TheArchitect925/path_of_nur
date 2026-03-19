import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/features/journey/xp/presentation/widgets/journey_xp_progress_card.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  testWidgets('xp progress card renders summary values', (tester) async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(journeyXpSummaryProvider.notifier)
        .awardLearningXp(
          sourceRef: 'lesson:card',
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
          home: const Scaffold(body: JourneyXpProgressCard()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Path XP'), findsOneWidget);
    expect(find.textContaining('Level 1'), findsOneWidget);
    expect(find.textContaining('10 total XP'), findsOneWidget);
    expect(find.textContaining('25 XP to go'), findsOneWidget);
  });
}
