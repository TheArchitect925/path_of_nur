import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_audio_controller.dart';
import 'package:path_of_nur/features/arabic/application/arabic_learning_asset_bundle.dart';
import 'package:path_of_nur/features/arabic/application/arabic_learning_lesson_packs_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_readiness_bridge_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

class _FakeArabicLearningAudioBackend implements ArabicLearningAudioBackend {
  final List<String> playedAssets = <String>[];
  final List<String> spokenTexts = <String>[];

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> playAsset(String path, {required double speed}) async {
    playedAssets.add(path);
    return true;
  }

  @override
  Future<bool> speakText(String text, {required double rate}) async {
    spokenTexts.add(text);
    return true;
  }

  @override
  Future<void> stop() async {}
}

class _FakeArabicLearningAssetBundle implements ArabicLearningAssetBundle {
  _FakeArabicLearningAssetBundle(this.available);

  final Set<String> available;

  @override
  Future<Set<String>> assetKeys() async => available;

  @override
  Future<List<String>> availableAssets(Iterable<String> candidates) async {
    return candidates.where(available.contains).toList(growable: false);
  }

  @override
  Future<String?> firstAvailableAsset(Iterable<String> candidates) async {
    for (final candidate in candidates) {
      if (available.contains(candidate)) {
        return candidate;
      }
    }
    return null;
  }

  @override
  Future<void> prewarmAssets(Iterable<String> assetPaths) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpBridgePage(
    WidgetTester tester, {
    required ArabicLearningAudience audience,
    List<Override> overrides = const <Override>[],
    String? initialSnippetId,
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
            body: QuranReadinessBridgePage(
              audience: audience,
              initialSnippetId: initialSnippetId,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('quran readiness bridge shows expanded progression sections', (
    tester,
  ) async {
    await pumpBridgePage(
      tester,
      audience: ArabicLearningAudience.adult,
      overrides: [
        arabicLearningAudioBackendProvider.overrideWithValue(
          _FakeArabicLearningAudioBackend(),
        ),
        arabicLearningAssetBundleProvider.overrideWithValue(
          _FakeArabicLearningAssetBundle(<String>{
            'assets/audio/quran_teacher/phrases/bismillah.mp3',
          }),
        ),
      ],
    );

    final l10n = AppLocalizations.of(
      tester.element(find.byType(QuranReadinessBridgePage)),
    );

    expect(find.text(l10n.quranReadinessAdultPageTitle), findsOneWidget);
    expect(find.text(l10n.quranReadinessProgressionTitle), findsOneWidget);
    expect(find.text(l10n.quranReadinessLevelOneTitle), findsOneWidget);
    expect(find.text(l10n.quranReadinessLevelTwoTitle), findsOneWidget);
    expect(find.text(l10n.quranReadinessLevelThreeTitle), findsOneWidget);
    expect(find.text('bismillah'), findsOneWidget);
    expect(find.text('qul huwa Allahu ahad'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.quranGuidedPassagesAdultCardTitle),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text(l10n.quranGuidedPassagesAdultCardTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.arabicLearningPackAdultQuranLinkedWordsThemeTitle),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(
      find.text(l10n.arabicLearningPackAdultQuranLinkedWordsThemeTitle),
      findsOneWidget,
    );
  });

  testWidgets(
    'quran readiness bridge shows tajweed-aware hint copy for linked snippets',
    (tester) async {
      await pumpBridgePage(
        tester,
        audience: ArabicLearningAudience.adult,
        initialSnippetId: 'qul_huwa_allahu_ahad_bridge',
        overrides: [
          arabicLearningAudioBackendProvider.overrideWithValue(
            _FakeArabicLearningAudioBackend(),
          ),
          arabicLearningAssetBundleProvider.overrideWithValue(
            _FakeArabicLearningAssetBundle(const <String>{}),
          ),
        ],
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(QuranReadinessBridgePage)),
      );

      await tester.ensureVisible(find.text('qul huwa Allahu ahad'));
      await tester.tap(find.text('qul huwa Allahu ahad'), warnIfMissed: false);
      await tester.pump();

      expect(
        find.text(l10n.quranReadinessPronunciationHintsTitle),
        findsOneWidget,
      );
      expect(find.text(l10n.quranReadinessHintBounceLabel), findsOneWidget);
      expect(
        find.text(l10n.quranReadinessPronunciationHintsOpenAction),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'quran readiness bridge still renders when themed lesson packs are unavailable',
    (tester) async {
      await pumpBridgePage(
        tester,
        audience: ArabicLearningAudience.adult,
        overrides: [
          arabicLearningAudioBackendProvider.overrideWithValue(
            _FakeArabicLearningAudioBackend(),
          ),
          arabicLearningAssetBundleProvider.overrideWithValue(
            _FakeArabicLearningAssetBundle(const <String>{}),
          ),
          arabicLearningLessonPacksProvider.overrideWith((ref, audience) {
            return const [];
          }),
        ],
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(QuranReadinessBridgePage)),
      );

      expect(find.text(l10n.quranReadinessAdultPageTitle), findsOneWidget);
      expect(
        find.text(l10n.arabicLearningPackAdultQuranLinkedWordsThemeTitle),
        findsNothing,
      );
    },
  );
}
