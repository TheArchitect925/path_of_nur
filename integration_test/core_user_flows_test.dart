import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/app/app.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/journey/presentation/journey_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learning_section_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/profile/presentation/settings_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('core flow matches current tab ownership and settings access', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app.onboardingCompleted': true,
      'profile.user': '{}',
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PathOfNurApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.byType(LearningSectionLandingPage), findsOneWidget);

    await tester.tap(find.text('Ibadah').last);
    await tester.pumpAndSettle();
    expect(find.byType(WorshipPage), findsOneWidget);

    await tester.tap(find.text('Growth').last);
    await tester.pumpAndSettle();
    expect(find.byType(JourneyPage), findsOneWidget);

    await tester.tap(find.text('Quran').last);
    await tester.pumpAndSettle();
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    container.read(appRouterProvider).go('/settings');
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
