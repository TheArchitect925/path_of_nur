import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_reader_share_service.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_lesson_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  group('HadithLessonPage', () {
    testWidgets(
      'reader shows source, reference, grade, narrator, and related sections',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              editorialHadithEntriesProvider.overrideWith(
                (ref) => seededHadithEntries,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: const HadithLessonPage(lessonId: 'intentions_core'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Source'), findsOneWidget);
        expect(find.text('Sahih al-Bukhari'), findsOneWidget);
        expect(find.text('Reference'), findsWidgets);
        expect(find.text('Hadith 1'), findsOneWidget);
        expect(find.text('Grade'), findsOneWidget);
        expect(find.text('Sahih'), findsWidgets);
        expect(find.text('Narrated by'), findsOneWidget);
        expect(find.text('Umar ibn al-Khattab'), findsOneWidget);
        await tester.scrollUntilVisible(find.textContaining('connection'), 300);
        await tester.pumpAndSettle();
        expect(find.textContaining('connection'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Religion Is Sincere Counsel'),
          300,
        );
        await tester.pumpAndSettle();
        expect(find.text('Religion Is Sincere Counsel'), findsOneWidget);
      },
    );

    testWidgets('save action toggles from the reader page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HadithLessonPage(lessonId: 'intentions_core'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Save'), 300);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        prefs.getString('learn.hadith.saved.v2'),
        contains('intentions_core'),
      );
    });

    testWidgets(
      'reader surfaces canonical related duas with relation labels',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              editorialHadithEntriesProvider.overrideWith(
                (ref) => seededHadithEntries,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: const HadithLessonPage(lessonId: 'repentance_joy'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.text('Related Duas'), 300);
        await tester.pumpAndSettle();

        expect(find.text('Related Duas'), findsOneWidget);
        expect(find.text('Supplication of repentance'), findsOneWidget);
        expect(find.text('Related dua'), findsOneWidget);
      },
    );

    test(
      'share text keeps source, reference, grade, and narrator separate',
      () {
        final entry = seededHadithEntries.firstWhere(
          (item) => item.id == 'intentions_core',
        );

        final text = HadithReaderShareService.buildShareText(
          entry: entry,
          sourceLabel: 'Source',
          referenceLabel: 'Reference',
          formattedReference: 'Hadith 1',
          gradeLabel: 'Grade',
          narratorLabel: 'Narrated by',
          translationLabel: 'Translation',
        );

        expect(text, contains('Source: Sahih al-Bukhari'));
        expect(text, contains('Reference: Hadith 1'));
        expect(text, contains('Grade: Sahih'));
        expect(text, contains('Narrated by: Umar ibn al-Khattab'));
        expect(text, contains(entry.translation.trim()));
      },
    );
  });
}
