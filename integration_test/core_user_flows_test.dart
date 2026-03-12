import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/app/app.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('core flow: launch and navigate main tabs', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app.onboardingCompleted': true,
      'profile.user': '{}',
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const PathOfNurApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Home'), findsWidgets);

    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Learn'), findsWidgets);

    await tester.tap(find.text('Worship').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Worship'), findsWidgets);
    // moon phase card should be visible
    expect(find.text('Moon Phase'), findsOneWidget);

    await tester.tap(find.text('Journey').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Journey'), findsWidgets);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Profile'), findsWidgets);
  });
}
