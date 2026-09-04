import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The recording slots under assets/audio/salah/adhkar/ are resolved by
/// file name at runtime, so a misnamed or stray file plays nothing and
/// nobody notices. This keeps the folder, the Dart slot list and the import
/// tool in agreement.
void main() {
  final dataSource = File(
    'lib/features/learn/salah/data/salah_trainer_data.dart',
  ).readAsStringSync();
  final toolSource = File('tools/import_salah_adhkar.py').readAsStringSync();
  final folder = Directory('assets/audio/salah/adhkar');

  List<String> dartSlots() {
    final start = dataSource.indexOf('const salahAdhkarAudioIds = <String>[');
    final end = dataSource.indexOf('];', start);
    return RegExp(r"'([a-z_]+)'")
        .allMatches(dataSource.substring(start, end))
        .map((m) => m.group(1)!)
        .toList();
  }

  test('the import tool knows every slot the app declares', () {
    final start = toolSource.indexOf('CLIPS: dict');
    final end = toolSource.indexOf('\n}\n', start);
    final toolSlots = RegExp(r'^\s+"([a-z_]+)":', multiLine: true)
        .allMatches(toolSource.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
    expect(toolSlots, dartSlots().toSet());
  });

  test('every bundled clip is a declared slot in mp3 form', () {
    final slots = dartSlots().toSet();
    final files = folder
        .listSync()
        .whereType<File>()
        .where((f) => !f.uri.pathSegments.last.startsWith('.'))
        .toList();
    for (final file in files) {
      final name = file.uri.pathSegments.last;
      expect(name.endsWith('.mp3'), isTrue, reason: '$name is not an mp3');
      final stem = name.substring(0, name.length - 4);
      expect(slots, contains(stem), reason: '$name is not a slot the app plays');
      expect(file.lengthSync(), greaterThan(1024), reason: '$name is empty');
      // An MPEG audio stream starts with an ID3 tag or a frame sync.
      final head = file.openSync().readSync(3);
      final isId3 = head[0] == 0x49 && head[1] == 0x44 && head[2] == 0x33;
      final isFrame = head[0] == 0xFF && (head[1] & 0xE0) == 0xE0;
      expect(isId3 || isFrame, isTrue, reason: '$name is not MPEG audio');
    }
  });

  test('the folder keeps its placeholder so the asset directory exists', () {
    expect(File('assets/audio/salah/adhkar/.gitkeep').existsSync(), isTrue);
  });
}
