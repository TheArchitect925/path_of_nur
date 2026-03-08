import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_of_nur/app/app.dart';

void main() {
  testWidgets('Path of Nūr app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PathOfNurApp()));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Daily Nur Progress'), findsOneWidget);
  });
}
