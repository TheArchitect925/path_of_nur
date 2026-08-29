import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Guards against a font asset being replaced by something that is not a font.
///
/// Three of the bundled Arabic faces were once HTML error pages saved with a
/// `.ttf` extension by a failed download. Flutter bundles them without
/// complaint and silently falls back to another face at runtime, so nothing
/// but a reader of the raw bytes catches it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // sfnt wrappers Flutter accepts: TrueType outlines, the legacy Apple tag,
  // TrueType collections, and CFF outlines.
  const sfntMagics = <List<int>>[
    [0x00, 0x01, 0x00, 0x00],
    [0x74, 0x72, 0x75, 0x65], // 'true'
    [0x74, 0x74, 0x63, 0x66], // 'ttcf'
    [0x4F, 0x54, 0x54, 0x4F], // 'OTTO'
  ];

  final assets = _declaredFontAssets();

  test('pubspec declares font assets', () {
    expect(assets, isNotEmpty);
  });

  for (final asset in assets) {
    test('$asset is a real font', () async {
      final file = File(asset);
      expect(file.existsSync(), isTrue, reason: '$asset is missing');

      final bytes = file.readAsBytesSync();
      expect(bytes.length, greaterThan(4), reason: '$asset is empty');

      final header = bytes.sublist(0, 4);
      expect(
        sfntMagics.any((magic) => _startsWith(header, magic)),
        isTrue,
        reason:
            '$asset does not begin with an sfnt signature — got '
            '${header.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Magic bytes alone would still pass on a truncated or corrupt table
      // directory, so hand the whole file to the engine's own parser.
      await ui.loadFontFromList(
        Uint8List.fromList(bytes),
        fontFamily: 'assert-parses-$asset',
      );
    });
  }
}

bool _startsWith(List<int> bytes, List<int> prefix) {
  for (var i = 0; i < prefix.length; i++) {
    if (bytes[i] != prefix[i]) return false;
  }
  return true;
}

/// Every `- asset:` path under the `flutter: fonts:` section of the pubspec.
List<String> _declaredFontAssets() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  final assets = <String>[];
  var inFonts = false;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed == 'fonts:' && line.startsWith('  fonts:')) {
      inFonts = true;
      continue;
    }
    if (!inFonts) continue;

    // The fonts block ends at the next key indented at or above its own level.
    if (trimmed.isNotEmpty &&
        !trimmed.startsWith('#') &&
        !trimmed.startsWith('-') &&
        !line.startsWith('   ')) {
      break;
    }

    final match = RegExp(r'-\s*asset:\s*(\S+)').firstMatch(trimmed);
    if (match != null) assets.add(match.group(1)!);
  }
  return assets;
}
