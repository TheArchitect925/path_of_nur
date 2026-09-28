import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/display/compact_list_tile.dart';
import 'package:path_of_nur/shared/widgets/display/expandable_tile.dart';
import 'package:path_of_nur/shared/widgets/display/filter_chip_row.dart';
import 'package:path_of_nur/shared/widgets/display/index_rail.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _wrap(Widget child) async {
  SharedPreferences.setMockInitialValues(const <String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('CompactListTile renders content and fires onTap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      await _wrap(
        CompactListTile(
          leading: const CompactTileBadge(label: '7'),
          title: 'Al-Fatihah',
          subtitle: 'The Opening',
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Al-Fatihah'), findsOneWidget);
    expect(find.text('The Opening'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    await tester.tap(find.text('Al-Fatihah'));
    expect(taps, 1);
  });

  testWidgets('ExpandableTile toggles its body', (tester) async {
    await tester.pumpWidget(
      await _wrap(
        const ExpandableTile(
          title: Text('Hadith'),
          child: Text('Full hadith text'),
        ),
      ),
    );

    expect(find.text('Full hadith text'), findsNothing);
    await tester.tap(find.text('Hadith'));
    await tester.pumpAndSettle();
    expect(find.text('Full hadith text'), findsOneWidget);
    await tester.tap(find.text('Hadith'));
    await tester.pumpAndSettle();
    expect(find.text('Full hadith text'), findsNothing);
  });

  testWidgets('FilterChipRow selects and clears', (tester) async {
    String? selected = 'unset';
    await tester.pumpWidget(
      await _wrap(
        StatefulBuilder(
          builder: (context, setState) => FilterChipRow<String>(
            items: const [
              FilterChipItem(value: 'anxiety', label: 'Anxiety'),
              FilterChipItem(value: 'gratitude', label: 'Gratitude'),
            ],
            selected: selected == 'unset' ? null : selected,
            onSelected: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Anxiety'));
    await tester.pump();
    expect(selected, 'anxiety');
    await tester.tap(find.text('Anxiety'));
    await tester.pump();
    expect(selected, isNull);
  });

  testWidgets('IndexRail reports the tapped label index', (tester) async {
    final selections = <int>[];
    await tester.pumpWidget(
      await _wrap(
        SizedBox(
          height: 400,
          child: IndexRail(
            labels: const ['1', '25', '50', '75', '99'],
            onSelected: selections.add,
          ),
        ),
      ),
    );

    final rect = tester.getRect(find.byType(IndexRail));
    await tester.tapAt(Offset(rect.center.dx, rect.top + 10));
    expect(selections.last, 0);
    await tester.tapAt(Offset(rect.center.dx, rect.bottom - 10));
    expect(selections.last, 4);
  });
}
