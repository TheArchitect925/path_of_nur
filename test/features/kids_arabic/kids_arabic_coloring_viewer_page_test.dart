import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_coloring_share_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_coloring_models.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_coloring_viewer_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

class _RecordingShareService extends KidsArabicColoringShareService {
  _RecordingShareService({this.failWith}) : super(bundle: rootBundle);

  final Object? failWith;
  final List<KidsArabicColoringPage> shared = <KidsArabicColoringPage>[];
  final List<Rect?> origins = <Rect?>[];

  @override
  Future<void> share(KidsArabicColoringPage page, {Rect? origin}) async {
    shared.add(page);
    origins.add(origin);
    if (failWith != null) throw failWith!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppLocalizations> pumpViewer(
    WidgetTester tester,
    _RecordingShareService service,
  ) async {
    final container = await makeTestContainer(
      overrides: [
        kidsArabicColoringShareServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
          traceResult: KidsArabicTraceResult.good,
        );
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
          home: const Scaffold(
            body: KidsArabicColoringViewerPage(pageId: 'coloring-alif'),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return AppLocalizations.of(
      tester.element(find.byType(KidsArabicColoringViewerPage)),
    );
  }

  Future<void> tapShare(WidgetTester tester, AppLocalizations l10n) async {
    final button = find.text(l10n.kidsArabicColoringShareAction);
    await tester.scrollUntilVisible(
      button,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('a parent can print or share the page, not copy a file path', (
    tester,
  ) async {
    final service = _RecordingShareService();
    final l10n = await pumpViewer(tester, service);

    await tapShare(tester, l10n);

    expect(find.text(l10n.kidsArabicColoringViewerHint), findsOneWidget);
    expect(find.textContaining('assets/'), findsNothing);
    expect(find.byIcon(Icons.copy_rounded), findsNothing);
    expect(service.shared.map((page) => page.id), ['coloring-alif']);
    expect(service.origins.single, isNotNull);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a failed share says so and leaves the button usable', (
    tester,
  ) async {
    final service = _RecordingShareService(failWith: StateError('no sheet'));
    final l10n = await pumpViewer(tester, service);

    await tapShare(tester, l10n);

    expect(
      find.text(l10n.kidsArabicColoringShareFailedMessage),
      findsOneWidget,
    );
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text(l10n.kidsArabicColoringShareAction),
        matching: find.bySubtype<ButtonStyleButton>(),
      ),
    );
    expect(button.onPressed, isNotNull);
  });
}
