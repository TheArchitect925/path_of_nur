import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/creation_explorer/application/creation_explorer_services.dart';
import 'package:path_of_nur/features/creation_explorer/presentation/creation_explorer_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  testWidgets(
    'creation explorer shows physical-device fallback when image labeling is unavailable',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          creationImageLabelingRuntimeProvider.overrideWithValue(
            CreationImageLabelingRuntime(
              availabilityOverride: () async => false,
            ),
          ),
        ],
      );
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
            home: const Scaffold(body: CreationExplorerPage()),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      expect(find.text(creationImageLabelingDeviceOnlyMessage), findsOneWidget);
      expect(find.text('Image labeling runs on device only'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
